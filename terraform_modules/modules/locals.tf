locals {
#   region_to_zone_mapping = {
#     "us-central1" = ["us-central1-a", "us-central1-b", "us-central1-c", "us-central1-f"]
#     "us-east4"    = ["us-east4-a", "us-east4-b", "us-east4-c"]
#   }

  region_mapping = {
    "us-central1" = "usc1"
    "us-east4"    = "use4"
  }

  zone_mapping = {
    "us-central1-a": "usc1a"
    "us-central1-b": "usc1b"
    "us-central1-c": "usc1c"
    "us-central1-f": "usc1f"
    "us-east4-a": "use4a"
    "us-east4-b": "use4b"
    "us-east4-c": "use4c"
  }

  bucket_types = ["staging", "temp", "op"]
}