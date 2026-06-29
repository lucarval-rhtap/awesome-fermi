FROM registry.access.redhat.com/hi/python:3.14-builder@sha256:d31b23ffd1b49355d66fc71cf3e79bae8351d8b36b4c1a29e24ae73178656c69 AS builder

USER 0
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /build

COPY requirements.txt .
RUN --mount=type=secret,id=netrc,target=$HOME/.netrc pip3 install --no-cache-dir -r requirements.txt

COPY pyproject.toml .
COPY src/ src/
RUN pip3 install --no-cache-dir --no-deps .

FROM registry.access.redhat.com/hi/python:3.14@sha256:8ad975b0cff5c0801c7335fd0d31e6c95bdc1237117deb497363599b90740b55

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=awesome_fermi

EXPOSE 8080
CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8080"]
