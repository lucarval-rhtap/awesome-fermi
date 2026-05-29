FROM registry.access.redhat.com/hi/python@sha256:b133c60e2e061fd74be0c7339749851b7791bbc4ab8e3464038d78adb322f2a3 AS builder

USER 0
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /build

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY pyproject.toml .
COPY src/ src/
RUN pip3 install --no-cache-dir --no-deps .

FROM registry.access.redhat.com/hi/python@sha256:6c19b1797df02da1cc8d8035bf999a467e7a6751ce1e94eb5eb2473f3d2e5e4c

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=awesome_fermi

EXPOSE 8080
CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8080"]
