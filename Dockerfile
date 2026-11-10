# ---------- Stage 1: builder ----------
# builds python with installed packages from requirements.txt
FROM python:3.12-slim AS builder

# Compilers are only needed if a package has no prebuilt wheel. They stay in this stage only.
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements first so this layer is cached until requirements.txt changes.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# ---------- Stage 2: runtime ----------
# Clean slim image: no compilers, no pip cache, just the virtualenv and the app.
# When the build finishes, the image you get is only the last stage. The builder stage is thrown away, along with everything installed in it
FROM python:3.12-slim AS runtime

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Run as a non-root user.
RUN useradd --create-home --uid 1000 appuser

WORKDIR /home/appuser/service

# copies the result of the build (the installed packages) without the tools that produced it (only what's needed to run the app).
COPY --from=builder /opt/venv /opt/venv
COPY --chown=appuser:appuser app/ app/
COPY --chown=appuser:appuser data/ data/

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
