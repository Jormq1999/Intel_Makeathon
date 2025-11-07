````markdown
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

# AI-Friendly Feedback for `07-build-and-execution.md`

**Source Repository:** `/nfs/site/disks/juanpsal_disk_002/iscp-fst/ip-csme`

## 1. Analysis Summary

The `ip-csme` repository uses a conventional, list-based build system. The execution flow is typical for UVM environments, relying on the `UVM_TESTNAME` variable to select the test to run. This makes it very straightforward for an AI agent to integrate newly generated tests into the build and run them.

## 2. Build System Analysis

### 2.1. Test Lists

-   **Location:** `verif/csme_usbr/tests/testlists/`
-   **Key Files:** `all.list`, `doa.list`, `utmi.list`
-   **Mechanism:** These files contain a simple list of paths to the test files that should be included in a simulation. The build system (likely a Makefile or script) reads these lists to determine which files to compile.
-   **AI Integration Point:** This is the **primary mechanism** for adding a new test to the build. The agent must add the path to its newly generated test file to one of these lists. For general-purpose tests, `all.list` is the most appropriate choice.

### 2.2. File Lists (`.f` files)

-   **Location:** Various directories contain `.f.template` files, such as `verif/csme_usbr/env/templates/reusable_verif.f.template`.
-   **Mechanism:** These templates are likely used by a script to generate the final file lists (`-f` files) passed to the simulator. They specify the paths to the core UVM environment components (agents, sequences, etc.).
-   **AI Integration Point:** When the agent generates a new **reusable sequence** in the `seqlib`, it must add the path to that sequence file to the `reusable_verif.f.template`. This ensures the sequence class is compiled and available to all tests.

## 3. Execution Flow Analysis

-   **UVM Test Selection:** The environment uses the standard `UVM_TESTNAME` plusarg to select which test to run from the compiled set.
-   **Simulation Scripts:** While the exact run command is not visible, it is standard practice to have a shell script or Makefile target that invokes the simulator (e.g., `vcs`) and passes it the necessary arguments, including `+UVM_TESTNAME=<test_name>`.

## 4. AI Agent Workflow for Build and Execution

Here is the step-by-step process the AI agent should follow to build and run a newly generated test.

### Step 1: Generate the Code

1.  **Generate Sequence:** Create a new sequence file in `verif/csme_usbr/env/seqlib/csme_usbr_ai_<feature>_seq.sv`.
2.  **Generate Test:** Create a new test file in `verif/csme_usbr/tests/moa_usbr_ai_<feature>_test.sv`.

### Step 2: Integrate into the Build System

1.  **Update Reusable File List:** Add the path to the new sequence to `verif/csme_usbr/env/templates/reusable_verif.f.template`.

    **Action:** Append the following line to the file:
    `$(VERIF_HOME)/csme_usbr/env/seqlib/csme_usbr_ai_{{feature}}_seq.sv`

2.  **Update Test List:** Add the path to the new test to `verif/csme_usbr/tests/testlists/all.list`.

    **Action:** Append the following line to the file:
    `$(TEST_DIR)/moa_usbr_ai_{{feature}}_test.sv`

### Step 3: Execute the Test

1.  **Construct the Run Command:** The agent needs to invoke the simulation script with the correct `UVM_TESTNAME`.

    **Example Command (inferred):**
    ```bash
    # The actual script name might be different (e.g., 'run_sim')
    ./run_vcs +UVM_TESTNAME=moa_usbr_ai_{{feature}}_test
    ```

2.  **Parse the Log File:** After the simulation completes, the agent must parse the output log file (e.g., `sim.log`) to check for:
    -   **UVM Errors/Fatals:** Search for `UVM_ERROR` and `UVM_FATAL`.
    -   **Test Status:** Look for the final `UVM Report Summary` to see if the test passed or failed.
    -   **Coverage:** If coverage is enabled, the agent should check the log to ensure a coverage database was written.

## 5. Summary for AI Agent

-   **To add a sequence:** Edit `reusable_verif.f.template`.
-   **To add a test:** Edit `all.list`.
-   **To run a test:** Execute the main simulation script with `+UVM_TESTNAME=<your_test_name>`.
-   **To check results:** Parse the simulation log file.
````