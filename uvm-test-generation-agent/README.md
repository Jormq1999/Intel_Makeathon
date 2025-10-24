# UVM Test Generation Agent Documentation

This directory contains comprehensive documentation to guide a copilot agent in automatically generating UVM/OVM/Saola verification environments and tests from validation documents.

## Overview

The UVM Test Generation Agent is designed to consume validation documents (Markdown/Promark) that describe:
- Test structure in UVM/OVM/Saola methodology
- Sequences used by the test
- RTL signals utilized
- Coverage points and requirements

From this information, the agent generates all necessary verification components including:
- UVM environments and testbenches
- Bus Functional Models (BFMs)
- Interfaces and protocols
- Test sequences and scenarios
- Coverage collectors and analysis
- Build and run collaterals

## Documentation Structure

### Core Documentation Files

1. **[01-extraction-guide.md](01-extraction-guide.md)**
   - How to extract sequences from validation documents
   - How to extract test base structure
   - How to extract RTL signals and interfaces

2. **[02-integration-guide.md](02-integration-guide.md)**
   - How to combine sequences and signals in tests
   - Test orchestration and execution patterns
   - UVM/OVM/Saola integration methodologies

3. **[03-coverage-implementation.md](03-coverage-implementation.md)**
   - Coverage implementation strategies
   - Functional and code coverage approaches
   - Coverage analysis and reporting

4. **[04-architecture-patterns.md](04-architecture-patterns.md)**
   - UVM testbench architecture patterns
   - Component hierarchy and organization
   - Interface and protocol handling

5. **[05-code-generation-templates.md](05-code-generation-templates.md)**
   - SystemVerilog code generation templates
   - UVM component templates
   - Test and sequence templates

6. **[06-validation-document-format.md](06-validation-document-format.md)**
   - Expected validation document format
   - Markdown/Promark structure requirements
   - Parsing guidelines and examples

7. **[07-build-and-execution.md](07-build-and-execution.md)**
   - Build system integration
   - Simulation and execution workflows
   - Debugging and analysis procedures

### Supporting Directories

- **examples/**: Sample validation documents and generated code
- **templates/**: SystemVerilog and UVM code templates
- **schemas/**: Validation document schemas and formats

## Usage Workflow

1. **Document Analysis**: Parse validation document for test requirements
2. **Component Extraction**: Extract sequences, signals, and coverage points
3. **Architecture Design**: Design UVM testbench architecture
4. **Code Generation**: Generate all verification components
5. **Integration**: Combine components into working test environment
6. **Validation**: Verify generated test meets requirements

## Agent Capabilities

The agent should be capable of:
- Parsing complex validation documents
- Understanding UVM/OVM/Saola methodologies
- Generating production-quality SystemVerilog code
- Creating comprehensive test environments
- Implementing functional and code coverage
- Integrating with existing verification flows

## Getting Started

1. Review the core documentation files in order (01-07)
2. Examine examples in the examples/ directory
3. Understand the validation document format requirements
4. Use the provided templates for code generation

---

*Last Updated: October 23, 2025*
*Version: 1.0*