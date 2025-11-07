# AI-Friendly Feedback for `04-architecture-patterns.md`

**Source Repository:** `/nfs/site/disks/juanpsal_disk_002/iscp-fst/ip-csme`

## 1. Analysis Summary

The `ip-csme` verification environment exhibits a set of strong, consistent architectural patterns. These patterns make the codebase predictable and easy to navigate, which is ideal for an AI agent. The agent should learn and replicate these patterns to ensure that any generated code integrates seamlessly.

## 2. Key Architectural Patterns

### 2.1. Directory Structure

The repository follows a standard UVM directory structure, which the agent should use as a blueprint for placing generated files.

-   `verif/csme_usbr/env/`: Contains the top-level environment and its core components (scoreboard, virtual sequencer).
-   `verif/csme_usbr/env/seqlib/`: A centralized library for all reusable sequences. **This is the primary location for the agent to add new stimulus.**
-   `verif/csme_usbr/tb/`: The top-level testbench file (`tb.sv`) and functional coverage (`*_cov.sv`).
-   `verif/csme_usbr/tests/`: Contains all the test files, with each test typically in its own subdirectory.
-   `verif/csme_usbr/ti/`: Contains the physical interfaces (`*_if.sv`) that connect the testbench to the DUT.

### 2.2. Component Naming Conventions

There is a consistent naming scheme that the agent must follow.

-   **Package Suffix:** All packages end with `_pkg` (e.g., `csme_usbr_pkg.sv`).
-   **Sequence Suffix:** Sequences generally end with `_seq` (e.g., `csme_usbr_init_seq.sv`).
-   **Test Suffix:** Tests end with `_test` (e.g., `moa_usbr_sanity.sv`).
-   **Component Prefix:** Most components and sequences are prefixed with `csme_usbr_` or `moa_usbr_`. The agent should adopt `moa_usbr_` for its generated components to align with the existing test names.

### 2.3. UVM Component Hierarchy and Factory Usage

-   **Centralized Environment:** A single, top-level environment class, `moa_usbr_env`, contains all other verification components.
-   **Virtual Sequencer:** A virtual sequencer (`moa_usbr_vsequencer`) is used to route sequences to the appropriate agents. All test-level sequences are started on this virtual sequencer.
-   **Factory Registration:** All components and transactions use the `uvm_*_utils` macros for factory registration. This is critical for allowing test-level overrides.

### 2.4. Sequence and Stimulus Organization

-   **Base Sequences:** There is a clear inheritance model for sequences, with most extending from `moa_usbr_base_seq`. This base class likely contains common functionality and handles for configuration objects or RAL models.
-   **Sequence Library (`seqlib`):** The use of a `seqlib` directory promotes stimulus reuse. The agent should contribute to this library by placing all its generated sequences here.
-   **Test-Level Control:** Tests are responsible for creating and starting the top-level sequence. They do not contain fine-grained stimulus logic themselves; they only orchestrate the sequences from the `seqlib`.

### 2.5. Configuration Mechanism

-   **Configuration Objects:** The environment is configured using a configuration object (`moa_usbr_cfg`), which is passed down from the test level using the `uvm_config_db`.
-   **Template-Based Generation:** Configuration objects and other components are generated from `.template` files (e.g., `moa_usbr_cfg.sv.template`). This suggests a script-based flow for creating the final component code. The AI agent should generate code that is compatible with these templates or, if possible, learn to modify the templates themselves.

## 3. Recommendations for the AI Agent

1.  **Adhere to Directory Structure:** When generating a new test, create a new subdirectory in `verif/csme_usbr/tests/`. When generating a new sequence, place it in `verif/csme_usbr/env/seqlib/`.

2.  **Follow Naming Conventions:** Prefix generated tests with `moa_usbr_ai_` and sequences with `csme_usbr_ai_`. Use the `_test` and `_seq` suffixes.

3.  **Use the Virtual Sequencer:** All generated top-level sequences must be designed to run on the `moa_usbr_vsequencer`. The agent should not try to access agent-level sequencers directly from the test.

4.  **Extend from Base Classes:**
    -   Generated tests must extend `usbr_base_test`.
    -   Generated sequences must extend `moa_usbr_base_seq`.

5.  **Leverage the `seqlib`:** The agent's primary output should be new, reusable sequences placed in the `seqlib`. The test file itself should be minimal, only serving to start the new top-level sequence.

6.  **Interact via Configuration Objects:** If the agent needs to parameterize a test, it should do so by modifying the `moa_usbr_cfg` object in the test's `build_phase`, rather than passing parameters directly to a sequence.
