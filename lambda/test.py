import json

# with open('example_ecs_event.json') as f:
#     s = json.load(f)

# with open('example_describe_interfaces.json') as g:
#     i = json.load(g.read())

# if s['detail-type'] == "ECS Task State Change":
#     if s['detail']['lastStatus'] == "PROVISIONING":
#         print("No ENI yet")
#     if s['detail']['lastStatus'] == "RUNNING":
#         for attachment in s['detail']['attachments']:
#             for detail in attachment['details']:
#                 if detail['name'] == "networkInterfaceId":
#                     print(detail['value'])

# print(i['NetworkInterfaces'])