import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, GoogleCloudOptions, StandardOptions
from apache_beam.io.gcp.bigtableio import WriteToBigTable
from google.cloud.bigtable.row import DirectRow
import logging

class CreateRowFn(beam.DoFn):
    def process(self, element):
        row_key = 'sample#4c410523#20250123'
        row = DirectRow(row_key)
        row.set_cell('family-first', 'column1', 'value1')
        # row.set_cell('family-second', 'column2', 123)
        # row.set_cell('family-third', 'column3', 'value3')
        logging.info(f'Creating row with key: {row_key}')
        yield row

def run():
    project_id = 'us-gcp-ame-con-ff12d-npd-1'
    instance_id = 'sample-instance-use4'
    table_id = 'test-table1'
    region = 'us-east4'
    temp_location = 'gs://hnb-bkt-sbx-temp-use4/tmp'
    staging_location = 'gs://hnb-bkt-sbx-staging-use4/stage'
    job_name = 'bigtable-write-job'
    service_account_email = 'sample-sa-test@us-gcp-ame-con-ff12d-npd-1.iam.gserviceaccount.com'

    options = PipelineOptions()
    google_cloud_options = options.view_as(GoogleCloudOptions)
    google_cloud_options.project = project_id
    google_cloud_options.region = region
    google_cloud_options.job_name = job_name
    google_cloud_options.staging_location = staging_location
    google_cloud_options.temp_location = temp_location
    google_cloud_options.service_account_email = service_account_email

    options.view_as(StandardOptions).runner = 'DataflowRunner'

    p = beam.Pipeline(options=options)

    (p
     | 'Start' >> beam.Create(["sample#4c410523#20250123"])
     | 'Create Row' >> beam.ParDo(CreateRowFn())
     | 'Write to Bigtable' >> WriteToBigTable(project_id, instance_id, table_id))

    result = p.run()
    result.wait_until_finish()

if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    run()

# python3 sample_beam_Script.py   --runner DataflowRunner   --no_use_public_ips --save_main_session True