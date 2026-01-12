from botocore.config import Config
import boto3

# https://botocore.amazonaws.com/v1/documentation/api/latest/reference/config.html

# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/configuration.html

AWS_ACCESS_KEY_ID = "foo"
AWS_SECRET_ACCESS_KEY = "bar"
sts = boto3.client(
    service_name="sts",
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    region_name="eu-central-1",
    config=Config(max_pool_connections=100, tcp_keepalive=True),
)

sts.client.get_caller_identity()
"""
response = {
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/Alice",
    "UserId": "AKIAI44QH8DHBEXAMPLE",
    "ResponseMetadata": {
        "...": "...",
    },
}
"""
