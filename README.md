# RX-QA Excel Templates

A simple web application built with Streamlit for browsing and downloading the Excel templates used for Quality Assurance in radiology.

## Features

- **Categorized browsing:** each subfolder of `Excel_templates/` is shown as a collapsible category.
- **One-click downloads:** every `.xlsx` and `.xls` file gets its own download button.
- **No restart needed:** templates added to the folder appear the next time the page is loaded.

## Running the app

There are two independent ways to run the app. Both install the same pinned dependency versions.

| | Local with uv | Docker |
|---|---|---|
| Best for | Development, running on a Windows workstation or server | Deploying on a server |
| Requires | Python ≥ 3.13 and [uv](https://docs.astral.sh/uv/) | [Docker](https://docs.docker.com/get-docker/) with Compose |
| Installs from | `uv.lock` | `requirements.txt` (with pip, no uv) |
| Templates folder | `Excel_templates/` next to the code | `Excel_templates/` next to `docker-compose.yml`, mounted read-only |
| Port | `8501`, configurable | `8501` inside the container, mapped in `docker-compose.yml` |

Either way, the Excel templates are **not** part of the repository (`Excel_templates/` is in `.gitignore`). You provide them yourself; see [Adding templates](#adding-templates).

### Local with uv

1. **Clone the repository:**

   ```bash
   git clone https://github.com/jlleongarcia/RX-QA-Excel-templates.git
   cd RX-QA-Excel-templates
   ```

2. **Install dependencies:**

   ```bash
   uv sync
   ```

   If Python 3.13 isn't installed, uv downloads it automatically.

3. **Run the app:**

   ```bash
   uv run python main.py
   ```

   The app will be accessible at `http://localhost:8501`. You can pass a custom port as an argument:

   ```bash
   uv run python main.py 8080
   ```

#### Starting the app at system startup (Windows)

Create an `excel_templates.bat` file in the project folder (it is ignored by git) with the following content, adjusting the paths:

```bat
@echo off
cd /d Path\to\RX-QA-Excel-templates
Path\to\uv\uv.exe run main.py
```

You can then schedule this script to run at system startup, for example with Windows Task Scheduler.

### Docker

A multi-architecture image (`linux/amd64` and `linux/arm64`) is built by GitHub Actions and published to `ghcr.io/jlleongarcia/rx-qa-excel-templates` on every push to `master`.

1. **Get `docker-compose.yml`** onto the server, either by cloning the repository or by copying just that file.

2. **Create the templates folder** next to `docker-compose.yml` and put your Excel files in it:

   ```bash
   mkdir Excel_templates
   ```

3. **Start the container** using the published image:

   ```bash
   docker compose pull
   docker compose up -d
   ```

   Or build the image locally instead (requires the full repository):

   ```bash
   docker compose up -d --build
   ```

   The app will be accessible at `http://localhost:8501`. The container always listens on port `8501`; to serve it on a different host port, change the left side of the `ports` mapping in `docker-compose.yml` (e.g. `"8080:8501"`). The container is configured with `restart: always`, so it comes back after a crash or a server reboot.

4. **Update to the latest image:**

   ```bash
   docker compose pull
   docker compose up -d
   ```

5. **Stop it:**

   ```bash
   docker compose down
   ```

> **Note:** If the published package is private on GitHub Container Registry, run `docker login ghcr.io` on the server before pulling, or make the package public in its GitHub settings.

#### How the image is built

- **Base image:** `python:3.13-slim`.
- **Dependencies:** installed with `pip install -r requirements.txt`, which pins every package to the versions in `uv.lock`.
- **Templates:** not included in the image. `docker-compose.yml` mounts the host's `./Excel_templates` folder at `/app/Excel_templates` as read-only, so adding or removing templates never requires rebuilding or restarting the container.
- **Process:** Streamlit runs directly as the main process (not through `main.py`), so it receives the stop signal from `docker stop` and shuts down cleanly.
- **Security:** the app runs as a non-root user.
- **Health check:** Docker polls Streamlit's `/_stcore/health` endpoint, so `docker ps` shows whether the app is healthy.
- **Privacy:** Streamlit's usage statistics are disabled.

## Adding templates

Place your Excel files (`.xlsx`, `.xls`) in the `Excel_templates` folder. Files directly in the folder are listed under "Files in Root Directory", and each subfolder becomes its own category (only one level of subfolders is scanned):

```
Excel_templates/
├── General.xlsx
├── Category1/
│   ├── EX1.xlsx
│   └── EX2.xlsx
└── Category2/
    └── EX3.xls
```

When running with Docker, the files must be readable by the container's non-root user. If templates don't appear, make them world-readable on the host:

```bash
chmod -R a+rX Excel_templates
```

If the folder doesn't exist when the container starts, Docker creates it empty (owned by root) and the app shows no templates.

## Dependencies

| Package | Version |
|---|---|
| Python | ≥ 3.13 |
| [Streamlit](https://streamlit.io/) | 1.66.1 |

`uv.lock` is the source of truth. `requirements.txt` is generated from it for the Docker image, so both ways of running the app use exactly the same versions.

### Updating dependencies

After changing dependencies in `pyproject.toml`, relock and regenerate `requirements.txt`:

```bash
uv lock
uv export --format requirements-txt --no-hashes --no-dev --no-emit-project --frozen -o requirements.txt
```

Never edit `requirements.txt` by hand; the [requirements sync workflow](#cicd) will fail if it doesn't match `uv.lock`.

## CI/CD

Two GitHub Actions workflows run on this repository:

- **`requirements-sync.yml`** runs on every push and pull request. It fails if `uv.lock` is out of date with `pyproject.toml`, or if `requirements.txt` doesn't match `uv.lock`. This keeps the local and Docker setups on the same versions.
- **`docker-publish.yml`** builds the image for `linux/amd64` and `linux/arm64`.
  - On pull requests to `master`, it only builds the image, to check that the Dockerfile still works.
  - On pushes to `master` (including merges), it also publishes the image to `ghcr.io/jlleongarcia/rx-qa-excel-templates`, tagged `latest` and with the commit SHA.
  - It can also be started manually from the Actions tab.

## Project structure

```
├── main.py                     # Local entry point – launches Streamlit
├── templates_download.py       # Streamlit application
├── pyproject.toml              # Project metadata and dependencies
├── uv.lock                     # Locked dependency versions (source of truth)
├── requirements.txt            # Same versions exported for pip (Docker)
├── Dockerfile                  # Container image definition
├── docker-compose.yml          # Deployment configuration
├── .dockerignore               # Files excluded from the Docker build context
├── LICENSE                     # MIT License
├── Excel_templates/            # Your templates (not tracked by git)
└── .github/workflows/
    ├── requirements-sync.yml   # Checks requirements.txt matches uv.lock
    └── docker-publish.yml      # Builds and publishes the multi-arch image
```

## License

This project is licensed under the [MIT License](LICENSE).
