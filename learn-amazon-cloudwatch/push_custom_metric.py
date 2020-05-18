import boto3
import requests

r = requests.get('https://tutorials.releaseworksacademy.com/sitemap.xml')
number_of_tutorials = r.text.count('/learn/')
cloudwatch = boto3.client('cloudwatch')

response = cloudwatch.put_metric_data(
    MetricData = [
        {
            'MetricName': 'Number of Releaseworks Tutorials',
            'Unit': 'Count',
            'Value': number_of_tutorials
        },
    ],
    Namespace='Releaseworks_metrics'
)

print(response)