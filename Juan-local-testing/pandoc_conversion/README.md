DOCX to Markdown conversion helper

How to run locally (PowerShell):

```powershell
This folder contains two converters:

- `convert_docx_to_md.py` — mammoth + html2text pipeline (no pandoc required).
- `pandoc_convert.py` — uses pypandoc or the pandoc CLI for conversion and generally yields more faithful output.

Usage (PowerShell):

```powershell
# change into the folder
Set-Location .\Juan-local-testing\pandoc_conversion

# Option A: use the mammoth converter (works without pandoc)
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python .\convert_docx_to_md.py .\VAL_DCN_OCS_CPM.docx

# Option B: use the pandoc-based converter (recommended if pandoc installed)
# Install pypandoc if you want the Python wrapper: pip install pypandoc
# or ensure pandoc CLI is installed and on PATH: https://pandoc.org/installing.html
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python .\pandoc_convert.py .\VAL_DCN_OCS_CPM.docx
```

Output: `VAL_DCN_OCS_CPM.md` will be written next to the input file.
