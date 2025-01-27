output "crypto_key_names" {
  value = { for k, v in google_kms_crypto_key.crypto_key : k => v.id }
}