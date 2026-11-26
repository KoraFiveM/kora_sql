from pathlib import Path, PurePosixPath
import re
import subprocess
import sys
import tempfile
from zipfile import ZIP_DEFLATED, ZipFile

TEST_DIRS = {"test", "tests", "__tests__", "spec", "specs", "[test]"}
DEV_DIRS = {".github", ".standards"}
DEV_FILES = {"AGENTS.md", "CONTRIBUTING.md", ".gitignore", ".gitattributes", ".stylua.toml"}
QA_DECLARATION = re.compile(
    rb'''(?m)^[ \t]*qa_feature[ \t]+(['"])[^\r\n]*?\1[ \t]*(?:--[^\r\n]*)?(?:\r?\n|$)'''
)
QA_FIELD = re.compile(rb"(?m)^[ \t]*qa_feature\b")


def development_file(path):
    return (
        any(part.lower() in TEST_DIRS | DEV_DIRS for part in path.parts[:-1])
        or path.name in DEV_FILES
        or path.suffix == ".feature"
        or re.search(r"\.(?:test|spec)\.[^.]+$", path.name)
    )


def package(folder, output):
    if not re.fullmatch(r"[A-Za-z0-9_.\[\]-]+", folder) or folder in {".", ".."}:
        raise ValueError("Invalid resource folder")
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as temporary:
        source = Path(temporary) / "source.zip"
        artifact = Path(temporary) / "resource.zip"
        subprocess.run(
            ["git", "archive", "--format=zip", f"--output={source}", "HEAD"],
            check=True,
        )
        with ZipFile(source) as tracked, ZipFile(artifact, "w", ZIP_DEFLATED) as release:
            count = 0
            for member in tracked.infolist():
                path = PurePosixPath(member.filename)
                if member.is_dir() or development_file(path):
                    continue
                data = tracked.read(member)
                if path.name == "fxmanifest.lua":
                    data = QA_DECLARATION.sub(b"", data)
                    if QA_FIELD.search(data):
                        raise ValueError(f"Unsupported qa_feature declaration in {path}")
                member.filename = f"{folder}/{path.as_posix()}"
                release.writestr(member, data)
                count += 1
            if not count:
                raise ValueError("The resource package is empty")
        output.write_bytes(artifact.read_bytes())


if __name__ == "__main__":
    package(sys.argv[1], Path(sys.argv[2]))
