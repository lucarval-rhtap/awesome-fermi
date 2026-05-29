# awesome-fermi

A simple Flask hello-world webapp.

## Setup

```bash
python -m venv venv
source venv/bin/activate
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

## Install production dependencies only

```bash
pip install -e .
```
