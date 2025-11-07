# VE Dashboard

A web-based dashboard to visualize and analyze SystemVerilog verification environments.

## Overview

This Flask application provides an interactive web interface to explore a verification project's structure. It automatically discovers and categorizes files, extracts component information (modules, classes, interfaces), and presents it in a user-friendly way.

## Features

- **Automatic File Discovery**: Scans a project directory and categorizes files into DUT, Testbench, and Tests based on common UVM naming conventions.
- **Component Extraction**: Parses SystemVerilog files to identify and list modules, classes, and interfaces.
- **Interactive Filtering**: Provides a user-friendly way to filter the component table, similar to a SQL query.
- **Visualization**: Displays a bar chart summarizing the count of each component type.
- **File Viewer**: Allows viewing the content of any discovered file directly in the browser.

## How to Use

### 1. Installation

The application requires Python and the Flask library.

**Environment Setup**

It is crucial to use the correct Python environment where Flask is installed. If you encounter a `ModuleNotFoundError: No module named 'flask'`, it means the `python3` command is not pointing to the environment where Flask is installed.

To fix this, use the specific Python executable that has the packages. For example:

```bash
# First, install Flask using the correct python executable
/usr/intel/bin/python3 -m pip install Flask

# Then, run the application with the same executable
/usr/intel/bin/python3 /nfs/site/disks/juanpsal_disk_002/iscp-fst/Intel_Makeathon/Juan-local-testing/ve_dashboard/dashboard.py
```

### 2. Running the Dashboard

Once the environment is set up, run the `dashboard.py` script:

```bash
/usr/intel/bin/python3 /nfs/site/disks/juanpsal_disk_002/iscp-fst/Intel_Makeathon/Juan-local-testing/ve_dashboard/dashboard.py
```

The server will start on `http://127.0.0.1:5000`. Open this URL in your web browser.

### 3. Navigating the Interface

- **Component Table**: This is the main view, showing all extracted components.
- **Filtering**: Use the dropdown and text box to filter the components. This is designed to be intuitive, like a SQL query:
  - `SELECT type WHERE name LIKE ''`: Choose a component type from the dropdown (e.g., `class`) and enter a partial name in the text box to see all classes with that name.
- **Statistics**: The bar chart gives a quick overview of the component distribution.
- **File Explorer**: The categorized file lists allow you to browse the project structure and view file contents.

### 4. Analyzing a Different Project

To analyze a different verification environment, you need to change the `PROJECTS_BASE_DIR` and the default `project_name` in the `dashboard.py` script.

1.  **Open `dashboard.py`**.
2.  **Modify the `PROJECTS_BASE_DIR` variable** to point to the directory containing your projects.
3.  **Modify the `project_name` in the `home()` function** to set the default project to load.

```python
# In dashboard.py

# Define the base directory for the verification projects
PROJECTS_BASE_DIR = "/path/to/your/projects/"

@app.route('/')
def home():
    project_name = "your_new_project_name" # Change this
    return project_dashboard(project_name)
```

## Troubleshooting

### `ModuleNotFoundError: No module named 'flask'`

As described in the installation section, this error occurs when the Python environment is incorrect. Ensure you are using the full path to the `python3` executable that was used to install Flask.

### `ERROR: Could not install packages due to an EnvironmentError: [Errno 122] Disk quota exceeded`

This error indicates that you have run out of disk space in your user directory. This is a system-level limitation and cannot be fixed from within the application.

**Workaround:**

The application has been designed to work without requiring large external libraries (like `pandas`). It uses Python's built-in `re` module for parsing and generates HTML manually. If you need to add more complex features, you will need to either:

1.  Request a disk quota increase from your system administrator.
2.  Continue to develop features using only the libraries already available in the environment.

## Local GUI Alternative (Tkinter)

If you prefer a local GUI instead of the Flask web page, a lightweight Tkinter app is included: `gui_app.py`.

Quick run (from `ve_dashboard` directory):

```bash
python3 gui_app.py
```

Requirements:
- Python 3
- Tkinter (commonly included; on some Linux distributions you may need to install it via the system package manager, e.g. `sudo apt install python3-tk`)

The GUI provides environment selection, file browsing, simple text/regex search, a file viewer, deletion, component extraction and dependency summaries.
