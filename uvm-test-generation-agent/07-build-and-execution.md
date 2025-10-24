# Build and Execution Guide

## Overview

This guide describes how to integrate generated UVM/OVM/Saola tests into build systems and execute them in simulation environments. The agent must generate not only verification code but also the necessary build collaterals and execution scripts.

## 1. Build System Integration

### 1.1 Build System Detection

```python
def detect_build_system(project_path):
    build_indicators = {
        'makefile': ['Makefile', 'makefile', 'GNUmakefile'],
        'cmake': ['CMakeLists.txt', 'cmake'],
        'scons': ['SConstruct', 'sconstruct'],
        'bazel': ['BUILD', 'WORKSPACE', 'BUILD.bazel'],
        'gradle': ['build.gradle', 'gradle.build'],
        'custom': ['build.sh', 'compile.sh', 'run.sh']
    }
    
    detected_systems = []
    
    for system, indicators in build_indicators.items():
        for indicator in indicators:
            if (Path(project_path) / indicator).exists():
                detected_systems.append(system)
                break
    
    return detected_systems[0] if detected_systems else 'none'
```

### 1.2 Build System Templates

#### Makefile Template

```makefile
# Generated Makefile for {{ test_name }}
# Methodology: {{ methodology }}
# Generated: {{ generation_timestamp }}

# Simulator configuration
SIM = {{ simulator }}  # vcs, questa, xcelium
SIM_VERSION = {{ sim_version }}

# UVM configuration
UVM_HOME = {{ uvm_home }}
UVM_VERSION = {{ uvm_version }}

# Project paths
PROJECT_ROOT = {{ project_root }}
TEST_DIR = $(PROJECT_ROOT)/{{ test_directory }}
SRC_DIR = $(PROJECT_ROOT)/{{ source_directory }}
INC_DIR = $(PROJECT_ROOT)/{{ include_directory }}
COV_DIR = $(PROJECT_ROOT)/{{ coverage_directory }}

# Test configuration
TEST_NAME = {{ test_name }}
TEST_CLASS = {{ test_class }}
SEED = {{ default_seed }}
VERBOSITY = {{ default_verbosity }}

# Source files
DUT_FILES = \
{%- for file in dut_files %}
	$(SRC_DIR)/{{ file }} \
{%- endfor %}

TB_FILES = \
{%- for file in testbench_files %}
	$(TEST_DIR)/{{ file }} \
{%- endfor %}

INC_DIRS = \
{%- for dir in include_directories %}
	+incdir+$(PROJECT_ROOT)/{{ dir }} \
{%- endfor %}

# Simulator specific settings
ifeq ($(SIM),vcs)
	SIM_OPTS = -sverilog -ntb_opts uvm-$(UVM_VERSION) +vcs+vcdpluson
	COMP_OPTS = -full64 -debug_access+all -kdb +vcs+initreg+random
	RUN_OPTS = -licqueue +UVM_TESTNAME=$(TEST_CLASS) +UVM_VERBOSITY=$(VERBOSITY) +ntb_random_seed=$(SEED)
else ifeq ($(SIM),questa)
	SIM_OPTS = -sv +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv
	COMP_OPTS = -64 +acc -permissive +cover
	RUN_OPTS = +UVM_TESTNAME=$(TEST_CLASS) +UVM_VERBOSITY=$(VERBOSITY) +seed=$(SEED)
else ifeq ($(SIM),xcelium)
	SIM_OPTS = -sv -uvm +incdir+$(UVM_HOME)/src
	COMP_OPTS = -64bit +access+rwc +nccoverage
	RUN_OPTS = +UVM_TESTNAME=$(TEST_CLASS) +UVM_VERBOSITY=$(VERBOSITY) +seed=$(SEED)
endif

# Coverage options
COV_OPTS = \
	+define+COVERAGE_ENABLED \
	+define+FUNCTIONAL_COVERAGE \
	+define+ASSERTION_COVERAGE

# Default target
all: compile run

# Compilation target
compile:
	@echo "Compiling $(TEST_NAME) for $(SIM)..."
	$(SIM) $(SIM_OPTS) $(COMP_OPTS) $(COV_OPTS) \
		$(INC_DIRS) \
		$(DUT_FILES) \
		$(TB_FILES) \
		-o $(TEST_NAME).simv

# Simulation target
run: compile
	@echo "Running $(TEST_NAME) with seed $(SEED)..."
	./$(TEST_NAME).simv $(RUN_OPTS)

# Coverage target
coverage: run
	@echo "Generating coverage report..."
{%- if methodology == 'UVM' %}
	urg -dir simv.vdb -report $(COV_DIR)
{%- elif methodology == 'Questa' %}
	vcover report -html $(COV_DIR) coverage.ucdb
{%- endif %}

# Regression target
regression:
	@echo "Running regression with multiple seeds..."
{%- for seed in regression_seeds %}
	$(MAKE) run SEED={{ seed }}
{%- endfor %}

# Clean target
clean:
	@echo "Cleaning build artifacts..."
	rm -rf simv* csrc DVE* ucli.key vc_hdrs.h
	rm -rf coverage.ucdb vsim.wlf transcript
	rm -rf work .vlogansetup.env .vlogansetup.args

# Help target
help:
	@echo "Available targets:"
	@echo "  compile    - Compile the testbench"
	@echo "  run        - Run simulation with default settings"
	@echo "  coverage   - Generate coverage report"
	@echo "  regression - Run regression with multiple seeds"
	@echo "  clean      - Clean build artifacts"
	@echo ""
	@echo "Variables:"
	@echo "  SIM        - Simulator (vcs/questa/xcelium)"
	@echo "  SEED       - Random seed"
	@echo "  VERBOSITY  - UVM verbosity level"
	@echo "  TEST_CLASS - Test class name"

.PHONY: all compile run coverage regression clean help
```

