"""Spins up a new ECS instances from an existing task definition"""

import boto3

client = boto3.client(
    'ecs',
    aws_access_key_id="AKIAZJ54PQLLTKDBZEFZ",
    aws_secret_access_key="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",
    )

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

# Here is the run_task response
# {'tasks': [{'attachments': [{'id': '86baaf97-8c61-46a9-b1ee-a64f7d5f817d', 'type': 'ElasticNetworkInterface', 'status': 'PRECREATED', 'details': [{'name': 'subnetId', 'value': 'subnet-0a98dc0cecd8268a3'}]}], 'availabilityZone': 'af-south-1a', 'capacityProviderName': 'FARGATE_SPOT', 'clusterArn': 'arn:aws:ecs:af-south-1:639808537303:cluster/rsa_tf', 'containers': [{'containerArn': 'arn:aws:ecs:af-south-1:639808537303:container/ad1b1701-d238-4304-b88f-dc7c119a7fae', 'taskArn': 'arn:aws:ecs:af-south-1:639808537303:task/rsa_tf/9e8278b1f094478389095283e8fda2f1', 'name': 'tf2', 'image': 'cm2network/tf2:latest', 'lastStatus': 'PENDING', 'networkInterfaces': [], 'cpu': '1024', 'memory': '2048', 'memoryReservation': '2048'}], 'cpu': '1024', 'createdAt': datetime.datetime(2020, 11, 12, 22, 8, 40, 605000, tzinfo=tzlocal()), 'desiredStatus': 'RUNNING', 'group': 'tf2-server', 'lastStatus': 'PROVISIONING', 'launchType': 'FARGATE', 'memory': '2048', 'overrides': {'containerOverrides': [{'name': 'tf2', 'environment': [{'name': 'SRCDS_HOSTNAME', 'value': 'rsa.tf | Experiment #3'}], 'cpu': 1, 'memory': 2048, 'memoryReservation': 2048}], 'inferenceAcceleratorOverrides': []}, 'platformVersion': '1.4.0', 'tags': [{'key': 'aws:ecs:clusterName', 'value': 'rsa_tf'}, {'key': 'game_type', 'value': 'tf2'}], 'taskArn': 'arn:aws:ecs:af-south-1:639808537303:task/rsa_tf/9e8278b1f094478389095283e8fda2f1', 'taskDefinitionArn': 'arn:aws:ecs:af-south-1:639808537303:task-definition/tf2-server:12', 'version': 1}], 'failures': [], 'ResponseMetadata': {'RequestId': '08814abc-5bf2-40d2-9616-fa48d8ed7be4', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '08814abc-5bf2-40d2-9616-fa48d8ed7be4', 'content-type': 'application/x-amz-json-1.1', 'content-length': '1408', 'date': 'Thu, 12 Nov 2020 20:08:40 GMT'}, 'RetryAttempts': 0}}