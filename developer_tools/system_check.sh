#!/bin/bash
# Comprehensive System Verification Script

echo "========================================"
echo "ATALANTA System Verification"
echo "========================================"
echo ""

PASS=0
FAIL=0

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_pass() {
    echo -e "${GREEN} PASS${NC}: $1"
    ((PASS++))
}

check_fail() {
    echo -e "${RED} FAIL${NC}: $1"
    ((FAIL++))
}

check_warn() {
    echo -e "${YELLOW} WARN${NC}: $1"
}

echo "=== 1. Core Files Check ==="

# Check ATALANTA executable
if [ -f "./atalanta" ] && [ -x "./atalanta" ]; then
    check_pass "ATALANTA executable exists and is executable"
else
    check_fail "ATALANTA executable missing or not executable"
fi

# Check configuration file
if [ -f "config.sh" ]; then
    check_pass "Configuration file (config.sh) exists"
    source config.sh
else
    check_fail "Configuration file (config.sh) missing"
fi

# Check automation scripts
SCRIPTS=("run_experiments.sh" "extract_results.sh" "generate_table.sh" "clean.sh" "help.sh")
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        check_pass "Script $script exists and is executable"
    else
        check_fail "Script $script missing or not executable"
    fi
done

# Check documentation files
DOCS=("USER_MANUAL.md" "SETUP_DOCUMENTATION.md" "README.md")
for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        check_pass "Documentation $doc exists"
    else
        check_warn "Documentation $doc missing (optional)"
    fi
done

echo ""
echo "=== 2. Benchmark Files Check ==="

# Check benchmarks directory
if [ -d "$BENCHMARK_DIR" ]; then
    check_pass "Benchmarks directory exists"
    
    # Check individual circuits
    MISSING_CIRCUITS=""
    for circuit in $CIRCUITS; do
        bench_file="${BENCHMARK_DIR}/${circuit}.bench"
        if [ -f "$bench_file" ]; then
            check_pass "Circuit file $circuit.bench exists"
        else
            check_fail "Circuit file $circuit.bench MISSING"
            MISSING_CIRCUITS="$MISSING_CIRCUITS $circuit"
        fi
    done
    
    if [ -n "$MISSING_CIRCUITS" ]; then
        echo ""
        echo "Missing circuits:$MISSING_CIRCUITS"
        echo "Download with: cd benchmarks && wget https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/bench/CIRCUIT.bench"
    fi
else
    check_fail "Benchmarks directory missing"
fi

echo ""
echo "=== 3. Results Directory Check ==="

if [ -d "$RESULTS_DIR" ]; then
    check_pass "Results directory exists"
    
    # Check if results are present
    RESULT_COUNT=$(ls -1 ${RESULTS_DIR}/*_output.log 2>/dev/null | wc -l)
    if [ $RESULT_COUNT -gt 0 ]; then
        check_pass "Found $RESULT_COUNT result files"
        
        # Check for summary and table
        if [ -f "$SUMMARY_FILE" ]; then
            check_pass "Summary file exists"
        else
            check_warn "Summary file missing (run ./extract_results.sh)"
        fi
        
        if [ -f "$TABLE_FILE" ]; then
            check_pass "Results table exists"
        else
            check_warn "Results table missing (run ./extract_results.sh)"
        fi
    else
        check_warn "No results found (run ./run_experiments.sh)"
    fi
else
    check_warn "Results directory doesn't exist (will be created on first run)"
fi

echo ""
echo "=== 4. ATALANTA Functionality Test ==="

# Test ATALANTA with help command
if ./atalanta -h g > /dev/null 2>&1; then
    check_pass "ATALANTA responds to help command"
else
    check_fail "ATALANTA help command failed"
fi

# Test with smallest circuit if available
if [ -f "benchmarks/${circuit}.bench" ]; then
    echo "Testing ATALANTA on ${circuit}.bench..."
    if ./atalanta benchmarks/${circuit}.bench > /tmp/atalanta_test.log 2>&1; then
        if grep -q -i "coverage\|Fault coverage" /tmp/atalanta_test.log; then
            check_pass "ATALANTA successfully generates test patterns"
            rm -f ${circuit}.test /tmp/atalanta_test.log
        else
            check_fail "ATALANTA ran but output format unexpected"
        fi
    else
        check_fail "ATALANTA failed to run on ${circuit}.bench"
    fi
fi

echo ""
echo "=== 5. System Dependencies Check ==="

# Check for required tools
TOOLS=("g++" "make" "wget" "dos2unix")
for tool in "${TOOLS[@]}"; do
    if command -v $tool &> /dev/null; then
        check_pass "Tool '$tool' is installed"
    else
        check_warn "Tool '$tool' is not installed (may be needed for setup)"
    fi
done

echo ""
echo "=== 6. Configuration Check ==="

echo "Current Configuration:"
echo "  Circuits: $CIRCUITS"
echo "  Benchmark Directory: $BENCHMARK_DIR"
echo "  Results Directory: $RESULTS_DIR"
echo "  ATALANTA Flags: ${ATALANTA_FLAGS:-[default]}"

echo ""
echo "========================================"
echo "VERIFICATION SUMMARY"
echo "========================================"
echo -e "${GREEN}Passed: $PASS${NC}"
if [ $FAIL -gt 0 ]; then
    echo -e "${RED}Failed: $FAIL${NC}"
fi
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN} System verification PASSED!${NC}"
    echo "Your system is ready for experiments."
    echo ""
    echo "Next steps:"
    echo "  1. Run experiments: ./run_experiments.sh"
    echo "  2. View results: cat results/RESULTS_TABLE.md"
    echo "  3. For help: ./help.sh"
else
    echo -e "${RED} System verification FAILED!${NC}"
    echo "Please fix the issues above before running experiments."
fi

echo ""