#### CMake Template

```cmake
# Generated CMakeLists.txt for {{ test_name }}
# Methodology: {{ methodology }}
# Generated: {{ generation_timestamp }}

cmake_minimum_required(VERSION 3.10)
project({{ test_name }})

# Configuration
set(METHODOLOGY "{{ methodology }}")
set(SIMULATOR "{{ simulator }}" CACHE STRING "Simulator to use")
set(UVM_VERSION "{{ uvm_version }}" CACHE STRING "UVM version")
set(DEFAULT_SEED "{{ default_seed }}" CACHE STRING "Default random seed")

# Paths
set(PROJECT_ROOT "{{ project_root }}")
set(SRC_DIR "${PROJECT_ROOT}/{{ source_directory }}")
set(TEST_DIR "${PROJECT_ROOT}/{{ test_directory }}")
set(INC_DIR "${PROJECT_ROOT}/{{ include_directory }}")
set(COV_DIR "${PROJECT_ROOT}/{{ coverage_directory }}")

# Source files
set(DUT_FILES
{%- for file in dut_files %}
    "${SRC_DIR}/{{ file }}"
{%- endfor %}
)

set(TB_FILES
{%- for file in testbench_files %}
    "${TEST_DIR}/{{ file }}"
{%- endfor %}
)

# Include directories
set(INC_DIRS
{%- for dir in include_directories %}
    "${PROJECT_ROOT}/{{ dir }}"
{%- endfor %}
)

# Simulator configuration
if(SIMULATOR STREQUAL "vcs")
    set(SIM_EXEC "vcs")
    set(SIM_ARGS "-sverilog -ntb_opts uvm-${UVM_VERSION} +vcs+vcdpluson -full64 -debug_access+all")
elseif(SIMULATOR STREQUAL "questa")
    set(SIM_EXEC "vlog")
    set(SIM_ARGS "-sv +incdir+${UVM_HOME}/src ${UVM_HOME}/src/uvm_pkg.sv -64 +acc")
elseif(SIMULATOR STREQUAL "xcelium")
    set(SIM_EXEC "xrun")
    set(SIM_ARGS "-sv -uvm +incdir+${UVM_HOME}/src -64bit +access+rwc")
else()
    message(FATAL_ERROR "Unsupported simulator: ${SIMULATOR}")
endif()

# Include directories for simulator
foreach(inc_dir ${INC_DIRS})
    list(APPEND SIM_ARGS "+incdir+${inc_dir}")
endforeach()

# Custom targets
add_custom_target(compile
    COMMAND ${SIM_EXEC} ${SIM_ARGS} ${DUT_FILES} ${TB_FILES} -o {{ test_name }}.simv
    COMMENT "Compiling {{ test_name }}"
    VERBATIM
)

add_custom_target(run
    COMMAND ./{{ test_name }}.simv +UVM_TESTNAME={{ test_class }} +UVM_VERBOSITY=UVM_MEDIUM +ntb_random_seed=${DEFAULT_SEED}
    DEPENDS compile
    COMMENT "Running {{ test_name }}"
    VERBATIM
)

add_custom_target(coverage
    COMMAND urg -dir simv.vdb -report ${COV_DIR}
    DEPENDS run
    COMMENT "Generating coverage report"
    VERBATIM
)

add_custom_target(clean_sim
    COMMAND ${CMAKE_COMMAND} -E remove_directory simv.daidir
    COMMAND ${CMAKE_COMMAND} -E remove simv*
    COMMAND ${CMAKE_COMMAND} -E remove_directory csrc
    COMMENT "Cleaning simulation artifacts"
)
```

