import boto3
import os

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    action = os.environ.get('ACTION', 'stop')
    tag_key = "Name"
    tag_value = "HelloWorldInstance"
    
    response = ec2.describe_instances(
        Filters=[{'Name': f'tag:{tag_key}', 'Values': [tag_value]}]
    )
    
    instance_ids = []
    for reservation in response.get('Reservations', []):
        for instance in reservation.get('Instances', []):
            state = instance.get('State', {}).get('Name')
            if action == 'stop' and state == 'running':
                instance_ids.append(instance['InstanceId'])
            elif action == 'start' and state == 'stopped':
                instance_ids.append(instance['InstanceId'])
    
    if instance_ids:
        if action == 'stop':
            ec2.stop_instances(InstanceIds=instance_ids)
        elif action == 'start':
            ec2.start_instances(InstanceIds=instance_ids)
    
    print(f"Action {action} triggered on instances: {instance_ids}")
    return {
        'statusCode': 200,
        'body': f'Action {action} performed on: {instance_ids}'
    }
