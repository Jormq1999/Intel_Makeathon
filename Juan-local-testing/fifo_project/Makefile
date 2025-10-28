```
# Makefile for running UVM tests for the FIFO project
#
# Usage:
#   make compile - Compiles the SystemVerilog code
#   make run TEST=<test_name> - Runs a specific test (e.g., make run TEST=test_write_to_full)
#   make all - Compiles and runs the default test
#

# Tool Configuration (using Synopsys VCS as an example)
VCS = vcs
VCS_FLAGS = -full64 -sverilog +v2k -timescale=1ns/1ps -debug_access+all
UVM_HOME ?= /path/to/your/uvm/library

# Files
DUT = fifo.sv
TB_TOP = tb_top.sv
INTERFACE = fifo_if.sv
UVM_COMPONENTS = fifo_item.sv fifo_sequences.sv fifo_driver.sv fifo_monitor.sv fifo_scoreboard.sv fifo_agent.sv fifo_env.sv fifo_tests.sv
TEST_NAME ?= fifo_base_test

# Icarus (non-UVM) testbenches
IVERILOG = iverilog
VVP = vvp

all: compile

## VCS (UVM) targets
compile:
	$(VCS) $(VCS_FLAGS) +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv \
	$(DUT) $(INTERFACE) $(TB_TOP) $(UVM_COMPONENTS) -o simv

run:
	./simv +UVM_TESTNAME=$(TEST_NAME)

## Icarus Verilog targets for quick directed tests
iver_wrap:
	$(IVERILOG) -g2012 -o tb_wrap.vvp fifo.sv fifo_if.sv tb_wrap.sv
	$(VVP) tb_wrap.vvp

iver_simul:
	$(IVERILOG) -g2012 -o tb_simul.vvp fifo.sv fifo_if.sv tb_simul.sv
	$(VVP) tb_simul.vvp

iver_edge:
	$(IVERILOG) -g2012 -o tb_edgecases.vvp fifo.sv fifo_if.sv tb_edgecases.sv
	$(VVP) tb_edgecases.vvp

clean:
	rm -rf simv simv.daidir csrc *.log *.key DVEfiles/ *.vvp
```
