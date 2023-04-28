#==================================================================================================
# Purpose:  Processes AWS Config Compliance Status change alerts before publishing to SNS.
#==================================================================================================
import boto3
import json
import os

SNS_TOPIC_ARN = os.environ['sns_topic_arn']

def lambda_handler(event, context):
    account_id = event['detail']['awsAccountId']
    resource_id = event['detail']['resourceId']
    resource_type = event['detail']['newEvaluationResult']['evaluationResultIdentifier']['evaluationResultQualifier']['resourceType']
    region = event['detail']['awsRegion']
    alert_type = event['detail']['messageType']
    config_rule_name = event['detail']['configRuleName']
    timestamp = event['detail']['newEvaluationResult']['resultRecordedTime']
    current_state = event['detail']['newEvaluationResult']['complianceType']
    raw_message = event
    client = boto3.client('sns')
    response = client.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject= f"Compliance alert for {resource_type} in {region}",
        Message= f"""
        ==========================================================================
        Account ID: {account_id} \n
        Resource Id: {resource_id} \n
        Resource Type: {resource_type} \n
        Region: {region} \n
        Alert Type: {alert_type} \n
        Rule Name: {config_rule_name} \n
        Timestamp: {timestamp} \n
        Current State: {current_state}
        ==========================================================================
        \n Raw Message: \n
        {raw_message}
        """
    )