# Synchronous FIFO Validation Test Plan

## 1. Overview

This document outlines the validation strategy for a synchronous FIFO (First-In, First-Out) memory buffer. The design is written in SystemVerilog and features parameterized data width and depth, along with AXI-stream-like control signals.

**Design Document:** `fifo.sv`  
**Version:** 1.0

### 1.1. Scope

This test plan covers the functional verification of the FIFO module. It includes testing of all input/output signals, internal storage, status flags, and corner cases.

### 1.2. Reference Documents

*   `fifo.sv`: RTL design file.

## 2. Features to be Validated

The following is a list of key features that will be verified:

*   **F1: Reset Behavior:** Verification of the FIFO's state after a reset.
*   **F2: Basic Write Operation:** Correctly writing data to the FIFO.
*   **F3: Basic Read Operation:** Correctly reading data from the FIFO.
*   **F4: Full Condition:** Correct assertion of the `full` and `almost_full` flags.
*   **F5: Empty Condition:** Correct assertion of the `empty` and `almost_empty` flags.
*   **F6: Simultaneous Write and Read:** Correct behavior when write and read operations occur in the same clock cycle.
*   **F7: Data Integrity:** Ensuring that data read from the FIFO is identical to the data that was written.
*   **F8: Pointer Wrapping:** Correct wrapping of write and read pointers when they reach the end of the memory buffer.
*   **F9: Parameterization:** Verification of FIFO functionality with different `DATA_WIDTH` and `DEPTH` parameters.

## 3. Verification Environment

The verification environment will be a standard UVM-based testbench.

*   **Sequencer:** Generates sequences of write and read transactions.
*   **Driver:** Drives the FIFO's input signals (`w_data`, `w_en`, `r_en`, `clk`, `rst_n`).
*   **Monitor:** Samples the FIFO's input and output signals to capture transactions.
*   **Scoreboard:** Checks for data integrity by comparing data written to data read.
*   **Coverage Collectors:** Collect functional and code coverage.

## 4. Test Cases

### 4.1. `test_reset`

*   **Description:** Verify the state of the FIFO immediately after a reset.
*   **Stimulus:**
    1.  Apply reset (`rst_n` = 0) for several clock cycles.
    2.  De-assert reset (`rst_n` = 1).
*   **Expected Results:**
    *   `w_ptr`, `r_ptr`, and `item_count` should be 0.
    *   `empty` flag should be asserted (1).
    *   `full` flag should be de-asserted (0).
    *   `almost_empty` should be asserted (1).
    *   `almost_full` should be de-asserted (0).

### 4.2. `test_write_to_full`

*   **Description:** Write data to the FIFO until it is full and verify status flags.
*   **Stimulus:**
    1.  Apply reset.
    2.  Continuously drive `w_en` high with valid `w_data`.
    3.  Keep `r_en` low.
*   **Expected Results:**
    *   The FIFO should fill up sequentially.
    *   `almost_full` should assert when `item_count` reaches `AFULL_THRESH`.
    *   `full` should assert when `item_count` reaches `DEPTH`.
    *   Once full, further write attempts should be ignored. `w_ptr` and `item_count` should not change.

### 4.3. `test_read_from_empty`

*   **Description:** Read data from a full FIFO until it is empty and verify status flags.
*   **Stimulus:**
    1.  Fill the FIFO completely.
    2.  Continuously drive `r_en` high.
    3.  Keep `w_en` low.
*   **Expected Results:**
    *   The FIFO should empty sequentially.
    *   `almost_empty` should assert when `item_count` reaches `AEMPTY_THRESH`.
    *   `empty` should assert when `item_count` reaches 0.
    *   Once empty, further read attempts should be ignored. `r_ptr` and `item_count` should not change. The `r_data` output will be stale.

### 4.4. `test_simultaneous_wr_rd`

*   **Description:** Perform simultaneous write and read operations.
*   **Stimulus:**
    1.  Half-fill the FIFO.
    2.  Drive both `w_en` and `r_en` high for `DEPTH * 2` cycles.
*   **Expected Results:**
    *   The `item_count` should remain constant.
    *   `w_ptr` and `r_ptr` should increment and wrap around correctly.
    *   Data read out should match the data being written `DEPTH` cycles prior.

### 4.5. `test_data_integrity`

*   **Description:** Verify that the data read from the FIFO is correct.
*   **Stimulus:**
    1.  Write a random sequence of data into the FIFO.
    2.  Read all the data back out.
*   **Expected Results:**
    *   The sequence of data read out must be identical to the sequence of data written.
    *   The scoreboard should report no mismatches.

### 4.6. `test_random_ops`

*   **Description:** Apply randomized, back-to-back write and read operations.
*   **Stimulus:**
    1.  Randomize the state of `w_en` and `r_en` on every clock cycle.
    2.  Provide random `w_data` when `w_en` is high.
*   **Expected Results:**
    *   The FIFO should not overflow or underflow.
    *   All status flags should behave correctly based on the `item_count`.
    *   The scoreboard should report no data mismatches.

## 5. Coverage Plan

### 5.1. Code Coverage

*   100% statement, branch, and condition coverage.

### 5.2. Functional Coverage

*   **Pointers:**
    *   Cover `w_ptr` and `r_ptr` hitting all values from 0 to `DEPTH-1`.
    *   Cover wrapping condition for both pointers.
*   **Item Count:**
    *   Cover `item_count` hitting all values from 0 to `DEPTH`.
*   **Status Flags:**
    *   Cover transitions for `full`, `empty`, `almost_full`, `almost_empty`.
*   **Cross Coverage:**
    *   Cross `w_en`, `r_en`, `full`, `empty` to cover all valid combinations of operations and states.
    *   Example: `(w_en=1, full=0)` vs `(w_en=1, full=1)`.

---
*End of Test Plan*
