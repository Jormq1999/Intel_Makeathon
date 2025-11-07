# UVM Test Generation Agent Support Docs

## Overview

Welcome to the UVM Test Generation Agent Support Documentation project. This repository contains a curated set of documents designed to help you adapt and train a copilot agent into a powerful assistant for Universal Verification Methodology (UVM) tasks.

The primary goal is to create an enjoyable and highly efficient user experience where your copilot agent can understand your verification needs from a high-level Test Plan and automatically generate a complete verification environment, its components, and the necessary build infrastructure.

By leveraging the structured information in the `uvm-agent-final-version` directory, your agent will gain the "knowledge base" needed to perform complex tasks, from creating a testbench from scratch to integrating with standard industry tools like Verdi.

---

## Adapting Your Copilot Agent: A Guide

To transform your general-purpose copilot agent into a specialized UVM verification expert, you should provide it with the context from the `uvm-agent-final-version` directory. This process mimics "training" the agent on a specific domain.

### Instructions for Your Copilot Agent

When you start a session with your copilot agent to work on a verification task, provide it with a preamble that points to this knowledge base. This preamble sets the context and instructs the agent on how to behave.

**Example Preamble to Give Your Copilot Agent:**

```
"You are an expert UVM verification assistant. Your primary goal is to help me create and manage a UVM testbench for my RTL design.

You must use the documentation located in the `/nfs/site/disks/juanpsal_disk_002/iscp-fst/Intel_Makeathon/uvm-agent-final-version/` directory as your comprehensive knowledge base and guide for all the code you generate.

Your key responsibilities are:
1.  **Parse my Test Plan**: Understand the verification requirements, test scenarios, and coverage goals I provide.
2.  **Generate UVM Components**: Create high-quality, reusable UVM components, including the testbench, environment, agents (monitors, drivers, sequencers), scoreboards, and sequences.
3.  **Follow Architectural Patterns**: Adhere to the UVM architecture patterns described in the support documents to ensure a robust and scalable environment.
4.  **Create Build Systems**: Generate a Makefile to compile and run simulations using VCS.
5.  **Enable Debugging**: Integrate support for Verdi for waveform debugging.
6.  **Adhere to Best Practices**: Follow the coding style, naming conventions, and directory structures outlined in the documentation.

When I provide a Test Plan, you are to read it, and then use the knowledge from your support documentation to generate all necessary files."
```

---

## Key Capabilities of the Adapted Agent

By following the guidelines in the support documentation, your agent will be equipped to:

### 1. Create a Full Verification Environment from a Test Plan
The agent will parse a validation document (Test Plan) to understand the DUT, its interfaces, and the required test scenarios. It will then generate all the necessary UVM collaterals.

-   **Input**: A Markdown file (`Testplan.md`).
-   **Output**: A complete UVM environment (`tb`, `env`, `sequences`, `bfms`, `monitor`, `scbd`, etc.).

### 2. Generate High-Quality, Reusable UVM Components
The agent has access to a rich database of templates and best practices for all standard UVM components. It can generate code that is modular, configurable, and easy to maintain.

### 3. Automate the Build and Execution Flow
The agent can create a `Makefile` to automate the entire simulation process. This includes:
-   Compiling the RTL and testbench.
-   Running specific tests using `+UVM_TESTNAME`.
-   Cleaning the simulation directory.

### 4. Integrate with Verdi for Advanced Debugging
The generated `Makefile` and testbench code will include the necessary hooks for dumping waveforms to an FSDB file, allowing for seamless debugging in Verdi. This includes setting up the required VCS flags and PLI table integration.

---

## Guide to the `uvm-agent-final-version` Documentation

This directory is the brain of your agent. Here’s what each document provides:

-   **`01-extraction.md`**: Teaches the agent how to parse and understand different sections of a validation document.
-   **`02-integration.md`**: Provides guidelines on how to integrate the generated components into a cohesive testbench.
-   **`03-coverage.md`**: Details how to implement functional coverage (covergroups, coverpoints) based on the requirements in a Test Plan.
-   **`04-architecture.md`**: Describes standard UVM architectural patterns (single-agent, multi-agent, hierarchical) that the agent should use as a blueprint.
-   **`05-code-generation-templates.md`**: Contains a rich library of ready-to-use SystemVerilog templates for every UVM component. **This is the core of the code generation capability.**
-   **`06-validation-document-format.md`**: Defines the expected format of the input Test Plan, ensuring the agent can parse it reliably.
-   **`07-build-and-execution.md`**: Provides the templates and instructions for creating a `Makefile` with VCS and Verdi support.
-   **`README.md`**: Offers a high-level overview of the agent's purpose and capabilities.

---

## Example Workflow

Here is a hypothetical interaction with your newly adapted, expert UVM agent:

1.  **You**: *(Provide the preamble from the section above)*. "Here is my Test Plan for a simple FIFO design. Please generate the complete UVM testbench."
    *(You attach `fifo_test_plan.md`)*

2.  **Agent**: *(Reads the preamble and understands its role. Reads the attached Test Plan.)* "Understood. I will now generate the UVM environment for the FIFO design based on your Test Plan. I will create the following components:
    -   FIFO Interface (`fifo_if.sv`)
    -   Transaction Item (`fifo_item.sv`)
    -   FIFO Agent (driver, monitor, sequencer)
    -   Scoreboard (`fifo_scoreboard.sv`)
    -   Environment (`fifo_env.sv`)
    -   Base Test and a `basic_write_read_test`
    -   A `Makefile` for compilation and execution."

3.  **Agent**: *(Proceeds to use the templates from `05-code-generation-templates.md` and `07-build-and-execution.md` to generate all the required files and the Makefile, placing them in the correct directory structure as defined in `04-architecture.md`.)*

4.  **Agent**: "I have generated all the files. You can now compile the environment by running `make compile` and run the first test with `make run TEST=basic_write_read_test`. To debug with Verdi, use `make run_verdi TEST=basic_write_read_test`."

This workflow dramatically accelerates the verification process, allowing you to focus on high-level strategy while your expert agent handles the detailed implementation.
