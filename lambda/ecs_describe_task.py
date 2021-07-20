"""Spins up a new ECS instances from an existing task definition"""
import json
import boto3

def create_server(event, context):
    pass

def add_cname_record(Name, value, action, record_type, ttl):
    try:
        response = client.change_resource_record_sets(
        HostedZoneId='###',
        ChangeBatch= {
            'Comment': 'add %s -> %s' % (Name, value),
            'Changes': [
                {
                    'Action': action,
                    'ResourceRecordSet': {
                        'Name': Name,
                        'Type': record_type,
                        'TTL': ttl,
                        'ResourceRecords': [{'Value': value}]
                }
            }]
        })
    except Exception as e:
        print(e)

if __name__ == '__main__':
    aws_session = boto3.session.Session()
    # print(aws_session)

    # client = aws_session.client('ecs')

    # response = client.describe_tasks(
    #     cluster='arn:aws:ecs:af-south-1:639808537303:cluster/rsa_tf',
    #     tasks=[
    #         "arn:aws:ecs:af-south-1:639808537303:task/rsa_tf/29325e1107a94b97ad849f35927d2688"
    #     ]
    # )

    # client = boto3.client('ec2')
    # response = client.describe_network_interfaces(
    #     NetworkInterfaceIds=[
    #         "eni-0c8dd41954c3abd52"
    #         ]
    #     )

    # for interface in response['NetworkInterfaces']:
    #     print(interface['Association']['PublicIp'])

    client = boto3.client('route53')
    add_cname_record('manualtest.games.defruss.com', '13.244.87.5', 'CREATE', 'A', 300)
