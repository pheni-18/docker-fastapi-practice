FROM python:3.10-slim as builder

RUN apt-get update && apt-get install gcc -y

WORKDIR /usr/src

RUN pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry export -f requirements.txt > requirements.txt


FROM python:3.10-slim

RUN apt-get update && apt-get install gcc -y

ENV PYTHONUNBUFFERED=1

WORKDIR /usr/src

COPY --from=builder /usr/src/requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 8000
CMD [ "uvicorn", "api.main:app", "--host", "0.0.0.0" ]
