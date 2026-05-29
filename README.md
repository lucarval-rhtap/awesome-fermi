# awesome-fermi

A simple Flask hello-world webapp.

## Setup

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install -e ".[dev]"
```

## Run the dev server

```bash
flask --app awesome_fermi run --debug
```

The app will be available at http://localhost:5000.

## Run tests

```bash
pytest
```

With verbose output:

```bash
pytest -v
```

## Container image

Build and run with podman:

```bash
podman build --secret id=netrc,src=$HOME/.netrc -t awesome-fermi .
podman run -p 8080:8080 awesome-fermi
```

The app will be available at http://127.0.0.1:8080.

The image uses [Red Hat Hardened Images](https://developers.redhat.com/articles/2026/05/12/red-hat-hardened-images-top-5-benefits-software-developers)
as the base with a multi-stage build: `hi/python:3.12-builder` for installing
dependencies and `hi/python:3.12` (distroless) for the runtime.

## Update dependencies

After changing dependencies in `pyproject.toml`, regenerate the lock files:

```bash
PIP_CONFIG_FILE=/dev/null pipx run --python python3.12 --spec pip-tools pip-compile --no-reuse-hashes --index-url https://packages.redhat.com/trusted-libraries/python/ --generate-hashes --output-file=requirements.txt pyproject.toml
PIP_CONFIG_FILE=/dev/null pipx run --python python3.12 pybuild-deps compile --generate-hashes -o requirements-build.txt requirements.txt
```

`requirements.txt` pins all runtime dependencies. `requirements-build.txt` pins
the build dependencies needed to compile them from source during hermetic builds.

Authentication to the package index is handled via `~/.netrc`.
