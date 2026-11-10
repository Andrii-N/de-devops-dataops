# CSV Stats API

**Docker image:**
https://hub.docker.com/repository/docker/andriide7600/csv-stats-api/general

A small FastAPI service that returns basic statistics about a CSV file using pandas. The image uses a multi-stage Docker build: dependencies are installed in a `builder` stage, and only the resulting virtualenv and the app are copied into a slim `runtime` stage that runs as a non-root user.

## Run from Docker Hub

```sh
docker run --rm -p 8000:8000 andriide7600/csv-stats-api:1.0
```

Then open http://localhost:8000/docs for the interactive API docs.

## Build and run locally

```sh
docker build -t csv-stats-api .
docker run --rm -p 8000:8000 csv-stats-api
```

## Endpoints

| Endpoint | Returns |
|---|---|
| `GET /health` | `{"status": "ok"}` |
| `GET /columns` | Row count and column types |
| `GET /stats` | Summary statistics for all columns |
| `GET /stats/{column}` | Min/max/mean/sum for numeric columns, top values for text columns |

Example: `curl http://localhost:8000/stats/units`

## Use your own CSV

The image includes `data/sales.csv` as sample data. To use another file, mount it and point `DATA_PATH` at it:

```sh
docker run --rm -p 8000:8000 \
  -v "$(pwd)/my-data:/data" \
  -e DATA_PATH=/data/my-file.csv \
  <username>/csv-stats-api:1.0
```
