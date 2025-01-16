locals {
  datascan_spec_folder              = "./yamls"
#   datascan_specs = {
#   for f in setunion(fileset(local.datascan_spec_folder, "**/*.yaml"), fileset(local.datascan_spec_folder, "**/*.yml")) :
#   replace(trimsuffix(trimsuffix(f, ".yaml"), ".yml"), "/", "-") => yamldecode(file("${local.datascan_spec_folder}/${f}"))
#   }
# emerald-vigil-428902-v5.test_dataset.fno_dq_table
    yaml_object = yamldecode(file("./yamls/data_quality_spec_table2.yaml"))
    rules = yamlencode(local.yaml_object.spec.rules)
    row_filter = local.yaml_object.spec.rowFilter
    sampling_percent = local.yaml_object.spec.samplingPercent
    sample = flatten(local.yaml_object.spec.rules)
    rule_keys = keys(merge(local.sample...))
    sql_assertion_create_flag = contains(local.rule_keys, "sql_assertion") || contains(local.rule_keys, "sqlAssertion") ? "yes" : "no"
    scan_name = local.yaml_object.metadata.name

}

resource "null_resource" "create_scan" {

    triggers = {
        always_run = timestamp()
        # job_name = $${local.scan_name}
    }

    provisioner "local-exec" {
        interpreter = ["/bin/bash" ,"-c"]
        # command = "cat '${local.gcloud_yaml_file}' > abc.yaml | gcloud dataplex datascans create data-quality tf-test --on-demand=ON_DEMAND --location=us-central1 --data-quality-spec-file=abc.yaml --data-source-resource=//bigquery.googleapis.com/projects/emerald-vigil-428902-v5/datasets/test_dataset/tables/fno_dq_table"

        # echo ${local.gcloud_yaml_file} > $FILE_PWD/spec.yaml
        command = <<EOF
            export FILE_PWD=$(pwd)
            export FILE_NAME=${local.scan_name}
            echo $FILE_PWD
            echo ${local.sql_assertion_create_flag}
# check if job already exists if yes then update command
# get name from yaml and run delete command in delete time provisioner

            cat > $FILE_PWD/$FILE_NAME.yaml <<-EOT
rowFilter: "${local.row_filter}"
samplingPercent: ${local.sampling_percent}
rules:
${local.rules}
postScanActions:
  bigqueryExport:
    resultsTable: "//bigquery.googleapis.com/projects/emerald-vigil-428902-v5/datasets/test_dataset/tables/dq_scan_results"
EOT

            if [ ${local.sql_assertion_create_flag} == "yes" ]; then
                echo  $(gcloud dataplex datascans list --location=us-central1 | grep $FILE_NAME) > $FILE_PWD/result.txt
                cat $FILE_PWD/result.txt
                if [ "$(cat $FILE_PWD/result.txt)" != ""  ]; then
                        # when the dq rule already exists i.e. file is not empty
                        # update scenario not working as expected in local provisioner
                        # not picking up the new changes - fixed
                        gcloud dataplex datascans update data-quality ${local.scan_name} --location=us-central1 --data-quality-spec-file=$FILE_PWD/$FILE_NAME.yaml
                else
                        # when the dq rule doesnt exist i.e file is empty
                        gcloud dataplex datascans create data-quality ${local.scan_name} --on-demand=ON_DEMAND --location=us-central1 --data-quality-spec-file=$FILE_PWD/$FILE_NAME.yaml --data-source-resource=//bigquery.googleapis.com/projects/emerald-vigil-428902-v5/datasets/test_dataset/tables/fno_dq_table
                fi

            else
                # echo "No sql assertion rules found in yaml"
                gcloud dataplex datascans create data-quality ${local.scan_name} --on-demand=ON_DEMAND --location=us-central1 --data-quality-spec-file=$FILE_PWD/$FILE_NAME.yaml --data-source-resource=//bigquery.googleapis.com/projects/emerald-vigil-428902-v5/datasets/test_dataset/tables/fno_dq_table
            fi
        EOF
    }

    # input = { scan_job = local.scan_name}

    # provisioner "local-exec" {
    #     when    = destroy
    #     interpreter = ["/bin/bash" ,"-c"]
    #     #  Destroy-time provisioners and their connection configurations may only reference attributes of the related resource, via 'self', 'count.index', or 'each.key'.
    #     command = "gcloud dataplex datascans delete ${local.scan_name} --location=us-central1"
    # }
}

