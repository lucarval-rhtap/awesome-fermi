FROM registry.access.redhat.com/hi/python@sha256:336f092d5fdfbc70c4b0b97498110ef5f5870122c80481971b311138b956fc12 AS builder

USER 0
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /build

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY pyproject.toml .
COPY src/ src/
RUN pip3 install --no-cache-dir --no-deps .

FROM registry.access.redhat.com/hi/python@sha256:336f092d5fdfbc70c4b0b97498110ef5f5870122c80481971b311138b956fc12

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=awesome_fermi

EXPOSE 8080
CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8080"]
