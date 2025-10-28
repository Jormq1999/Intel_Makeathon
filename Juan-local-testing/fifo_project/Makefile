## Makefile for running tests for the FIFO project
## Usage:
##   make compile          # Compiles the SystemVerilog code (VCS)
##   make run TEST=<name>  # Runs the compiled simv with the given UVM test
##   make iver_wrap        # Quick Icarus directed test (iverilog + vvp)

# Tool Configuration (using Synopsys VCS as an example)
VCS = vcs
VCS_FLAGS = -full64 -sverilog +v2k -timescale=1ns/1ps -debug_access+all -ntb_opts uvm
RUN_ARGS = +UVM_TESTNAME=$(TEST)


# Setup tool environment
export LM_PROJECT := EIG_CSME
export SNPSLMD_LICENSE_FILE=26586@synopsys96p.elic.intel.com:26586@synopsys97p.elic.intel.com:26586@synopsys92p.elic.intel.com:26586@synopsys93p.elic.intel.com:26586@synopsys65p.elic.intel.com:26586@synopsys91p.elic.intel.com:26586@synopsys50p.elic.intel.com:26586@synopsys92p.elic.intel.com:26586@synopsys51p.elic.intel.com:26586@synopsys50p.elic.intel.com:26586@synopsys103p.elic.intel.com:26586@synopsys02p.elic.intel.com:26586@synopsys69p.elic.intel.com:26586@synopsys68p.elic.intel.com:26586@synopsys102p.elic.intel.com:26586@synopsys10p.elic.intel.com:26586@synopsys45p.elic.intel.com

RTL_CAD_ROOT ?= /p/hdk/rtl/cad/x86-64_linux44
VCS_VERSION     := V-2023.12-SP2-1
export VCS_HOME        := $(RTL_CAD_ROOT)/synopsys/vcsmx/$(VCS_VERSION)
VERDI_VERSION   := $(VCS_VERSION)
export VERDI_HOME      := $(RTL_CAD_ROOT)/synopsys/verdi3/$(VERDI_VERSION)
export PATH            := $(VCS_HOME)/bin:$(VERDI_HOME)/bin:$(PATH)

UVM_HOME ?= $(VCS_HOME)/etc/uvm-1.2

# Files
DUT = fifo.sv
TB_TOP = tb_top.sv
INTERFACE = fifo_if.sv
UVM_COMPONENTS = fifo_item.sv fifo_sequences.sv fifo_driver.sv fifo_monitor.sv fifo_scoreboard.sv fifo_agent.sv fifo_env.sv fifo_tests.sv
TESTBENCH_FILES = $(DUT) $(TB_TOP) $(INTERFACE) $(UVM_COMPONENTS)
TEST_NAME ?= fifo_base_test

# Icarus (non-UVM) tool names
IVERILOG = iverilog
VVP = vvp

all: compile

## VCS (UVM) targets
compile:
	vcs $(VCS_FLAGS) +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv \
	$(TESTBENCH_FILES) -o simv

run:
	./simv $(RUN_ARGS)

run_and_debug: compile
	./simv +UVM_TESTNAME=$(TEST_NAME) -gui=verdi

## Icarus Verilog targets for quick directed tests
iver_wrap:
	$(IVERILOG) -g2012 -o tb_wrap.vvp $(DUT) $(INTERFACE) tb_wrap.sv
	$(VVP) tb_wrap.vvp

iver_simul:
	$(IVERILOG) -g2012 -o tb_simul.vvp $(DUT) $(INTERFACE) tb_simul.sv
	$(VVP) tb_simul.vvp

iver_edge:
	$(IVERILOG) -g2012 -o tb_edgecases.vvp $(DUT) $(INTERFACE) tb_edgecases.sv
	$(VVP) tb_edgecases.vvp

clean:
	rm -rf simv simv.daidir csrc *.log *.key DVEfiles/ *.vvp
