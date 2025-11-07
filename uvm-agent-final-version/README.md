````markdown
# UVM Test Generation Agent Documentation

## Overview

This documentation provides comprehensive guidance for creating an automated UVM test generation agent. The agent is designed to parse validation documents and generate complete UVM/OVM/Saola verification environments for any IP, following industry-standard verification methodologies with minimal human intervention.

### Project Purpose

The UVM test generation agent automates the creation of verification testbenches by:
- Parsing validation documents (Markdown, Promark, Word formats)
- Extracting test sequences, signal definitions, and coverage requirements
- Generating production-quality SystemVerilog UVM code
- Creating complete test environments with proper architecture
- Integrating with existing build systems and simulation flows

### Supported IP Types

The agent is designed to work with various IP categories:
- **Communication IPs**: PCIe, USB, Ethernet, UART, SPI, I2C
- **Memory Controllers**: DDR, HBM, LPDDR interfaces
- **Security IPs**: Cryptographic engines, key management, authentication
- **Processor IPs**: CPU cores, DSPs, microcontrollers
- **Custom ASICs**: Application-specific integrated circuits
- **System-on-Chip**: Complex multi-protocol integration

### Key Architecture Elements

The agent handles common verification patterns:
- **Protocol Interfaces**: Standard and custom communication protocols
- **Register Models**: RAL (Register Abstraction Layer) integration
- **Clock/Reset Domains**: Multi-domain synchronization
- **Power Management**: Clock gating, power state verification
- **Debug/Test**: DFT, JTAG, and manufacturing test modes
````