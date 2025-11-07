# Extraction Guide: Parsing Validation Documents & UVM Environments

## Overview

This guide describes how to extract key verification components from both high-level validation documents (Markdown/Promark) and existing UVM source code repositories. The agent must be able to identify and parse critical elements to understand the testbench architecture and available stimulus.

The primary extraction targets are:
1.  **Sequences**: Test sequences and their parameters.
2.  **Test Base Structure**: UVM/OVM/Saola testbench architecture.
3.  **RTL Signals & Interfaces**: Physical interface signals and protocols.
4.  **Transaction Objects**: The data structures passed within the testbench.
5.  **Configuration & Register Models**: RAL models and configuration objects.

---

## Part 1: Extracting from High-Level Validation Documents

This section focuses on parsing human-readable documents to capture the intended verification strategy.

### 1.1. Sequence Extraction

#### Identification Patterns
Look for these patterns in Markdown or Promark formats:

*   **Markdown Lists:**
    ```markdown
    - **sequence_name**: `uvm_sequence_name`
      - **Parameters**: `param1=value1, param2=value2`
    ```
*   **Promark Annotations:**
    ```promark
    @sequence(name="main_traffic_seq", type="random")
    @parameters(burst_length=8)
    ```

#### Sequence Classification
- **UVM**: `uvm_sequence`, `uvm_reg_sequence`
- **OVM**: `ovm_sequence`, `ovm_scenario`
- **Saola**: `sla_sequence`, `sla_scenario_sequence`

### 1.2. Test Base Structure Extraction

#### Architecture Identification
Look for testbench architecture descriptions, often in ASCII-art trees or component lists.

*   **UVM Architecture Example:**
    ```markdown
    ## Test Architecture
    - **Test**: `base_test` extending `uvm_test`
    - **Environment**: `chip_env` extending `uvm_env`
    - **Agents**: `pcie_agent`, `ddr_agent`
    ```

#### Component Mapping
| Document Term | UVM Component | OVM Component | Saola Component |
|---------------|---------------|---------------|------------------|
| Test | `uvm_test` | `ovm_test` | `sla_test_manager` |
| Environment | `uvm_env` | `ovm_env` | `sla_env` |
| Agent | `uvm_agent` | `ovm_agent` | `sla_bfm` |

### 1.3. RTL Signal Extraction

#### Signal Documentation Patterns
Look for Markdown tables detailing interface signals.

*   **Interface Table Example:**
    ```markdown
    | Signal Name | Direction | Width | Description |
    |-------------|-----------|-------|-------------|
    | pcie_clk    | input     | 1     | PCIe clock  |
    | pcie_rst_n  | input     | 1     | PCIe reset  |
    ```

---

## Part 2: Extracting from a UVM Source Code Repository

This section provides a practical strategy for extracting information directly from a well-structured UVM repository, using `/nfs/site/disks/juanpsal_disk_002/iscp-fst/ip-csme` as a case study.

### 2.1. Recommended Extraction Strategy & Key Targets

1.  **Start with the Core Environment (`moa_usbr_env.sv`):**
    *   **Location:** `verif/csme_usbr/env/`
    *   **Goal:** Parse this file first to build the top-level component tree. Identify instantiations of agents, scoreboards (`csme_usbr_scoreboard.sv`), and the virtual sequencer (`moa_usbr_vsequencer.sv`). This establishes the main architecture.

2.  **Identify and Parse Agents:**
    *   **Location:** Recursively parse agent directories (e.g., `verif/csme_usbr/env/usbr_agent/`).
    *   **Goal:** For each agent, find its core components: driver, monitor, and sequencer. Also, locate its configuration object (e.g., `usbr_agent_cfg.sv`) to understand its operational modes.

3.  **Build the Sequence Library:**
    *   **Location:** `verif/csme_usbr/env/seqlib/`
    *   **Goal:** This is the most critical step for stimulus generation. Scan and parse every `*.sv` file in this directory (e.g., `csme_usbr_init.sv`, `csme_usbr_bulk_data_seq.sv`). Extract sequence names, their parameters, and the high-level tasks they perform to create a comprehensive catalog of available stimulus.

4.  **Parse Transaction and Configuration Objects:**
    *   **Location:** Look for a central package file (`csme_usbr_pkg.sv`) and template files (`verif/csme_usbr/env/templates/`).
    *   **Goal:** Extract the `class` definitions for transaction items (`uvm_sequence_item`) to understand their fields and constraints. Also, parse configuration classes (e.g., `moa_usbr_cfg.sv.template`) to identify all parameters that can be configured at the test level.

5.  **Map Physical Interfaces:**
    *   **Location:** `verif/csme_usbr/ti/`
    *   **Goal:** Parse the interface files (e.g., `csme_usbr_utmi_intf.sv`) to get a complete list of signals, ports, and modports. This is essential for mapping the agent's virtual interface to the physical DUT connections.

6.  **Analyze a Base Test for Execution Patterns:**
    *   **Location:** `verif/csme_usbr/tests/`
    *   **Goal:** Parse a simple sanity test (e.g., `moa_usbr_sanity.sv`). Analyze how the environment is created, how the configuration object is set, and how the top-level virtual sequence is started. This provides the blueprint for executing newly generated tests.

### 2.2. Cross-Reference Validation

After extraction, the agent must perform consistency checks:
- **Sequence-Signal Mapping**: Ensure that sequences reference signals that actually exist in the parsed interfaces.
- **Architecture-Interface Alignment**: Verify that agent configuration objects are assigned a valid virtual interface.
- **Protocol Compliance**: Check that the signals found in an interface file match the expected signals for a detected protocol (e.g., AXI, USB).

### 2.3. Final Output Format

The final extracted data should be stored in a structured format like JSON, containing all the key elements discovered.

```json
{
  "extraction_metadata": {
    "repository_source": "/nfs/site/disks/juanpsal_disk_002/iscp-fst/ip-csme",
    "extraction_timestamp": "2025-11-07T13:36:00Z",
    "methodology": "UVM"
  },
  "sequences": [
    {
      "name": "csme_usbr_bulk_data_seq",
      "class": "csme_usbr_bulk_data_seq",
      "file_path": "verif/csme_usbr/env/seqlib/csme_usbr_bulk_data_seq.sv",
      "parameters": { "num_packets": 10 }
    }
  ],
  "architecture": {
    "methodology": "UVM",
    "test_class": "moa_usbr_base_test",
    "environment_class": "moa_usbr_env",
    "components": [
      { "name": "usbr_agent", "type": "uvm_agent" },
      { "name": "scoreboard", "type": "csme_usbr_scoreboard" }
    ]
  },
  "interfaces": [
    {
      "name": "csme_usbr_utmi_intf",
      "protocol": "UTMI",
      "signals": [
        { "name": "data_out", "direction": "output", "width": 8 }
      ]
    }
  ]
}
```
