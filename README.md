# RX-QA Excel Templates

A Streamlit web application for browsing and downloading Excel templates for Quality Assurance in radiology.

## Features

- Categorized browsing of Excel templates.
- Download templates directly from the web interface.
- Easy setup and launch.

## Project Structure

```
RX-QA-Excel-templates/
│
├── .gitignore
├── .python-version
├── excel_templates.bat
├── main.py
├── pyproject.toml
├── README.md
├── templates_download.py
├── uv.lock
├── Excel_templates/
│   ├── Whatever1/
│   │   ├── EX1.xlsx
│   │   ├── EX2.xlsx
│   │   ├── EX3.xlsx
│   └── Whatever2/
│       └── EX4.xlsx
```


## Getting Started

### Prerequisites

- Python 3.9 (see [.python-version](.python-version))
- [Streamlit](https://streamlit.io/) (see [pyproject.toml](pyproject.toml))

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/RX-QA-Excel-templates.git
    cd RX-QA-Excel-templates
    ```

2. Install dependencies:
    ```sh
    pip install -r requirements.txt
    ```
    Or, if using `uv`:
    ```sh
    uv pip install -r pyproject.toml
    ```

### Running the App

- **Via Python:**
    ```sh
    python main.py
    ```
    Optionally, specify a port:
    ```sh
    python main.py 8501
    ```

- **Via Batch Script (Windows):**
    Double-click [excel_templates.bat](http://_vscodecontentref_/6).

- The app is ready to be scheduled at system start up.

- The app will be available at [http://localhost:8501](http://localhost:8501) by default.

## Adding Templates

Place your Excel files (`.xlsx`, `.xls`) in the [Excel_templates](http://_vscodecontentref_/7) folder or its subfolders. They will appear in the app for download.

## Creating excel_templates.bat

Create a .bat file and copy this into it:

```
@echo off
cd /d Path\to\RX-QA-Excel-templates
Path\to\uv\uv.exe run main.py
```

## License

MIT License

---

For questions or contributions, open an issue or pull request!