## 2. Simulation Environment Setup

### 2.1 Environment Configuration

```bash
#!/bin/bash
# Generated environment setup script
# Test: {{ test_name }}
# Generated: {{ generation_timestamp }}

# Simulator paths
export VCS_HOME={{ vcs_home }}
export QUESTA_HOME={{ questa_home }}
export XCELIUM_HOME={{ xcelium_home }}

# UVM configuration
export UVM_HOME={{ uvm_home }}
export UVM_VERSION={{ uvm_version }}

# License configuration
export LM_LICENSE_FILE={{ license_file }}
export SNPSLMD_LICENSE_FILE={{ synopsys_license }}
export MGLS_LICENSE_FILE={{ mentor_license }}
export CADENCE_LICENSE_FILE={{ cadence_license }}

# Library paths
export LD_LIBRARY_PATH="$VCS_HOME/lib:$QUESTA_HOME/lib:$XCELIUM_HOME/tools/lib/64bit:$LD_LIBRARY_PATH"

# Tool paths
export PATH="$VCS_HOME/bin:$QUESTA_HOME/bin:$XCELIUM_HOME/tools/bin:$PATH"

# Project specific settings
export PROJECT_ROOT={{ project_root }}
export TEST_NAME={{ test_name }}
export METHODOLOGY={{ methodology }}

# Coverage settings
export COVERAGE_DIR={{ coverage_directory }}
export COVERAGE_DB={{ coverage_database }}

# Simulation settings
export DEFAULT_SIMULATOR={{ default_simulator }}
export DEFAULT_VERBOSITY={{ default_verbosity }}
export DEFAULT_SEED={{ default_seed }}

echo "Environment configured for {{ test_name }}"
echo "Methodology: {{ methodology }}"
echo "Default Simulator: $DEFAULT_SIMULATOR"
echo "UVM Version: $UVM_VERSION"
```

### 2.2 Simulator-Specific Scripts

#### VCS Execution Script

