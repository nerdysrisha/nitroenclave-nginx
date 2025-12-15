use aws_nitro_enclaves_sdk_nsm::AttestationDocument;
use base64::{engine::general_purpose, Engine as _};
use std::io::{self, Read};

fn main() {
    // Read base64 nonce from stdin
    let mut b64nonce = String::new();
    io::stdin().read_to_string(&mut b64nonce).unwrap();
    let b64nonce = b64nonce.trim();

    let nonce = if !b64nonce.is_empty() {
        general_purpose::STANDARD.decode(b64nonce).unwrap()
    } else {
        Vec::new()
    };

    // Generate attestation document
    let doc = AttestationDocument::new(&nonce).expect("Failed to get attestation");

    // Base64 encode the attestation
    let attestation_b64 = general_purpose::STANDARD.encode(doc.as_bytes());

    // Return JSON
    println!(
        "{{\"attestation_document_base64\": \"{}\", \"nonce_base64\": \"{}\"}}",
        attestation_b64, b64nonce
    );
}
