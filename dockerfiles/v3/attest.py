#!/usr/bin/env python3
import sys
import base64
import json
import ctypes
from ctypes import c_uint8, c_size_t, c_void_p, byref

# Load the NSM shared library (part of aws-nitro-enclaves-nsm-api C bindings)
lib = ctypes.CDLL("/usr/lib/libnsm.so")

# Constants from NSM library
NSM_MAX_ATTESTATION_DOC_SIZE = 8192

# Define function prototype
lib.nsm_get_attestation_doc.argtypes = [
    ctypes.c_int,
    ctypes.POINTER(c_uint8),
    c_size_t,
    ctypes.POINTER(c_uint8),
    c_size_t,
    ctypes.POINTER(c_uint8),
    c_size_t,
    ctypes.POINTER(c_uint8),
    ctypes.POINTER(c_size_t),
]
lib.nsm_get_attestation_doc.restype = ctypes.c_int

def get_attestation(nonce_bytes):
    # Prepare buffers
    nonce_buf = (c_uint8 * len(nonce_bytes))(*nonce_bytes)
    out_buf = (c_uint8 * NSM_MAX_ATTESTATION_DOC_SIZE)()
    out_len = c_size_t(NSM_MAX_ATTESTATION_DOC_SIZE)

    status = lib.nsm_get_attestation_doc(
        0,
        nonce_buf,
        len(nonce_bytes),
        None,
        0,
        None,
        0,
        out_buf,
        byref(out_len),
    )

    if status != 0:
        raise Exception(f"NSM attestation error {status}")

    # Extract the actual attestation bytes
    att_bytes = bytes(out_buf[: out_len.value])
    return base64.b64encode(att_bytes).decode("utf-8")

if __name__ == "__main__":
    # Read base64 nonce from stdin
    b64nonce = sys.stdin.read().strip()
    nonce = base64.b64decode(b64nonce) if b64nonce else b""
    att_doc_b64 = get_attestation(nonce)

    output = {
        "attestation_document_base64": att_doc_b64,
        "nonce_base64": b64nonce,
    }
    print(json.dumps(output))
