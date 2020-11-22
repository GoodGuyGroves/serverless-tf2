"""Spins up a new ECS instances from an existing task definition"""
import json
import boto3



def create_server(event, context):
    pass

if __name__ == '__main__':
    aws_session = boto3.session.Session()
    print(aws_session)

    client = aws_session.client('ecs')

    response = client.run_task(
        capacityProviderStrategy = [
            {
                "capacityProvider": "FARGATE_SPOT",
                "weight": 100,
                "base": 1
            }
        ],
        cluster = "rsa_tf",
        count = 1,
        enableECSManagedTags = True,
        group = "tf2-server",
        networkConfiguration = {
            "awsvpcConfiguration": {
                "subnets": [
                    "subnet-0a98dc0cecd8268a3"
                ],
                "securityGroups": [
                    "sg-0838e5a4a93ec01b0"
                ],
                "assignPublicIp": "ENABLED"
            }
        },
        overrides={
            "containerOverrides": [
                {
                    "name": "tf2",
                    # "command": [
                    #     ""
                    # ],
                    "environment": [
                        {
                            "name": "SRCDS_HOSTNAME",
                            "value": "rsa.tf | Experiment #3"
                        },
                    ],
                    "cpu": 1,
                    "memory": 2048,
                    "memoryReservation": 2048,
                }
            ],
            # "cpu": "",
            # "executionRoleArn": "",
            # "memory": "",
            # "taskRoleArn": ""
        },
        platformVersion = "1.4.0",
        tags = [
            {
                "key": "game_type",
                "value": "tf2"
            }
        ],
        taskDefinition = "tf2-server"
    )

    print("Here is the run_task response")
    print(response)

# def hello(event, context):
#     body = {
#         "message": "Go Serverless v1.0! Your function executed successfully!",
#         "input": event
#     }

#     response = {
#         "statusCode": 200,
#         "body": json.dumps(body)
#     }

#     return response

#     # Use this code if you don't use the http event with the LAMBDA-PROXY
#     # integration
#     """
#     return {
#         "message": "Go Serverless v1.0! Your function executed successfully!",
#         "event": event
#     }
#     """

# Here is the run_task response
# {'tasks': [
#         {'attachments': [
#                 {'id': '86baaf97-8c61-46a9-b1ee-a64f7d5f817d', 'type': 'ElasticNetworkInterface', 'status': 'PRECREATED', 'details': [
#                         {'name': 'subnetId', 'value': 'subnet-0a98dc0cecd8268a3'
#                         }
#                     ]
#                 }
#             ], 'availabilityZone': 'af-south-1a', 'capacityProviderName': 'FARGATE_SPOT', 'clusterArn': 'arn:aws:ecs:af-south-1: 639808537303:cluster/rsa_tf', 'containers': [
#                 {'containerArn': 'arn:aws:ecs:af-south-1: 639808537303:container/ad1b1701-d238-4304-b88f-dc7c119a7fae', 'taskArn': 'arn:aws:ecs:af-south-1: 639808537303:task/rsa_tf/9e8278b1f094478389095283e8fda2f1', 'name': 'tf2', 'image': 'cm2network/tf2:latest', 'lastStatus': 'PENDING', 'networkInterfaces': [], 'cpu': '1024', 'memory': '2048', 'memoryReservation': '2048'
#                 }
#             ], 'cpu': '1024', 'createdAt': datetime.datetime(2020,
#             11,
#             12,
#             22,
#             8,
#             40,
#             605000, tzinfo=tzlocal()), 'desiredStatus': 'RUNNING', 'group': 'tf2-server', 'lastStatus': 'PROVISIONING', 'launchType': 'FARGATE', 'memory': '2048', 'overrides': {'containerOverrides': [
#                     {'name': 'tf2', 'environment': [
#                             {'name': 'SRCDS_HOSTNAME', 'value': 'rsa.tf | Experiment #3'
#                             }
#                         ], 'cpu': 1, 'memory': 2048, 'memoryReservation': 2048
#                     }
#                 ], 'inferenceAcceleratorOverrides': []
#             }, 'platformVersion': '1.4.0', 'tags': [
#                 {'key': 'aws:ecs:clusterName', 'value': 'rsa_tf'
#                 },
#                 {'key': 'game_type', 'value': 'tf2'
#                 }
#             ], 'taskArn': 'arn:aws:ecs:af-south-1: 639808537303:task/rsa_tf/9e8278b1f094478389095283e8fda2f1', 'taskDefinitionArn': 'arn:aws:ecs:af-south-1: 639808537303:task-definition/tf2-server: 12', 'version': 1
#         }
#     ], 'failures': [], 'ResponseMetadata': {'RequestId': '08814abc-5bf2-40d2-9616-fa48d8ed7be4', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '08814abc-5bf2-40d2-9616-fa48d8ed7be4', 'content-type': 'application/x-amz-json-1.1', 'content-length': '1408', 'date': 'Thu,
#             12 Nov 2020 20: 08: 40 GMT'
#         }, 'RetryAttempts': 0
#     }
# }

