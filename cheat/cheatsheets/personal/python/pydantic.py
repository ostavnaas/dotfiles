from pydantic import BaseModel, ConfigDict, field_validator
from datetime import datetime, UTC
import base64


class BarModel(BaseModel):
    model_config = ConfigDict(validate_by_name=True)

    size: int
    name: str
    timestamp: float
    d: datetime

    @field_validator("name", mode="before")
    @classmethod
    def b64decode_name(cls, value: str) -> str:
        return base64.b64decode(value).decode()


m = BarModel(
    size=42,
    name="Rm9v",
    timestamp=datetime.now(UTC).timestamp(),
    d=datetime.now(UTC),
)
# BarModel(size=42, name='Foo', timestamp=1136214245.323242, d=datetime.datetime(2024, 10, 14, 6, 17, 54, 979054, tzinfo=datetime.timezone.utc))

m.model_dump_json()
# '{"size":42,"name":"Foo","timestamp":1136214245.323242,"d":"2024-10-14T06:17:54.979054Z"}'

m.model_dump(mode="json")
# {'size': 42, 'name': 'Foo', 'timestamp': 1136214245.323242, 'd': '2024-10-14T06:17:54.979054Z'}
