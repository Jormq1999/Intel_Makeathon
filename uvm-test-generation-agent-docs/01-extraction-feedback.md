# AI-Friendly Feedback for `01-extraction-guide.md`

**Source Repository:** `/nfs/site/disks/juanpsal_disk_002/iscp-fst/ip-csme`

## 1. Analysis Summary

The `ip-csme` repository is a comprehensive UVM verification environment for a USB component, referred to as `csme_usbr`. The repository follows a conventional, well-organized structure that is highly suitable for automated data extraction. The consistent naming conventions and clear directory hierarchy provide reliable targets for an AI agent to parse and understand the environment's architecture.

## 2. Key Extraction Targets

An AI agent should focus on the following files and directories to extract the core architectural and stimulus information.

### 2.1. UVM Component Hierarchy

- **Top-Level Environment:** The main environment components are located in `verif/csme_usbr/env/`.
  - **Key Files:** `moa_usbr_env.sv`, `moa_usbr_vsequencer.sv`, `csme_usbr_scoreboard.sv`.
  - **Extraction Goal:** Parse these files to understand the instantiation of major components (agents, scoreboards, virtual sequencers) and their connectivity.

- **Agents:** The primary agent seems to be `usbr_agent`, located within `verif/csme_usbr/env/`.
  - **Extraction Goal:** Identify the agent's sub-components (driver, monitor, sequencer) and its configuration object.

### 2.2. Stimulus and Sequences

- **Sequence Library (`seqlib`):** A rich set of sequences is available in `verif/csme_usbr/env/seqlib/`.
  - **Key Files:** All `*.sv` files in this directory, such as `csme_usbr_init.sv`, `csme_usbr_bulk_data_seq.sv`, and `csme_usbr_port_reset.sv`.
  - **Extraction Goal:** Parse these sequence files to build a library of available stimulus. The agent should extract sequence names, parameters, and the tasks they perform. This is the primary source for generating new tests.

- **Test Files:** The `verif/csme_usbr/tests/` directory contains numerous test files.
  - **Key Files:** `moa_usbr_sanity.sv`, `moa_usbr_bulk.sv`, etc.
  - **Extraction Goal:** Analyze these tests to understand how sequences are started on the virtual sequencer. This provides the pattern for integrating newly generated tests.

### 2.3. Interfaces and Transactions

- **Transaction Objects:** The definition for transaction items (the data packets passed between components) is critical. These are likely located in a central package.
  - **Likely File:** `csme_usbr_pkg.sv` or a file included by it.
  - **Extraction Goal:** Extract the `class` definition for transaction objects to understand their fields, constraints, and methods.

- **Physical Interfaces (`*_if.sv`):** The connection between the DUT and the testbench is defined in interface files.
  - **Key Files:** `verif/csme_usbr/ti/csme_usbr_utmi_intf.sv`.
  - **Extraction Goal:** Parse the interface to get the list of signals, ports, and modports. This is essential for connecting the agent's driver and monitor.

### 2.4. Configuration and Register Model (RAL)

- **RAL Model:** The register abstraction layer is likely generated from templates.
  - **Key File:** `verif/csme_usbr/env/templates/moa_usbr_ral_env.svh.template`.
  - **Extraction Goal:** Analyze the template to understand the structure of the register model. If possible, find the script or tool that generates the final RAL code to get a complete list of registers and fields.

- **Configuration Objects:** The environment and its components will have configuration objects.
  - **Key File:** `verif/csme_usbr/env/templates/moa_usbr_cfg.sv.template`.
  - **Extraction Goal:** Extract the fields of the configuration class to understand what parameters can be randomized or set at the test level (e.g., agent activity, scoreboard checks).

## 3. Recommended Extraction Strategy

1.  **Start with `moa_usbr_env.sv`:** Parse this file to build the top-level component tree.
2.  **Identify Agents:** For each agent found, recursively parse its directory to find its driver, monitor, and sequencer.
3.  **Map Interfaces:** Locate the interface instantiations and connect them to the corresponding agent's virtual interface handle in its configuration object.
4.  **Build Sequence Library:** Scan the `seqlib` directory and parse every `*.sv` file to create a catalog of available stimulus sequences.
5.  **Parse Transaction Definitions:** Find the core `*_pkg.sv` file and extract the definitions for all `uvm_sequence_item` extensions.
6.  **Analyze a Base Test:** Parse a simple test like `moa_usbr_sanity.sv` to understand the test structure, how the environment is created, and how the top-level sequence is started. This provides the template for execution.
