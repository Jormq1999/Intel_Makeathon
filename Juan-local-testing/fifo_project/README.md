# FIFO UVM Testbench

This project contains a simple FIFO design and a UVM testbench to verify its functionality.

## Project Structure

- `fifo.sv`: The FIFO RTL design.
- `fifo_if.sv`: The interface for the FIFO.
- `tb_top.sv`: The top-level testbench module that instantiates the DUT and the UVM test environment.
- `fifo_item.sv`: The UVM sequence item (transaction).
- `fifo_sequences.sv`: UVM sequences for driving transactions.
- `fifo_driver.sv`: The UVM driver.
- `fifo_monitor.sv`: The UVM monitor.
- `fifo_scoreboard.sv`: The UVM scoreboard for checking correctness.
- `fifo_agent.sv`: The UVM agent that encapsulates the driver and monitor.
- `fifo_env.sv`: The UVM environment that contains the agent and scoreboard.
- `fifo_tests.sv`: The UVM tests.
- `Makefile`: Makefile for compiling and running the simulations.

## Setup and Running Simulation

This project uses Synopsys VCS and Verdi.

### 1. Environment Setup

Before running the simulation, you need to set up your environment correctly. The `Makefile` attempts to set the necessary tool paths, but license file configuration is required.

**IMPORTANT**: You must set the `LM_LICENSE_FILE` environment variable. Please set it to the correct path for your license server.

Example for `tcsh`:
```tcsh
setenv LM_LICENSE_FILE <your_license_server_details>
```

Example for `bash`:
```bash
export LM_LICENSE_FILE=<your_license_server_details>
```

### 2. Compilation

To compile the testbench, run the following command from the `fifo_project` directory:

```sh
make compile
```

This will create a `simv` executable file.

### 3. Running a Test

To run a specific test, use the `run` target and specify the test name with the `TEST` variable. The default test is `fifo_base_test`.

To run the base test:
```sh
make run
```

To run a different test, for example `test_write_to_full`:
```sh
make run TEST=test_write_to_full
```

### 4. Running with Verdi

To run a test and open the Verdi GUI for debugging, use the `run_and_debug` target:

```sh
make run_and_debug TEST=fifo_base_test
```

### 5. Cleaning Up

To remove generated files:
```sh
make clean
```
