from __future__ import annotations
from pathlib import Path
import subprocess
from pydantic import BaseModel, Field
import logging

from dataclasses import dataclass

import httpx


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Release(BaseModel):
    tag_name: str = Field(..., serialization_alias="tag_name")
    assets: list[asset] = Field(..., serialization_alias="assets")


class asset(BaseModel):
    name: str
    browser_download_url: str


@dataclass
class Repo:
    project: str
    repo: str
    arch: str = "amd64"
    alt_arch = "x86_64"
    os: str = "linux"
    release: Release | None = None

    def get_latest_release(self) -> None:
        reps = httpx.get(self.release_url)
        self.release = Release.model_validate_json(reps.content)

    @property
    def url(self) -> str:
        return f"https://github.com/{self.project}/{self.repo}"

    @property
    def file_name(self) -> str:
        assert self.release
        tag: str = self.release.tag_name.replace("v", "")
        match self.project, self.repo:
            case "helmfile", "helmfile":
                return f"{self.repo}_{tag}_{self.os}_{self.arch}.tar.gz"
            case "docker", "compose":
                return f"{self.project}-{self.repo}-{self.os}-{self.alt_arch}"
            case "getsops", "sops":
                return f"{self.repo}-{self.release.tag_name}.{self.os}.{self.arch}"
            case "helm", "helm":
                return (
                    f"{self.repo}-{self.release.tag_name}-{self.os}-{self.arch}.tar.gz"
                )
            case _:
                raise NotImplementedError()

    @property
    def get_release_download_url(self) -> str | None:
        if (url := self.download_url_outside_github()) is not None:
            return url + self.file_name

        assert self.release
        for r in self.release.assets:
            if r.name == self.file_name:
                return r.browser_download_url
        else:
            return None

    @property
    def api(self):
        return f"https://api.github.com/repos/{self.project}/{self.repo}"

    @property
    def release_url(self) -> str:
        return self.api + "/releases/latest"

    def download_url_outside_github(self) -> str | None:
        match self.project, self.repo:
            case "helm", "helm":
                return "https://get.helm.sh/"
            case _:
                return None

    def decompress(self, folder: Path):
        download_path: Path = folder / self.file_name
        print(str(folder))
        subprocess.run(["tar", "zxvf", f"{download_path}", "-C", f"{folder}"])


def download_latest_version(repo: Repo, folder: Path):
    repo.get_latest_release()

    if (download_link := repo.get_release_download_url) is not None:
        file_name = Path(repo.file_name)
        download_path: Path = folder / file_name

        if download_path.exists():
            repo.decompress(folder)
            logging.info("Release already downloaded")
            return

        with download_path.open(mode="wb") as file, httpx.stream(
            "GET", download_link, follow_redirects=True
        ) as reps:
            for data in reps.iter_bytes():
                file.write(data)


# project, repo = sys.argv[1].split("/")
# projects = [("helmfile", "helmfile"), ("getsops", "sops"), ("docker", "compose")]
projects: list[tuple[str, str]] = [
    ("helmfile", "helmfile"),
]
projects: list[tuple[str, str]] = [
    ("pyen", "pyenv"),
]
for p in projects:
    download_latest_version(Repo(*p), Path("~/.local/.bin"))