```bash
#!/bin/bash
# VCS execution script for {{ test_name }}

# Parse command line arguments
TEST_CLASS="{{ test_class }}"
SEED="{{ default_seed }}"
VERBOSITY="UVM_MEDIUM"
WAVES="off"
COVERAGE="off"

while [[ $# -gt 0 ]]; do
    case $1 in
        -test)
            TEST_CLASS="$2"
            shift 2
            ;;
        -seed)
            SEED="$2"
            shift 2
            ;;
        -verbosity)
            VERBOSITY="$2"
            shift 2
            ;;
        -waves)
            WAVES="on"
            shift
            ;;
        -coverage)
            COVERAGE="on"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Build VCS command
VCS_OPTS="-sverilog -ntb_opts uvm-{{ uvm_version }} -full64 -debug_access+all -kdb"

if [ "$WAVES" = "on" ]; then
    VCS_OPTS="$VCS_OPTS +vcs+vcdpluson"
fi

if [ "$COVERAGE" = "on" ]; then
    VCS_OPTS="$VCS_OPTS -cm line+cond+fsm+branch+tgl"
fi

# Include directories
INC_DIRS=""
{%- for dir in include_directories %}
INC_DIRS="$INC_DIRS +incdir+{{ project_root }}/{{ dir }}"
{%- endfor %}

# Source files
SRC_FILES=""
{%- for file in dut_files %}
SRC_FILES="$SRC_FILES {{ project_root }}/{{ source_directory }}/{{ file }}"
{%- endfor %}
{%- for file in testbench_files %}
SRC_FILES="$SRC_FILES {{ project_root }}/{{ test_directory }}/{{ file }}"
{%- endfor %}

# Compile
echo "Compiling with VCS..."
vcs $VCS_OPTS $INC_DIRS $SRC_FILES -o {{ test_name }}.simv

if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi

# Run simulation
echo "Running simulation..."
echo "Test: $TEST_CLASS"
echo "Seed: $SEED"
echo "Verbosity: $VERBOSITY"

RUN_OPTS="+UVM_TESTNAME=$TEST_CLASS +UVM_VERBOSITY=$VERBOSITY +ntb_random_seed=$SEED"

if [ "$COVERAGE" = "on" ]; then
    RUN_OPTS="$RUN_OPTS -cm line+cond+fsm+branch+tgl -cm_name $TEST_CLASS"
fi

./{{ test_name }}.simv $RUN_OPTS

SIM_EXIT_CODE=$?

# Generate coverage report if enabled
if [ "$COVERAGE" = "on" ] && [ $SIM_EXIT_CODE -eq 0 ]; then
    echo "Generating coverage report..."
    urg -dir simv.vdb -report {{ coverage_directory }}
fi

exit $SIM_EXIT_CODE
```

## 3. Test Execution Framework

### 3.1 Test Runner Script

