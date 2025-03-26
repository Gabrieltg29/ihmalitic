FROM python:3.12-slim


COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN groupadd -g 10001 imh && \
   useradd -u 10000 -g imh imh &&\
   mkdir -p /home/imh/.cache &&\
   chown -R imh:imh /home/imh

USER imh:imh

WORKDIR /app

COPY ./src/ ./src/

RUN chown -R imh:imh /home/imh/.cache

COPY ./pyproject.toml .

RUN uv sync --no-install-project --no-sources

CMD [".venv/bin/python", "src/manage.py", "runserver", "0.0.0.0:8000"]
