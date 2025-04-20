FROM python:3.12-slim

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN groupadd -g 1000 imh && \
   useradd -u 1000 -g imh imh &&\
   mkdir -p /home/imh/.cache &&\
   chown -R imh:imh /home/imh &&\
   chown -R imh:imh /app

USER imh:imh


COPY --chown=imh:imh ./src/ ./src/

RUN chown -R imh:imh /home/imh/.cache

COPY --chown=imh:imh ./pyproject.toml .

RUN uv sync --no-install-project --no-sources

CMD [".venv/bin/python", "src/manage.py", "runserver", "0.0.0.0:8000"]
