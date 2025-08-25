class Dao:
    def __init__(self, connection: None | int = None):
        self.connection = connection

    async def __aenter__(self):
        return self

    async def __aexit__(self, exc_type, exc_val, exc_tb):
        if exc_type is not None:
            print("ROLLBACK")
        else:
            print("COMMIT")

    async def cursor(self):
        raise NotImplementedError("This method is not implemented yet")


async def run_loop():
    # Will ROLLBACK
    try:
        async with Dao() as dao:
            await dao.cursor()
    except NotImplementedError:
        pass

    # Will COMMIT
    async with Dao() as dao:
        try:
            await dao.cursor()
        except NotImplementedError:
            pass
