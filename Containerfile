FROM registry.access.redhat.com/hi/python:3.12-builder@sha256:418ed06209e2700a15275756567c98bfd9885abb80e6d64de767aa4f57cf0c6e AS builder

USER 0
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /build

COPY requirements.txt .
RUN --mount=type=secret,id=netrc,target=$HOME/.netrc pip3 install --no-cache-dir -r requirements.txt

COPY pyproject.toml .
COPY src/ src/
RUN --mount=type=secret,id=netrc,target=$HOME/.netrc pip3 install --no-cache-dir --no-deps .

FROM registry.access.redhat.com/hi/python:3.12@sha256:2764c1d9a5e45115f42b334e3c3dc1b501f18eaf09550ff345f81a564f3b3f49

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=awesome_fermi

EXPOSE 8080
CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8080"]
