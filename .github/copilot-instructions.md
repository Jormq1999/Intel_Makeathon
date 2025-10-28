# Copilot Instructions for Intel_Makeathon

## Project Overview
This workspace is focused on automated UVM test generation for hardware IP validation. The main agents parse validation documents and generate complete UVM/OVM/Saola verification environments, following industry-standard methodologies with minimal human intervention.

## Key Directories & Documentation
- `uvm-test-generation-agent/` and `uvm-test-generation-agent-generic/`: Core guides and implementation details for test generation agents.
- Each agent directory contains numbered documentation files:
  - `01-extraction-guide.md`: Parsing validation documents
  - `02-integration-guide.md`: Integrating generated components
  - `03-coverage-implementation.md`: Coverage strategies
  - `04-architecture-patterns.md`: Testbench architecture
  - `05-code-generation-templates.md`: Templates for code generation
  - `06-validation-document-format.md`: Validation doc requirements
  - `07-build-and-execution.md`: Build and run instructions
- `README.md` files summarize agent goals and workflow.

## Essential Workflow
1. **Document Analysis**: Parse validation documents for test requirements.
2. **Component Extraction**: Identify sequences, signals, and coverage points.
3. **Architecture Design**: Design UVM testbench structure.
4. **Code Generation**: Use templates to generate verification components.
5. **Integration**: Assemble components into a working environment.
6. **Validation**: Ensure generated tests meet requirements.

## Patterns & Conventions
- Follow the stepwise workflow outlined in agent READMEs and guides.
- Use provided templates for code generation; do not invent new formats.
- Validation documents must match the format described in `06-validation-document-format.md`.
- Coverage implementation should follow strategies in `03-coverage-implementation.md`.
- Architecture must align with patterns in `04-architecture-patterns.md`.

## Build & Execution
- Refer to `07-build-and-execution.md` for build commands and simulation setup.
- If examples are present, use them as reference for integration and execution.

## Integration Points
- Generated code is intended to work with UVM/OVM/Saola verification environments.
- Ensure cross-component communication matches documented patterns.

## Getting Started
- Review documentation files in order (01-07) for each agent.
- Use README.md summaries for quick orientation.
- Always validate generated code against the documented requirements and templates.

---
**Feedback:** If any section is unclear or missing, please specify so it can be improved for future AI agents.
