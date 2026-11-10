"""Tiny data API: serves basic statistics about a CSV file."""

import os
from pathlib import Path

import pandas as pd
from fastapi import FastAPI, HTTPException

DATA_PATH = Path(os.getenv("DATA_PATH", "data/sales.csv"))

app = FastAPI(title="CSV Stats API")


def load_data() -> pd.DataFrame:
    if not DATA_PATH.exists():
        raise HTTPException(status_code=404, detail=f"Data file not found: {DATA_PATH}")
    return pd.read_csv(DATA_PATH)


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.get("/columns")
def columns() -> dict:
    df = load_data()
    return {"rows": len(df), "columns": {col: str(dtype) for col, dtype in df.dtypes.items()}}


@app.get("/stats")
def stats() -> dict:
    df = load_data()
    # describe() returns NaN for some cells; replace them so the result is valid JSON.
    summary = df.describe(include="all").astype(object)
    return summary.where(summary.notna(), None).to_dict()


@app.get("/stats/{column}")
def column_stats(column: str) -> dict:
    df = load_data()
    if column not in df.columns:
        raise HTTPException(status_code=404, detail=f"Unknown column: {column}")
    series = df[column]
    if pd.api.types.is_numeric_dtype(series):
        return {
            "column": column,
            "min": float(series.min()),
            "max": float(series.max()),
            "mean": float(series.mean()),
            "sum": float(series.sum()),
        }
    return {"column": column, "unique": int(series.nunique()), "top_values": series.value_counts().head(5).to_dict()}
