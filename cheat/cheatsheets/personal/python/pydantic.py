from pydantic import BaseModel, ConfigDict, field_validator, computed_field
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

    @computed_field
    @property
    def size_in_inch(self) -> float:
        return round(self.size / 2.54, 2)


m = BarModel(
    size=180,
    name="Rm9v",
    timestamp=datetime.now(UTC).timestamp(),
    d=datetime.now(UTC),
)
# BarModel(size=180, name='Foo', timestamp=1761113190.825167, d=datetime.datetime(2025, 10, 22, 6, 6, 30, 825173, tzinfo=datetime.timezone.utc), size_in_inch=70.87)

m.model_dump_json()
# '{"size":180,"name":"Foo","timestamp":1761113190.825167,"d":"2025-10-22T06:06:30.825173Z","size_in_inch":70.87}'

m.model_dump(mode="json")
# {'size': 180, 'name': 'Foo', 'timestamp': 1761113190.825167, 'd': '2025-10-22T06:06:30.825173Z', 'size_in_inch': 70.87}

m.model_dump()
# {'size': 180, 'name': 'Foo', 'timestamp': 1761113190.825167, 'd': datetime.datetime(2025, 10, 22, 6, 6, 30, 825173, tzinfo=datetime.timezone.utc), 'size_in_inch': 70.87}
