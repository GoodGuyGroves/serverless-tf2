"""Gets triggered when an ECS container status changes"""
import json
import boto3

def add_cname_record(Name, value, action, record_type, ttl):
    r53_client = boto3.client('route53')
    try:
        response = r53_client.change_resource_record_sets(
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

def event_handler(event, context):
    """Checks for status change from PENDING to RUNNING and assigns a domain name to the container IP"""

    if event["source"] != "aws.ecs":
        raise ValueError("Function only supports input from events with a source type of: aws.ecs")

    print('Here is the event:')
    print(json.dumps(event))

    eni=""
    if event['detail-type'] == "ECS Task State Change":
        if event['detail']['lastStatus'] == "PROVISIONING":
            print("No ENI yet")
        if event['detail']['lastStatus'] == "PENDING":
            for attachment in event['detail']['attachments']:
                for detail in attachment['details']:
                    if detail['name'] == "networkInterfaceId":
                        eni = detail['value']
                        print("Eni is: %s" % eni)

                        client = boto3.client('ec2')
                        response = client.describe_network_interfaces(
                            NetworkInterfaceIds=[
                                eni
                            ]
                        )

                        for interface in response['NetworkInterfaces']:
                            ip_addr = interface['Association']['PublicIp']
                            print("IP: %s" % ip_addr)

                        add_cname_record('test.games.defruss.com', ip_addr, 'CREATE', 'A', 300)
