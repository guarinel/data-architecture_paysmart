import json
import boto3
import awswrangler as wr
import pandas as pd

s3 = boto3.client('s3')
s3_r = boto3.resource("s3")


def lambda_handler(event, context):
    
    bucket_name_destino = "curated-zone-mysql"

    # retrieve bucket name and file_key from the S3 event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    
    # # get the object
    obj = s3.get_object(Bucket=bucket_name, Key=file_key)
    # # get lines inside the csv
    lines = obj['Body'].read().split(b'\n')
    
    list_of_values_to_df = [
        json.loads(updated_value.decode())['value']['after']
        for updated_value in lines
        ]
        
    table  = change_value['value']['source']['table']
    execution_time = str(change_value['value']['ts_ms'])
    file_name = f"{table}/{execution_time}-{table}.csv"

        
    df_change_values = pd.DataFrame(list_of_values_to_df)
    
    path_to_file = f"s3://{bucket_name_destino}/{file_name}"

    wr.s3.to_parquet(df_change_values, path_to_file)