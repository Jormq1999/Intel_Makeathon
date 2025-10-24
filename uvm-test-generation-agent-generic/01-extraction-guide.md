# Extraction Guide: Parsing Validation Documents

## Overview

This guide describes how to extract key verification components from validation documents written in Markdown or Promark format. The agent must be able to identify and parse three critical elements:

1. **Sequences**: Test sequences and their parameters
2. **Test Base Structure**: UVM/OVM/Saola testbench architecture
3. **RTL Signals**: Interface signals and protocols

## 1. Sequence Extraction

### 1.1 Sequence Identification Patterns

Look for these patterns in validation documents:

#### Markdown Format
```markdown
## Sequences

### Primary Sequences
- **sequence_name**: `uvm_sequence_name`
  - **Type**: `random/directed/constrained`
  - **Parameters**: `param1=value1, param2=value2`
  - **Description**: Brief description of sequence purpose

### Secondary Sequences
- **reset_sequence**: `chip_reset_seq`
- **config_sequence**: `register_config_seq`
```

#### Promark Format
```promark
@sequence(name="main_traffic_seq", type="random")
@parameters(burst_length=8, address_range="0x1000-0x2000")
@description("Generates random traffic with specified burst patterns")
```

### 1.2 Sequence Extraction Algorithm

```python
def extract_sequences(document_content):
    sequences = []
    
    # Pattern 1: Markdown bullet lists
    sequence_pattern = r'-\s*\*\*([^*]+)\*\*:\s*`([^`]+)`'
    
    # Pattern 2: Promark annotations
    promark_pattern = r'@sequence\(name="([^"]+)".*?\)'
    
    # Pattern 3: Table format
    table_pattern = r'\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|'
    
    for match in re.finditer(sequence_pattern, document_content):
        sequence_name = match.group(1).strip()
        sequence_class = match.group(2).strip()
        sequences.append({
            'name': sequence_name,
            'class': sequence_class,
            'type': extract_sequence_type(document_content, sequence_name),
            'parameters': extract_sequence_parameters(document_content, sequence_name)
        })
    
    return sequences
```

### 1.3 Sequence Classification

**UVM Sequences**:
- `uvm_sequence`
- `uvm_reg_sequence`
- Custom sequence classes extending UVM base

**OVM Sequences**:
- `ovm_sequence`
- `ovm_scenario`
- Legacy OVM sequence types

**Saola Sequences**:
- `sla_sequence`
- `sla_scenario_sequence`
- Saola-specific sequence classes

## 2. Test Base Structure Extraction

### 2.1 Architecture Identification

Look for testbench architecture descriptions:

#### UVM Architecture
```markdown
## Test Architecture

### UVM Components
- **Test**: `base_test` extending `uvm_test`
- **Environment**: `chip_env` extending `uvm_env`
- **Agents**: 
  - `pcie_agent` (master)
  - `ddr_agent` (slave)
  - `gpio_agent` (monitor only)

### Component Hierarchy
```
test
├── env
│   ├── pcie_agent
│   │   ├── driver
│   │   ├── monitor
│   │   └── sequencer
│   ├── ddr_agent
│   └── scoreboard
└── virtual_sequencer
```
```

#### Saola Architecture
```markdown
## Saola Test Structure

### Framework Components
- **Test Manager**: `sla_test_manager`
- **Environment**: `sla_env_<IP_name>`
- **BFMs**: 
  - `sla_<protocol>_bfm`
  - `sla_<interface>_bfm`
```

### 2.2 Architecture Extraction Patterns

```python
def extract_test_architecture(document_content):
    architecture = {
        'methodology': detect_methodology(document_content),
        'components': [],
        'hierarchy': {},
        'interfaces': []
    }
    
    # Detect methodology
    if 'uvm_' in document_content.lower():
        architecture['methodology'] = 'UVM'
    elif 'ovm_' in document_content.lower():
        architecture['methodology'] = 'OVM'
    elif 'sla_' in document_content.lower():
        architecture['methodology'] = 'Saola'
    
    # Extract component hierarchy
    hierarchy_pattern = r'```\s*\n([^`]+)\n```'
    for match in re.finditer(hierarchy_pattern, document_content):
        architecture['hierarchy'] = parse_hierarchy_tree(match.group(1))
    
    return architecture
```

### 2.3 Component Mapping

| Document Term | UVM Component | OVM Component | Saola Component |
|---------------|---------------|---------------|------------------|
| Test | `uvm_test` | `ovm_test` | `sla_test_manager` |
| Environment | `uvm_env` | `ovm_env` | `sla_env` |
| Agent | `uvm_agent` | `ovm_agent` | `sla_bfm` |
| Driver | `uvm_driver` | `ovm_driver` | `sla_driver` |
| Monitor | `uvm_monitor` | `ovm_monitor` | `sla_monitor` |
| Sequencer | `uvm_sequencer` | `ovm_sequencer` | `sla_sequencer` |

## 3. RTL Signal Extraction

### 3.1 Signal Documentation Patterns

#### Interface Tables
```markdown
## RTL Interfaces

### PCIe Interface
| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| pcie_clk | input | 1 | PCIe clock |
| pcie_rst_n | input | 1 | PCIe reset (active low) |
| pcie_tx_data | output | 32 | Transmit data |
| pcie_rx_data | input | 32 | Receive data |

### GPIO Interface
| Signal | Type | Width | Function |
|--------|------|-------|----------|
| gpio_out[7:0] | output | 8 | General purpose outputs |
| gpio_in[7:0] | input | 8 | General purpose inputs |
```

#### Protocol Specifications
```markdown
## Protocol Details

### AXI4 Master Interface
- **Clock Domain**: `axi_clk`
- **Reset**: `axi_resetn` (active low)
- **Address Width**: 32 bits
- **Data Width**: 64 bits
- **Burst Support**: INCR, WRAP
```

### 3.2 Signal Extraction Algorithm

```python
def extract_rtl_signals(document_content):
    interfaces = []
    
    # Extract interface tables
    table_pattern = r'\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|'
    
    current_interface = None
    for line in document_content.split('\n'):
        # Detect interface headers
        if line.startswith('###') and 'Interface' in line:
            current_interface = {
                'name': extract_interface_name(line),
                'signals': [],
                'protocol': detect_protocol(line)
            }
            interfaces.append(current_interface)
        
        # Extract signal information from tables
        table_match = re.match(table_pattern, line)
        if table_match and current_interface:
            signal = {
                'name': table_match.group(1).strip(),
                'direction': table_match.group(2).strip(),
                'width': parse_width(table_match.group(3).strip()),
                'description': table_match.group(4).strip()
            }
            current_interface['signals'].append(signal)
    
    return interfaces
```

### 3.3 Protocol Detection

**Standard Protocols**:
- AXI4, AXI4-Lite, AXI4-Stream
- PCIe, USB, SATA
- I2C, SPI, UART
- DDR3/DDR4
- Custom protocols

**Detection Patterns**:
```python
protocol_patterns = {
    'AXI4': ['axi_', 'awaddr', 'araddr', 'wdata', 'rdata'],
    'PCIe': ['pcie_', 'cfg_', 'rx_', 'tx_'],
    'DDR': ['ddr_', 'dq[', 'dqs', 'ba[', 'ras_n'],
    'GPIO': ['gpio_', '_pin', '_port'],
    'I2C': ['i2c_', 'sda', 'scl'],
    'SPI': ['spi_', 'mosi', 'miso', 'sclk', 'cs_n']
}
```

## 4. Cross-Reference Validation

### 4.1 Consistency Checks

1. **Sequence-Signal Mapping**: Verify sequences reference valid signals
2. **Architecture-Signal Alignment**: Ensure testbench components connect to described signals
3. **Protocol Compliance**: Validate signal sets match protocol specifications

### 4.2 Error Detection

```python
def validate_extraction(sequences, architecture, signals):
    errors = []
    warnings = []
    
    # Check for missing signal references
    for sequence in sequences:
        for signal_ref in extract_signal_references(sequence):
            if not find_signal_in_interfaces(signal_ref, signals):
                errors.append(f"Signal '{signal_ref}' referenced in sequence '{sequence['name']}' not found")
    
    # Check architecture completeness
    if not architecture.get('methodology'):
        warnings.append("No clear verification methodology detected")
    
    return errors, warnings
```

## 5. Output Format

### 5.1 Structured Data Format

```json
{
  "extraction_metadata": {
    "document_source": "validation_doc.md",
    "extraction_timestamp": "2025-10-23T10:30:00Z",
    "methodology": "UVM"
  },
  "sequences": [
    {
      "name": "main_traffic_seq",
      "class": "traffic_sequence",
      "type": "random",
      "parameters": {
        "burst_length": 8,
        "address_range": "0x1000-0x2000"
      },
      "signals_used": ["axi_awaddr", "axi_wdata"]
    }
  ],
  "architecture": {
    "methodology": "UVM",
    "test_class": "base_test",
    "environment_class": "chip_env",
    "components": [
      {
        "name": "pcie_agent",
        "type": "uvm_agent",
        "role": "master"
      }
    ]
  },
  "interfaces": [
    {
      "name": "pcie_interface",
      "protocol": "PCIe",
      "signals": [
        {
          "name": "pcie_clk",
          "direction": "input",
          "width": 1
        }
      ]
    }
  ]
}
```

## Best Practices

1. **Robust Parsing**: Handle variations in document formatting
2. **Error Recovery**: Continue extraction even with partial failures
3. **Validation**: Cross-check extracted information for consistency
4. **Documentation**: Maintain clear traceability from source to extracted data
5. **Extensibility**: Design patterns to accommodate new methodologies and protocols

---

*Next: [02-integration-guide.md](02-integration-guide.md) - Learn how to integrate extracted components*