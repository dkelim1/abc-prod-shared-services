#==================================================================================================
# Purpose:  Processes CloudWatch Alarm before publishing to SNS.
#==================================================================================================

import boto3
import json
import os
import urllib.parse

SNS_TOPIC_ARN = os.environ['sns_topic_arn']

def lambda_handler(event, context):
    print('sns received: ' + json.dumps(event))
    event_subscription_arn = event['Records'][0]['EventSubscriptionArn']
    event_sns = event['Records'][0]['Sns']
    event_sns_subject = event_sns['Subject']
    event_sns_message = json.loads(event_sns['Message'])

    timestamp = event_sns['Timestamp']
    region = event['Records'][0]['EventSubscriptionArn'].split(':')[3]
    alarm_name = event_sns_message['AlarmName']
    alarm_description = event_sns_message['AlarmDescription']
    account_id = event_sns_message['AWSAccountId']
    new_state_value = event_sns_message['NewStateValue']
    old_state_value = event_sns_message['OldStateValue']
    alarm_reason = event_sns_message['NewStateReason']
    trigger = event_sns_message['Trigger']
    metric_name = trigger['MetricName'] 
    trigger_str = '{} {} {} {} for {} period(s) of {} seconds'.format(trigger['Statistic'], metric_name, trigger['ComparisonOperator'], trigger['Threshold'], trigger['EvaluationPeriods'], trigger['Period'])

    subject = 'Security alert from CloudWatch Alarm: {} in {}'.format(alarm_name, region)
    link_to_alarm = 'https://console.aws.amazon.com/cloudwatch/home?region=' + region + '#alarm:alarmFilter=ANY;name=' + urllib.parse.quote(alarm_name)
    client = boto3.client('sns')
    response = client.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject= subject,
        Message= f"""
        ==========================================================================
        Account ID: {account_id}
        Alarm Name: {alarm_name}
        Alarm Description: {alarm_description}
        Trigger: {trigger_str}
        Old State: {old_state_value}
        New State: {new_state_value}
        ==========================================================================
        Link to alarm: {link_to_alarm}
        """
    )