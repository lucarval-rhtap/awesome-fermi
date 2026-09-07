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

FROM registry.access.redhat.com/hi/python:3.12@sha256:dab536a947c45853b1618957bd01f4461e315994e387f0b8715f76f3d4915fdd

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=awesome_fermi

EXPOSE 8080
CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8080"]
