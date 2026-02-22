#!/bin/bash
# Comprehensive System Verification and Visualization

echo "=========================================="
echo "ATALANTA SYSTEM VERIFICATION"
echo "=========================================="
echo ""

PASS=0
FAIL=0
WARN=0

# Colors for better visualization
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

pass_check() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASS++))
}

fail_check() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAIL++))
}

warn_check() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARN++))
}

info_check() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

echo "=== PHASE 1: FILE EXISTENCE CHECK ==="
echo ""

# Check core executable
if [ -f "atalanta" ] && [ -x "atalanta" ]; then
    pass_check "atalanta executable exists and is executable"
else
    fail_check "atalanta executable missing or not executable"
fi

# Check configuration
if [ -f "config.sh" ]; then
    pass_check "config.sh exists"
    source config.sh
else
    fail_check "config.sh missing"
fi

# Check automation scripts
REQUIRED_SCRIPTS=(
    "run_experiments.sh"
    "extract_results.sh"
    "generate_table.sh"
    "clean.sh"
    "help.sh"
)

for script in "${REQUIRED_SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        pass_check "Script: $script"
    else
        fail_check "Script missing or not executable: $script"
    fi
done

# Check optional scripts
OPTIONAL_SCRIPTS=(
    "system_check.sh"
    "audit_system.sh"
    "cleanup_unnecessary.sh"
    "cleanup_optional.sh"
    "verify_and_visualize.sh"
)

for script in "${OPTIONAL_SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        pass_check "Optional script: $script"
    else
        warn_check "Optional script missing: $script"
    fi
done

# Check documentation
DOCS=("README.md" "USER_MANUAL.md" "SETUP_DOCUMENTATION.md" "PROGRESS_REPORT.md" "SYSTEM_OVERVIEW.md")

for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        pass_check "Documentation: $doc"
    else
        warn_check "Documentation missing: $doc"
    fi
done

# Check benchmarks
echo ""
if [ -d "benchmarks" ]; then
    pass_check "${BENCHMARK_DIR}/ directory exists"
    for circuit in $CIRCUITS; do
        if [ -f "${BENCHMARK_DIR}/${circuit}.bench" ]; then
            pass_check "Benchmark: ${circuit}.bench"
        else
            fail_check "Benchmark missing: ${circuit}.bench"
        fi
    done
else
    fail_check "${BENCHMARK_DIR}/ directory missing"
fi

# Check results
echo ""
if [ -d "results" ]; then
    pass_check "${RESULTS_DIR}/ directory exists"
    
    result_count=0
    for circuit in $CIRCUITS; do
        if [ -f "${RESULTS_DIR}/${circuit}_output.log" ]; then
            pass_check "Result log: ${circuit}_output.log"
            ((result_count++))
        else
            warn_check "Result log missing: ${circuit}_output.log (run experiments)"
        fi
    done
    
    if [ -f "${RESULTS_DIR}/SUMMARY.txt" ]; then
        pass_check "SUMMARY.txt exists"
    else
        warn_check "SUMMARY.txt missing (run extract_results.sh)"
    fi
    
    if [ -f "${RESULTS_DIR}/RESULTS_TABLE.md" ]; then
        pass_check "RESULTS_TABLE.md exists"
    else
        warn_check "RESULTS_TABLE.md missing (run generate_table.sh)"
    fi
else
    warn_check "${RESULTS_DIR}/ directory missing (will be created on first run)"
fi

echo ""
echo "=== PHASE 2: FUNCTIONALITY TESTING ==="
echo ""

# Test ATALANTA executable
info_check "Testing ATALANTA executable..."
if ./atalanta -h g > /dev/null 2>&1; then
    pass_check "ATALANTA responds to help command"
else
    fail_check "ATALANTA help command failed"
fi

# Test configuration loading
info_check "Testing configuration file..."
if source config.sh 2>/dev/null; then
    if [ -n "$CIRCUITS" ]; then
        pass_check "Configuration loads and has CIRCUITS defined"
        info_check "Configured circuits: $CIRCUITS"
    else
        fail_check "Configuration missing CIRCUITS variable"
    fi
else
    fail_check "Configuration file has syntax errors"