# response = client.describe_tasks(
#     cluster='string',
#     tasks=[
#         'string',
#     ],
#     include=[
#         'TAGS',
#     ]
# )

# {
#     'tasks': [
#         {
#             'attachments': [
#                 {
#                     'id': 'string',
#                     'type': 'string',
#                     'status': 'string',
#                     'details': [
#                         {
#                             'name': 'string',
#                             'value': 'string'
#                         },
#                     ]
#                 },
#             ],
#             'attributes': [
#                 {
#                     'name': 'string',
#                     'value': 'string',
#                     'targetType': 'container-instance',
#                     'targetId': 'string'
#                 },
#             ],
#             'availabilityZone': 'string',
#             'capacityProviderName': 'string',
#             'clusterArn': 'string',
#             'connectivity': 'CONNECTED'|'DISCONNECTED',
#             'connectivityAt': datetime(2015, 1, 1),
#             'containerInstanceArn': 'string',
#             'containers': [
#                 {
#                     'containerArn': 'string',
#                     'taskArn': 'string',
#                     'name': 'string',
#                     'image': 'string',
#                     'imageDigest': 'string',
#                     'runtimeId': 'string',
#                     'lastStatus': 'string',
#                     'exitCode': 123,
#                     'reason': 'string',
#                     'networkBindings': [
#                         {
#                             'bindIP': 'string',
#                             'containerPort': 123,
#                             'hostPort': 123,
#                             'protocol': 'tcp'|'udp'
#                         },
#                     ],
#                     'networkInterfaces': [
#                         {
#                             'attachmentId': 'string',
#                             'privateIpv4Address': 'string',
#                             'ipv6Address': 'string'
#                         },
#                     ],
#                     'healthStatus': 'HEALTHY'|'UNHEALTHY'|'UNKNOWN',
#                     'cpu': 'string',
#                     'memory': 'string',
#                     'memoryReservation': 'string',
#                     'gpuIds': [
#                         'string',
#                     ]
#                 },
#             ],
#             'cpu': 'string',
#             'createdAt': datetime(2015, 1, 1),
#             'desiredStatus': 'string',
#             'executionStoppedAt': datetime(2015, 1, 1),
#             'group': 'string',
#             'healthStatus': 'HEALTHY'|'UNHEALTHY'|'UNKNOWN',
#             'inferenceAccelerators': [
#                 {
#                     'deviceName': 'string',
#                     'deviceType': 'string'
#                 },
#             ],
#             'lastStatus': 'string',
#             'launchType': 'EC2'|'FARGATE',
#             'memory': 'string',
#             'overrides': {
#                 'containerOverrides': [
#                     {
#                         'name': 'string',
#                         'command': [
#                             'string',
#                         ],
#                         'environment': [
#                             {
#                                 'name': 'string',
#                                 'value': 'string'
#                             },
#                         ],
#                         'environmentFiles': [
#                             {
#                                 'value': 'string',
#                                 'type': 's3'
#                             },
#                         ],
#                         'cpu': 123,
#                         'memory': 123,
#                         'memoryReservation': 123,
#                         'resourceRequirements': [
#                             {
#                                 'value': 'string',
#                                 'type': 'GPU'|'InferenceAccelerator'
#                             },
#                         ]
#                     },
#                 ],
#                 'cpu': 'string',
#                 'inferenceAcceleratorOverrides': [
#                     {
#                         'deviceName': 'string',
#                         'deviceType': 'string'
#                     },
#                 ],
#                 'executionRoleArn': 'string',
#                 'memory': 'string',
#                 'taskRoleArn': 'string'
#             },
#             'platformVersion': 'string',
#             'pullStartedAt': datetime(2015, 1, 1),
#             'pullStoppedAt': datetime(2015, 1, 1),
#             'startedAt': datetime(2015, 1, 1),
#             'startedBy': 'string',
#             'stopCode': 'TaskFailedToStart'|'EssentialContainerExited'|'UserInitiated',
#             'stoppedAt': datetime(2015, 1, 1),
#             'stoppedReason': 'string',
#             'stoppingAt': datetime(2015, 1, 1),
#             'tags': [
#                 {
#                     'key': 'string',
#                     'value': 'string'
#                 },
#             ],
#             'taskArn': 'string',
#             'taskDefinitionArn': 'string',
#             'version': 123
#         },
#     ],
#     'failures': [
#         {
#             'arn': 'string',
#             'reason': 'string',
#             'detail': 'string'
#         },
#     ]
# }

