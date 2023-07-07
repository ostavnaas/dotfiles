from __future__ import annotations

import sys
from dataclasses import dataclass
from pprint import pprint
from typing import Any

import httpx


@dataclass
class Repo:
    project: str
    repo: str
    arch: str = "amd64"
    alt_arch = "x86_64"
    os: str = "linux"

    @property
    def url(self) -> str:
        return f"https://github.com/{self.project}/{self.repo}"

    def file_name(self, tag_name: str) -> str:
        tag = tag_name.replace("v", "")
        if self.project == "helmfile" and self.repo == "helmfile":
            return f"{self.repo}_{tag}_{self.os}_{self.arch}.tar.gz"
        if self.project == "docker" and self.repo == "compose":
            return f"{self.project}-{self.repo}-{self.os}-{self.alt_arch}"
        if self.project == "mozilla" and self.repo == "sops":
            return f"{self.repo}-{tag_name}.{self.os}.{self.arch}"

        raise NotImplemented()

    @property
    def api(self):
        return f"https://api.github.com/repos/{self.project}/{self.repo}"


@dataclass
class Release:
    tag_name: str
    download_url: str | None = None

    @classmethod
    def from_json(cls, json: Any, repo: Repo) -> Release:
        tag_name = json["tag_name"]
        [download_url] = [
            url["browser_download_url"]
            for url in json["assets"]
            if url["name"] == repo.file_name(tag_name)
        ]
        return cls(tag_name=tag_name, download_url=download_url)


def get_latest_version(repo: Repo):
    r = httpx.get(repo.api + "/releases/latest")

    #    pprint(r.json())

    print(Release.from_json(r.json(), repo))


# project, repo = sys.argv[1].split("/")
projects = [("helfile", "helmfile"), "mozilla/sops", "docker/compose"]
for p in projects:
    get_latest_version(Repo(project, repo))
