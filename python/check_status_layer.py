def check_status(instance_name):
    if instance_name:
        print(f'Instance "{instance_name}" stopped successfully')
    else:
        print(f'Task failed')