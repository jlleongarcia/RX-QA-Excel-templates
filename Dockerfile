FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

WORKDIR /app

# Install dependencies first so code changes don't invalidate this layer.
# requirements.txt is a complete pinned export of uv.lock.
COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY templates_download.py ./

RUN useradd --create-home appuser
USER appuser

EXPOSE 8501

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8501/_stcore/health')"

# Excel templates are not part of the image; mount them at /app/Excel_templates (see docker-compose.yml).
# Run Streamlit directly (not via main.py) so it is PID 1 and receives SIGTERM on `docker stop`
CMD ["streamlit", "run", "templates_download.py", "--server.address=0.0.0.0", "--server.port=8501", "--server.headless=true"]
