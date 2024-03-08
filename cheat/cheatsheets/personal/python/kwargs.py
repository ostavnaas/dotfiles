from typing import TypedDict, Unpack


class Movie(TypedDict):
    name: str
    year: int


def print_movie(**kwargs: Unpack[Movie]):
    print(kwargs["name"])


gf = Movie({"name": "The Godfather", "year": 1972})
print_movie(**gf)
