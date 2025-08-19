import subprocess
import sys


def run_app(port):
    """Run the Streamlit app."""
    print("Starting the Streamlit app...")
    try:
        subprocess.check_call([
            sys.executable, "-m", "streamlit", "run", "templates_download.py",
            "--server.address=0.0.0.0", # Make Streamlit accessible to all interfaces
            f"--server.port={port}",
            "--server.headless", "true" # Avoid asking for email 
        ])
    except subprocess.CalledProcessError as e:
        print(f"Error running Streamlit app: {e}")
        sys.exit(1)

if __name__ == "__main__":
    print("Starting setup script...")

    # Define a default port and check for a command-line argument
    port_number = 8501
    if len(sys.argv) > 1:
        try:
            port_number = int(sys.argv[1])
        except ValueError:
            print(f"Invalid port number '{sys.argv[1]}'. Using default port {port_number}.")

    # Run the Streamlit app
    run_app(port=port_number)
    