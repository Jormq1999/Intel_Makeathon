# FIFO Test Plan

## 1. Design Under Test (DUT) Overview

### Module: `fifo`

**Parameters:**
- `DATA_WIDTH`: Width of data bus (default: 8 bits)
- `DEPTH`: Number of entries in FIFO (default: 16)
- `ADDR_WIDTH`: Address width, automatically calculated as $clog2(DEPTH)

**Ports:**

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `rst_n` | Input | 1 | Active-low asynchronous reset |
| `wr_en` | Input | 1 | Write enable signal |
| `rd_en` | Input | 1 | Read enable signal |
| `data_in` | Input | DATA_WIDTH | Data input for write operations |
| `data_out` | Output | DATA_WIDTH | Data output for read operations |
| `full` | Output | 1 | FIFO full flag (active high) |
| `empty` | Output | 1 | FIFO empty flag (active high) |

---

## 2. Test Objectives

The primary objectives of this test plan are to verify:
1. Correct FIFO functionality for write and read operations
2. Proper flag generation (full and empty)
3. Data integrity through the FIFO
4. Pointer management and wraparound behavior
5. Reset functionality
6. Corner case handling

---

## 3. Test Features and Coverage Goals

### 3.1 Functional Coverage

| Feature | Description | Priority |
|---------|-------------|----------|
| Basic Write/Read | Verify single write and read operations | High |
| Sequential Fill | Fill FIFO completely from empty to full | High |
| Sequential Drain | Drain FIFO completely from full to empty | High |
| Data Integrity | Verify written data matches read data (FIFO order) | High |
| Full Flag | Verify full flag assertion when FIFO is full | High |
| Empty Flag | Verify empty flag assertion when FIFO is empty | High |
| Simultaneous R/W | Verify concurrent read and write operations | Medium |
| Pointer Wraparound | Verify correct behavior when pointers wrap around | High |
| Reset Behavior | Verify all registers/pointers reset correctly | High |
| Overflow Protection | Verify writes are ignored when FIFO is full | High |
| Underflow Protection | Verify reads are ignored when FIFO is empty | High |

### 3.2 Code Coverage Goals
- **Line Coverage**: 100%
- **Branch Coverage**: 100%
- **Toggle Coverage**: 95%
- **FSM Coverage**: N/A (no explicit FSM)

---

## 4. Detailed Test Cases

### Test Case 1: Reset Functionality
**Objective**: Verify that reset initializes all FIFO state correctly

**Stimulus:**
1. Assert `rst_n` (active low)
2. Apply random values to inputs
3. Deassert `rst_n`

**Expected Results:**
- `empty` flag = 1
- `full` flag = 0
- `wr_ptr` = 0
- `rd_ptr` = 0
- `data_out` = 0

**Priority**: High

---

### Test Case 2: Basic Write Operation
**Objective**: Verify single write to empty FIFO

**Preconditions**: FIFO is empty after reset

**Stimulus:**
1. Set `wr_en` = 1
2. Apply test data to `data_in` (e.g., 0xAA)
3. Wait one clock cycle
4. Set `wr_en` = 0

**Expected Results:**
- `empty` flag transitions from 1 to 0
- `full` flag remains 0
- Write pointer increments by 1
- Data stored in memory location 0

**Priority**: High

---

### Test Case 3: Basic Read Operation
**Objective**: Verify single read from FIFO with one entry

**Preconditions**: FIFO has one entry (from Test Case 2)

**Stimulus:**
1. Set `rd_en` = 1
2. Wait one clock cycle
3. Check `data_out`
4. Set `rd_en` = 0

**Expected Results:**
- `data_out` = 0xAA (matches written data)
- `empty` flag transitions from 0 to 1
- `full` flag remains 0
- Read pointer increments by 1

**Priority**: High

---

### Test Case 4: Fill FIFO to Full
**Objective**: Verify FIFO can be filled completely

**Preconditions**: FIFO is empty

**Stimulus:**
1. Write DEPTH (16) unique data values sequentially
2. Keep `wr_en` = 1 for DEPTH clock cycles
3. Use incrementing data pattern (0x00, 0x01, 0x02, ..., 0x0F)