# response = client.stop_task(
#     cluster='string',
#     task='string',
#     reason='string'
# )

#     'task': {
#         'attachments': [
#             {
#                 'id': 'string',
#                 'type': 'string',
#                 'status': 'string',
#                 'details': [
#                     {
#                         'name': 'string',
#                         'value': 'string'
#                     },
#                 ]
#             },
#         ],
#         'attributes': [
#             {
#                 'name': 'string',
#                 'value': 'string',
#                 'targetType': 'container-instance',
#                 'targetId': 'string'
#             },
#         ],
#         'availabilityZone': 'string',
#         'capacityProviderName': 'string',
#         'clusterArn': 'string',
#         'connectivity': 'CONNECTED'|'DISCONNECTED',
#         'connectivityAt': datetime(2015, 1, 1),
#         'containerInstanceArn': 'string',
#         'containers': [
#             {
#                 'containerArn': 'string',
#                 'taskArn': 'string',
#                 'name': 'string',
#                 'image': 'string',
#                 'imageDigest': 'string',
#                 'runtimeId': 'string',
#                 'lastStatus': 'string',
#                 'exitCode': 123,
#                 'reason': 'string',
#                 'networkBindings': [
#                     {
#                         'bindIP': 'string',
#                         'containerPort': 123,
#                         'hostPort': 123,
#                         'protocol': 'tcp'|'udp'
#                     },
#                 ],
#                 'networkInterfaces': [
#                     {
#                         'attachmentId': 'string',
#                         'privateIpv4Address': 'string',
#                         'ipv6Address': 'string'
#                     },
#                 ],
#                 'healthStatus': 'HEALTHY'|'UNHEALTHY'|'UNKNOWN',
#                 'cpu': 'string',
#                 'memory': 'string',
#                 'memoryReservation': 'string',
#                 'gpuIds': [
#                     'string',
#                 ]
#             },
#         ],
#         'cpu': 'string',
#         'createdAt': datetime(2015, 1, 1),
#         'desiredStatus': 'string',
#         'executionStoppedAt': datetime(2015, 1, 1),
#         'group': 'string',
#         'healthStatus': 'HEALTHY'|'UNHEALTHY'|'UNKNOWN',
#         'inferenceAccelerators': [
#             {
#                 'deviceName': 'string',
#                 'deviceType': 'string'
#             },
#         ],
#         'lastStatus': 'string',
#         'launchType': 'EC2'|'FARGATE',
#         'memory': 'string',
#         'overrides': {
#             'containerOverrides': [
#                 {
#                     'name': 'string',
#                     'command': [
#                         'string',
#                     ],
#                     'environment': [
#                         {
#                             'name': 'string',
#                             'value': 'string'
#                         },
#                     ],
#                     'environmentFiles': [
#                         {
#                             'value': 'string',
#                             'type': 's3'
#                         },
#                     ],
#                     'cpu': 123,
#                     'memory': 123,
#                     'memoryReservation': 123,
#                     'resourceRequirements': [
#                         {
#                             'value': 'string',
#                             'type': 'GPU'|'InferenceAccelerator'
#                         },
#                     ]
#                 },
#             ],
#             'cpu': 'string',
#             'inferenceAcceleratorOverrides': [
#                 {
#                     'deviceName': 'string',
#                     'deviceType': 'string'
#                 },
#             ],
#             'executionRoleArn': 'string',
#             'memory': 'string',
#             'taskRoleArn': 'string'
#         },
#         'platformVersion': 'string',
#         'pullStartedAt': datetime(2015, 1, 1),
#         'pullStoppedAt': datetime(2015, 1, 1),
#         'startedAt': datetime(2015, 1, 1),
#         'startedBy': 'string',
#         'stopCode': 'TaskFailedToStart'|'EssentialContainerExited'|'UserInitiated',
#         'stoppedAt': datetime(2015, 1, 1),
#         'stoppedReason': 'string',
#         'stoppingAt': datetime(2015, 1, 1),
#         'tags': [
#             {
#                 'key': 'string',
#                 'value': 'string'
#             },
#         ],
#         'taskArn': 'string',
#         'taskDefinitionArn': 'string',
#         'version': 123
#     }
# }