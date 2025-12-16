
#!/usr/bin/env bash
set -Eeuo pipefail

# ---- Read optional nonce from client (prevents replay); do not hang forever ----
NONCE="$(timeout 1 cat 2>/dev/null | head -c 512 || true)"
export NONCE

# If bash itself dies before Python runs, still return something structured
fail_json() {
  local msg="${1:-unknown error}"
  local now
  now="$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo "unknown-time")"
  echo "{\"ok\":false,\"stage\":\"bash\",\"time_utc\":\"$now\",\"error\":\"$(printf "%s" "$msg" | sed 's/"/\\"/g')\"}"
}
trap 'fail_json "bash trap: line=$LINENO exit=$? cmd=$BASH_COMMAND"' ERR

python3 - <<'PY'
import os, sys, json, time, base64, traceback, hashlib, platform, subprocess

out = {
  "ok": False,
  "stage": "init",
  "time_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "nonce": {
    "present": bool(os.environ.get("NONCE","")),
    "len": len(os.environ.get("NONCE","").encode("utf-8")) if os.environ.get("NONCE","") else 0,
    "preview_b64_first32": base64.b64encode(os.environ.get("NONCE","").encode("utf-8")[:32]).decode("ascii") if os.environ.get("NONCE","") else ""
  },
  "env": {
    "python": sys.version.replace("\n"," "),
    "platform": platform.platform(),
    "uname": " ".join(platform.uname()),
    "uid_gid": f"{os.getuid()}:{os.getgid()}",
  },
  "checks": {},
  "nsm": {},
  "attestation": {},
  "errors": [],
}

def sh(cmd):
  try:
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=1)
    return {"rc": p.returncode, "stdout": p.stdout[:4000], "stderr": p.stderr[:4000]}
  except Exception as e:
    return {"rc": None, "stdout": "", "stderr": f"{type(e).__name__}: {e}"}

# ---- Basic /dev/nsm diagnostics ----
out["stage"] = "check_dev"
dev = "/dev/nsm"
out["checks"]["dev_nsm_exists"] = os.path.exists(dev)
out["checks"]["dev_nsm_is_char"] = os.path.exists(dev) and os.stat(dev).st_mode & 0o170000 == 0o020000  # char dev
out["checks"]["dev_nsm_stat"] = sh(["/usr/bin/stat", dev]) if os.path.exists(dev) else None
out["checks"]["dev_nsm_ls"] = sh(["/usr/bin/ls", "-l", dev]) if os.path.exists(dev) else None

# These help when there is no console (you’ll get them back over VSOCK)
out["checks"]["id"] = sh(["/usr/bin/id"])
out["checks"]["mount"] = sh(["/usr/bin/mount"])
out["checks"]["cmdline"] = sh(["/usr/bin/cat", "/proc/cmdline"])
out["checks"]["dmesg_tail"] = sh(["/usr/bin/dmesg", "--ctime", "--nopager"])  # may be blocked; will error if so

# ---- Import aws_nsm_interface ----
out["stage"] = "import"
try:
  import aws_nsm_interface
  out["checks"]["aws_nsm_interface_import"] = True
  out["checks"]["aws_nsm_interface_version"] = getattr(aws_nsm_interface, "__version__", "unknown")
except Exception:
  out["checks"]["aws_nsm_interface_import"] = False
  out["errors"].append({
    "where": "import aws_nsm_interface",
    "trace": traceback.format_exc()
  })
  print(json.dumps(out))
  raise SystemExit(0)

# ---- Open NSM device and run describe + attestation ----
out["stage"] = "nsm_open"
fd = None
try:
  fd = aws_nsm_interface.open_nsm_device()  # /dev/nsm access [2](https://docs.rs/crate/aws-nitro-enclaves-nsm-api/latest/source/docs/attestation_process.md)[1](https://deepwiki.com/aws/aws-nitro-enclaves-samples/3.1-system-architecture)
  out["checks"]["open_nsm_device"] = True

  out["stage"] = "describe_nsm"
  try:
    # describe_nsm returns module_id, digest, locked_pcrs, etc. [2](https://docs.rs/crate/aws-nitro-enclaves-nsm-api/latest/source/docs/attestation_process.md)
    out["nsm"]["describe"] = aws_nsm_interface.describe_nsm(fd)
  except Exception:
    out["errors"].append({"where":"describe_nsm", "trace": traceback.format_exc()})

  out["stage"] = "get_attestation_doc"
  nonce = os.environ.get("NONCE","").encode("utf-8") if os.environ.get("NONCE","") else None

  # get_attestation_doc(user_data/nonce/public_key optional) [2](https://docs.rs/crate/aws-nitro-enclaves-nsm-api/latest/source/docs/attestation_process.md)[3](https://github.com/aws/aws-nitro-enclaves-nsm-api/blob/main/docs/attestation_process.md)
  resp = aws_nsm_interface.get_attestation_doc(fd, nonce=nonce)
  doc = resp.get("document", b"")
  out["attestation"]["size_bytes"] = len(doc)
  out["attestation"]["sha256"] = hashlib.sha256(doc).hexdigest()
  out["attestation"]["document_b64"] = base64.b64encode(doc).decode("ascii")

  out["ok"] = True
  out["stage"] = "done"

except Exception:
  out["ok"] = False
  out["errors"].append({"where": out["stage"], "trace": traceback.format_exc()})

finally:
  out["stage"] = out.get("stage","finalize")
  try:
    if fd is not None:
      aws_nsm_interface.close_nsm_device(fd)  # [2](https://docs.rs/crate/aws-nitro-enclaves-nsm-api/latest/source/docs/attestation_process.md)
      out["checks"]["close_nsm_device"] = True
  except Exception:
    out["checks"]["close_nsm_device"] = False
    out["errors"].append({"where":"close_nsm_device", "trace": traceback.format_exc()})

print(json.dumps(out))
PY