```python
#!/usr/bin/env python3
"""
Generated test runner for {{ test_name }}
Methodology: {{ methodology }}
Generated: {{ generation_timestamp }}
"""

import argparse
import subprocess
import sys
import os
import json
from pathlib import Path
from datetime import datetime

class TestRunner:
    def __init__(self):
        self.project_root = Path("{{ project_root }}")
        self.test_name = "{{ test_name }}"
        self.methodology = "{{ methodology }}"
        self.default_simulator = "{{ default_simulator }}"
        self.results = []
        
    def run_test(self, args):
        """Run a single test with given arguments"""
        start_time = datetime.now()
        
        # Build command based on simulator
        if args.simulator == 'vcs':
            cmd = self.build_vcs_command(args)
        elif args.simulator == 'questa':
            cmd = self.build_questa_command(args)
        elif args.simulator == 'xcelium':
            cmd = self.build_xcelium_command(args)
        else:
            raise ValueError(f"Unsupported simulator: {args.simulator}")
        
        print(f"Running: {' '.join(cmd)}")
        
        # Execute simulation
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=self.project_root)
            end_time = datetime.now()
            duration = (end_time - start_time).total_seconds()
            
            test_result = {
                'test_class': args.test,
                'seed': args.seed,
                'simulator': args.simulator,
                'start_time': start_time.isoformat(),
                'duration': duration,
                'exit_code': result.returncode,
                'stdout': result.stdout,
                'stderr': result.stderr,
                'passed': result.returncode == 0 and 'UVM_ERROR' not in result.stdout
            }
            
            self.results.append(test_result)
            
            if test_result['passed']:
                print(f"✓ Test PASSED (seed: {args.seed}, duration: {duration:.2f}s)")
            else:
                print(f"✗ Test FAILED (seed: {args.seed}, duration: {duration:.2f}s)")
                if args.verbose:
                    print("STDOUT:", result.stdout)
                    print("STDERR:", result.stderr)
            
            return test_result['passed']
            
        except Exception as e:
            print(f"Error running test: {e}")
            return False
    
    def build_vcs_command(self, args):
        """Build VCS simulation command"""
        cmd = ['vcs']
        cmd.extend(['-sverilog', '-ntb_opts', f'uvm-{{ uvm_version }}'])
        cmd.extend(['-full64', '-debug_access+all', '-kdb'])
        
        if args.waves:
            cmd.append('+vcs+vcdpluson')
        
        if args.coverage:
            cmd.extend(['-cm', 'line+cond+fsm+branch+tgl'])
        
        # Include directories
{%- for dir in include_directories %}
        cmd.append(f'+incdir+{self.project_root}/{{ dir }}')
{%- endfor %}
        
        # Source files
{%- for file in dut_files %}
        cmd.append(f'{self.project_root}/{{ source_directory }}/{{ file }}')
{%- endfor %}
{%- for file in testbench_files %}
        cmd.append(f'{self.project_root}/{{ test_directory }}/{{ file }}')
{%- endfor %}
        
        cmd.extend(['-o', f'{self.test_name}.simv'])
        
        # Run arguments
        cmd.append('&&')
        cmd.append(f'./{self.test_name}.simv')
        cmd.append(f'+UVM_TESTNAME={args.test}')
        cmd.append(f'+UVM_VERBOSITY={args.verbosity}')
        cmd.append(f'+ntb_random_seed={args.seed}')
        
        if args.coverage:
            cmd.append(f'-cm_name {args.test}_{args.seed}')
        
        return cmd
    
    def run_regression(self, args):
        """Run regression with multiple seeds"""
        seeds = args.seeds if args.seeds else {{ regression_seeds }}
        passed_tests = 0
        total_tests = len(seeds)
        
        print(f"Running regression with {total_tests} seeds...")
        
        for seed in seeds:
            args.seed = seed
            if self.run_test(args):
                passed_tests += 1
        
        # Generate summary
        pass_rate = (passed_tests / total_tests) * 100
        print(f"\nRegression Summary:")
        print(f"  Total Tests: {total_tests}")
        print(f"  Passed: {passed_tests}")
        print(f"  Failed: {total_tests - passed_tests}")
        print(f"  Pass Rate: {pass_rate:.1f}%")
        
        # Save results
        self.save_results(args.output)
        
        return passed_tests == total_tests
    
    def save_results(self, output_file):
        """Save test results to JSON file"""
        with open(output_file, 'w') as f:
            json.dump({
                'test_name': self.test_name,
                'methodology': self.methodology,
                'timestamp': datetime.now().isoformat(),
                'results': self.results
            }, f, indent=2)
        
        print(f"Results saved to {output_file}")

def main():
    parser = argparse.ArgumentParser(description='Test runner for {{ test_name }}')
    parser.add_argument('-test', default='{{ test_class }}', help='Test class name')
    parser.add_argument('-seed', type=int, default={{ default_seed }}, help='Random seed')
    parser.add_argument('-simulator', default='{{ default_simulator }}', choices=['vcs', 'questa', 'xcelium'], help='Simulator')
    parser.add_argument('-verbosity', default='UVM_MEDIUM', choices=['UVM_NONE', 'UVM_LOW', 'UVM_MEDIUM', 'UVM_HIGH', 'UVM_FULL'], help='UVM verbosity')
    parser.add_argument('-waves', action='store_true', help='Enable waveform dumping')
    parser.add_argument('-coverage', action='store_true', help='Enable coverage collection')
    parser.add_argument('-verbose', action='store_true', help='Verbose output')
    parser.add_argument('-regression', action='store_true', help='Run regression')
    parser.add_argument('-seeds', type=int, nargs='+', help='Seeds for regression')
    parser.add_argument('-output', default='test_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    runner = TestRunner()
    
    if args.regression:
        success = runner.run_regression(args)
    else:
        success = runner.run_test(args)
    
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
```

