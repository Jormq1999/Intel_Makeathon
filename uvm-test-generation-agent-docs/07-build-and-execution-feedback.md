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
