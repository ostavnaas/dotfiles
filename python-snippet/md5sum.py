import hashlib


def md5sum(path: str) -> str:
    d = hashlib.md5()
    with open(path, "rb") as data:
        for chunk in iter(lambda: data.read(4096), b""):
            d.update(chunk)

    return d.hexdigest()
