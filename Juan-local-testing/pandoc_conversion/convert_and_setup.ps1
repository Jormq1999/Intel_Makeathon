<#
PowerShell helper to create a venv, install requirements, and run the DOCX->MD converter.
Usage (from repo root):
  Set-Location .\Juan-local-testing\pandoc_conversion
  .\convert_and_setup.ps1 -Docx .\VAL_DCN_OCS_CPM.docx
#>
param(
    [string]$Docx = "VAL_DCN_OCS_CPM.docx"
)

Write-Host "[DEBUG] Current working directory: $(Get-Location)"

# Resolve script directory robustly
$scriptDef = $MyInvocation.MyCommand.Definition
if ([string]::IsNullOrWhiteSpace($scriptDef)) {
    # When dot-sourced or run in some contexts, fallback to PSScriptRoot if available
    if ($PSCommandPath) { $scriptDir = Split-Path -Parent $PSCommandPath } else { $scriptDir = Get-Location }
} else {
    $scriptDir = Split-Path -Parent $scriptDef
}

Write-Host "[DEBUG] Resolved script directory: $scriptDir"

# Ensure script dir exists and list files for visibility
if (-not (Test-Path $scriptDir)) {
    Write-Error "Script directory not found: $scriptDir"
    exit 1
}

Write-Host "[DEBUG] Files in script directory:"
Get-ChildItem -Path $scriptDir -Force | Select-Object Name,Mode,Length | ForEach-Object { Write-Host "  $_" }

Set-Location $scriptDir

function Find-PythonLauncher {
    $candidates = @('py','python')
    foreach ($c in $candidates) {
        $cmd = Get-Command $c -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Path }
    }
    return $null
}

$launcher = Find-PythonLauncher
if (-not $launcher) {
    Write-Error "No Python launcher found in PATH. Please install Python (ensure 'py' or 'python' is on PATH)."
    exit 2
}

Write-Host "[DEBUG] Using Python launcher: $launcher"

# Absolute paths for venv and activation
$venvPath = Join-Path -Path $scriptDir -ChildPath '.venv'
$activate = Join-Path -Path $venvPath -ChildPath 'Scripts\Activate.ps1'

if (-not (Test-Path $venvPath)) {
    Write-Host "Creating virtual environment at $venvPath using: $launcher"
    & $launcher -3 -m venv $venvPath 2>&1 | ForEach-Object { Write-Host "  $_" }
}

if (-not (Test-Path $activate)) {
    Write-Error "Activation script not found at $activate -- venv creation may have failed."
    exit 3
}

Write-Host "Activating virtual environment..."
. $activate

Write-Host "Installing requirements from: $(Join-Path $scriptDir 'requirements.txt')"
pip install -r (Join-Path $scriptDir 'requirements.txt')

# Resolve DOCX path
$docxFull = Resolve-Path -Path (Join-Path $scriptDir $Docx) -ErrorAction SilentlyContinue
if (-not $docxFull) {
    Write-Host "[DEBUG] DOCX not found at $Docx in script folder. Searching for DOCX files in folder..."
    $found = Get-ChildItem -Path $scriptDir -Filter *.docx -ErrorAction SilentlyContinue | Select-Object -First 5
    if ($found) {
        Write-Host "Found DOCX candidates:"; $found | ForEach-Object { Write-Host "  $_.FullName" }
        Write-Host "Using first candidate: $($found[0].FullName)"
        $docxFull = $found[0].FullName
    } else {
        Write-Error "DOCX not found and no .docx files present in $scriptDir"
        exit 4
    }
} else {
    $docxFull = $docxFull.Path
}

Write-Host "Running converter on: $docxFull"
python (Join-Path $scriptDir 'convert_docx_to_md.py') $docxFull

Write-Host "Done. Check the .md file next to the input DOCX."
