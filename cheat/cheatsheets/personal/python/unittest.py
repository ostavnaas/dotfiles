from unittest import mock


class Foo:
    async def __init__(self, x):
        self.x = x

    async def __aenter__(self):
        return self

    async def __aexit__(self, exc_type, exc, tb):
        pass

    @property
    def two(self):
        return 2


async def test():
    this = mock.AsyncMock(return_value="Hello Mock")

    foo = mock.AsyncMock()
    # Mock async method
    foo.__aenter__.return_value = this
    foo.__aexit__.return_value = None

    async with foo as f:
        print(await f())
        # prints Hello Mock
    # Mock property
    type(foo).two = mock.PropertyMock(return_value=42)
    print(foo.two)
    # prints 42


if __name__ == "__main__":
    import asyncio

    asyncio.run(test())