### 3.2 Continuous Integration Integration

#### Jenkins Pipeline

```groovy
// Generated Jenkinsfile for {{ test_name }}
pipeline {
    agent any
    
    parameters {
        choice(
            name: 'SIMULATOR',
            choices: ['vcs', 'questa', 'xcelium'],
            description: 'Simulator to use'
        )
        booleanParam(
            name: 'COVERAGE',
            defaultValue: true,
            description: 'Enable coverage collection'
        )
        string(
            name: 'SEEDS',
            defaultValue: '{{ regression_seeds | join(",") }}',
            description: 'Comma-separated list of seeds'
        )
    }
    
    environment {
        PROJECT_ROOT = '{{ project_root }}'
        TEST_NAME = '{{ test_name }}'
        UVM_HOME = '{{ uvm_home }}'
        LM_LICENSE_FILE = '{{ license_file }}'
    }
    
    stages {
        stage('Setup') {
            steps {
                echo "Setting up environment for ${TEST_NAME}"
                sh 'source setup_env.sh'
            }
        }
        
        stage('Compile') {
            steps {
                echo "Compiling testbench with ${params.SIMULATOR}"
                sh """
                    python3 run_test.py \
                        -simulator ${params.SIMULATOR} \
                        -test compile_check \
                        -seed 1
                """
            }
        }
        
        stage('Regression') {
            steps {
                echo "Running regression tests"
                script {
                    def seeds = params.SEEDS.split(',')
                    def coverageFlag = params.COVERAGE ? '-coverage' : ''
                    
                    sh """
                        python3 run_test.py \
                            -regression \
                            -simulator ${params.SIMULATOR} \
                            -seeds ${params.SEEDS.replace(',', ' ')} \
                            ${coverageFlag} \
                            -output jenkins_results.json
                    """
                }
            }
        }
        
        stage('Coverage') {
            when {
                params.COVERAGE == true
            }
            steps {
                echo "Generating coverage report"
                sh 'make coverage'
                
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: '{{ coverage_directory }}',
                    reportFiles: 'index.html',
                    reportName: 'Coverage Report'
                ])
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: 'jenkins_results.json, *.log', fingerprint: true
            
            script {
                def results = readJSON file: 'jenkins_results.json'
                def passRate = results.results.count { it.passed } / results.results.size() * 100
                
                if (passRate < 95) {
                    currentBuild.result = 'UNSTABLE'
                    echo "Test pass rate ${passRate}% below threshold"
                }
            }
        }
        
        failure {
            emailext (
                subject: "Test Failed: ${TEST_NAME}",
                body: "The test ${TEST_NAME} has failed. Please check the logs.",
                to: "{{ notification_email }}"
            )
        }
    }
}
```

## 4. Result Analysis and Reporting

### 4.1 Result Parser

