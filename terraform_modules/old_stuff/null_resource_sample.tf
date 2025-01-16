locals {
  encoded_spec = yamlencode({"rules":[{"column": "guid","dimension": "UNIQUENESS","sqlAssertion": {"sqlStatement": "SELECT COUNT(guid) FROM $${data()} group by guid, run_date having count(guid) > 1"}}], "rowFilter": "run_date <= '2024-07-20'", "postScanActions": {"bigqueryExport": {"resultsTable": "//bigquery.googleapis.com/projects/emerald-vigil-428902-v5/datasets/shriyut_test_dataset/tables/dq_scan_results"}}})
  test_spec = yamldecode("hello: world")
  var_spec = yamlencode({
        resultsTable: "${var.results_table}"
        rowFilter: "${var.row_filter}"
    })

  rule_spec = yamlencode({
    rules: [{
        sqlAssertion: {
            "sqlStatement": "${var.sql_statement}"
        },
        column: "${var.dq_col}",
        dimension: "${var.dq_dimension}"
    }]
  })
}


resource "null_resource" "deploy_scan" {
    provisioner "local-exec" {
        interpreter = ["/bin/bash" ,"-c"]
        command = <<EOF
            export FILE_PWD=$(pwd)
            echo $FILE_PWD
            cat > $FILE_PWD/spec.yaml <<-EOT
rowFilter: "${var.row_filter}"
rules:
- sqlAssertion:
    sqlStatement: "${var.sql_statement}"
  column: ${var.dq_col}
  dimension: ${var.dq_dimension}
- setExpectation :
    values :
    - 'guid1'
    - 'guid2'
    - 'guid3'
  column : guid
  ignoreNull : true
  dimension : VALIDITY
  threshold : 1
postScanActions:
  bigqueryExport:
    resultsTable: ${var.results_table}
EOT
            cat $FILE_PWD/spec.yaml
            gcloud dataplex datascans create data-quality ${var.dq_scan_name} --on-demand=${var.on_demand} --location=${var.location} --data-quality-spec-file=$FILE_PWD/spec.yaml --data-source-resource=${var.data_source_resource}
        EOF
    }
}

#need to use each.key in the delete local exec, directly referncing variables doesnt work
# resource "null_resource" "delete_scan" {
#     provisioner "local-exec" {
#         when = destroy
#         interpreter = ["/bin/bash" ,"-c"]
#         command = "gcloud dataplex datascans delete ${var.dq_scan_name} --location=${var.location}"
#     }
# }


# resource "null_resource" "create_scan" {
#     provisioner "local-exec" {
#         # interpreter = ["/bin/bash" ,"-c"]
#         # command = "export FILE_PWD=$(pwd) && sleep 5 && echo $FILE_PWD && echo ${path.module}"
#         command = "export FILE_PWD=$(pwd) && sleep 5 && echo $FILE_PWD && echo jsondecode(${local.encoded_spec}) > $FILE_PWD/spec.json && cat $FILE_PWD/spec.json"
#         # command = "export FILE_PWD=$(pwd) && sleep 5 && echo $FILE_PWD && echo ${local.encoded_spec} > $FILE_PWD/spec.json && gcloud dataplex datascans create data-quality gcloud-tf --on-demand=${var.on_demand} --location=${var.location} --data-quality-spec-file=$FILE_PWD/spec.json --data-source-resource=${var.data_source_resource}"
#     }
# }

# resource "null_resource" "deploy_scan" {
#     provisioner "local-exec" {
#         interpreter = ["/bin/bash" ,"-c"]
#         command = <<EOF
#             export FILE_PWD=$(pwd)
#             echo $FILE_PWD
#             cat<<-EOT
# rowFilter: "${var.row_filter}"
# ${local.rule_spec}
# postScanActions:
#   bigqueryExport:
#     resultsTable: ${var.results_table}
#         EOT
#         EOF
#     }
# }




            # cat > $FILE_PWD/spec.yaml <<-EOT
            #     rowFilter: "${var.row_filter}"
            #     resultsTable: ${var.results_table}
            # EOT
            # cat $FILE_PWD/spec.yaml
            # echo ${local.var_spec} > $FILE_PWD/spec.yaml
            # echo ${local.encoded_spec} > $FILE_PWD/spec.json
            # cat $FILE_PWD/spec.json
# gcloud dataplex datascans create data-quality gcloud-tf --on-demand=${var.on_demand} --location=${var.location} --data-quality-spec-file=$FILE_PWD/spec.json --data-source-resource=${var.data_source_resource}

# resource "terraform_data" "dataplex"{
#     provisioner "local-exec" {
#         command = "gcloud dataplex datascans create data-quality gcloud-tf --on-demand=${var.on_demand} --location=${var.location} --data-quality-spec-file=/home/shriyut/test.yaml --data-source-resource=${var.data_source_resource}"
#     }

#     depends_on = [
#         null_resource.create_scan
#     ]
# }