**Expected Results:**
- After 15 writes: `empty` = 0, `full` = 0
- After 16th write: `full` = 1, `empty` = 0
- All data stored in correct memory locations
- 17th write attempt should be ignored (full protection)

**Priority**: High

---

### Test Case 5: Drain FIFO to Empty
**Objective**: Verify FIFO can be drained completely

**Preconditions**: FIFO is full (from Test Case 4)

**Stimulus:**
1. Read DEPTH (16) times sequentially
2. Keep `rd_en` = 1 for DEPTH clock cycles
3. Capture all `data_out` values

**Expected Results:**
- Data read in FIFO order: 0x00, 0x01, 0x02, ..., 0x0F
- After 15 reads: `empty` = 0, `full` = 0
- After 16th read: `empty` = 1, `full` = 0
- 17th read attempt should be ignored (empty protection)

**Priority**: High

---

### Test Case 6: Data Integrity - Random Pattern
**Objective**: Verify data integrity with random data patterns

**Preconditions**: FIFO is empty

**Stimulus:**
1. Generate N random data values (where N < DEPTH)
2. Write all N values to FIFO
3. Read all N values from FIFO
4. Compare read data with written data

**Expected Results:**
- All read data matches written data in correct order
- No data corruption
- Flags behave correctly during operation

**Priority**: High

---

### Test Case 7: Simultaneous Read and Write
**Objective**: Verify concurrent read and write operations

**Preconditions**: FIFO is half full

**Stimulus:**
1. Assert both `wr_en` and `rd_en` for multiple clock cycles
2. Use different data for each write
3. Monitor both pointers and flags

**Expected Results:**
- Both operations occur in same clock cycle
- FIFO level remains constant if R/W rates equal
- Data integrity maintained
- No deadlock or race conditions

**Priority**: Medium

---

### Test Case 8: Pointer Wraparound
**Objective**: Verify correct behavior when pointers wrap around

**Preconditions**: FIFO is empty

**Stimulus:**
1. Perform DEPTH writes (fill FIFO)
2. Perform DEPTH reads (empty FIFO)
3. Perform DEPTH writes again
4. Perform DEPTH reads again
5. Repeat multiple times

**Expected Results:**
- Pointers wrap correctly using MSB for full/empty detection
- No stuck conditions
- Data integrity maintained across wraparounds
- Flags operate correctly after wraparound

**Priority**: High

---

### Test Case 9: Write to Full FIFO (Overflow Protection)
**Objective**: Verify writes are ignored when FIFO is full

**Preconditions**: FIFO is full

**Stimulus:**
1. Attempt to write new data with `wr_en` = 1
2. Monitor write pointer and memory contents
3. Attempt multiple consecutive writes

**Expected Results:**
- Write pointer does not increment
- Memory contents unchanged
- `full` flag remains asserted
- No overflow or corruption

**Priority**: High

---

### Test Case 10: Read from Empty FIFO (Underflow Protection)
**Objective**: Verify reads are ignored when FIFO is empty

**Preconditions**: FIFO is empty

**Stimulus:**
1. Attempt to read with `rd_en` = 1
2. Monitor read pointer and `data_out`
3. Attempt multiple consecutive reads

**Expected Results:**
- Read pointer does not increment
- `data_out` maintains previous value or 0
- `empty` flag remains asserted
- No underflow or corruption

**Priority**: High

---

### Test Case 11: Back-to-Back Operations
**Objective**: Verify rapid sequential writes and reads

**Preconditions**: FIFO is empty

**Stimulus:**
1. Write N values back-to-back (no idle cycles)
2. Immediately read N values back-to-back
3. Use recognizable data pattern

**Expected Results:**
- All writes succeed until full
- All reads succeed until empty
- Data ordering preserved
- No loss of data
- Flags update correctly

**Priority**: Medium

---

### Test Case 12: Partial Fill/Drain Cycles
**Objective**: Verify correct operation with partial operations

**Preconditions**: FIFO is empty