fi

# Test help system
info_check "Testing help system..."
if [ -f "help.sh" ] && [ -x "help.sh" ]; then
    if grep -q "case" help.sh && grep -q "manual" help.sh; then
        pass_check "help.sh has proper structure"
    else
        warn_check "help.sh may be incomplete"
    fi
fi

echo ""
echo "=== PHASE 3: REDUNDANCY CHECK ==="
echo ""

# Check for duplicate or redundant files
info_check "Checking for redundant files..."

redundant_found=0

# Check for backup files
if ls *.backup 2>/dev/null | grep -q .; then
    warn_check "Backup files found (can be deleted if not needed):"
    ls *.backup 2>/dev/null | sed 's/^/  - /'
    redundant_found=1
fi

# Check for old test logs
if [ -f "*_test.log" ]; then
    warn_check "Old test log: *_test.log (can be deleted)"
    redundant_found=1
fi

# Check for duplicate table files
if [ -f "${RESULTS_DIR}/RESULTS_TABLE_FIXED.md" ] && [ -f "${RESULTS_DIR}/RESULTS_TABLE.md" ]; then
    warn_check "Duplicate: RESULTS_TABLE_FIXED.md (check if different from RESULTS_TABLE.md)"
    redundant_found=1
fi

# Check for build artifacts
if ls *.o 2>/dev/null | grep -q .; then
    warn_check "Build artifacts found (*.o files - can be deleted)"
    redundant_found=1
fi

if [ $redundant_found -eq 0 ]; then
    pass_check "No redundant files found"
fi

echo ""
echo "=== PHASE 4: INTEGRATION TEST ==="
echo ""

info_check "Testing automated workflow..."

# Check if scripts call each other properly
if grep -q "extract_results.sh" run_experiments.sh; then
    pass_check "run_experiments.sh calls extract_results.sh"
else
    fail_check "run_experiments.sh does not call extract_results.sh"
fi

if grep -q "generate_table.sh" extract_results.sh; then
    pass_check "extract_results.sh calls generate_table.sh"
else
    fail_check "extract_results.sh does not call generate_table.sh"
fi

if grep -q "source config.sh" run_experiments.sh; then
    pass_check "Scripts source config.sh properly"
else
    warn_check "Some scripts may not load configuration"
fi

echo ""
echo "=== PHASE 5: RESULTS VALIDATION ==="
echo ""

if [ -d "results" ] && [ -f "${RESULTS_DIR}/RESULTS_TABLE.md" ]; then
    info_check "Validating results table..."
    
    # Check if table has data
    if grep -q "first_circuit" ${RESULTS_DIR}/RESULTS_TABLE.md; then
        pass_check "Results table contains data"
    else
        warn_check "Results table may be empty"
    fi
    
    # Check if table has proper structure
    if grep -q "Circuit.*Inputs.*Outputs.*Gates" ${RESULTS_DIR}/RESULTS_TABLE.md; then
        pass_check "Results table has proper header"
    else
        fail_check "Results table header is malformed"
    fi
    
    # Check for actual numbers
    if grep -q "[0-9]\+\.[0-9]\+" ${RESULTS_DIR}/RESULTS_TABLE.md; then
        pass_check "Results table contains numerical data"
    else
        warn_check "Results table may be missing numerical values"
    fi
fi

echo ""
echo "=========================================="
echo "VERIFICATION SUMMARY"
echo "=========================================="
echo -e "${GREEN}Passed: $PASS${NC}"
if [ $WARN -gt 0 ]; then
    echo -e "${YELLOW}Warnings: $WARN${NC}"
fi
if [ $FAIL -gt 0 ]; then
    echo -e "${RED}Failed: $FAIL${NC}"
fi
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}System is fully functional!${NC}"
else
    echo -e "${RED}System has issues that need attention${NC}"
fi

echo ""
echo "=========================================="
echo "SYSTEM VISUALIZATION"
echo "=========================================="
echo ""

