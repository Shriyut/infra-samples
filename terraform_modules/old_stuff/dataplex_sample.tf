terraform {
    required_providers {
      google = {
        source = "hashicorp/google"
        version =  "5.37.0"
      }
    }

}


provider "google" {
    alias = "test"
}

resource "google_dataplex_datascan" "full_quality" {
  provider = google.test
  location = var.location
  data_scan_id = var.display_name

  data {
    resource = var.resource
  }

  execution_spec {
    trigger {
      on_demand {}
    }
  }

  data_quality_spec {
    sampling_percent = 5
    row_filter = var.row_filter
    rules {
      column = var.column
      dimension = var.dimension
      threshold = 0.99
      non_null_expectation {}
    }



    rules {
      dimension = var.dimension
      sql_assertion {
        sql_statement = var.sql_statement
      }
    }
  }


  project = var.project
}