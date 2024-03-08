from botocore import config
from aiobotocore.session import get_session


def get_credentials():
    return "AWS_ACCESS", "AWS_SECRET"


async def get_client():
    AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY = get_credentials()
    session = get_session()
    session.set_default_client_config(config.Config(max_pool_connections=50))
    async with session.create_client(
        "s3",
        region_name="eu-west-1",
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
        aws_access_key_id=AWS_ACCESS_KEY_ID,
    ) as client:
        return client
