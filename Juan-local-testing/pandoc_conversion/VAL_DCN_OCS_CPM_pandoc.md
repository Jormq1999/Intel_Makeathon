*Document naming convention: VAL_DCN\_”PCR_Name”\_”PCR_Number”*

PCR Title: OCS CPM Refactor

PCR url:

Review State

|           |             |
|:----------|:------------|
| Owner     | Linda Chung |
| Reviewers |             |

Revision

|                     |                         |             |               |
|:--------------------|:------------------------|:------------|:--------------|
| PCR Revision Number | Val DCN Revision Number | Description | Revision Date |
|                     |                         |             |               |
|                     |                         |             |               |

# Contents

[1 Affected Database [1](#affected-database)](#affected-database)

[1.1 Areas Affected [1](#areas-affected)](#areas-affected)

[2 Brief Description of the PCR
[1](#brief-description-of-the-pcr)](#brief-description-of-the-pcr)

[3 Verif A-Spec Content Changes
[1](#verif-a-spec-content-changes)](#verif-a-spec-content-changes)

[3.1 DUT Summary [1](#dut-summary)](#dut-summary)

[3.2 Block diagram of DUT (RTL centric)
[1](#block-diagram-of-dut-rtl-centric)](#block-diagram-of-dut-rtl-centric)

[3.3 Block diagram (Verification centric)
[1](#block-diagram-verification-centric)](#block-diagram-verification-centric)

[3.4 Dimensions of configurability for DUT
[1](#dimensions-of-configurability-for-dut)](#dimensions-of-configurability-for-dut)

[3.4.1 Objective: [1](#objective)](#objective)

[3.4.2 Flow [1](#flow)](#flow)

[3.5 Verification area of focus
[1](#verification-area-of-focus)](#verification-area-of-focus)

[3.6 Component Hierarchy
[1](#component-hierarchy)](#component-hierarchy)

[3.6.1 Features’ Environments
[1](#features-environments)](#features-environments)

[3.6.2 BFMs [1](#bfms)](#bfms)

[3.6.3 Scoreboards [1](#scoreboards)](#scoreboards)

[3.6.4 Monitors [1](#monitors)](#monitors)

[3.6.5 Clock and Reset [1](#clock-and-reset)](#clock-and-reset)

[3.6.6 RAL modeling [1](#ral-modeling)](#ral-modeling)

[3.7 Test Bench [1](#test-bench)](#test-bench)

[3.8 Test Island [1](#test-island)](#test-island)

[3.9 Abstraction Layers [1](#abstraction-layers)](#abstraction-layers)

[3.10 Stimulus Randomness Control
[1](#stimulus-randomness-control)](#stimulus-randomness-control)

[3.11 Checking Control [1](#checking-control)](#checking-control)

[3.12 Checking strategy [1](#checking-strategy)](#checking-strategy)

[3.12.1 Scoreboard [1](#scoreboard)](#scoreboard)

[3.12.2 Assertions [1](#assertions)](#assertions)

[3.12.3 Test-based self-checking
[1](#test-based-self-checking)](#test-based-self-checking)

[3.12.4 Compliance monitors checking
[1](#compliance-monitors-checking)](#compliance-monitors-checking)

[3.12.5 Register checking [1](#register-checking)](#register-checking)

[3.13 Coverage Strategy [1](#coverage-strategy)](#coverage-strategy)

[3.14 Exceptions to the Published Coding Guidelines
[1](#exceptions-to-the-published-coding-guidelines)](#exceptions-to-the-published-coding-guidelines)

[3.15 Development Process
[1](#development-process)](#development-process)

[3.16 External dependencies
[1](#external-dependencies)](#external-dependencies)

[3.17 Directory Structure
[1](#directory-structure)](#directory-structure)

[3.18 Flows / Ladder diagrams / pseudocode
[1](#flows-ladder-diagrams-pseudocode)](#flows-ladder-diagrams-pseudocode)

[3.18.1 HECI Host sending message to CSE flow
[1](#heci-host-sending-message-to-cse-flow)](#heci-host-sending-message-to-cse-flow)

[4 Test Plan Content Changes
[1](#test-plan-content-changes)](#test-plan-content-changes)

[4.1 Test Cases [1](#test-cases)](#test-cases)

[4.1.1 Test Scenario *\<Name of the test that covers this test scenario
– Name to match Unix environment test name\>*
[1](#_Toc162271507)](#_Toc162271507)

[4.1.2 Test Scenario *\<Name of the test that covers this test scenario
– Name to match Unix environment test name\>*
[1](#_Toc162271508)](#_Toc162271508)

[4.2 Checklist [1](#ocs_accessible_pg_test)](#ocs_accessible_pg_test)

[4.2.1 Register Validation
[1](#register-validation)](#register-validation)

[4.2.2 Feature Vs. Flow Matrix
[1](#feature-vs.-flow-matrix)](#feature-vs.-flow-matrix)

[4.2.3 Feature Vs. Feature Matrix
[1](#feature-vs.-feature-matrix)](#feature-vs.-feature-matrix)

[4.2.4 Error Scenarios [1](#error-scenarios)](#error-scenarios)

[4.2.5 Fuse and Soft straps
[1](#fuse-and-soft-straps)](#fuse-and-soft-straps)

[4.2.6 DFX and VISA [1](#dfx-and-visa)](#dfx-and-visa)

[4.2.7 Ad hoc Signals [1](#ad-hoc-signals)](#ad-hoc-signals)

[4.2.8 Power Flows [1](#power-flows)](#power-flows)

[4.2.9 Reset Flows [1](#reset-flows)](#reset-flows)

[4.2.10 Performance Measurement
[1](#performance-measurement)](#performance-measurement)

[4.2.11 Clock Frequency coverage
[1](#clock-frequency-coverage)](#clock-frequency-coverage)

[4.2.12 Coverage on multi iteration of scenario/feature/flow
[1](#coverage-on-multi-iteration-of-scenariofeatureflow)](#coverage-on-multi-iteration-of-scenariofeatureflow)

[4.2.13 Misc. [1](#misc.)](#misc.)

[4.2.14 ValPlan AI checklist
[1](#valplan-ai-checklist)](#valplan-ai-checklist)

[5 Security Test Plan Content Changes
[1](#security-test-plan-content-changes)](#security-test-plan-content-changes)

[5.1 S3 for SDLe Tool [1](#s3-for-sdle-tool)](#s3-for-sdle-tool)

[5.1.1 \<SKS engine\> [1](#sks-engine)](#sks-engine)

[5.1.2 Validation report that Captures Security Verification Result
[1](#validation-report-that-captures-security-verification-result)](#validation-report-that-captures-security-verification-result)

[5.1.3 \<HCU DMA\> [1](#hcu-dma)](#hcu-dma)

[5.1.4 Security and Validation Plan
[1](#security-and-validation-plan-1)](#security-and-validation-plan-1)

[5.1.5 Validation report that Captures Security Verification Result
[1](#validation-report-that-captures-security-verification-result-1)](#validation-report-that-captures-security-verification-result-1)

[5.1.6 Multiple Area [1](#multiple-area)](#multiple-area)

[5.1.7 Security and Validation Plan
[1](#security-and-validation-plan-2)](#security-and-validation-plan-2)

[5.1.8 Validation report that Captures Security Verification Result
[1](#validation-report-that-captures-security-verification-result-2)](#validation-report-that-captures-security-verification-result-2)

[5.2 Additional Consideration for Security Assets not covered in S3
[1](#additional-consideration-for-security-assets-not-covered-in-s3)](#additional-consideration-for-security-assets-not-covered-in-s3)

[5.2.1 PUF Key [1](#puf-key)](#puf-key)

[5.3 Additional Consideration for Security Checks not covered in S3
[1](#additional-consideration-for-security-checks-not-covered-in-s3)](#additional-consideration-for-security-checks-not-covered-in-s3)

[5.3.1 Unused byte lane [1](#unused-byte-lane)](#unused-byte-lane)

[6 Appendix [1](#appendix)](#appendix)

[6.1 Implementation Notes
[1](#implementation-notes)](#implementation-notes)

[6.2 Bottoms up Effort [1](#bottoms-up-effort)](#bottoms-up-effort)

[6.3 Process on how to update the val dcn document?
[1](#process-on-how-to-update-the-val-dcn-document)](#process-on-how-to-update-the-val-dcn-document)

# Affected Database

## Areas Affected 

OCS

# Brief Description of the PCR

Develop standalone essential block to interact with CSE IPs including
OCS. Essential block is responsible for the power states, clocks and
resets. The goal is to have CSE_TOP as integration testing and all the
CSE IPs can fully validate functionality including power transitions.
Most of OCS features does not get affect with power transitioning. For
example, DMA will gracefully end before OCS accept the power transition.
However, selftest and PUF have state retention and save and restore
registers that will get affected from power states. OCS can only accept
the power transition and not deny. As for validation, we will have focus
tests for power transition along with each feature cross with different
power states.

# Verif A-Spec Content Changes

## DUT Summary

## Block diagram of DUT (RTL centric)

<img src="media/image1.emf" style="width:6.5in;height:6.30018in" />

Below is the diagram of the state transition mapped out through Pstate
taken from the Essential Refactor Cluster Aspec 0p5 document.

<img src="media/image2.emf" style="width:6.5in;height:6.24716in" />

PSTATE description and valid response but OCS can only accept all
PSTATE:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 36%" />
<col style="width: 29%" />
<col style="width: 12%" />
</colgroup>
<thead>
<tr>
<th><strong>PSTATE</strong></th>
<th><strong>State Description</strong></th>
<th><strong>Transition Actions</strong></th>
<th><strong>Valid Device Response</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>OFF</strong></td>
<td><p>Off State.</p>
<p>Security Engine is non-operational in an IP Inaccessible state
(either cold/global reset, InAcc PG, or VNN Removal after Accessible PG
occurred)</p>
<p>PACTIVE_*WAKEs from devices may be ignored</p>
<p>This is the default state of the subsystem</p></td>
<td><p>Request all devices to continue locking the external
interface.</p>
<p>During P_REQUEST window, all devices must turn off their SRAM, enable
their CFI ISM to enter IDLE state, and then accept this PREQ.</p></td>
<td>Accept only</td>
</tr>
<tr>
<td><strong>ACTV</strong></td>
<td><p>Active State.</p>
<p>This is the normal operational state of the subsystem. The CFI ISMs
will never be idle, all SRAMs are powered on, and external interfaces
are unlocked (barring specific flows/configurations)</p></td>
<td>During P_REQUEST window, all devices must prevent their CFI ISM to
enter IDLE and then accept the PREQ.</td>
<td>Accept only</td>
</tr>
<tr>
<td><strong>RESTORE</strong></td>
<td><p>PG Restore</p>
<p>This is transitory state which indicates all context has been
restored and CSE is ready to resume normal operation</p></td>
<td><p>Request all devices to continue locking their external
interface.</p>
<p>During the P_COMPLETE window, devices will perform a restore
operation</p></td>
<td>Accept only</td>
</tr>
<tr>
<td><strong>ACCBLK</strong></td>
<td><p>IP-Accessible Blocking</p>
<p>All subIPs have locked their external interface and are prepared to
enter IP-Accesible PG</p>
<p>Devices are permitted to upse PACTIVE_*WAKE to initiate wake from
ACCBLK and return to ACTV</p></td>
<td>Request all devices to lock external interfaces. LMT does not need
to be in the C2 state. Devices are permitted to decline this PREQ if
they are unable to lock external interfaces immediately</td>
<td><p>Accept or</p>
<p>Deny</p></td>
</tr>
<tr>
<td><strong>ACCPG</strong></td>
<td><p>IP-Accessible PG</p>
<p>CSE is committed to entering IP-Accessible PG</p></td>
<td><p>Request all devices to continue locking the external
interface.</p>
<p>All devices must save their context into HW Save and Restore Buffer,
turning off their SRAM, enable their CFI ISM enter IDLE state, and then
accept this PREQ.</p>
<p>Device is permitted to issue PACTIVE_*WAKE to request Essential to
exit from ACCPG immediately.</p></td>
<td>Accept only</td>
</tr>
<tr>
<td><strong>INACCBLK</strong></td>
<td><p>IP-Inaccessible Blocking</p>
<p>Upon reaching this state, all subIPs have locked their external
interface and are prepared to enter IP-Accesible PG</p>
<p>Devices are permitted to upse PACTIVE_*WAKE to initiate wake from
ACCBLK and return to ACTV</p></td>
<td><p>Request all devices to continue locking the external
interface.</p>
<p>All devices must save their context into HW Save and Restore Buffer,
turning off their SRAM, enable their CFI ISM enter IDLE state, and then
accept this PREQ.</p>
<p>PACTIVE_*WAKE from devices will be ignored</p></td>
<td><p>Accept or</p>
<p>Deny</p></td>
</tr>
<tr>
<td><strong>WRMRSTSRMOFF</strong></td>
<td><p>Warm Reset w/SRAM Off</p>
<p>Subsystem is prepared to enter Warm Reset. Device external interface
remains locked, their CFI ISM is enabled to enter IDLE, and their SRAM
is powered OFF.</p></td>
<td><p>Request all devices to continue locking the external
interface</p>
<p>All devices must turn off their SRAM, enable their CFI ISM to enter
IDLE state, and then accept this PREQ.</p>
<p>The PACTIVE_*WAKE from devcies will be ignored.</p></td>
<td>Accept only</td>
</tr>
<tr>
<td><strong>WRMRSTSRMON</strong></td>
<td><p>Warm Reset w/SRAM On</p>
<p>Subsystem is prepared to enter Warm Reset. Device external interface
remains locked, their CFI ISM is enabled to enter IDLE, but their SRAM
must remain powered ON.</p></td>
<td><p>Request all devices to continue locking the external
interface</p>
<p>All devices must turn off their SRAM, enable their CFI ISM to enter
IDLE state, and then accept this PREQ.</p>
<p>The PACTIVE_*WAKE from devcies will be ignored.</p></td>
<td>Accept only</td>
</tr>
<tr>
<td><strong>GLBLK</strong></td>
<td><p>Global Blocking</p>
<p>All subIPs have locked their external interface. LMT is in C2 state.
Subsystem is preprared to enter TCG state.</p></td>
<td><p>Request all devices to lock external interface and have LMT in C2
state. Devices are permitted to decline this PREQ, if they are unable to
lock external interface or have LMT in C2 state.</p>
<p>Once Device accepted the PREQ, they are permitted to use
PACTIVE_*WAKE to initiate a wake from GLBLK.</p></td>
<td><p>Accept or</p>
<p>Deny</p></td>
</tr>
<tr>
<td><strong>TCG</strong></td>
<td><p>Func Clock Trunk Clock Gating (TCG)</p>
<p>Subsystem has deasserted the slowfast_clkreq to SOC, thus
fast/slow_clk may be turned off at the trunk level. All devices continue
to lock their external interface, LMT remains in C2 state.</p></td>
<td><p>Request all devices to continue locking external interface and
have LMT in C2 state. Devices with stepping stone logic to manage the
synchronous fast/slow_clk crossing must disable it at this time.</p>
<p>Once Device accepted the PREQ, they are permitted to use
PACTIVE_*WAKE to initiate a wake from TCG.</p></td>
<td>Accept only</td>
</tr>
<tr>
<td><strong>TCGEXITPREP</strong></td>
<td><p>TCG Exit Prep</p>
<p>Slowfast_clkreq has been asserted and fast/slow_clk is running.</p>
<p>Any stepping stones have been re-enabled and running correctly.</p>
<p>Subsystem is ready to re-enter ACTV state.</p></td>
<td>Request all devices to continue locking external interface and have
LMT in C2 state, but to re-enable their stepping stone logic. Devices
with stepping stones shall re-enable the stepping stone in the P_REQUEST
window then accept this PREQ.</td>
<td>Accept only</td>
</tr>
<tr>
<td><strong>CSERST</strong></td>
<td><p>Device Reset Isolation</p>
<p>All subIPs have quiesed all traffic and are prepared for a CSE Reset
event (either CSE partition reset, or CSE internal reset).</p></td>
<td><p>Request all devices to stop propagating requests to internal CSE
Fabric.</p>
<p>During the P_REQUEST window, all devices must gracefully stop
propagating request to internal CSE fabric, and then accept this
PREQ.</p>
<p>Once the PREQ is de-asserted, during P_COMPLETE window, it requests
all devices to stop propagating requests to internal CSE Fabric, and
ensure that all the request from internal CSE fabric has been gracefully
terminiated or has been propagated to external interface.</p>
<p>All devices must gracefully drain all the requests from internal CSE
fabric, and then de-assert its PACCEPT</p>
<p>In summary, during P_REQUEST window, devices perform Device
Isolation, and during P_COMPLETE window, devices perform Bridge
Isolation</p></td>
<td>Accept only</td>
</tr>
</tbody>
</table>

## Block diagram (Verification centric)

<img src="media/image3.png" style="width:6.5in;height:5.15556in"
alt="A diagram of a computer program AI-generated content may be incorrect." />

## Dimensions of configurability for DUT

*Author requirement: Summarize on how your IP achieves configurable
testbench.*

*Below is an summary of “Configuring a Test Environment” section from
UVM cookbook with an example from cse sub-ip.*

### Objective:

*One of the key tenets of designing reusable testbenches is to make
testbenches as configurable as possible. Doing this means that the
testbench and its constituent parts can easily be reused and quickly
modified* *(i.e. reconfigured) according to the DUT. This is achieved by
following below steps.*

*For more information on Testbench Configuration and code examples,
refer to “Configuring a Test Environment” chapter in UVM cookbook
(<https://verificationacademy.com/cookbook/uvm>)
(verificationacademy.com Account may need to be created to access the
cookbook)*

### Flow

*Below process flow* *illustrates on how DUT configuration values are
retrieved, stored, and distributed on the testbench side of the
environment.*

1.  *“Parameter package” contains named parameters with associated
    values to be shared by both the HDL/DUT side and testbench side of
    the environment.*

*Example: /subBlock/cse/units/cse/cfmia/ace/lib/csme_mtl_s/cfmia.json*

2.  *Class based configuration object is implemented using Template
    Toolkit to encapsulate all related configuration variables for a
    DUT. configuration object variable values are retrieved using
    hierarchy reference to parameter package.*

*Example:
/subBlock/cse/units/cse/cfmia/validation/cfmia/testbench/templates/cfmia_cfg.sv.template*

3.  *Test makes an instance of the configuration object and passes it on
    to the environment class.*

4.  *Any object or component that has a handle to the environment class
    can access the variables and methods in the configuration object.*

## Verification area of focus

## Component Hierarchy

*Author requirement: Include path (file system path), and overview of
parent environment. Include main components instantiated such as:*

- *Features’ environments*

- *BFMs*

- *List of all scoreboards along a brief description*

- *List of all monitors along a brief description*

- *Clock and reset modeling architecture*

*Also include a path and overview on base test. Include main common
components such as background traffic generator(s).*

### Features’ Environments

*Author requirement: Include list of any features’ environments
instantiated in the main IP env.*

### BFMs

*Author requirement: Include list of BFMs used in your IP. Include any
treatment in your environment to switch between different ones, if
applicable.*

### Scoreboards

P-channel scoreboard is responsible for checking the pactive signal
correctness. The actual pactive signal is taken from the P-channel
monitor which is monitoring the RTL DUT signals. The expected will be
generated based on the idleness of each engine. Table below shows the
event variable that can be used to indicate that the engines are busy
and this includes the OCP fabric which has registers transcaction. If
OCS is busy, then PACTIVE.PACTIVE_FUNC should be 1. Scoreboard will not
be clock cycle accuracy. There will be some buffer and the checking will
confirm that it is correct within that window.

| **OCS Engine** | **Indicator used to know if it is busy** |
|----|----|
| DMA (AES_A, AES_P, HCU, GPDMA, RC4 ) | dma_on_e and dma_off_e event detected for each DMA |
| SKS |  |
| EAU | eau_on_e and eau_off_e event detected |
| ECC | ecc_on_e and ecc_off_e event detected |
| XMSS/LMS | xmss_active variable |
| TRNG |  |
| PUF | ?? waiting for RTL to generate puf key to indicate puf is done (puf_key_valid_e) |
| SELF_TEST | ?? scoreboard does not calculate if it is done or not though |

Purpose of the scoreboard to confirm that the PACTIVE.PACTIVE_FUNC is
set correctly and predict whether or not the RTL will send the PACCEPT
or PDENY. PDENY is only valid for GLBLK, ACCBLK, and INACCBLK state.

<table>
<colgroup>
<col style="width: 24%" />
<col style="width: 10%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr>
<th colspan="3"><strong>Device Activity Indicator</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>PACTIVE[6:0]</td>
<td>D2E</td>
<td><p>Each bit of PACTIVE indicates something regarding the activity of
the device. Bits 0 and 1 are asynchronous wake events. Bits 2 through 6
indicate transactions pending/ongoing activity in a given clock domain.
For bits 2 through 6, if device does not contain logic in that clock
domain, the device shall tie that bit to 1’b0.</p>
<p><u>6: PACTIVE_PRIVEPSIDE</u> - Device's hint to indicate there is a
transaction pending in priv_side_clk domain. This signal is synchronous
to priv_side_clk domain.</p>
<p><u>5: PACTIVE_LLEPSIDE</u> - Device's hint to indicate there is a
transaction pending in llep_side_clk domain. This signal is synchronous
to llep_side_clk domain.</p>
<p><u>4: PACTIVE_GPSIDE</u> - Device's hint to indicate there is a
transaction pending in side_clk domain. This signal is synchronous to
side_clk domain.</p>
<p><u>3: PACTIVE_PRIM</u> - Device's hint to indicate there is a
transaction pending in prim_clk domain. This signal is synchronous to
prim_clk domain.</p>
<p><mark><u>2: PACTIVE_FUNC</u> - Device's hint to indicate there is a
transaction pending in fast/slow_clk domain. This signal is synchronous
to slow_clk domain.</mark></p>
<p><u>1: PACTIVE_SPURIOUS_WAKE</u> – Device’s request to exit from low
power state caused by a Spurious Wake source (see <a
href="https://docs.intel.com/documents/Security_IP/HAS/COMMON/IP%20HAS%20Chapters/ChapCSME02%20CSE/ChapCSME02%20CSE.html#spurious-power-wake-handling">HAS</a>).
This signal can be asserted asynchronously, even when the clock is not
running. Once asserted, it needs to remain asserted until CSE is in the
OFF, ACTV, or TCGEXITPREP states.</p>
<p><u>0: PACTIVE_FW_WAKE</u> - Device's request to exit from low power
state caused by a FW Power Wake source (see <a
href="https://docs.intel.com/documents/Security_IP/HAS/COMMON/IP%20HAS%20Chapters/ChapCSME02%20CSE/ChapCSME02%20CSE.html#spurious-power-wake-handling">HAS</a>).
This signal can be asserted asynchronusly, even when the clock is not
running. Once asserted, it need to remain asserted until CSE is in the
OFF, ACTV, or TCGEXITPREP states.</p></td>
</tr>
</tbody>
</table>

Scoreboard to log the timeout signal assertion/deassertion timestamp.
When a REQ comes in and the timestamp is within the timeout signal then
expect a PACCEPT and not a PDENY. If the REQ is outside the timeout
signal range, then clear out the timeout_info variable.

Associated Array: timeout_info = \[“assert” : timestamp, “deassert” :
timestamp\]

For existing scoreboard, PUF and selftest scoreboard needs to be
enhanced to understand the PSTATE transition. Selftest scoreboard needs
to store the register values that are state retained and when there is a
power transition to ACCPG, then add a check to make sure particular
fields are correct upon exiting of ACCPG and going back to ACTV.
Previously, this is done at CSE_TOP with a focus test. Now, the
retention is done at OCS level because OCS will have its own UPF. Also,
need to do those field for save and restore flow.

As for PUF scoreboard, we need to make sure the PUF key is always
retained through all power flow because the key is store in the AON
domain.

The save and restore scoreboard will need to save the content when RTL
issues the save write requests and restore the content when it sees RTL
issues the restore read requests. RTL will set the address it wants to
write/read to and the scoreboard will create a snoop memory area to keep
track of all those transactions in order to reply to the read requests
RTL issue during RESTORE state. The content will get used for functional
testing as well. For example, selftest indicators that decide if
selftest will rerun, pass, or fail.

### Monitors

P-channel monitor monitors all p-channel interface siganls and broadcast
them through analysis port.

We will be using the IOSF BFM export port to monitor downstream/upstream
traffic in order to validate the pactive signal

Save and restore monitor monitors all its interface signals to create a
save and restore snoop memory for the predictor in the scoreboard and
drive the input signals to DUT.

### Clock and Reset

*Author requirement: Include description on how your IP models clocks
and reset. Additionally, the author is recommended to detail here, the
strategy used to send reset information to components such as
scoreboards, to aid in accurate reference-modeling of the DUT.*

Drive side_rst (used for factory signing driven before cse_rst and for
all beside TCG and cserst) and powergood_rst (only in OFF stage)
accordingly. Same as baseline and driven at TOP level (find out which
configurations)

Factory signing with side reset with FW reads/writes through APB but it
depends on Dfx so the testing is still within TOP level.

### RAL modeling

*Author requirement:*

- *Describe implementation choice of implicit prediction or explicit
  prediction.*

- *Treatment of /V and lock attributes, etc.*

- *HDL paths checking, including documentation of each exception case.*

## Test Bench

*Author requirement: Include path to tb file, in which DUT is
instantiated. Also include memory model if any. Describe UPF switching
DUT instantiating hierarchy, if applicable. Describe the collection of
tied-off signals with justification.*

There is no special UPF validation beside testbench driving the pfet and
other signals to connect UPF correctly. UPF is used for state retention
and we will validate the registers through testing and scoreboard for
selftest.

Create clocking block for all the save and restore signals within the
interface file. Drive the output signals within the test island through
always_comb block.

## Test Island

Include P-Channel interface to add in test island and rename the reset
and clock signal.

<table>
<colgroup>
<col style="width: 29%" />
<col style="width: 16%" />
<col style="width: 54%" />
</colgroup>
<thead>
<tr>
<th><strong>Signal Name</strong></th>
<th><strong>Direction</strong></th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>slow_vnnpgd_gclk </td>
<td>Input</td>
<td>Vnnpg version of slow clock </td>
</tr>
<tr>
<td>cse_rst_vnnpgd_slow_b </td>
<td>Input</td>
<td>Vnnpgd version cse reset </td>
</tr>
<tr>
<td>cse_side_rst_b</td>
<td>Input</td>
<td></td>
</tr>
<tr>
<td>powergood_rst_b</td>
<td>Input</td>
<td></td>
</tr>
<tr>
<td>ess_ocs_pchnl_pstate[M-1:0] </td>
<td>Intput</td>
<td>The power state to which ESS is requesting the device to transition
to</td>
</tr>
<tr>
<td>ess_ocs_pchnl_preq </td>
<td>Input</td>
<td>Active High Request to transtion to the power state indicated by
PSTATE</td>
</tr>
<tr>
<td>ocs_ess_pchnl_paccept </td>
<td>Output</td>
<td>Active High Accept of the PREQ, indicating the device will
transition to the state indicated by PSTATE</td>
</tr>
<tr>
<td>ocs_ess_pchnl_pdeny </td>
<td>Output</td>
<td>Active High Deny of the PREQ, indicating the device will not
transition to the state indicated by PSTATE, and will remain in its
current state</td>
</tr>
<tr>
<td>ocs_ess_pchnl_pactive[6:0] </td>
<td>Output</td>
<td><p>Each bit of PACTIVE indicates something regarding the activity of
the device. Bits 0 and 1 are asynchronous wake events. Bits 2 through 6
indicate transactions pending/ongoing activity in a given clock domain.
For bits 2 through 6, if device does not contain logic in that clock
domain, the device shall tie that bit to 1’b0.</p>
<p><u>6: PACTIVE_PRIVEPSIDE</u> - Device's hint to indicate there is a
transaction pending in priv_side_clk domain. This signal is synchronous
to priv_side_clk domain.</p>
<p><u>5: PACTIVE_LLEPSIDE</u> - Device's hint to indicate there is a
transaction pending in llep_side_clk domain. This signal is synchronous
to llep_side_clk domain.</p>
<p><u>4: PACTIVE_GPSIDE</u> - Device's hint to indicate there is a
transaction pending in side_clk domain. This signal is synchronous to
side_clk domain.</p>
<p><u>3: PACTIVE_PRIM</u> - Device's hint to indicate there is a
transaction pending in prim_clk domain. This signal is synchronous to
prim_clk domain.</p>
<p><u>2: PACTIVE_FUNC</u> - Device's hint to indicate there is a
transaction pending in fast/slow_clk domain. This signal is synchronous
to slow_clk domain.</p>
<p><u>1: PACTIVE_SPURIOUS_WAKE</u> – Device’s request to exit from low
power state caused by a Spurious Wake source (see <a
href="https://docs.intel.com/documents/Security_IP/HAS/COMMON/IP%20HAS%20Chapters/ChapCSME02%20CSE/ChapCSME02%20CSE.html#spurious-power-wake-handling">HAS</a>).
This signal can be asserted asynchronously, even when the clock is not
running. Once asserted, it needs to remain asserted until CSE is in the
OFF, ACTV, or TCGEXITPREP states.</p>
<p><u>0: PACTIVE_FW_WAKE</u> - Device's request to exit from low power
state caused by a FW Power Wake source (see <a
href="https://docs.intel.com/documents/Security_IP/HAS/COMMON/IP%20HAS%20Chapters/ChapCSME02%20CSE/ChapCSME02%20CSE.html#spurious-power-wake-handling">HAS</a>).
This signal can be asserted asynchronusly, even when the clock is not
running. Once asserted, it need to remain asserted until CSE is in the
OFF, ACTV, or TCGEXITPREP states.</p></td>
</tr>
<tr>
<td>ess_ocs_pchnl_timeout</td>
<td>Input</td>
<td><p>P-Channel Timeout</p>
<p>Indicates a timeout for a given flow has occurred and devices
<em>must</em> respond immediately.</p>
<p>This signal can assert prior to a PREQ being sent, with the
expectation that the device will accept in a timely fashion</p>
<p>This signal can assert after PREQ has been asserted, but before all
devices have responded. In the event that it asserts during an active
handshake, any device that has not responded must accept
immediately.</p>
<p>See section 1.4.4 for more details</p></td>
</tr>
</tbody>
</table>

Add save and restore interface to test island:

<table>
<colgroup>
<col style="width: 27%" />
<col style="width: 17%" />
<col style="width: 55%" />
</colgroup>
<thead>
<tr>
<th><strong>Signal Name</strong></th>
<th><strong>Direction</strong></th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td>ocs_gsk_snr_put</td>
<td>Out</td>
<td>SNR Command Put. Devices track an internal credit count and may only
issue an snr_put if it has credits available. Devices must decrement
their internal credit count after each snr_put.</td>
</tr>
<tr>
<td>ocs_gsk_snr_addr[9:0]</td>
<td>Out</td>
<td>SNR Address. 0-based.  Each device should start at address “0”.</td>
</tr>
<tr>
<td>ocs_gsk_snr_wxrb</td>
<td>Out</td>
<td>SNR Command Write/Read indication<br />
1- write (save)<br />
0 - read (restore)</td>
</tr>
<tr>
<td>ocs_gsk_snr_wdata[63:0]</td>
<td>Out</td>
<td>SNR Command Write Data (Save)</td>
</tr>
<tr>
<td>gsk_ocs_snr_rdata[63:0]</td>
<td>In</td>
<td><p>Read data for Restore Operation</p>
<p>Returned in order of read requests. Valid only during
snr_cpl</p></td>
</tr>
<tr>
<td>gsk_ocs_snr_rdata_cpl</td>
<td>In</td>
<td><p>Completion indicator. 1-clock valid signal (each clock valid
indicates a single completion).</p>
<p>For reads, the snr_rdata is valid in the cycle snr_cpl is
asserted.</p>
<p>For writes, it indicates the SNR has been delivered to the AON SNR
Buffer.</p>
<p>Devices must only receive a snr_cpl after issuing an snr_put. There
is a 1-to-1 relationship with snr_put and snr_cpl.</p>
<p>The snr_cpl also operates as a credit return. Devices will increment
their internal credit count upon receiving snr_cpl.</p></td>
</tr>
</tbody>
</table>

typedef enum logic \[3:0\] {

OFF = 4'h0,

ACTV = 4'h1,

RESTORE = 4'h2,

ACCBLK = 4'h3,

ACCPG = 4'h4,

INACCBLK = 4'h5,

WRMRSTSRMOFF = 4'h6,

WRMRSTSRMON = 4'h7,

GLBLK = 4'h8,

TCG = 4'h9,

TCGEXITPREP = 4'hA,

CSERST = 4'hB

} pchnl_pstate_t;

## Abstraction Layers

*Author requirement: detail, through additional sub-sections, the
available abstraction layers used within the IP environment (including
sequences.) Examples that warrant descriptions here, include the use of
Saola’s “Interrupt Manager”, “System Manager” (Saola’s memory-management
abstraction which plays the role of the C language’s malloc() and free()
APIs), “Fuse Abstraction Layer”, as well as IP-specific abstraction
layers, if any significant developments are anticipated/proposed or
already exist. The goal of this section is twofold: to provide an
overview of how the IP’s validation collaterals intend to use the
abstraction layer (such as partially, or only for one specific use-case,
or heavily in a variety of different ways, all summarized), to help
reviewers provide feedback on potential gotchas or hazards, and so on.
The other goal is to serve as general documentation to benefit new IP
team members, and to help when the IP team plans to migrate from an old
foundation (e.g. OVM) to a newer one (e.g. UVM.) Each of these
abstraction layers that are planned to be used, or are actually used,
should be described in a corresponding sub-section named after that
abstraction layer. In general, the author is reminded that abstraction
layers represent a double-edged sword: they may help in the short term,
but if not approached carefully, over the long term timeframe, reliance
on abstraction layers incur nontrivial migration and maintenance costs.
When using an abstraction, it is strongly encouraged that IP validation
collaterals should minimize their use of each abstraction, and to use
the abstraction in a way that facilitates migrating from one abstraction
implementation, to the next. Relevant examples include migrating from
Saola’s “System Manager” memory-management facilities, to UVM’s very
different facilities; similarly, Saola’s RAL to UVM’s RAL. Documenting
the strategy employed when approaching the use of such abstractions
here, helps to force the author to keep these points in mind, and to
document requirements and reasons for using such facilities.*

## Stimulus Randomness Control

*Author requirement: Include a brief table to describe how to silence
certain parts of the environment randomness. Example is a knob to guard
BFM randomization. Since some of the collaterals may have been listed in
different parts of this document, feel free to reference to the
appropriate section for the particular knob.  *

| *Knob*        | *Description*                                    |
|---------------|--------------------------------------------------|
| *pvc_rand_en* | *Turn on PVC randomization available in the BFM* |
|               |                                                  |

## Checking Control

*Author requirement: Summarize the mechanism to enable/disable various
components (i.e. scoreboards, reg predictors etc) and briefly describe
the implications of doing so. Please feel free to provide reference to
specific section within this document for the detailed description of
the component.*

*Example:*

<table style="width:100%;">
<colgroup>
<col style="width: 19%" />
<col style="width: 39%" />
<col style="width: 8%" />
<col style="width: 32%" />
</colgroup>
<thead>
<tr>
<th><em>Field name</em></th>
<th><em>Instance name</em></th>
<th><p><em>Default</em></p>
<p><em>val</em></p></th>
<th><p><em>Description</em></p>
<p><em>(Please refer to <a href="#component-hierarchy">section 7.1</a>
for further details on a specific scoreboard component)</em></p></th>
</tr>
</thead>
<tbody>
<tr>
<td><em>gsk_component_en</em></td>
<td><em>*Gsk_env.Gsk_agents_top.IntPsf2SB</em></td>
<td><em>1</em></td>
<td><em>This knob when set, enables the scoreboard that checks mIA
initiated traffic targeted to go out over sideband interface (i.e. SB
ATT, LTR). When cleared, the scoreboard is disabled.</em></td>
</tr>
<tr>
<td><em>Enable</em></td>
<td><em>*Gsk_env.spiral_env.Gsk_ebb_comparator</em></td>
<td><em>1</em></td>
<td><em>This knob when set, enables Spiral/boot-guard scoreboard. When
cleared, the scoreboard is disabled.</em></td>
</tr>
</tbody>
</table>

*Below are some examples of setting these knobs using OVM/UVM
“set_config_int” API call. The user is expected to use this API in the
build function of their respective test/top level env.*

*set_config_int("\*Gsk_env.Gsk_agents_top.IntPSF2SB","gsk_component_en",
0) //Disabling mIA🡪SB traffic scoreboarding*

*In case the user wants to disable ALL the scoreboards (this may be
needed while writing a self-checking focused test for error scenario
testing etc), below is the mechanism to achieve it (using “\*”
wildcard)*

*set_config_int("\*","gsk_component_en", 0) //Disable all gasket
scoreboards*

*  
\*Cautionary Note: The existing Gasket validation infrastructure has a
known limitation of not being able to disable a scoreboard component
completely through above mechanism, certain portions of the component
may still be active and spit out error messages. Similarly, many of the
gasket scoreboard components also perform register modeling (i.e. RAL
shadow copy update) which would <u>not</u> be impacted by disabling the
respective scoreboard. So, please be mindful to check if is this
matching your intention before updating the settings.*

## Checking strategy

Author requirement: Call attention to any internal
signals/interfaces/bridges used as observation points

### Scoreboard

> Scoreboard will be connected to the PChannel monitor and save and
> restore monitor.

### Assertions

> Write assertions to check the follow PChannel requirements:

1.  PREQ can only assert when both PACCEPT and PDENY are both deasserted

2.  PACCEPT can only assert when PREQ is asserted.

3.  PDENY can only assert when PREQ is asserted.

4.  PACCEPT and PDENY must never both be asserted at the same time

5.  PREQ can only deassert when either PACCEPT or PDENY is asserted

6.  PACCEPT and PDENY can only deassert when PREQ is deasserted.

7.  PSTATE must remain stable while PREQ is asserted

### Test-based self-checking 

> The ocs_illegal_power_flow_test will have self-checking to make sure
> that RTL always accept the PSTATE transition.

### Compliance monitors checking

> N/A

### Register checking

> N/A

## Coverage Strategy

We will collect CSpec coverage inside scoreboard. We will have coverage
for all the interface signals. There are no new register introduced from
this DCN. We need to cover all PSTATE.

## Exceptions to the Published Coding Guidelines 

## Development Process

Author requirement: Note if there is a plan to use a unit-level testing
like the vunit. Or using emacs capability to stitch top-level modules,
instead of collage. Other option is just hand-crafted with no special
tools.

## External dependencies

Author requirement: Such as libraries, Saola

## Directory Structure

## Flows / Ladder diagrams / pseudocode

Author requirement: Depict understanding of all generic flows. Example
below

### HECI Host sending message to CSE flow

The below diagram shows basic HECI Host sending message to CSE flow.

(embed Wikipedia page for ladder diagram guidelines)

![](media/image4.emf)

# Test Plan Content Changes

## Test Cases

### ocs_basic_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will transition from Cold Boot to Accessible PG Entry/Exit to
Inaccessible PG Entry/Exit</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>Fork:</p>
<ol type="i">
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
</ol></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>50% of time call init sequence to set up OCS BAR to see what
happens because OCS shouldn’t respond to this until h.</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence if it was not called in
1e.</p></li>
<li><p>Call accessible PG entry sequence (TODO: Save operation needs to
be done)</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCPG</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, assert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Random delay, assert the cse_side_rst_b</p></li>
</ol></li>
<li><p>Call accessible PG exit sequence (TODO: Check for selftest
register retention for OCS UPF testing )</p>
<ol type="a">
<li><p>Fork:</p>
<ol type="i">
<li><p>Random delay, then deassert cse_side_rst_b</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
</ol></li>
<li><p>Random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Random delay, call inaccessible PG entry sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
INACCBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
WRMRST SRM ON</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, assert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Random delay, then assert cse_side_rst_b</p></li>
</ol></li>
<li><p>Random delay, call inaccessible PG exit sequence</p>
<ol type="a">
<li><p>Fork:</p>
<ol type="i">
<li><p>Random delay, then deassert cse_side_rst_b</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
</ol></li>
<li><p>Random delay, deassert cse_rst_vnnpgd_slow_b.</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
</ol>
<p><img src="media/image5.png"
style="width:4.77108in;height:4.403in" /></p>
<p>Open: Check GSC and DMR sip variations if we have side reset.</p>
<p>Note: Side reset is on a deeper domain so it needs to be deasserted
before CSE reset and it needs to be asserted after CSE reset.</p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>N/A</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>Cover following PSTATE: OFF, ACTV, INACCBLK, WRMRST SRMON, WRMRST
SRMOFF, ACCBLK, ACCPG</p>
<p>Cover preq, paccept, and pactive signals</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_reset_isolation_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective <mark>(3<sup>rd</sup>)</mark></p>
<p>Test will transition from ACTV -&gt; CSERST -&gt;ACTV</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Reset isolation entry sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
CSERST</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, then assert cse_rstisoen_slow_b</p></li>
<li><p>Random delay, then assert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Short random delay of 2-3 clock cycle only, then deassert
cse_rstisoen_slow_b</p></li>
<li><p>Random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
</ol></li>
<li><p>Reset isolation exit sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p><mark>OPEN: how to make sure group 2 fuses are deliveried???
Check the MRA interface</mark></p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
</ol>
<p><img src="media/image6.png"
style="width:4.77108in;height:4.403in" /></p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>N/A</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>Cover following PSTATE: OFF, ACTV, CSERST</p>
<p>Cover preq, paccept</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_accessible_pg_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective <mark>(2<sup>nd</sup>)</mark></p>
<p>Test will transition from ACTV -&gt; ACCBLK -&gt;ACTV or
ACCPG-&gt;ACTV or remains in ACTV if ACCBLK gets deny</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Call accessible PG entry sequence with accblk_exit variable = 1
or 0 with even distribution and deny variable with 10% distribution</p>
<ol type="a">
<li><p>If deny ==1</p></li>
</ol></li>
</ol>
<blockquote>
<p>Fork</p>
</blockquote>
<ol type="1">
<li><p><strong>Thread 1</strong>: Issue OCS traffic</p></li>
</ol>
<blockquote>
<p>Wait for ocs_ess_pactive.pactive_func = 1</p>
</blockquote>
<ol start="2" type="1">
<li><p><strong>Thread 2</strong>: Random delay enough that
ocs_ess_pactive.pactive_func = 1, then set ess_ocs_preq = 1 and set
ess_ocs_pstate = ACCBLK.</p></li>
</ol>
<blockquote>
<p>Wait for RTL to set ocs_ess_pdeny = 1</p>
<p>Random delay, then set ess_ocs_preq = 0 and set ess_ocs_pstate =
ACTV</p>
<p>Skip Step 4 (Call accessible PG exit sequence) and test ends.</p>
</blockquote>
<ol start="2" type="a">
<li><p>Else</p>
<ol type="i">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>If accblk_exit =1,</p>
<ol type="1">
<li><p>Go to Step 4 ii then 4 c. Do not assert any resets.</p></li>
</ol></li>
</ol></li>
</ol>
<blockquote>
<p>Else if accblk_exit = 0,</p>
</blockquote>
<ol start="2" type="1">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCPG</p></li>
<li><p><em>Fork / join_any</em></p>
<ol type="a">
<li><p><em>Thread 1: RTL will trigger save write requests to GSK so
scoreboard will detect those writes and save the contents that are
getting written. Every time there is a ocs_gsk_snr_put signal, testbench
will drive gsk_ocs_snr_cpl signal with some small random clock delay.
This thread will loop forever until the other thread completes to
indicate RTL is done with saving.</em></p></li>
<li><p>Thread 2: Wait for RTL to set ocs_ess_paccept = 1</p></li>
</ol></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, assert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Random delay, assert the cse_side_rst_b</p></li>
</ol>
<ol start="4" type="1">
<li><p>Call accessible PG exit sequence</p>
<ol type="a">
<li><p>Fork:</p>
<ol type="i">
<li><p>Random delay, then deassert cse_side_rst_b if it was
asserted</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
</ol></li>
<li><p>Random delay, then deassert cse_rst_vnnpgd_slow_b if it was
asserted</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
</ol>
<p><img src="media/image7.png"
style="width:4.77108in;height:4.403in" /></p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>N/A</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>Cover following PSTATE: OFF, ACTV, ACCBLK, ACCPG</p>
<p>Cover preq, paccept, and pactive signals</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_inaccessible_pg_test 

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective <mark>(1<sup>st</sup>)</mark></p>
<p>Test will transition from ACTV -&gt; INACCBLK -&gt;ACTV or WARM* or
OFF-&gt;ACTV</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Random delay, call inaccessible PG entry sequence</p>
<ol type="a">
<li><p>If deny ==1</p></li>
</ol></li>
</ol>
<blockquote>
<p>Fork</p>
</blockquote>
<ol type="1">
<li><p><strong>Thread 1</strong>: Issue OCS traffic</p></li>
</ol>
<blockquote>
<p>Wait for ocs_ess_pactive.pactive_func =1</p>
</blockquote>
<ol start="2" type="1">
<li><p><strong>Thread 2</strong>: Random delay enough that
ocs_ess_pactive.pactive_func = 1, then set ess_ocs_preq = 1 and set
ess_ocs_pstate = INACCBLK.</p></li>
</ol>
<blockquote>
<p>Wait for RTL to set ocs_ess_pdeny = 1</p>
<p>Random delay, then set ess_ocs_preq = 0 and set ess_ocs_pstate =
ACTV</p>
<p>Skip Step 4 (call inaccessible PG exit sequence) and test ends.</p>
</blockquote>
<ol type="a">
<li><p>Else</p></li>
</ol>
<ol start="3" type="1">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
INACCBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>If inaccblk_exit =1,</p>
<ol type="I">
<li><p>Go to step 4 ii and then 4d. Do not assert any resets.</p></li>
</ol></li>
</ol>
<blockquote>
<p>Else if inaccblk_exit = 0,</p>
</blockquote>
<ol start="2" type="I">
<li><p>Case statement to pick next power state transition of WRMRST SRM
ON, WRMRST SRM OFF, or OFF. For OCS, it is all the same
functionality.</p>
<ol type="1">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
WRMRST SRM ON</p></li>
</ol></li>
</ol>
<blockquote>
<p>Wait for RTL to set ocs_ess_paccept = 1</p>
<p>Random delay, then set ess_ocs_preq = 0</p>
<p>Wait for RTL to set ocs_ess_paccept = 0</p>
<p>Random delay, assert cse_rst_vnnpgd_slow_b</p>
<p>Random delay, then assert cse_side_rst_b</p>
</blockquote>
<ol start="2" type="1">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
WRMRST SRM OFF</p></li>
</ol>
<blockquote>
<p>Wait for RTL to set ocs_ess_paccept = 1</p>
<p>Random delay, then set ess_ocs_preq = 0</p>
<p>Wait for RTL to set ocs_ess_paccept = 0</p>
<p>Random delay, assert cse_rst_vnnpgd_slow_b</p>
<p>Random delay, then assert cse_side_rst_b</p>
</blockquote>
<ol start="3" type="1">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
OFF</p></li>
</ol>
<blockquote>
<p>Wait for RTL to set ocs_ess_paccept = 1</p>
<p>Random delay, then set ess_ocs_preq = 0</p>
<p>Wait for RTL to set ocs_ess_paccept = 0</p>
<p>Random delay, assert cse_rst_vnnpgd_slow_b.</p>
<p>Random delay, then assert cse_side_rst_b</p>
<p>Random delay, then Assert the powergood_rst_b.</p>
</blockquote>
<p>(note: all reset can assert same clock cycle)</p>
<ol start="4" type="1">
<li><p>Random delay, call inaccessible PG exit sequence</p>
<ol type="a">
<li><p>Deassert powergood_rst_b if it was asserted before in the OFF
state</p></li>
<li><p>Fork:</p>
<ol type="I">
<li><p>Random delay, then deassert cse_side_rst_b</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
</ol></li>
<li><p>Random delay, deassert cse_rst_vnnpgd_slow_b.</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
</ol>
<p><img src="media/image8.png"
style="width:4.77108in;height:4.403in" /></p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>N/A</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>Cover following PSTATE: OFF, ACTV, INACCBLK, WRMRST SRMON, WRMRST
SRMOFF</p>
<p>Cover preq, paccept, and pactive signals</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_save_and_restore_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective <mark>(4<sup>th</sup>)</mark></p>
<p>Test will transition from ACTV -&gt; ACCBLK -&gt; ACCPG -&gt;
(internally park OCS IP to OFF without preq) -&gt; RESTORE -&gt;
ACTV.</p>
<p>Testbench environment needs to understand that after ACCPG,
internally PSTATE will default back to OFF state without a preq because
the reset are asserted.</p>
<p>OCS does the save during ACCPG and restore in the restore
state.</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Random delay, call accessible PG entry sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCPG</p></li>
<li><p><em>Fork / join_any</em></p>
<ul>
<li><p><em>Thread 1: RTL will trigger save write requests to GSK so
scoreboard will detect those writes and save the contents that are
getting written. Every time there is a ocs_gsk_snr_put signal, testbench
will drive gsk_ocs_snr_cpl signal with some small random clock delay.
This thread will loop forever until the other thread completes to
indicate RTL is done with saving.</em></p></li>
<li><p>Thread 2: Wait for RTL to set ocs_ess_paccept = 1</p></li>
</ul></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, assert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Random delay, assert the cse_side_rst_b</p></li>
</ol></li>
<li><p>Random delay, call restore entry sequence</p>
<ol type="a">
<li><p>Random delay, then deassert cse_side_rst_b</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
RESTORE</p></li>
<li><p>Random delay, then assert vnn_restore wire 🡨 OPEN: is this done
before the preq=1</p></li>
<li><p>Random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p><em>Fork / join_any</em></p>
<ul>
<li><p><em>Thread 1: RTL send restore read requests. Testbench drives
gsk_ocs_snr_rdata[63:0] and gsk_ocs_snr_cpl signal accordingly as when
they see a ocs_gsk_snr_put</em></p></li>
</ul></li>
</ol></li>
</ol>
<blockquote>
<p><mark>Open for check</mark>: Check the address if it’s in the right
range. Count the put and a particular address. Discuss with Bindu
further.</p>
</blockquote>
<ul>
<li><p>Thread 2:Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ul>
<ol start="8" type="a">
<li><p>Random delay, then deassert vnn_restore wire</p></li>
</ol>
<ol start="5" type="1">
<li><p>Random delay, call restore exit sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
</ol>
<p><img src="media/image9.png"
style="width:4.77108in;height:4.403in" /></p>
<p><img src="media/image10.png"
style="width:5.86119in;height:2.34028in" /></p>
<p><img src="media/image11.png"
style="width:5.86242in;height:2.97761in" /></p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>The save and restore scoreboard will make sure the restored data is
correct.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>Cover following PSTATE: OFF, ACTV, INACCBLK, RESTORE</p>
<p>Cover preq, paccept</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_save_and_restore_err_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective <mark>(4<sup>th</sup>)</mark></p>
<p>Test will transition from ACTV -&gt; ACCBLK -&gt; ACCPG -&gt;
(internally park OCS IP to OFF without preq) -&gt; RESTORE -&gt;
ACTV.</p>
<p>Testbench environment needs to understand that after ACCPG,
internally PSTATE will default back to OFF state without a preq because
the reset are asserted.</p>
<p>OCS does the save during ACCPG and restore in the restore state.
During the save, testbench will intentionally <strong>not</strong> issue
the cpl signal. 🡨 this will hang until until the cpl signal get send out
right? Colin: Yes will hang. Real system will not happen so no need
timeout concept. Bindu: move us back to ACTV after a long wait</p>
<p>During the restore, testbench will fork off two thread. Thread 1 to
generate background read data without cpl signal. Thread 2 will issue
good read data with cpl signal.</p>
<p>Open: Is there value in forcing internal credit signals to different
values?</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Random delay, call accessible PG entry sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCPG</p></li>
<li><p><em>Fork / join_any</em></p>
<ul>
<li><p><em>Thread 1: RTL will trigger save write requests to GSK so
scoreboard will detect those writes and save the contents that are
getting written. <mark>Every time there is a ocs_gsk_snr_put signal,
testbench will drive gsk_ocs_snr_cpl signal sometime</mark>. This thread
will loop forever until the other thread completes to indicate RTL is
done with saving.</em></p></li>
<li><p>Thread 2: Wait for RTL to set ocs_ess_paccept = 1</p></li>
</ul></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, assert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Random delay, assert the cse_side_rst_b</p></li>
</ol></li>
<li><p>Random delay, call restore entry sequence</p>
<ol type="a">
<li><p>Random delay, then deassert cse_side_rst_b</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
RESTORE</p></li>
<li><p>Random delay, then assert vnn_restore wire</p></li>
<li><p>Random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p><em>Fork / join_any</em></p>
<ul>
<li><p><em>Thread 1: RTL send restore read requests. Testbench drives
gsk_ocs_snr_rdata[63:0] and gsk_ocs_snr_cpl signal accordingly as when
they see a ocs_gsk_snr_put</em></p></li>
<li><p>Thread 2: Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Thread 3: Testbench drives <em>gsk_ocs_snr_rdata[63:0]</em>
without gsk_ocs_snr_cpl</p></li>
</ul></li>
<li><p>Random delay, then deassert vnn_restore wire</p></li>
</ol></li>
<li><p>Random delay, call restore exit sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
</ol>
<p><img src="media/image9.png" style="width:4.77108in;height:4.403in"
alt="A diagram of a diagram AI-generated content may be incorrect." /></p>
<p><img src="media/image10.png"
style="width:5.91667in;height:2.36243in" /></p>
<p><img src="media/image11.png" style="width:5.86242in;height:2.97761in"
alt="A screenshot of a computer AI-generated content may be incorrect." /></p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>The save and restore scoreboard will make sure the restored data is
correct.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>Cover following PSTATE: OFF, ACTV, INACCBLK, RESTORE</p>
<p>Cover preq, paccept</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_tcg_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will transition from ACTV -&gt; GLBLK -&gt;VNN - &gt;
VNNEXITPREP -&gt; ACTV</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Random delay, call global block entry sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
GLBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
TCG</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>With 90% distribution, gate the clock then random delay, enable
clock</p></li>
<li><p>Random delay, call tcg exit sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
TCGEXITPREP</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Issue DMA Traffic</p></li>
<li><p>Wait for RTL to set ocs_ess_pactive.pactive_func = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
</ol>
<p><img src="media/image12.png"
style="width:4.77108in;height:4.403in" /></p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>Cover following PSTATE: OFF, ACTV, GLBLK, VNN, VNNEXITPREP</p>
<p>Cover preq, paccept, and pactive signals</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_global_blocking_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will transition from ACTV -&gt; GLBLK -&gt; ACTV or Remains in
ACTV because GLBLK got deny</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Random delay, call global block entry sequence with deny variable
= 1 with 10% distribution</p>
<ol type="a">
<li><p>If deny ==1</p></li>
</ol></li>
</ol>
<blockquote>
<p>Fork</p>
</blockquote>
<ol type="1">
<li><p><strong>Thread 1</strong>: Issue OCS traffic</p></li>
</ol>
<blockquote>
<p>Wait for ocs_ess_pactive.pactive_func = 1</p>
</blockquote>
<ol start="2" type="1">
<li><p><strong>Thread 2</strong>: Random delay enough that
ocs_ess_pactive.pactive_func = 1, then set ess_ocs_preq = 1 and set
ess_ocs_pstate = GLBLK.</p></li>
</ol>
<blockquote>
<p>Wait for RTL to set ocs_ess_pdeny = 1</p>
<p>Random delay, then set ess_ocs_preq = 0 and set ess_ocs_pstate =
ACTV</p>
<p>Skip Step 4 and test ends.</p>
</blockquote>
<ol start="2" type="a">
<li><p>Else</p>
<ol type="I">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
GLBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Continue to Step 4</p></li>
</ol></li>
</ol>
<ol start="4" type="1">
<li><p>Random delay, call tcg exit sequence</p>
<ol type="a">
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
</ol>
<p><img src="media/image13.png"
style="width:4.77108in;height:4.403in" /></p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>N/A</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>Cover following PSTATE: OFF, ACTV, GLBLK</p>
<p>Cover preq, paccept, and pactive signals</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_pchnl_timeout_with_cserst_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out CSERST with timeout asserted</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Random delay and assert the pchnl_timeout signal. The
point it to catch the timeframe where the timeout signal is asserted
before the PREQ and during PREQ. Only deassert the pchnl_timeout once
RTL deassert ocs_ess_paccept. Deassertion of pchnl_timeout can happen
right after the first ocs_ess_paccept deassertion or multiple
ocs_ess_paccept deassertion.</p></li>
<li><p>Thread 2: Within a loop of 5 rounds and with random delay, call
the reset isolation entry and exit flow.</p></li>
</ol></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Assertions will make sure that the RTL response with PACCEPT within a
reasonable timeframe.</p></td>
</tr>
<tr>
<td>Coverage</td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_pchnl_timeout_with_accpg_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out accessible_pg with timeout asserted. Timeout can
be asserted only in ACCPG.</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Wait on pstate=ACCBLK and PREQ=1 and then 0. Issue
Random delay and assert the pchnl_timeout signal. The point it to catch
the timeframe where the timeout signal is asserted before the PREQ with
PSTATE= ACCPG and during PREQ with PSTATE= ACCPG. Deassert the
pchnl_timeout once RTL deassert ocs_ess_paccept. Deassertion of
pchnl_timeout can happen right after the first ocs_ess_paccept
deassertion or multiple ocs_ess_paccept deassertion.</p></li>
<li><p>Thread 2: Within a loop of 5 rounds and with random delay, call
the accessible_pg entry and exit sequence</p></li>
</ol></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Assertions will make sure that the RTL response with PACCEPT within a
reasonable timeframe.</p></td>
</tr>
<tr>
<td>Coverage</td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_pchnl_timeout_with_inaccpg_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out inaccessible_pg with timeout asserted. Timeout can
be asserted only during OFF, WRMRSTSRAMOFF, WRMRSTSRAMON states</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Wait on pstate=INACCBLK and PREQ=1 and then 0. Issue
Random delay and assert the pchnl_timeout signal. The point it to catch
the timeframe where the timeout signal is asserted before the PREQ with
PSTATE= OFF, WRMRSTSRAMOFF, or WRMRSTSRAMON and during PREQ with PSTATE=
OFF, WRMRSTSRAMOFF, or WRMRSTSRAMON. Deassert the pchnl_timeout once RTL
deassert ocs_ess_paccept. Deassertion of pchnl_timeout can happen right
after the first ocs_ess_paccept deassertion or multiple ocs_ess_paccept
deassertion.</p></li>
<li><p>Thread 2: Within a loop of 5 rounds and with random delay, call
the inaccessible_pg entry and exit sequence</p></li>
</ol></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Assertions will make sure that the RTL response with PACCEPT within a
reasonable timeframe.</p></td>
</tr>
<tr>
<td>Coverage</td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_ecc_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out all power flows with ECC traffic</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol start="4" type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Issue ECC traffic</p></li>
<li><p>Thread 2: Random delay, then randomly pick one of the power flow
entry and exit to get back to ACTV state (accessible pg, inaccessible
pg, save and restore, TGC, or reset isolation)</p></li>
</ol></li>
<li><p>Check to make sure all ECC registers are back to default values
for accessible/inaccessible pg/ reset isolation.</p></li>
<li><p>Issue ECC traffic again because after the fork/join, test will be
in ACTV power state</p></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p>
<p>Test will check if the ECC registers are reset back to default values
for all power transition.</p></td>
</tr>
<tr>
<td>Coverage</td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_eau_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out all power flows with EAU traffic</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Issue EAU traffic</p></li>
<li><p>Thread 2: Random delay, then randomly pick one of the power flow
entry and exit to get back to ACTV state (accessible pg, inaccessible
pg, save and restore, TGC or reset isolation)</p></li>
</ol></li>
<li><p>Check to make sure all EAU registers are back to default values
for accessible/inaccessible pg/ reset isolation.</p></li>
<li><p>Issue EAU traffic again because after the fork/join, test will be
in ACTV power state</p></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p>
<p>Test will check if the EAU registers are reset back to default values
for all power transition.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>&lt;Define CP’s that are when hit considered intent met&gt;</p>
<p>&lt;mention seeds required to hit the CP&gt;</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_sks_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out all power flows with SKS traffic</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Issue SKS traffic</p></li>
<li><p>Thread 2: Random delay, then randomly pick one of the power flow
entry and exit to get back to ACTV state (accessible pg, inaccessible
pg, save and restore, TGC or reset isolation)</p></li>
</ol></li>
<li><p>Check to make sure all SKS registers are back to default values
for accessible/inaccessible pg/ reset isolation.</p></li>
<li><p>Issue SKS traffic again because after the fork/join, test will be
in ACTV power state</p></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p>
<p>Test will check if the SKS registers are reset back to default values
for all power transition.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>&lt;Define CP’s that are when hit considered intent met&gt;</p>
<p>&lt;mention seeds required to hit the CP&gt;</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_dma_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out all power flows with DMA traffic</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Issue DMA traffic</p></li>
<li><p>Thread 2: Random delay, then randomly pick one of the power flow
entry and exit to get back to ACTV state (accessible pg, inaccessible
pg, save and restore, TGC or reset isolation)</p></li>
</ol></li>
<li><p>Check to make sure all DMA registers are back to default values
for accessible/inaccessible pg/ reset isolation.</p></li>
<li><p>Issue DMA traffic again because after the fork/join, test will be
in ACTV power state</p></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p>
<p>Test will check if the DMA registers are reset back to default values
for all power transition.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>&lt;Define CP’s that are when hit considered intent met&gt;</p>
<p>&lt;mention seeds required to hit the CP&gt;</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_trng_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out all power flows with TRNG traffic</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Issue TRNG traffic</p></li>
<li><p>Thread 2: Random delay, then randomly pick one of the power flow
entry and exit to get back to ACTV state (accessible pg, inaccessible
pg, save and restore, TGC or reset isolation)</p></li>
</ol></li>
<li><p>Check to make sure all TRNG registers are back to default values
for accessible/inaccessible pg/ reset isolation.</p></li>
<li><p>Issue TRNG traffic again because after the fork/join, test will
be in ACTV power state</p></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p>
<p>Test will check if the TRNG registers are reset back to default
values for all power transition.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>&lt;Define CP’s that are when hit considered intent met&gt;</p>
<p>&lt;mention seeds required to hit the CP&gt;</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_xmss_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out all power flows with XMSS traffic</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Fork</p>
<ol type="a">
<li><p>Thread 1: Issue XMSS traffic</p></li>
<li><p>Thread 2: Random delay, then randomly pick one of the power flow
entry and exit to get back to ACTV state (accessible pg, inaccessible
pg, save and restore, TGC or reset isolation)</p></li>
</ol></li>
<li><p>Check to make sure all XMSS registers are back to default values
for accessible/inaccessible pg/ reset isolation.</p></li>
<li><p>Issue XMSS traffic again because after the fork/join, test will
be in ACTV power state</p></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p>
<p>Test will check if the XMSS registers are reset back to default
values for all power transition.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>&lt;Define CP’s that are when hit considered intent met&gt;</p>
<p>&lt;mention seeds required to hit the CP&gt;</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_selftest_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out all power flows with selftest traffic</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>Override selftest fuse en to 1 to run selftest. Look into the
algorithm disable registers to randomize its register programming to
validate the state retention.</p></li>
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Wait for selftest to complete</p></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Random delay, then randomly pick one of the power flow entry and
exit to get back to ACTV state (accessible pg, inaccessible pg, save and
restore, TGC or reset isolation)</p></li>
<li><p>Check selftest registers. Depending on the power state, check the
state retention and save and restore registers and/or default
values.</p></li>
<li><p>For save and restore, make sure that selftest does not get rerun
and it boot up OCS again either with selftest passed or selftest
failed.</p></li>
</ol>
<p><strong>Focus on the list below for the state retention and save and
restore registers:</strong></p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_RERUN.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_PASS.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_FAIL.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_STAGE1_PASS.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_STAGE1_FAIL.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_STAGE2_PASS.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_STAGE2_FAIL.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_STAGE3_PASS.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SELFTEST_STAGE3_FAIL.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
AES_ECB_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
AES_CBC_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
AES_CTR_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
AES_CFB_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
AES_OFB_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
AES_GCM_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
AES_CCM_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
AES_CTS_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
RC4_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
MD5_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SHA1_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SHA224_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SHA256_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SHA384_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SHA512_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
HMAC_MD5_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
HMAC_1_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
HMAC_224_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
HMAC_256_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
HMAC_384_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
HMAC_512_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
DRNG_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
ECDSA_SIGN_VERIFY_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
EAU_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
EAU_SMALL_KEYSZ_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SM2_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SM3_DISABLE.set_sr(1);</p>
<p>./saola/ESEXX/self_test_regs_ESEXX_regs.svh:
SM4_DISABLE.set_sr(1);</p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p>
<p>Test will check if the selftest registers functionality.</p>
<p>Selftest scoreboard will understand the save and restore power state
and expect to skip selftest run.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>&lt;Define CP’s that are when hit considered intent met&gt;</p>
<p>&lt;mention seeds required to hit the CP&gt;</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_puf_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out all power flows with production flow PUF</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Wait for PUF key to get generated.</p></li>
<li><p>Random delay, then randomly pick one of the power flow entry and
exit to get back to ACTV state (accessible pg, inaccessible pg, save and
restore, TGC or reset isolation)</p></li>
<li><p>Check to make sure all PUF registers are back to default values
for accessible/inaccessible pg/ reset isolation. Depending on the power
flow, check that the PUF key is retained because it is stored in the AON
domain.</p></li>
</ol>
<p>Note: DO multiple resets and have to assert the puf helper data to
check if the ocs rtl completes the group 2 fuse pulling each before it
sets the paccept =0 once its ACTV state</p></td>
</tr>
<tr>
<td><p>Checking</p>
<p>Scoreboard will check if the pactive is set correctly.</p>
<p>Test will check if the PUF registers are reset back to default values
for all power transition.</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>&lt;Define CP’s that are when hit considered intent met&gt;</p>
<p>&lt;mention seeds required to hit the CP&gt;</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

### ocs_illegal_power_flow_test

<table style="width:100%;">
<colgroup>
<col style="width: 99%" />
</colgroup>
<thead>
<tr>
<th><p>Objective</p>
<p>Test will test out illegal power flow transition and expect RTL to
issue PACCEPT but not do anything and OCS is will remain in currrect
state.</p>
<p>ACTV -&gt; ACCBLK -&gt; INACCBLK -&gt;ACTV</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>Description</p>
<ol type="1">
<li><p>Boot up sequence (ocs_hard_reset_sequence)</p>
<ol type="a">
<li><p>assert cse_rst_vnnpgd_slow_b and cse_side_rst_b</p></li>
<li><p>random delay , then deassert cse_side_rst_b</p></li>
<li><p>random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACTV</p></li>
<li><p>random delay, then deassert cse_rst_vnnpgd_slow_b</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>random delay, then set ess_ocs_preq = 0</p></li>
<li><p>wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></li>
<li><p>Call ocs initialization sequence</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
ACCBLK</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
<li><p>Random delay, then set ess_ocs_preq = 1 and set ess_ocs_pstate =
INACCBLK.</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 1 🡨 ensure get paccept or
pdeny</p></li>
<li><p>Random delay, then set ess_ocs_preq = 0</p></li>
<li><p>Wait for RTL to set ocs_ess_paccept = 0</p></li>
</ol></td>
</tr>
<tr>
<td><p>Checking</p>
<p>&lt;Details on how checking will be performed for the stimulus
present; Ex: Assertions, Scoreboard Checks, Self-checking test,
etc.?&gt;</p></td>
</tr>
<tr>
<td><p>Coverage</p>
<p>&lt;Define CP’s that are when hit considered intent met&gt;</p>
<p>&lt;mention seeds required to hit the CP&gt;</p></td>
</tr>
<tr>
<td><p>Useful Resources</p>
<p>&lt;Example: Block diagrams, waves, snippets from PCR/HAS
etc.&gt;</p></td>
</tr>
</tbody>
</table>

## Checklist

### Register Validation

*The author is required and expected to comply with the Intel-wide
“Register MRC” team’s recommendations for register attribute validation.
Please refer to the website alias “goto/registers,” clicking the
“Documents” item from the right-hand frame, then “[Register Validation
Requirements](https://docs.intel.com/documents/arch_register_spec/Documents/RegisterValidationRequirements/RegisterValidationRequirements.html).”
(At some future point in time, this documentation shall be transferred
to some location within our development repository, for long-term
maintenance by our own team. While the CREST tool described in the
provided link is not required within our team, it is a requirement that
an equivalent be used.*

*\<Fill in below table for every special attribute field that is not
covered by recursive testing or automated tools\>*

*\<Field Name\>*

| Attribute | Data | Stimulus present in test | Check Name | Cover point Name |
|:--:|:--:|:--:|:--:|:--:|
| *Access type* | *\<RW/1C\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

### Feature Vs. Flow Matrix 

*\<List the test names that covers given Feature X Flow validation\>*

*\<Purpose: This table organizes high-level information facilitating the
management and tracking of individual tests which are involved in
validating the specified flows and features.\>*

*\<Fill in below table for every new feature and flow added\>*

*\<Below are few examples given; author and reviewer should agree
(pre-review) upon an appropriate list of “flows” and “features” for
treatment in a tabular fashion as depicted here. \>*

| Feature X Flow  | *\<Power Flows\>* | *\<Reset Flows\>* | *\<Clock Gating\>* |
|-----------------|-------------------|-------------------|--------------------|
| *\<Feature A\>* | *\<Test Name\>*   | *\<Test Name\>*   | *\<Test Name\>*    |
| *\<Feature B\>* | *\<Test Name\>*   | *\<Test Name\>*   | *\<Test Name\>*    |
| *\<Feature C\>* | *\<Test Name\>*   | *\<Test Name\>*   | *\<Test Name\>*    |
| *\<Feature D\>* | *\<Test Name\>*   | *\<Test Name\>*   | *\<Test Name\>*    |

### Feature Vs. Feature Matrix 

*\<List the test names that covers given Feature X Feature validation\>*

*\<Purpose: This table organizes high-level information facilitating the
management and tracking of individual tests which are involved in
validating the specified flows and features.\>*

*\<Fill in below table for every new feature and flow added\>*

*\<Below are few examples given; author and reviewer should agree
(pre-review) upon an appropriate list of “feature” and “feature” for
treatment in a tabular fashion as depicted here. \>*

| Feature X Feature | *\<Feature A\>* | *\<Feature B\>* | *\<Feature C\>* |
|-------------------|-----------------|-----------------|-----------------|
| *\<Feature A\>*   | *\<Test Name\>* | *\<Test Name\>* | *\<Test Name\>* |
| *\<Feature B\>*   | *\<Test Name\>* | *\<Test Name\>* | *\<Test Name\>* |
| *\<Feature C\>*   | *\<Test Name\>* | *\<Test Name\>* | *\<Test Name\>* |
| *\<Feature D\>*   | *\<Test Name\>* | *\<Test Name\>* | *\<Test Name\>* |

### Error Scenarios 

*\<List the test names that covers error scenario validation\>*

*\<Fill in below table for every new feature added\>*

*\<For example, things like malformed requests (e.g., requests violating
some requirement of the bus specification or IP HAS), and violations to
the IP’s programming model\>*

*\<Author and reviewer to decide on the content that can be considered
as Error Scenarios for your IP\>*

| Scenario | Stimulus present in test | Check Name | Cover point Name |
|:--:|:--:|:--:|:--:|
| *\<unsupported Cmd type\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |
| *\<unsupported length\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |
| *\< unsupported Address\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |
| *\<Spurious cmpl\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

### Fuse and Soft straps

*\<List the test names that covers given fuses/soft straps validation\>*

| Fuse/Soft Strap Name | Stimulus present in test | Check Name | Cover point Name |
|:--:|:--:|:--:|:--:|
| *\<Fuse Name\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

### DFX and VISA

*\<List the test names that covers given DFX and VISA validation\>*

| DFX/VISA Signal or Flow | Stimulus present in test | Check Name | Cover point Name |
|:--:|:--:|:--:|:--:|
| *\<Signal Name\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

### Ad hoc Signals

*\<List the test names that covers given ad hoc signal validation\>*

*\<Long Term Plan: Maintain documentation about Ad Hoc signals within
our testbench collaterals where the DUT is instantiated—imagine
embedding information there, extracted by a script, and resulting in a
text file report or a PDF file, and here we could cite that path to file
generated in the repo.\>*

| Ad hoc Signal | Stimulus present in test | Check Name | Cover point Name |
|:--:|:--:|:--:|:--:|
| *\<Signal Name\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

### Power Flows

*\<Below are few examples given, author and reviewer to decide on the
content that can be considered as power flows for your IP\>*

| Power Flow | Stimulus present in test | Check Name | Cover point Name |
|:--:|:--:|:--:|:--:|
| *\<Acc PG entry-exit\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

### Reset Flows

*\<Below are few examples given, author and reviewer to decide on the
content that can be considered as reset flows for your IP\>*

| Reset Flow | Stimulus present in test | Check Name | Cover point Name |
|:--:|:--:|:--:|:--:|
| *\<Global Reset\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |
| *\<Host Partition reset\>* | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

### Performance Measurement

*\<Add tests related to performance measurement of feature\>*

### Clock Frequency coverage

*\<Add frequencies that are covered as part of PSV validation\>*

|   Clock Name   | Frequency range covered. |
|:--------------:|:------------------------:|
| *\<cse clk\>*  |  *\< \[180-360\] MHz\>*  |
| *\<prim clk\>* |  *\< \[180-360\] MHz\>*  |

### Coverage on multi iteration of scenario/feature/flow

*\<List down the scenario/feature/flow that requires a cover point to be
written in such a way that the CP is hit only when the flows is
performed 2 times or more in the same test\>*

| Feature/Flow/Scenario | Cover Point Name |
|:---------------------:|:----------------:|
|    *\<LMT Halt\>*     |      *\<\>*      |
|                       |                  |

### Misc.

*\<Author to use one of the below options when filling the table\>*

NA – If the scenario is not applicable.

YES – Provide test name where this scenario is covered.

NO – Provide reason for “no” for not covering the scenario.

| Scenario | Stimulus present in test | Check Name | Cover point Name |
|----|:--:|:--:|:--:|
| Exhaust credits on IP interfaces (e.g., back-pressure scenarios caused by insufficient credits) | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

### ValPlan AI checklist

*\<Author to list down the valid rules generated by ValPlan AI and make
sure they are all getting validated\>*

|  |  |  |  |  |
|----|----|----|----|----|
| Section | Rule | Stimulus present in test | Check Name | Cover point Name |
| (Section 3.1.3.4.6) Gen Graphics | KVM related RAVDMs are limited to Reg_Wr_Req only. | *\<Test Name\>* | *\<Check Name\>* | *\<CP Name\>* |

# Security Test Plan Content Changes

## S3 for SDLe Tool 

*\< Every product leaving Intel must go through SDL. For each project,
the security risk is assessed by a Product Security Expert (PSE), based
on which he/she defines the security assurance plan for the project. The
security assurance plan includes both SDL tasks, which are focused on
tasks performed by the product team, as well as activities involving
evaluation by team(s) of external security experts. SDLe is a tool to
keep track of all the SDL tasks assigned to the product team. Product
team will proceed with SDL task execution and once all the SDL tasks are
completed, product team will acquire SDL approval for their release \>*

### \<SKS engine\>

##### Security and Validation Plan 

<table style="width:100%;">
<colgroup>
<col style="width: 14%" />
<col style="width: 20%" />
<col style="width: 49%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr>
<th>PCR</th>
<th>Requirement Validated</th>
<th>Validated Detailed Test Description</th>
<th>Owner</th>
</tr>
</thead>
<tbody>
<tr>
<td><p><em>&lt;HSD number and title of the PCR&gt;</em></p>
<p><em>&lt;Revision of the requirement defined&gt;</em></p></td>
<td><em>&lt;called out requirement from SDL HSD&gt;</em></td>
<td><p><em>&lt;Background Description&gt;</em></p>
<p><em>&lt;Test name&gt;</em></p>
<p><em>&lt;Execution Sequence&gt;</em></p>
<p><em>&lt;Pass Condition&gt;</em></p></td>
<td></td>
</tr>
</tbody>
</table>

### Validation report that Captures Security Verification Result 

| Evaluation Area | Coverage Name and Explanation | Evidence that coverage is getting hit | Owner |
|----|----|----|----|
| *\<HSD number and title of the PCR\>* | *\<CSpec / Whitebox\>* | *\<Snip of the coverage collection\>* |  |

### \<HCU DMA\>

### Security and Validation Plan

<table style="width:100%;">
<colgroup>
<col style="width: 14%" />
<col style="width: 20%" />
<col style="width: 49%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr>
<th>PCR</th>
<th>Requirement Validated</th>
<th>Validated Detailed Test Description</th>
<th>Owner</th>
</tr>
</thead>
<tbody>
<tr>
<td><p><em>&lt;HSD number and title of the PCR&gt;</em></p>
<p><em>&lt;Revision of the requirement defined&gt;</em></p></td>
<td><em>&lt;called out requirement from SDL HSD&gt;</em></td>
<td><p><em>&lt;Background Description&gt;</em></p>
<p><em>&lt;Test name&gt;</em></p>
<p><em>&lt;Execution Sequence&gt;</em></p>
<p><em>&lt;Pass Condition&gt;</em></p></td>
<td></td>
</tr>
</tbody>
</table>

### Validation report that Captures Security Verification Result 

| Evaluation Area | Coverage Name and Explanation | Evidence that coverage is getting hit | Owner |
|----|----|----|----|
| *\<HSD number and title of the PCR\>* | *\<CSpec / Whitebox\>* | *\<Snip of the coverage collection\>* |  |

### Multiple Area

### Security and Validation Plan

<table>
<colgroup>
<col style="width: 14%" />
<col style="width: 18%" />
<col style="width: 39%" />
<col style="width: 13%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr>
<th>PCR</th>
<th>Requirement Validated</th>
<th>Validated Detailed Test Description</th>
<th>Affected area</th>
<th>Owner</th>
</tr>
</thead>
<tbody>
<tr>
<td><p><em>&lt;HSD number and title of the PCR&gt;</em></p>
<p><em>&lt;Revision of the requirement defined&gt;</em></p></td>
<td><em>&lt;called out requirement from SDL HSD&gt;</em></td>
<td><p><em>&lt;Background Description&gt;</em></p>
<p><em>&lt;Test name&gt;</em></p>
<p><em>&lt;Execution Sequence&gt;</em></p>
<p><em>&lt;Pass Condition&gt;</em></p></td>
<td></td>
<td></td>
</tr>
<tr>
<td><p><a
href="https://hsdes.intel.com/resource/14012033569">14012033569</a></p>
<p>Support Gkey testmode toggle prevention until reset</p>
<p><strong>HSD Rev</strong>: 7</p></td>
<td>For defense in depth, ensure there is a test to verify that the HW
could hide the production GKEY until the next reset, after entering the
GKEY testmode.</td>
<td><p><strong>Background:</strong> </p>
<p>OCS is required to protect the production Gkey and soft strap re-pull
capability should not get access to the production secret. To further
protect the production GKEY, OCS is adding additional logic for the
testmode_gkey*_fuse_en signals by creating an internal latched
testmode_gkey*_fuse_en signals. OCS will be using the internal latched
testmode_gkey*_fuse_en signals to indicate production versus testmode
Gkey and the latched signal holds its value until a reset.</p>
<p><strong>Objective:</strong></p>
<p>Test the internal latched signal that RTL will used to determine
whether to use testmode GKEY or not.</p>
<p><strong>Test name:</strong></p>
<ul>
<li><p>ocs_sks_gkey_reset_test</p></li>
<li><p>ocs_aes_gkey_reset_test</p></li>
</ul>
<p><strong>Execution Sequence:</strong></p>
<ol type="1">
<li><p>Generate Gkey* with testmode_gkey*_fuse_en = 1</p></li>
<li><p>Perform AES encrypt to use the Gkey1</p></li>
<li><p>Generate Gkey* with testmode_gkey*_fuse_en = 0</p></li>
<li><p>Perform AES encrypt to use the Gkey* with the same input values
as Step 2.</p></li>
<li><p>Assert the reset</p></li>
<li><p>Generate Gkey* with random testmode_gkey*_fuse_en value</p></li>
<li><p>Perform AES encrypt to use the Gkey*</p></li>
</ol>
<p><strong>Pass Conditions:</strong></p>
<p>No mismatch between the expected and actual data of the encrypted
data.</p></td>
<td>SKS, AES_A DMA, AES_P DMA</td>
<td>Linda</td>
</tr>
</tbody>
</table>

### Validation report that Captures Security Verification Result 

<table>
<colgroup>
<col style="width: 13%" />
<col style="width: 27%" />
<col style="width: 50%" />
<col style="width: 8%" />
</colgroup>
<thead>
<tr>
<th>Evaluation Area</th>
<th>Coverage Name and Explanation</th>
<th>Evidence that coverage is getting hit</th>
<th>Owner</th>
</tr>
</thead>
<tbody>
<tr>
<td><em>&lt;HSD number and title of the PCR&gt;</em></td>
<td><em>&lt;CSpec / Whitebox&gt;</em></td>
<td><em>&lt;Snip of the coverage collection&gt;</em></td>
<td></td>
</tr>
<tr>
<td><p><a
href="https://hsdes.intel.com/resource/14012033569">14012033569</a></p>
<p>Support Gkey testmode toggle prevention until reset</p></td>
<td><p><strong>Whitebox coverages</strong>: testmode_gkey1_fuse_en_stk,
testmode_gkey0_fuse_en_stk, testmode_gkey2_fuse_en_stk</p>
<p>Make sure that the testmode_gkey*_fuse_en input signal is 1 while the
internal sticky signal is 0 and GKEY generation bit.</p></td>
<td><img src="media/image14.png"
style="width:3.76267in;height:0.38833in" /></td>
<td>Linda</td>
</tr>
</tbody>
</table>

## Additional Consideration for Security Assets not covered in S3

*\<Document any verification done for security asset defined from the
threat model or identify by the architect or designer. If there are many
testcases that verify the mitigation, then pick 1 to 3 tests to document
in the table format. Any testcases that are describe in the security
testplan do not need to be included in the functional testplan. Try to
avoid duplication when possible. Only document assets that are not
called out as a requirement in S3.\>*

### PUF Key

<table>
<colgroup>
<col style="width: 16%" />
<col style="width: 14%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr>
<th><strong>ASSET:</strong></th>
<th colspan="2">PUF key</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>ACCESS PATH:</strong> </td>
<td colspan="2"><p><em>&lt;List out all the physical pathway that needs
to be considered and stimulus to verify that pathway&gt;</em></p>
<p>List out all the pathway:</p>
<ul>
<li><p>IOSF-Primary: all the testing is done through this pathway by
using register accessing</p></li>
<li><p>MRA: this is not possible with IP testing but can be considered
using FPV testing.</p></li>
</ul></td>
</tr>
<tr>
<td><strong>THREAT:</strong></td>
<td colspan="2">FW uses PUF key to decrypt UDS (unique device
secrets)</td>
</tr>
<tr>
<td><strong>HARDWARE MITIGATION:</strong>  </td>
<td colspan="2">ROM invalidates PUF KEY in SKS</td>
</tr>
<tr>
<td rowspan="4"></td>
<td>Test Name:</td>
<td>ocs_puf_invalidate_test</td>
</tr>
<tr>
<td>Description:</td>
<td><ol type="1">
<li><p>This test will generate the PUF key and store it in slot 30 of
SKS.</p></li>
<li><p>Invalidate the slot 30 to make sure the PUF key is not accessible
anymore.</p></li>
<li><p>Try using the key in slot 30 with a set key command in SKS to
confirm that the slot is invalidated.</p></li>
</ol></td>
</tr>
<tr>
<td>Checking:</td>
<td>RTL assertions to make sure HW writes zeros to SKS slot when
invalidation command is detected.</td>
</tr>
<tr>
<td>Coverage:</td>
<td><p>Coverage group name: <em>sks_go_command_cg</em></p>
<p>Cross the invalidate command with the SKS slot address</p></td>
</tr>
<tr>
<td><strong>THREAT:</strong></td>
<td colspan="2">PUF is transferred to ROM/FW readable register</td>
</tr>
<tr>
<td><strong>HARDWARE MITIGATION:</strong>  </td>
<td colspan="2">PUF key cannot be transferred to FW visible register
through SKS programming</td>
</tr>
<tr>
<td rowspan="4"></td>
<td>Test Name:</td>
<td>ocs_sks_slot_attr_test</td>
</tr>
<tr>
<td>Description:</td>
<td><p>1) This test was written as part of testplan for PCR:14011194333:
to check that if parameter OCS_SKS_GKEY_PUF_SECURE is set, then
SKS_ATR_1.SECURE_KEY is *always* set to 1 after GKEY1 or PUF is
successfully generated.</p>
<p>2) However, the scope of this test is broadened to check ALL slot
attributes, for both the ways in which slot can be populated.</p>
<p>3) The test needs to check both things:</p>
<ol type="i">
<li><p>that the correct value is loaded into SKS_ATR_X AND</p></li>
<li><p>that the value is loaded at the right time (that is right after
slot is valid).</p></li>
</ol>
<p>4) Make sure that SKS_ATR_1.SECURE_KEY is programmable from
SKS_CMDR.SECURE_KEY when slot is not populated by GKEY1/PUF..or in other
words, make sure SKS_ATR_1.SECURE_KEY programming by GKEY1/PUF is not
sticky.</p></td>
</tr>
<tr>
<td>Checking:</td>
<td>Scoreboard updates the expected secure attribute for slot 1/30 to
always be 1 if the ocs_sks_gkey_puf_secure parameter is set. Then,
scoreboard will compare it with the actual secure attribute field set by
HW.</td>
</tr>
<tr>
<td>Coverage:</td>
<td><p>Cover group name: <em>read_sks_puf_secure_att_reg_cg</em></p>
<p>Cross the generation of PUF key, secure key field in the SKS_CMDR
register, and secure key attribute setting in SKS_ATR[30]
register</p></td>
</tr>
</tbody>
</table>

## Additional Consideration for Security Checks not covered in S3

*\<Document any verification done for security checks that might have
multiple assets and/or cannot be document in a table format as in
Chapter 3. The security checks can be documented in paragraph form. Only
document checks that are not called out as a requirement in S3.\>*

### Unused byte lane

*\<Checks to ensure no data leakage through inactive byte lanes.*

*Check to ensure HW only responds with data size that was requested
for.\>*

# Appendix

## Implementation Notes

*\<Any further details that the Validation DCN owner wants to include
that are not needed to be part of overall documents\>*

## Bottoms up Effort

*\<T-Shirt Sizing\>*

<table style="width:65%;">
<colgroup>
<col style="width: 21%" />
<col style="width: 21%" />
<col style="width: 21%" />
</colgroup>
<thead>
<tr>
<th style="text-align: center;"><p><em><strong>&lt;Validation
Environment&gt;</strong></em></p>
<p><em><strong>&lt;Ex: MISA&gt;</strong></em></p>
<p><strong>Effort Sizing</strong></p></th>
<th style="text-align: center;"><p><em><strong>&lt;Validation
Environment&gt;</strong></em></p>
<p><em><strong>&lt;Ex: GASKET&gt;</strong></em></p>
<p><strong>Effort Sizing</strong></p></th>
<th style="text-align: center;"><p><em><strong>&lt;Validation
Environment&gt;</strong></em></p>
<p><em><strong>&lt;Ex: CSE TOP&gt;</strong></em></p>
<p><strong>Effort Sizing</strong></p></th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: center;"><em>&lt;S&gt;</em></td>
<td style="text-align: center;"><em>&lt;M&gt;</em></td>
<td style="text-align: center;"><em>&lt;XL&gt;</em></td>
</tr>
</tbody>
</table>

*\<Provide overall effort needed to execute this PCR, effort to be
provided per IP environment, below is an example template, owner can
choose to use a different template than below\>*

<table>
<colgroup>
<col style="width: 21%" />
<col style="width: 43%" />
<col style="width: 11%" />
<col style="width: 11%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr>
<th style="text-align: center;"><strong>Area of Impact</strong></th>
<th style="text-align: center;"><strong>Comments</strong></th>
<th style="text-align: center;"><p><em><strong>&lt;Validation
Environment&gt;</strong></em></p>
<p><em><strong>&lt;Ex: MISA&gt;</strong></em></p>
<p><strong>Effort in Weeks</strong></p></th>
<th style="text-align: center;"><p><em><strong>&lt;Validation
Environment&gt;</strong></em></p>
<p><em><strong>&lt;Ex: GASKET&gt;</strong></em></p>
<p><strong>Effort in Weeks</strong></p></th>
<th style="text-align: center;"><p><em><strong>&lt;Validation
Environment&gt;</strong></em></p>
<p><em><strong>&lt;Ex: CSE TOP&gt;</strong></em></p>
<p><strong>Effort in Weeks</strong></p></th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: center;">Documentation</td>
<td style="text-align: center;">Val DCN (Test Plan, Verif A-spec,
Security Test Plan)</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;">Environment</td>
<td style="text-align: center;">Example: TB, TI, Interface, monitors,
cfg files, env.sv</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;">Test Development/Execution</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;">Checkers</td>
<td style="text-align: center;">Scoreboards, Assertions, Protocol
checkers etc..</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;">C-Spec Coverage</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;">OpenBox Coverage</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;">L0/L1 regression</td>
<td style="text-align: center;">Baselining regression and coverage</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;">Misc</td>
<td style="text-align: center;">Example: Turnin, Collage, Etc..</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;">Reviews</td>
<td style="text-align: center;">Reviews (Val DCN, Code, Paranoia) and
Feedback incorporation</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
<tr>
<td style="text-align: center;"><strong>Total Effort in
Weeks</strong></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
</tr>
</tbody>
</table>

*\<Provide Details on work that can execute in parallel\>*

| Workstream | WW1 | WW2 | WW3 | WW4 | WW5 | WW6 | Total |
|----|----|----|----|----|----|----|----|
| 1 | *\<Documentation\>* | *\<Environment changes\>* | *\<Test Development\>* |  |  |  |  |
| 2 |  | *\<Environment changes\>* | *\<Test Development\>* |  |  |  |  |
| 3 |  |  | *\<Test Development\>* |  |  |  |  |
|  |  |  |  |  |  |  |  |

## Process on how to update the val dcn document?

**<u>Option 1:</u>** When an existing content needs a update, follow
below steps

1.  Enable “track changes” feature in overall document(s)

2.  Add your changes

3.  Copy paste the delta into this document for the review

4.  Once the review is complete and all the changes are approved, port
    the feedback back to the overall document(s)

local copy of overall document(s)

Val DCN

Val DCN Review

**<u>Option 2:</u>** When new content is added, follow below steps

1.  Add your changes into this document

2.  Once the review is complete and all the changes are approved, port
    the changes to the overall document(s)

Val DCN

Val DCN Review

overall document(s)
