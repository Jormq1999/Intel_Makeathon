# Copilot Instructions for Intel_Makeathon UVM Test Generation

## Project Overview
This workspace focuses on automated UVM test generation for hardware IP validation. The main agents parse validation documents and generate complete UVM/OVM/Saola verification environments, following industry-standard methodologies with minimal human intervention.

## Architecture & Key Components

### Core Agent Directories
- `uvm-test-generation-agent/`: Primary agent implementation and documentation
- `uvm-test-generation-agent-generic/`: Generic IP verification templates  
- `uvm-test-generation-agent-docs/`: Comprehensive documentation and guides
- `Juan-local-testing/fifo_project/`: Working FIFO UVM testbench example
- `Juan-local-testing/pandoc_conversion/`: Document conversion utilities

### Essential Workflow (Follow This Order)
1. **Document Analysis**: Parse validation documents (Word → Markdown via pandoc/mammoth)
2. **Component Extraction**: Extract sequences, signals, coverage points using regex patterns
3. **Architecture Design**: Detect UVM/OVM/Saola methodology from document content
4. **Code Generation**: Use Jinja2 templates to generate SystemVerilog components
5. **Integration**: Assemble into working testbench with proper build system
6. **Validation**: Ensure generated tests meet requirements

## Critical Build & Simulation Patterns

### VCS-Based Build System (Standard Pattern)
```makefile
# Environment setup for Intel tools
RTL_CAD_ROOT ?= /p/hdk/rtl/cad/x86-64_linux44
VCS_VERSION := V-2023.12-SP2-1
export VCS_HOME := $(RTL_CAD_ROOT)/synopsys/vcsmx/$(VCS_VERSION)
export VERDI_HOME := $(RTL_CAD_ROOT)/synopsys/verdi3/$(VCS_VERSION)
export UVM_HOME ?= $(VCS_HOME)/etc/uvm-1.2

# Standard compilation
VCS_FLAGS = -full64 -sverilog +v2k -timescale=1ns/1ps -debug_access+all -ntb_opts uvm
```

### Required License Setup (tcsh)
```tcsh
setenv LM_PROJECT EIG_CSME
setenv LM_LICENSE_FILE <your_license_server_details>
```

### UVM Component Structure (Follow This Pattern)
Based on `Juan-local-testing/fifo_project/`, components must follow this hierarchy:
```
tb_top.sv          # Clock/reset generation, interface instantiation
<module>_if.sv     # Virtual interface definition
<module>_item.sv   # UVM sequence item (transaction)
<module>_sequences.sv  # UVM sequences for stimulus
<module>_driver.sv # Drives transactions to DUT
<module>_monitor.sv # Observes DUT behavior  
<module>_scoreboard.sv # Checking logic
<module>_agent.sv  # Contains driver + monitor
<module>_env.sv    # Top-level environment
<module>_tests.sv  # Test classes extending uvm_test
```

## Document Processing & Conversion

### Validation Document Formats
- **Primary**: Markdown (.md) with structured sections
- **Secondary**: Word (.docx) → convert via pandoc or mammoth
- **Extended**: Promark (.pmark) with @protocol/@sequence annotations

### Document Conversion Workflow
```powershell
# Use Juan-local-testing/pandoc_conversion/ utilities
Set-Location .\Juan-local-testing\pandoc_conversion
.\convert_and_setup.ps1 -Docx .\VAL_DCN_OCS_CPM.docx
```

### Pattern Recognition for Extraction
```python
# Architecture detection patterns (from 01-extraction-guide.md)
def detect_methodology(content):
    if 'uvm_' in content.lower(): return 'UVM'
    elif 'ovm_' in content.lower(): return 'OVM'
    elif 'sla_' in content.lower(): return 'Saola'

# Sequence extraction regex patterns
sequence_pattern = r'-\s*\*\*([^*]+)\*\*:\s*`([^`]+)`'
signal_pattern = r'`([a-zA-Z_][a-zA-Z0-9_]*)`'
```

## Project-Specific Conventions

### Generated Code Templates (Use Jinja2)
All code generation uses templates from `05-code-generation-templates.md`:
- Variable substitution: `{{ test_name }}`, `{{ methodology }}`
- Conditional blocks: `{%- if simulator == "vcs" %}`
- File lists: `{%- for file in testbench_files %}`

### Cross-Component Communication
- Use UVM configuration database: `uvm_config_db#(virtual fifo_if)::set()`
- Virtual interfaces passed through config DB, not direct connections
- All testbench files must include `uvm_macros.svh` and import `uvm_pkg::*`

### Build System Integration
- Generate Makefiles with simulator detection (VCS/Questa/Xcelium)
- Include coverage collection targets: `COV_DIR`, coverage options
- Support multiple test execution: `make run TEST=test_name`

## Development Workflow Commands

### Compilation & Simulation
```bash
# Standard workflow in fifo_project/
make compile                    # Build testbench
make run TEST=test_write_to_full # Run specific test
make run_and_debug TEST=fifo_base_test # Launch with Verdi
make clean                      # Remove artifacts
```

### Document Processing
```bash
# Convert validation documents
python convert_docx_to_md.py input.docx  # mammoth-based
python pandoc_convert.py input.docx      # pandoc-based (preferred)
```

## Key Integration Points

### IP Categories Supported
- Communication IPs: PCIe, USB, Ethernet, UART, SPI, I2C
- Memory Controllers: DDR, HBM, LPDDR interfaces  
- Security IPs: Cryptographic engines, authentication
- Custom ASICs and System-on-Chip integration

### External Dependencies
- Synopsys VCS/Verdi toolchain (Intel-specific paths)
- UVM library (typically bundled with VCS)
- Python packages: mammoth, html2text, pypandoc for document conversion
- License server configuration required

## Getting Started Checklist
1. Review documentation files in order: `01-extraction-guide.md` through `07-build-and-execution.md`
2. Set up license environment variables for your site
3. Use `Juan-local-testing/fifo_project/` as reference implementation
4. Validate document format against `06-validation-document-format.md` requirements
5. Follow the 6-step workflow: parse → extract → design → generate → integrate → validate

---
**Always validate generated code against the documented requirements and templates.**