FROM registry.access.redhat.com/hi/python:3.14-builder@sha256:03cf946c7166c5652fe7b41a2531379a5f5dd9db313b5dd2b89e2b96cc033e3f AS builder

USER 0
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /build

COPY requirements.txt .
RUN --mount=type=secret,id=netrc,target=$HOME/.netrc pip3 install --no-cache-dir -r requirements.txt

COPY pyproject.toml .
COPY src/ src/
RUN pip3 install --no-cache-dir --no-deps .

FROM registry.access.redhat.com/hi/python:3.14@sha256:926e2552bd26c01fcd910d39278efd6756ee6a5d237819814f6da50fffd8115e

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=awesome_fermi

EXPOSE 8080
CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8080"]
