FROM --platform=$BUILDPLATFORM python:3.10-alpine AS builder

WORKDIR /code
COPY requirements.txt /code
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

COPY . .

ENV FLASK_RUN_PORT 8080
ENV FLASK_RUN_HOST 0.0.0.0

EXPOSE 8080

CMD ["flask", "--app", "web", "run"]
