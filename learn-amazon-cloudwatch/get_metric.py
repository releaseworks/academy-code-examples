import boto3
from datetime import datetime, timedelta

cloudwatch = boto3.client('cloudwatch')
response = cloudwatch.get_metric_statistics(
        Namespace='AWS/EC2',
        MetricName='CPUUtilization',
        Dimensions=[
            {
                'Name' : 'InstanceId',
                'Value' : 'XXXXXXXXXX' # Please enter your EC2 instance ID here
            }
        ],  
        StartTime=datetime.utcnow() - timedelta(seconds=600),
        EndTime=datetime.utcnow(),
        Period=60,
        Statistics=[
            'Average'
        ]
   )

# print(response)

for i in response["Datapoints"]:
    # print(i)
    average_cpu = round(i["Average"],1)
    print("{}%".format(average_cpu))
    