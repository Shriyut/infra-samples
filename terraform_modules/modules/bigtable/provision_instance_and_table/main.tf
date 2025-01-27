resource "google_bigtable_instance" "instance" {

  for_each = toset(var.regions)
  name = "${var.instance_name}-${var.region_mapping[each.key]}"

  //disabling deletion protection for dev (true by default, needs to be disabled by adding it and running apply to delete)
  deletion_protection = false

  dynamic "cluster" {
    for_each = var.zones[each.key]
    content {
      cluster_id = "${var.cluster_id}-${var.zone_mapping[cluster.value]}"
      zone = cluster.value
      storage_type = "HDD"
      kms_key_name = var.crypto_key_names[each.key]

      autoscaling_config {
        cpu_target = var.cpu_target
        max_nodes = var.max_nodes
        min_nodes = var.min_nodes
      }
    }
  }
}

//assuming tables will be common across all instances
resource "google_bigtable_table" "table" {
  for_each      = toset(var.regions)
  name          = var.table_name
  instance_name = google_bigtable_instance.instance[each.key].name

  column_family {
    family = "family-first"
  }

  column_family {
    family = "family-second"
    type   = "intsum"
  }

  column_family {
    family = "family-third"
    type = var.family_third_type
  }

  //disabled properties - to be enabled based on requirement
  change_stream_retention = "0"
#   automated_backup_policy {
#     retention_period = "0"  # terraform doc says to set 0 to disable but results in error min value 72
#     frequency = "0"
#   }

}

resource "google_bigtable_instance_iam_member" "instance_iam_binding" {
  for_each = google_bigtable_instance.instance
  instance = each.value.name
  role   = "roles/bigtable.user"
  member = "serviceAccount:${var.platform_service_account}"
}

resource "google_bigtable_table_iam_member" "table_iam" {
  for_each      = toset(var.regions)
  instance = google_bigtable_instance.instance[each.key].name
  table = google_bigtable_table.table[each.key].name
  role          = "roles/bigtable.user"
  member        = "serviceAccount:${var.platform_service_account}"
}