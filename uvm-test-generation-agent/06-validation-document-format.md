# Validation Document Format Guide

## Overview

This guide defines the expected format and structure for validation documents that the UVM test generation agent will parse. The agent requires properly formatted documents to extract sequences, signals, architecture, and coverage requirements. A well-structured document is critical for successful automated test generation.

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

A comprehensive validation document should be organized into the following primary sections. While the exact naming can vary, the agent will look for content corresponding to these concepts.

```markdown
# Validation Plan: [Project Name]

## 1. Overview and Scope
- **PCR Title**: [Title of the change]
- **DUT**: [Design Under Test]
- **Brief Description**: High-level summary of the project or changes.

## 2. Verification Specification (Verif A-Spec)
### 2.1 DUT Summary
[Detailed DUT description]

### 2.2 Block Diagrams
[Verification-centric block diagram, component connections]

### 2.3 Component Hierarchy
- **Environments**: Top-level and feature-specific environments.
- **BFMs**: Bus Functional Models used.
- **Scoreboards**: Description of each scoreboard's purpose and checking logic.
- **Monitors**: Description of each monitor's purpose.
- **Clock and Reset**: Clocking and reset architecture.
- **RAL Modeling**: Register Abstraction Layer strategy.

### 2.4 Test Bench Details
[DUT instantiation, memory models, UPF details]

### 2.5 Checking Strategy
[Details on scoreboards, assertions, and self-checking tests]

### 2.6 Coverage Strategy
[Functional, code, and assertion coverage goals]

## 3. Test Plan
### 3.1 Test Cases / Scenarios
[List of specific tests, their purpose, and stimulus]

### 3.2 Checklists
[Validation checklists for registers, features, errors, etc.]
```

### 2.2 Section Identification Patterns

The agent uses regular expressions to identify the key sections within the document.

```python
section_patterns = {
    'overview': [
        r'#+ .*[Oo]verview',
        r'#+ .*[Bb]rief [Dd]escription',
        r'#+ .*[Aa]ffected [Dd]atabase'
    ],
    'verification_spec': [
        r'#+ .*[Vv]erif [Aa]-[Ss]pec',
        r'#+ .*[Vv]erification [Ss]pecification'
    ],
    'component_hierarchy': [
        r'#+ .*[Cc]omponent [Hh]ierarchy'
    ],
    'test_bench': [
        r'#+ .*[Tt]est [Bb]ench'
    ],
    'checking_strategy': [
        r'#+ .*[Cc]hecking [Ss]trategy'
    ],
    'coverage': [
        r'#+ .*[Cc]overage [Ss]trategy'
    ],
    'test_plan': [
        r'#+ .*[Tt]est [Pp]lan'
    ],
    'test_cases': [
        r'#+ .*[Tt]est [Cc]ases?',
        r'#+ .*[Ss]cenarios?'
    ],
    'signals': [
        r'#+ .*[Ss]ignals?',
        r'#+ .*[Ii]nterfaces?',
        r'#+ .*[Pp]orts?'
    ]
}
```

## 3. Verification Specification Format

This section details the structure for the core verification components.

### 3.1 Component Hierarchy Format

This section is critical for understanding the testbench structure.

```markdown
## Component Hierarchy

### Environments
- **Path**: `/path/to/top_env.sv`
- **Description**: The top-level environment that integrates all other components.

### BFMs
- **`protocol_a_bfm`**: Handles Protocol A interactions.
- **`protocol_b_bfm`**: Manages Protocol B primary and sideband traffic.

### Scoreboards

#### Protocol Scoreboard
- **Description**: Responsible for checking protocol signal correctness (e.g., request/grant, valid/ready) based on transaction state.
- **Checking Logic**: Predicts expected response state based on stimulus. Confirms protocol compliance within a timing window.

| Component/Block | Busy Indicator Signal/Event   |
|-----------------|-------------------------------|
| Block A         | `block_a_active_event`        |
| Module B        | `module_b_in_progress_flag`   |
| Unit C          | `unit_c_done_event`           |

#### State Retention Scoreboard
- **Description**: Snoops save/restore transactions to a local memory model to verify state retention across low-power state transitions.

### Monitors
- **Protocol Monitor**: Monitors all primary protocol interface signals and broadcasts them via an analysis port.
- **State Monitor**: Monitors internal state signals to assist the scoreboard predictor.

### Clock and Reset
- **Description**: Details the clocking domains (e.g., `core_clk`, `io_clk`) and reset signals (`sys_rst_n`, `power_on_rst_n`) and the strategy for driving them in different operational modes.

### RAL Modeling
- **Prediction**: Explicit prediction is used for register values.
- **HDL Paths**: All register paths are checked. Exceptions are documented.
```

### 3.2 Parsing Component Hierarchy