**Stimulus:**
1. Write 4 entries
2. Read 2 entries
3. Write 3 entries
4. Read 5 entries
5. Verify FIFO state after each operation

**Expected Results:**
- FIFO level tracks correctly: 0→4→2→5→0
- Flags reflect correct state at each step
- Data read in correct FIFO order
- No pointer errors

**Priority**: Medium

---

### Test Case 13: Maximum Data Values
**Objective**: Verify operation with boundary data values

**Preconditions**: FIFO is empty

**Stimulus:**
1. Write minimum value (0x00)
2. Write maximum value (0xFF for 8-bit)
3. Write alternating pattern (0xAA, 0x55)
4. Read all values back

**Expected Results:**
- All data values handled correctly
- No bit corruption
- Full data width utilized

**Priority**: Medium

---

### Test Case 14: Reset During Operation
**Objective**: Verify reset can recover FIFO from any state

**Preconditions**: Various (empty, full, half-full)

**Stimulus:**
1. Put FIFO in different states
2. Assert `rst_n` during operation
3. Verify reset behavior
4. Resume operation after reset

**Expected Results:**
- FIFO returns to reset state immediately
- All pointers reset to 0
- Flags show empty condition
- Normal operation resumes after reset

**Priority**: High

---

### Test Case 15: Stress Test
**Objective**: Verify sustained operation over extended period

**Preconditions**: FIFO is empty

**Stimulus:**
1. Randomize write and read enables
2. Run for 10,000+ clock cycles
3. Vary data patterns
4. Include all corner cases randomly

**Expected Results:**
- No hangs or deadlocks
- Data integrity maintained
- Flags always accurate
- Pointers never exceed valid range

**Priority**: Low

---

## 5. Test Environment Requirements

### 5.1 Testbench Components
- **Driver**: Generate write/read transactions
- **Monitor**: Observe DUT outputs and flag changes
- **Scoreboard**: Track expected vs. actual data
- **Coverage Collector**: Measure functional and code coverage
- **Reference Model**: Golden reference for comparison

### 5.2 Assertions
Implement the following assertions:
1. `full` and `empty` never both asserted
2. Write pointer never exceeds DEPTH
3. Read pointer never exceeds DEPTH
4. No write when `full` is asserted
5. No read when `empty` is asserted
6. `data_out` stable when not reading

### 5.3 Test Configuration
- Clock frequency: 100 MHz (10ns period)
- Reset duration: 100ns minimum
- Timeout: 10,000 cycles per test
- Parameterized configurations:
  - DATA_WIDTH: 8, 16, 32
  - DEPTH: 4, 8, 16, 32, 64

---

## 6. Pass/Fail Criteria

### Pass Criteria:
- All test cases pass
- Functional coverage > 95%
- Code coverage goals met
- No assertion failures
- No simulation errors or warnings

### Fail Criteria:
- Any test case fails
- Data corruption detected
- Assertion failures
- Coverage below targets
- Simulation hangs or crashes

---

## 7. Test Execution Plan

### Phase 1: Basic Functionality (High Priority)
- Test Cases: 1, 2, 3, 4, 5, 6

### Phase 2: Corner Cases (High Priority)
- Test Cases: 8, 9, 10, 14

### Phase 3: Advanced Features (Medium Priority)
- Test Cases: 7, 11, 12, 13

### Phase 4: Stress Testing (Low Priority)
- Test Case: 15

---

## 8. Verification Checklist

- [ ] All test cases documented
- [ ] Test environment set up
- [ ] Testbench components implemented
- [ ] Assertions coded and enabled
- [ ] Coverage model defined
- [ ] All Phase 1 tests pass
- [ ] All Phase 2 tests pass
- [ ] All Phase 3 tests pass
- [ ] Phase 4 stress test completed
- [ ] Coverage goals achieved
- [ ] No outstanding bugs
- [ ] Regression suite passes
- [ ] Test report generated

---

## 9. References
- SystemVerilog IEEE 1800-2017 Standard
- UVM 1.2 User Guide
- Project Design Specification
- FIFO RTL Design Document

---

## Document History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2025-10-25 | Test Engineer | Initial test plan |