```python
class ResultAnalyzer:
    def __init__(self, results_file):
        with open(results_file, 'r') as f:
            self.data = json.load(f)
    
    def analyze_results(self):
        """Analyze test results and generate summary"""
        results = self.data['results']
        
        analysis = {
            'total_tests': len(results),
            'passed_tests': len([r for r in results if r['passed']]),
            'failed_tests': len([r for r in results if not r['passed']]),
            'pass_rate': 0,
            'avg_duration': 0,
            'failed_seeds': [],
            'coverage_summary': None
        }
        
        if analysis['total_tests'] > 0:
            analysis['pass_rate'] = (analysis['passed_tests'] / analysis['total_tests']) * 100
            analysis['avg_duration'] = sum(r['duration'] for r in results) / len(results)
            analysis['failed_seeds'] = [r['seed'] for r in results if not r['passed']]
        
        return analysis
    
    def generate_report(self, output_file='test_report.html'):
        """Generate HTML test report"""
        analysis = self.analyze_results()
        
        html_template = f"""
<!DOCTYPE html>
<html>
<head>
    <title>Test Report: {self.data['test_name']}</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 20px; }}
        .summary {{ background: #f0f0f0; padding: 15px; border-radius: 5px; }}
        .passed {{ color: green; }}
        .failed {{ color: red; }}
        table {{ border-collapse: collapse; width: 100%; margin-top: 20px; }}
        th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
        th {{ background-color: #f2f2f2; }}
    </style>
</head>
<body>
    <h1>Test Report: {self.data['test_name']}</h1>
    
    <div class="summary">
        <h2>Summary</h2>
        <p><strong>Total Tests:</strong> {analysis['total_tests']}</p>
        <p><strong>Passed:</strong> <span class="passed">{analysis['passed_tests']}</span></p>
        <p><strong>Failed:</strong> <span class="failed">{analysis['failed_tests']}</span></p>
        <p><strong>Pass Rate:</strong> {analysis['pass_rate']:.1f}%</p>
        <p><strong>Average Duration:</strong> {analysis['avg_duration']:.2f}s</p>
        <p><strong>Timestamp:</strong> {self.data['timestamp']}</p>
    </div>
    
    <h2>Test Results</h2>
    <table>
        <tr>
            <th>Test Class</th>
            <th>Seed</th>
            <th>Simulator</th>
            <th>Duration</th>
            <th>Status</th>
        </tr>
        {self._generate_result_rows()}
    </table>
    
    {self._generate_failed_details() if analysis['failed_tests'] > 0 else ''}
</body>
</html>
        """
        
        with open(output_file, 'w') as f:
            f.write(html_template)
        
        print(f"HTML report generated: {output_file}")
    
    def _generate_result_rows(self):
        rows = []
        for result in self.data['results']:
            status_class = 'passed' if result['passed'] else 'failed'
            status_text = 'PASS' if result['passed'] else 'FAIL'
            
            rows.append(f"""
            <tr>
                <td>{result['test_class']}</td>
                <td>{result['seed']}</td>
                <td>{result['simulator']}</td>
                <td>{result['duration']:.2f}s</td>
                <td class="{status_class}">{status_text}</td>
            </tr>
            """)
        
        return ''.join(rows)
    
    def _generate_failed_details(self):
        failed_results = [r for r in self.data['results'] if not r['passed']]
        
        details = "<h2>Failed Test Details</h2>"
        for result in failed_results:
            details += f"""
            <h3>Seed {result['seed']} - {result['test_class']}</h3>
            <pre>{result['stderr']}</pre>
            """
        
        return details
```

## 5. Best Practices

### 5.1 Build System Integration

1. **Modular Design**: Separate compilation and execution phases
2. **Tool Abstraction**: Support multiple simulators with unified interface
3. **Dependency Management**: Handle file dependencies correctly
4. **Parallel Execution**: Support parallel test execution
5. **Resource Management**: Handle simulator licenses and resources

### 5.2 Execution Framework

1. **Robust Error Handling**: Graceful handling of simulation failures
2. **Result Tracking**: Comprehensive result collection and analysis
3. **Configuration Management**: Flexible test configuration
4. **Reproducibility**: Ensure tests can be reproduced with same seeds
5. **Scalability**: Support large regression suites

### 5.3 CI/CD Integration

1. **Pipeline Definition**: Clear pipeline stages and dependencies
2. **Artifact Management**: Proper handling of build artifacts
3. **Notification System**: Timely notifications of failures
4. **Resource Optimization**: Efficient use of CI/CD resources
5. **Quality Gates**: Automated quality checks and thresholds

---

*This completes the comprehensive UVM Test Generation Agent documentation suite. All 7 guides provide the necessary information for parsing validation documents and generating complete UVM/OVM/Saola verification environments.*