```python
def parse_component_hierarchy(section_text):
    hierarchy = {
        'environments': extract_key_value_list(section_text, 'Environments'),
        'bfms': extract_key_value_list(section_text, 'BFMs'),
        'scoreboards': parse_scoreboard_details(section_text),
        'monitors': extract_key_value_list(section_text, 'Monitors'),
        'clock_reset': extract_description(section_text, 'Clock and Reset'),
        'ral': extract_key_value_list(section_text, 'RAL Modeling')
    }
    return hierarchy

def parse_scoreboard_details(section_text):
    scoreboards = []
    sb_pattern = r'#### ([^\n]+) Scoreboard\n([\s\S]*?)(?=####|$)'
    matches = re.findall(sb_pattern, section_text)
    
    for name, content in matches:
        scoreboard = {
            'name': name.strip(),
            'description': extract_field(content, r'\*\*Description\*\*:?\s*([^\n]+)'),
            'checking_logic': extract_field(content, r'\*\*Checking Logic\*\*:?\s*([^\n]+)'),
            'signal_table': parse_markdown_table(content)
        }
        scoreboards.append(scoreboard)
    return scoreboards
```

## 4. Test Plan Format

### 4.1 Test Case / Scenario Format

Test cases define the specific stimulus and checking for a feature.

```markdown
## Test Cases

### Test Scenario: `basic_write_read_test`

- **Objective**: Verify a basic write transaction followed by a read transaction to the same address.
- **Stimulus**:
    1. Reset the DUT.
    2. Perform a single write transaction to a valid address with a known data pattern.
    3. Perform a read transaction from the same address.
- **Checks**:
    - Verify that the write transaction is acknowledged correctly by the DUT.
    - Verify that the data read back matches the data that was written.
- **Coverage**:
    - `Covergroup: basic_transactions`: Hits `WRITE` and `READ` transaction types.
    - `Coverpoint: address_map`: Covers the specific address region used in the test.
```

### 4.2 Parsing Test Cases

```python
def parse_test_cases(section_text):
    test_cases = []
    test_pattern = r'### Test Scenario: `([^`]+)`\n([\s\S]*?)(?=### Test Scenario:|$)'
    matches = re.findall(test_pattern, section_text)
    
    for name, content in matches:
        test_case = {
            'name': name.strip(),
            'objective': extract_field(content, r'- \*\*Objective\*\*:?\s*([^\n]+)'),
            'stimulus': extract_list_items(extract_section(content, r'- \*\*Stimulus\*\*:([\s\S]*?)(?=- \*\*)')),
            'checks': extract_list_items(extract_section(content, r'- \*\*Checks\*\*:([\s\S]*?)(?=- \*\*)')),
            'coverage': extract_list_items(extract_section(content, r'- \*\*Coverage\*\*:([\s\S]*?)(?=$)'))
        }
        test_cases.append(test_case)
    
    return test_cases
```

## 5. Signal and Interface Format

Signal definitions remain critical and should be provided in clear tabular format.

### 5.1 Signal Table Format

```markdown
## Example Protocol Interface

| Signal Name | Direction | Width | Description |
|---|---|---|---|
| `proto_req`   | Input  | 1     | Request signal from the master. |
| `proto_ack`   | Output | 1     | Acknowledge signal from the slave. |
| `proto_addr`  | Input  | 32    | Address for the transaction. |
| `proto_wdata` | Input  | 64    | Write data for the transaction. |
| `proto_rdata` | Output | 64    | Read data from the transaction. |
```

### 5.2 Signal Parsing

```python
def parse_signals(section_text):
    interfaces = []
    # Matches tables under headings like "## P-Channel Interface"
    interface_pattern = r'## ([^\n]+) Interface\n([\s\S]*?)(?=##|$)'
    matches = re.findall(interface_pattern, section_text)
    
    for name, content in matches:
        interface = {
            'name': name.strip(),
            'signals': parse_markdown_table(content)
        }
        interfaces.append(interface)
    
    return interfaces

def parse_markdown_table(content):
    signals = []
    # Generic markdown table parser
    rows = re.findall(r'\| `?([^|`]+)`? \| `?([^|`]+)`? \| `?([^|`]+)`? \| `?([^|`]+)`? \|', content)
    # header_pattern: \| Signal Name \| Direction \| Width \| Description \|
    
    for name, direction, width, description in rows:
        signals.append({
            'name': name.strip(),
            'direction': direction.strip(),
            'width': width.strip(),
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

1. **Follow the Structure**: Adhere to the defined section hierarchy for reliable parsing.
2. **Use Markdown Tables**: Define signals, scoreboards, and checklists in tables.
3. **Be Specific**: Provide clear, unambiguous descriptions for test cases, checking logic, and components.
4. **Include Paths**: When possible, include file system paths to relevant environment or component files.
5. **Separate Concerns**: Keep verification specifications distinct from the test plan.
6. **Version Control**: Track document versions and changes.

---

*Next: [07-build-and-execution.md](07-build-and-execution.md) - Learn about build system integration and execution workflows*