import json
import boto3

def lambda_handler(event, context):
    # Create an EC2 resource object for the desired region
    ec2_resource = boto3.resource("ec2", region_name="us-east-1")

    # Define filter for "running" instances with the Environment:Dev tag and store in a variable called "instances"
    instances = ec2_resource.instances.filter(
        Filters=[
            {'Name': 'instance-state-name', 'Values': ['running']},
            {'Name': 'tag:Environment', 'Values': ['Dev']}
        ]
    )

    # Extract the instance IDs from the "instances" variable
    instance_ids = [instance.id for instance in instances]

    # Stop each instance
    for instance_id in instance_ids:
        # Create an EC2 instance object using the instance ID
        instance = ec2_resource.Instance(instance_id)

        # Extract the instance name from its tags
        instance_name = ''
        for tag in instance.tags:
            if tag['Key'] == 'Name':
                instance_name = tag['Value']
                break

        # Stop the instance
        instance.stop()

        # Print a message indicating the instance name and that it was stopped successfully
        if instance_name:
            print(f'Instance "{instance_name}" stopped successfully')
        else:
            print(f'Instance "{instance_id}" stopped successfully')
        
    return {
        'statusCode': 200,
        'body': json.dumps('Success')
    }