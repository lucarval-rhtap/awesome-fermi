FROM registry.access.redhat.com/hi/python:3.12-builder@sha256:83a8d45c8cf97d0581ac4248a2ac2727eb3549165429cc9e072f437a67f33bda AS builder

USER 0
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /build

COPY requirements.txt .
RUN --mount=type=secret,id=netrc,target=$HOME/.netrc pip3 install --no-cache-dir -r requirements.txt

COPY pyproject.toml .
COPY src/ src/
RUN --mount=type=secret,id=netrc,target=$HOME/.netrc pip3 install --no-cache-dir --no-deps .

FROM registry.access.redhat.com/hi/python:3.12@sha256:aab4f05539f774dd5d2cd487f553f982bb44fcfed1a627ef636cbd3ebd549a57

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=awesome_fermi

EXPOSE 8080
CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8080"]
