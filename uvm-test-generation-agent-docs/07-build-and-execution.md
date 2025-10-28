# Build and Execution Guide

This guide provides instructions for setting up the build and execution flow for a UVM environment, focusing on Makefile-based automation for simulators like VCS.

## Makefile for UVM Projects

A well-structured Makefile is essential for automating compilation, simulation, and cleanup.

### Key Components

- **Simulator Configuration**: Define variables for the simulator (e.g., `VCS`), flags, and UVM home directory.
- **File Lists**: Specify lists of RTL files, testbench files, and test files.
- **Targets**: Create standard targets like `compile`, `run`, `clean`, and `all`.

### Example Makefile for VCS

```makefile
# Simulator
SIM = vcs
UVM_HOME = /path/to/uvm-1.2
VCS_FLAGS = -full64 -sverilog +v2k -timescale=1ns/1ps -debug_access+all -ntb_opts uvm

# Verdi Integration
VERDI_HOME = /path/to/verdi
VCS_FLAGS += +define+DUMP_VERDI
VCS_FLAGS += -P $(VERDI_HOME)/share/PLI/VCS/linux64/novas.tab $(VERDI_HOME)/share/PLI/VCS/linux64/pli.a

# Files
RTL_FILES = fifo.sv
TB_FILES = tb_top.sv fifo_if.sv fifo_item.sv fifo_sequences.sv fifo_driver.sv fifo_monitor.sv fifo_scoreboard.sv fifo_agent.sv fifo_env.sv
TEST_FILES = fifo_tests.sv

# Targets
.PHONY: compile run clean all

all: clean compile run

compile:
	$(SIM) $(VCS_FLAGS) +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv \
	$(RTL_FILES) $(TB_FILES) $(TEST_FILES) -o simv

run:
	./simv +UVM_TESTNAME=$(TEST)

clean:
	rm -rf simv simv.daidir csrc *.log *.key DVEfiles/ *.vvp novas.*

```

### Usage

- **Compile**: `make compile`
- **Run a specific test**: `make run TEST=test_name`
- **Clean**: `make clean`

## Enabling Verdi Waveform Dumping

To debug with Verdi, you need to:
1. Add the `+define+DUMP_VERDI` to your VCS flags.
2. Link the Verdi PLI libraries in your Makefile.
3. Add a `DUMP_VERDI` block in your testbench top file to enable waveform dumping.

### Example `tb_top.sv` with Verdi Dump

```systemverilog
`ifdef DUMP_VERDI
initial begin
  $fsdbDumpfile("waves.fsdb");
  $fsdbDumpvars(0, tb_top);
end
`endif
```