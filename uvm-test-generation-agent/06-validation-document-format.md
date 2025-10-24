# Validation Document Format Guide

## Overview

This guide defines the expected format and structure for validation documents that the UVM test generation agent will parse. The agent requires properly formatted documents to extract sequences, signals, architecture, and coverage requirements.

## 1. Supported Document Formats

### 1.1 Primary Formats

- **Markdown (.md)**: Primary format with structured sections
- **Promark (.pmark)**: Extended markdown with protocol-specific annotations
- **Word Documents (.docx)**: Converted to markdown for processing
- **Plain Text (.txt)**: Simple text format with clear delimiters

### 1.2 Format Detection

```python
def detect_document_format(file_path):
    format_indicators = {
        'markdown': ['# ', '## ', '### ', '```', '| --- |'],
        'promark': ['@protocol:', '@sequence:', '@signal:', '@coverage:'],
        'word': ['.docx', '.doc'],
        'plaintext': ['.txt']
    }
    
    # Check file extension
    extension = Path(file_path).suffix.lower()
    if extension in ['.md', '.markdown']:
        return 'markdown'
    elif extension in ['.pmark']:
        return 'promark'
    elif extension in ['.docx', '.doc']:
        return 'word'
    elif extension in ['.txt']:
        return 'plaintext'
    
    # Check content patterns
    with open(file_path, 'r') as f:
        content = f.read(1000)  # Sample first 1000 chars
        for format_type, patterns in format_indicators.items():
            if any(pattern in content for pattern in patterns):
                return format_type
    
    return 'unknown'
```

## 2. Document Structure Requirements

### 2.1 Mandatory Sections

```markdown
# Validation Plan: [Test Name]

## 1. Test Overview
- **Protocol**: [Protocol Name]
- **Methodology**: [UVM/OVM/Saola]
- **Scope**: [Block/System/Integration]
- **DUT**: [Design Under Test]

## 2. Test Architecture
[Architecture description and component hierarchy]

## 3. Sequences
[Sequence definitions and parameters]

## 4. Signals and Interfaces
[Signal definitions and interface specifications]

## 5. Coverage Requirements
[Functional and code coverage specifications]

## 6. Build and Execution
[Build requirements and execution parameters]
```

### 2.2 Section Identification Patterns

```python
section_patterns = {
    'test_overview': [
        r'#+ .*[Tt]est [Oo]verview',
        r'#+ .*[Oo]verview',
        r'#+ .*[Ss]ummary'
    ],
    'architecture': [
        r'#+ .*[Aa]rchitecture',
        r'#+ .*[Tt]estbench',
        r'#+ .*[Ee]nvironment'
    ],
    'sequences': [
        r'#+ .*[Ss]equences?',
        r'#+ .*[Tt]est [Cc]ases?',
        r'#+ .*[Ss]cenarios?'
    ],
    'signals': [
        r'#+ .*[Ss]ignals?',
        r'#+ .*[Ii]nterfaces?',
        r'#+ .*[Pp]orts?'
    ],
    'coverage': [
        r'#+ .*[Cc]overage',
        r'#+ .*[Vv]erification'
    ]
}
```

## 3. Test Overview Format

### 3.1 Basic Information

```markdown
## Test Overview

**Protocol**: AXI4-Stream  
**Methodology**: UVM 1.2  
**Scope**: Block-level verification  
**DUT**: Stream Processor IP  
**Test Duration**: 10,000 clock cycles  
**Random Seed**: Configurable  

### Test Objectives
- Verify AXI4-Stream protocol compliance
- Test data integrity through the stream processor
- Validate backpressure handling
- Ensure proper error handling

### Test Environment
- **Testbench Architecture**: Single-agent UVM environment
- **Clocking**: 100MHz system clock
- **Reset**: Asynchronous reset, active low
- **Interfaces**: AXI4-Stream input/output
```

### 3.2 Parsing Rules

```python
def parse_test_overview(section_text):
    overview = {
        'protocol': extract_field(section_text, r'\*\*Protocol\*\*:?\s*([^\n]+)'),
        'methodology': extract_field(section_text, r'\*\*Methodology\*\*:?\s*([^\n]+)'),
        'scope': extract_field(section_text, r'\*\*Scope\*\*:?\s*([^\n]+)'),
        'dut': extract_field(section_text, r'\*\*DUT\*\*:?\s*([^\n]+)'),
        'objectives': extract_list(section_text, r'### Test Objectives([\s\S]*?)(?=###|$)'),
        'architecture': extract_field(section_text, r'\*\*Testbench Architecture\*\*:?\s*([^\n]+)')
    }
    return overview
