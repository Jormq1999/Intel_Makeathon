# Run simulation helper
# Tries to run with Icarus Verilog (iverilog + vvp) if available.

$cwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $cwd

function Run-Icarus {
    if (-not (Get-Command iverilog -ErrorAction SilentlyContinue)) { return $false }
    if (-not (Get-Command vvp -ErrorAction SilentlyContinue)) { return $false }

    Write-Host "Compiling with iverilog..."
    iverilog -g2012 -o fifo_tb.vvp fifo.sv fifo_if.sv tb_simple.sv
    if ($LASTEXITCODE -ne 0) { Write-Error "iverilog compile failed"; return $false }

    Write-Host "Running simulation (vvp)..."
    vvp fifo_tb.vvp
    return $true
}

if (-not (Run-Icarus)) {
    Write-Host "Icarus Verilog not available or simulation failed. Please use your preferred simulator."
    Write-Host "Suggested VCS demo compile command (update UVM path):"
    Write-Host "vcs -full64 -sverilog +v2k -timescale=1ns/1ps fifo.sv fifo_if.sv tb_simple.sv -o simv"
    Write-Host "./simv"
}
