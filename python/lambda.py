import boto3

def lambda_demo(event, context):
    ec2_resource = boto3.resource("ec2", region_name="us-east-1")
    instances = ec2_resource.instances.filter(
        Filters=[
            {'Name': 'instance-state-name', 'Values': ['running']},
        ]
    )

    instance_ids = [instance.id for instance in instances]

    # Stop instances
    for instance_id in instance_ids:
        instance = ec2_resource.Instance(instance_id)

        instance_name = ''
        for tag in instance.tags:
            if tag['Key'] == 'Name':
                instance_name = tag['Value']
                break
        instance.stop()
    
    ## Confirm  
        if instance_name:
            print(f'Instance "{instance_name}" stopped successfully')
        else:
            print(f'Instance "{instance_id}" stopped successfully')
