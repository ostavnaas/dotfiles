import sys
from pydantic.alias_generators import to_pascal
from pprint import pprint
from pydantic import AfterValidator, BaseModel, ConfigDict, Field
from typing import Annotated, NewType


CVSS = NewType("CVSS", str)


def to_attack_vector_metric_value(v: str) -> str:
    match v:
        case "N":
            return "Network"
        case "A":
            return "Adjacent"
        case "L":
            return "Local"
        case "P":
            return "Physical"
        case _:
            return v


def to_common_metric_value(v: str) -> str:
    match v:
        case "L":
            return "Low"
        case "H":
            return "High"
        case "N":
            return "None"
        case "U":
            return "Unchanged"
        case "C":
            return "Changed"
        case "R":
            return "Required"
        case _:
            return v


CommonMetric = Annotated[str, AfterValidator(to_common_metric_value)]
AttackVectorMetric = Annotated[str, AfterValidator(to_attack_vector_metric_value)]


class CVSSScore(BaseModel):
    model_config = ConfigDict(alias_generator=to_pascal)

    cvss_version: CommonMetric = Field(validation_alias="CVSS")
    attack_complexity: AttackVectorMetric = Field(validation_alias="AC")
    privileges_required: CommonMetric = Field(validation_alias="AC")
    user_interaction: CommonMetric = Field(validation_alias="UI")
    scope: CommonMetric = Field(validation_alias="S")
    confidentiality: CommonMetric = Field(validation_alias="C")
    integrity: CommonMetric = Field(validation_alias="I")
    availability: CommonMetric = Field(validation_alias="A")


if __name__ == "__main__":
    if len(sys.argv) <= 1:
        print("CVSS Vector (eg. CVSS:3.1/AV:N/AC:L/PR:H/UI:R/S:C/C:L/I:L/A:N)")
        sys.exit(1)
    cvss_argument = sys.argv[1]

    pprint(
        CVSSScore.model_validate(
            {k: v for k, v in [item.split(":") for item in cvss_argument.split("/")]}
        ).model_dump(by_alias=True)
    )