cat << 'EOF'
ATALANTA AUTOMATED EXPERIMENT SYSTEM
====================================

                    [USER]
                      |
                      | edits
                      v
               [config.sh]
                      |
                      | defines
                      v
        +-------------+-------------+
        |                           |
    [CIRCUITS]              [PARAMETERS]
        |                           |
        +-------------+-------------+
                      |
                      | used by
                      v
         [run_experiments.sh] <--- Main Entry Point
                      |
                      | executes
                      v
              +-------+-------+
              |               |
         [atalanta]      [${BENCHMARK_DIR}/]
              |               |
              +-------+-------+
                      |
                      | produces
                      v
                [${RESULTS_DIR}/*.log]
                [${RESULTS_DIR}/*.test]
                      |
                      | analyzed by
                      v
         [extract_results.sh] <--- Auto-called
                      |
                      | creates
                      v
            [${RESULTS_DIR}/SUMMARY.txt]
                      |
                      | formatted by
                      v
         [generate_table.sh] <--- Auto-called
                      |
                      | creates
                      v
        [${RESULTS_DIR}/RESULTS_TABLE.md]
                      |
                      | used in
                      v
              [PROGRESS_REPORT.md]
                      |
                      v
                  [PAPER]


SUPPORTING TOOLS:
-----------------
[help.sh] ---------> Access all documentation
[system_check.sh] -> Verify system integrity
[audit_system.sh] -> Review all files
[clean.sh] --------> Clean results for rerun
[cleanup_*.sh] ----> Remove unnecessary files

DOCUMENTATION:
--------------
[README.md] -------> Quick start
[USER_MANUAL.md] --> Complete guide
[SETUP_DOCUMENTATION.md] -> Setup record
[SYSTEM_OVERVIEW.md] ----> System inventory

WORKFLOW:
---------
1. User edits config.sh (if needed)
2. User runs ./run_experiments.sh
3. System automatically:
   - Runs ATALANTA on each circuit
   - Extracts results
   - Generates formatted table
4. User views ${RESULTS_DIR}/RESULTS_TABLE.md
5. User includes in progress report

EOF

echo ""
echo "=========================================="
echo "REDUNDANCY ANALYSIS"
echo "=========================================="
echo ""

cat << 'EOF'
ESSENTIAL FILES (CANNOT DELETE):
- atalanta (executable)
- config.sh (configuration)
- run_experiments.sh (main runner)
- extract_results.sh (data extraction)
- generate_table.sh (table creation)
- ${BENCHMARK_DIR}/*.bench (your circuits)
- ${RESULTS_DIR}/*.log (experimental data)
- ${RESULTS_DIR}/*.test (test patterns)

USEFUL FILES (KEEP):
- help.sh (convenient help access)
- clean.sh (easy cleanup)
- README.md (quick reference)
- USER_MANUAL.md (detailed guide)
- SETUP_DOCUMENTATION.md (reproducibility)
- PROGRESS_REPORT.md (assignment deliverable)
- SYSTEM_OVERVIEW.md (system documentation)

OPTIONAL FILES (CAN DELETE):
- system_check.sh (verification - useful but not required)
- audit_system.sh (file review - useful but not required)
- cleanup_*.sh (cleanup helpers - useful but not required)

REDUNDANT FILES (SAFE TO DELETE):
- *.backup (old versions if you're confident)
- *_test.log (old test file)
- *.o (build artifacts)
- *.opt, *.positions (build artifacts)
- ${BENCHMARK_DIR}/*.vec (vector files, not needed)

SOURCE FILES (DELETE IF NOT RECOMPILING):
- *.cpp, *.h (source code)
- *.dsp, *.dsw, *.vcproj (build project files)
- data/ (ATALANTA examples, not your benchmarks)
- atalanta_tutorials/ (tutorial files)

RECOMMENDATION:
Keep everything except build artifacts and redundant files.
Run ./cleanup_unnecessary.sh for safe cleanup.
EOF

echo ""
echo "=========================================="
echo "NEXT STEPS"
echo "=========================================="
echo ""
echo "1. If FAILED checks above, fix those issues"
echo "2. Run safe cleanup: ./cleanup_unnecessary.sh"
echo "3. Verify results: cat ${RESULTS_DIR}/RESULTS_TABLE.md"
echo "4. Review progress report: cat PROGRESS_REPORT.md"
echo "5. Submit progress report by Feb 7"
echo ""