```

## 4. Sequence Format

### 4.1 Sequence Definition

```markdown
## Sequences

### 4.1 Basic Write Sequence

**Description**: Single AXI4-Stream write transaction  
**Type**: Directed  
**Duration**: 50 clock cycles  
**Parameters**:
- `data_width`: 32 bits
- `transfer_size`: Variable (1-16 beats)
- `data_pattern`: Incremental

**Implementation**:
```systemverilog
class basic_write_seq extends uvm_sequence#(axi_stream_item);
  rand int transfer_size;
  rand bit [31:0] start_data;
  
  constraint c_transfer_size {
    transfer_size inside {[1:16]};
  }
  
  virtual task body();
    for (int i = 0; i < transfer_size; i++) begin
      `uvm_do_with(req, {
        tdata == start_data + i;
        tlast == (i == transfer_size - 1);
      })
    end
  endtask
endclass
```

**Signals Used**:
- `tdata[31:0]`: Transfer data
- `tvalid`: Data valid
- `tready`: Ready for data
- `tlast`: Last transfer
- `tkeep[3:0]`: Byte enables
```

### 4.2 Parsing Sequence Definitions

```python
def parse_sequences(section_text):
    sequences = []
    
    # Find sequence blocks
    sequence_pattern = r'### \d+\.\d+ ([^\n]+)\n([\s\S]*?)(?=### \d+\.\d+|$)'
    matches = re.findall(sequence_pattern, section_text)
    
    for name, content in matches:
        sequence = {
            'name': clean_sequence_name(name),
            'description': extract_field(content, r'\*\*Description\*\*:?\s*([^\n]+)'),
            'type': extract_field(content, r'\*\*Type\*\*:?\s*([^\n]+)'),
            'duration': extract_field(content, r'\*\*Duration\*\*:?\s*([^\n]+)'),
            'parameters': parse_parameters(content),
            'implementation': extract_code_block(content, 'systemverilog'),
            'signals_used': parse_signals_used(content)
        }
        sequences.append(sequence)
    
    return sequences

def parse_parameters(content):
    parameters = {}
    param_section = extract_section(content, r'\*\*Parameters\*\*:([\s\S]*?)(?=\*\*|$)')
    
    if param_section:
        param_lines = re.findall(r'- `([^`]+)`: ([^\n]+)', param_section)
        for name, description in param_lines:
            parameters[name] = description.strip()
    
    return parameters
```

## 5. Signal and Interface Format

### 5.1 Signal Definitions

```markdown
## Signals and Interfaces

### 5.1 AXI4-Stream Interface

**Interface Name**: `axi_stream_if`  
**Protocol**: AXI4-Stream  
**Data Width**: 32 bits  
**Direction**: Bidirectional  

#### Signal List

| Signal Name | Width | Direction | Description |
|-------------|-------|-----------|-------------|
| `tdata` | 32 | Master → Slave | Transfer data |
| `tvalid` | 1 | Master → Slave | Data valid |
| `tready` | 1 | Slave → Master | Ready for data |
| `tlast` | 1 | Master → Slave | Last transfer |
| `tkeep` | 4 | Master → Slave | Byte enables |
| `tuser` | 8 | Master → Slave | User signals |

#### Timing Requirements

- **Setup Time**: 2ns before clock edge
- **Hold Time**: 1ns after clock edge
- **Clock Frequency**: 100MHz
- **Reset**: Asynchronous, active low

#### Protocol Constraints

- `tvalid` must remain high until `tready` is asserted
- `tlast` indicates the final beat of a packet
- `tkeep` bits correspond to `tdata` byte lanes
- All signals must be stable during valid transfers

### 5.2 Clock and Reset Signals

| Signal Name | Width | Direction | Description |
|-------------|-------|-----------|-------------|
| `clk` | 1 | Input | System clock |
| `rst_n` | 1 | Input | Async reset (active low) |
```

### 5.2 Signal Parsing

```python
def parse_signals(section_text):
    interfaces = []
    
    # Extract interface sections
    interface_pattern = r'### \d+\.\d+ ([^\n]+)\n([\s\S]*?)(?=### \d+\.\d+|$)'
    matches = re.findall(interface_pattern, section_text)
    
    for name, content in matches:
        interface = {
            'name': extract_field(content, r'\*\*Interface Name\*\*:?\s*`([^`]+)`'),
            'protocol': extract_field(content, r'\*\*Protocol\*\*:?\s*([^\n]+)'),
            'data_width': extract_field(content, r'\*\*Data Width\*\*:?\s*([^\n]+)'),
            'direction': extract_field(content, r'\*\*Direction\*\*:?\s*([^\n]+)'),
            'signals': parse_signal_table(content),
            'timing': parse_timing_requirements(content),
            'constraints': parse_protocol_constraints(content)
        }
        interfaces.append(interface)
    
    return interfaces

def parse_signal_table(content):
    signals = []
    
    # Find markdown table
    table_pattern = r'\| Signal Name \| Width \| Direction \| Description \|\n\|[^\n]+\|\n([\s\S]*?)(?=\n\n|$)'
    match = re.search(table_pattern, content)
    
    if match:
        table_content = match.group(1)
        rows = re.findall(r'\| `([^`]+)` \| ([^|]+) \| ([^|]+) \| ([^|]+) \|', table_content)
        
        for name, width, direction, description in rows:
            signals.append({
                'name': name.strip(),
                'width': parse_width(width.strip()),
                'direction': direction.strip(),
                'description': description.strip()
            })
    
    return signals
```

## 6. Coverage Format

### 6.1 Coverage Requirements

```markdown
## Coverage Requirements

### 6.1 Functional Coverage

#### Feature Coverage

**Transfer Size Coverage**:
- Single beat transfers (tlast = 1 on first beat)
- Short packets (2-4 beats)
- Medium packets (5-16 beats)
- Long packets (17+ beats)

**Data Pattern Coverage**:
- All zeros (0x00000000)
- All ones (0xFFFFFFFF)
- Walking ones (0x00000001, 0x00000002, ...)
- Random data patterns

**Backpressure Coverage**:
- No backpressure (tready always high)
- Random backpressure (tready randomly deasserted)
- Burst backpressure (tready low for multiple cycles)

#### Cross Coverage

**Size × Pattern Cross**:
- All combinations of transfer sizes and data patterns
- Exclude: Single beat with walking ones pattern

**Backpressure × Transfer Cross**:
- All combinations of backpressure scenarios and transfer types

### 6.2 Code Coverage

**Target Coverage**: 95% line coverage, 90% branch coverage  
**Exclusions**: Reset logic, error injection paths  
**Tools**: VCS coverage, Questa coverage  

### 6.3 Assertion Coverage

**Protocol Assertions**:
- AXI4-Stream protocol compliance
- Handshake signal relationships
- Data stability requirements

**Custom Assertions**:
- End-to-end data integrity
- Packet boundary detection
- Error condition handling
```

### 6.2 Coverage Parsing

```python
def parse_coverage(section_text):
    coverage = {
        'functional': parse_functional_coverage(section_text),
        'code': parse_code_coverage(section_text),
        'assertions': parse_assertion_coverage(section_text)
    }
    return coverage

def parse_functional_coverage(content):
    functional_cov = {
        'features': [],
        'cross_coverage': [],
        'scenarios': []
    }
    
    # Extract feature coverage
    feature_pattern = r'\*\*([^*]+)\*\*:([\s\S]*?)(?=\*\*|###|$)'
    features = re.findall(feature_pattern, content)
    
    for name, description in features:
        if 'Coverage' in name:
            functional_cov['features'].append({
                'name': name.replace(' Coverage', '').strip(),
                'items': extract_list_items(description)
            })
    
    return functional_cov
```

## 7. Promark Extensions

### 7.1 Promark Annotations

```promark
@protocol: AXI4-Stream
@methodology: UVM
@version: 1.2

# Test: AXI Stream Verification

@sequence: basic_write
@type: directed
@duration: 50
@signals: tdata[31:0], tvalid, tready, tlast

```systemverilog
class basic_write_seq extends uvm_sequence#(axi_stream_item);
  virtual task body();
    `uvm_do_with(req, {
      tdata == 32'hDEADBEEF;
      tlast == 1;
    })
  endtask
endclass
```

@coverage: transfer_size
@bins: single[1], short[2:4], medium[5:16], long[17:64]

@interface: axi_stream_if
@signals:
  - tdata[31:0]: output: Transfer data
  - tvalid: output: Data valid
  - tready: input: Ready for data
  - tlast: output: Last transfer
```

### 7.2 Promark Parsing

```python
def parse_promark(content):
    sections = {
        'metadata': {},
        'sequences': [],
        'signals': [],
        'coverage': []
    }
    
    # Parse annotations
    annotations = re.findall(r'@(\w+):\s*([^\n]+)', content)
    for key, value in annotations:
        if key in ['protocol', 'methodology', 'version']:
            sections['metadata'][key] = value
    
    # Parse annotated sequences
    seq_pattern = r'@sequence:\s*(\w+)([\s\S]*?)(?=@sequence|@interface|@coverage|$)'
    sequences = re.findall(seq_pattern, content)
    
    for name, seq_content in sequences:
        sequence = parse_annotated_sequence(name, seq_content)
        sections['sequences'].append(sequence)
    
    return sections
```

## 8. Document Validation

### 8.1 Validation Rules

```python
def validate_document(parsed_doc):
    errors = []
    warnings = []
    
    # Required sections
    required_sections = ['test_overview', 'sequences', 'signals']
    for section in required_sections:
        if section not in parsed_doc or not parsed_doc[section]:
            errors.append(f"Missing required section: {section}")
    
    # Sequence validation
    for seq in parsed_doc.get('sequences', []):
        if not seq.get('name'):
            errors.append("Sequence missing name")
        if not seq.get('signals_used'):
            warnings.append(f"Sequence '{seq.get('name')}' has no signals defined")
    
    # Signal validation
    for interface in parsed_doc.get('signals', []):
        for signal in interface.get('signals', []):
            if not signal.get('name') or not signal.get('direction'):
                errors.append("Signal missing name or direction")
    
    return {'errors': errors, 'warnings': warnings}
```

### 8.2 Document Quality Scoring

```python
def score_document_quality(parsed_doc):
    score = 0
    max_score = 100
    
    # Completeness (40 points)
    required_sections = ['test_overview', 'sequences', 'signals', 'coverage']
    score += (len([s for s in required_sections if s in parsed_doc]) / len(required_sections)) * 40
    
    # Detail level (30 points)
    if parsed_doc.get('sequences'):
        detailed_sequences = [s for s in parsed_doc['sequences'] if s.get('implementation')]
        score += (len(detailed_sequences) / len(parsed_doc['sequences'])) * 15
    
    if parsed_doc.get('signals'):
        detailed_signals = [s for iface in parsed_doc['signals'] for s in iface.get('signals', []) if s.get('description')]
        total_signals = sum(len(iface.get('signals', [])) for iface in parsed_doc['signals'])
        if total_signals > 0:
            score += (len(detailed_signals) / total_signals) * 15
    
    # Coverage specifications (20 points)
    if parsed_doc.get('coverage'):
        score += 20
    
    # Code quality (10 points)
    if any(seq.get('implementation') for seq in parsed_doc.get('sequences', [])):
        score += 10
    
    return min(score, max_score)
```

## 9. Common Document Issues

### 9.1 Parsing Challenges

**Inconsistent Formatting**:
- Mixed heading styles (`#` vs `##` vs bold text)
- Inconsistent table formats
- Mixed code block delimiters

**Missing Information**:
- Signal directions not specified
- Sequence parameters missing
- Coverage targets undefined

**Ambiguous Specifications**:
- Unclear signal relationships
- Vague sequence descriptions
- Conflicting requirements

### 9.2 Resolution Strategies

```python
def resolve_document_issues(parsed_doc, issues):
    resolved_doc = parsed_doc.copy()
    
    for issue in issues:
        if issue['type'] == 'missing_signal_direction':
            # Infer direction from signal name patterns
            signal = issue['signal']
            if any(pattern in signal['name'].lower() for pattern in ['clk', 'clock']):
                signal['direction'] = 'input'
            elif any(pattern in signal['name'].lower() for pattern in ['rst', 'reset']):
                signal['direction'] = 'input'
            elif signal['name'].endswith('_o'):
                signal['direction'] = 'output'
            elif signal['name'].endswith('_i'):
                signal['direction'] = 'input'
        
        elif issue['type'] == 'missing_sequence_type':
            # Infer type from implementation
            sequence = issue['sequence']
            if 'randomize' in sequence.get('implementation', ''):
                sequence['type'] = 'random'
            elif 'constraint' in sequence.get('implementation', ''):
                sequence['type'] = 'constrained'
            else:
                sequence['type'] = 'directed'
    
    return resolved_doc
```

## Best Practices

1. **Consistent Structure**: Use standardized section headers and formatting
2. **Complete Information**: Include all required fields for sequences and signals
3. **Clear Descriptions**: Provide detailed descriptions for all components
4. **Code Examples**: Include SystemVerilog implementation examples
5. **Validation**: Validate documents before processing
6. **Version Control**: Track document versions and changes

---

*Next: [07-build-and-execution.md](07-build-and-execution.md) - Learn about build system integration and execution workflows*