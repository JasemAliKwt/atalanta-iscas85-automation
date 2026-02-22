#!/bin/bash
# Complete End-to-End System Test
# Tests all automation features

echo "=========================================="
echo "COMPLETE SYSTEM TEST"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0

pass_test() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASS++))
}

fail_test() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAIL++))
}

info_test() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

echo "=== TEST 1: Backup Current System ==="
info_test "Backing up current configuration..."
cp config.sh config.sh.test_backup
cp -r results results.test_backup
pass_test "Backup created"
echo ""

echo "=== TEST 2: System Check ==="
info_test "Running system verification..."
if ./system_check.sh > /tmp/system_check.log 2>&1; then
    if grep -q "Passed:" /tmp/system_check.log; then
        pass_test "System check passed"
    else
        fail_test "System check has issues"
    fi
else
    fail_test "System check failed to run"
fi
echo ""

echo "=== TEST 3: Configuration Change Test ==="
info_test "Testing with reduced circuit set (c432, c880, c5315)..."

# Modify config temporarily
cat > config.sh << 'EOF'
#!/bin/bash
# ATALANTA Experiment Configuration

CIRCUITS="c432 c880 c5315"
BENCHMARK_DIR="benchmarks"
RESULTS_DIR="results"
ATALANTA_FLAGS=""
SUMMARY_FILE="${RESULTS_DIR}/SUMMARY.txt"
TABLE_FILE="${RESULTS_DIR}/RESULTS_TABLE.md"
EOF

pass_test "Configuration modified to 3 circuits"
echo ""

echo "=== TEST 4: Auto-Download Test ==="
info_test "Removing c5315 to test auto-download..."
rm -f benchmarks/c5315.bench
if [ ! -f "benchmarks/c5315.bench" ]; then
    pass_test "c5315.bench removed"
else
    fail_test "Failed to remove c5315.bench"
fi
echo ""

echo "=== TEST 5: Run Complete Experiment Pipeline ==="
info_test "Running experiments with auto-download..."
if ./run_experiments.sh > /tmp/run_test.log 2>&1; then
    # Check if c5315 was downloaded
    if [ -f "benchmarks/c5315.bench" ]; then
        pass_test "Auto-download worked - c5315.bench downloaded"
    else
        fail_test "Auto-download failed"
    fi
    
    # Check results were generated
    if [ -f "results/c432_output.log" ] && [ -f "results/c880_output.log" ] && [ -f "results/c5315_output.log" ]; then
        pass_test "All result logs generated"
    else
        fail_test "Some result logs missing"
    fi
    
    # Check SUMMARY.txt
    if [ -f "results/SUMMARY.txt" ]; then
        NUM_CIRCUITS_IN_SUMMARY=$(grep "========== c" results/SUMMARY.txt | wc -l)
        if [ "$NUM_CIRCUITS_IN_SUMMARY" -eq 3 ]; then
            pass_test "SUMMARY.txt contains exactly 3 circuits"
        else
            fail_test "SUMMARY.txt has $NUM_CIRCUITS_IN_SUMMARY circuits (expected 3)"
        fi
    else
        fail_test "SUMMARY.txt not generated"
    fi
    
    # Check RESULTS_TABLE.md
    if [ -f "results/RESULTS_TABLE.md" ]; then
        if grep -q "c432" results/RESULTS_TABLE.md && grep -q "c880" results/RESULTS_TABLE.md && grep -q "c5315" results/RESULTS_TABLE.md; then
            pass_test "RESULTS_TABLE.md contains all 3 circuits"
        else
            fail_test "RESULTS_TABLE.md missing some circuits"
        fi
        
        # Should NOT contain c499, c1355, c1908
        if grep -q "c499\|c1355\|c1908" results/RESULTS_TABLE.md; then
            fail_test "RESULTS_TABLE.md contains old circuits that should be removed"
        else
            pass_test "RESULTS_TABLE.md does not contain old circuits"
        fi
    else
        fail_test "RESULTS_TABLE.md not generated"
    fi
    
    # Check PROGRESS_REPORT.md
        # Save generated report before restore
        cp PROGRESS_REPORT.md /tmp/test5_progress.md
    if [ -f "PROGRESS_REPORT.md" ]; then
        if grep -E -q "Circuits Under Test:.*3 circuits" /tmp/test5_progress.md && grep -E -q "Circuit List:.*c432 c880 c5315" /tmp/test5_progress.md; then
            pass_test "PROGRESS_REPORT.md reflects new configuration"
        else
            fail_test "PROGRESS_REPORT.md not updated correctly"
        fi
        
        # Check if it has today's date
        CURRENT_DATE=$(date '+%B %d, %Y')
        if grep -q "$CURRENT_DATE" PROGRESS_REPORT.md; then
            pass_test "PROGRESS_REPORT.md has current date"
        else
            fail_test "PROGRESS_REPORT.md has incorrect date"
        fi
    else
        fail_test "PROGRESS_REPORT.md not generated"
    fi
else
    fail_test "Experiment pipeline failed to run"
fi
echo ""

echo "=== TEST 6: Cleanup Test ==="
info_test "Checking for unused circuit files..."
# Old circuits (c499, c1355, c1908) should still have results
OLD_CIRCUITS="c499 c1355 c1908"
for circuit in $OLD_CIRCUITS; do
    if [ -f "results/${circuit}_output.log" ]; then
        info_test "Found old result: ${circuit}_output.log"
    fi
done

info_test "Running cleanup to remove unused circuits..."
echo "y" | ./cleanup_unnecessary.sh > /tmp/cleanup_test.log 2>&1

# Check if old circuits were removed
CLEANED=0
for circuit in $OLD_CIRCUITS; do
    if [ ! -f "results/${circuit}_output.log" ]; then
        ((CLEANED++))
    fi
done

if [ $CLEANED -eq 3 ]; then
    pass_test "Cleanup removed all unused circuit results"
else
    fail_test "Cleanup removed $CLEANED/3 unused circuits"
fi
echo ""

echo "=== TEST 7: Restore Original System ==="
info_test "Restoring original configuration..."
cp config.sh.test_backup config.sh
rm -rf results
cp -r results.test_backup results

if [ -f "config.sh" ] && [ -d "results" ]; then
    pass_test "Original system restored"
else
    fail_test "Failed to restore original system"
fi
echo ""

echo "=== TEST 8: ATALANTA Parameters Test ==="
info_test "Testing with modified ATALANTA parameters..."

# Modify config with different parameters
cat > config.sh << 'EOF'
#!/bin/bash
# ATALANTA Experiment Configuration

CIRCUITS="c432 c880"
BENCHMARK_DIR="benchmarks"
RESULTS_DIR="results"
ATALANTA_FLAGS="-b 20 -r 32"
SUMMARY_FILE="${RESULTS_DIR}/SUMMARY.txt"
TABLE_FILE="${RESULTS_DIR}/RESULTS_TABLE.md"
EOF

pass_test "Configuration modified with ATALANTA_FLAGS=\"-b 20 -r 32\""
echo ""

info_test "Running experiments with new parameters..."
./clean.sh > /dev/null 2>&1

if ./run_experiments.sh > /tmp/param_test.log 2>&1; then
    # Check if results were generated
    if [ -f "results/c432_output.log" ]; then
        pass_test "Experiments completed with new parameters"
        
        # Check if parameters affected results (backtrack limit should be different)
        if grep -q "Backtrack limit" results/c432_output.log; then
            pass_test "ATALANTA ran with parameters (backtrack limit visible in logs)"
        else
            info_test "Could not verify parameter usage in logs"
        fi
    else
        fail_test "Experiments failed with new parameters"
    fi
    
    # Check if PROGRESS_REPORT.md shows the parameters
        # Save generated report before restore
        cp PROGRESS_REPORT.md /tmp/test8_progress.md
    if [ -f "PROGRESS_REPORT.md" ]; then
        if grep -E -q "ATALANTA Parameters:.*-b 20 -r 32" /tmp/test8_progress.md; then
            pass_test "PROGRESS_REPORT.md shows new ATALANTA parameters"
        else
            fail_test "PROGRESS_REPORT.md does not show new parameters"
        fi
    else
        fail_test "PROGRESS_REPORT.md not generated"
    fi
    
    # Check if results table was generated
    if [ -f "results/RESULTS_TABLE.md" ]; then
        NUM_CIRCUITS_IN_TABLE=$(grep -c "^| c" results/RESULTS_TABLE.md)
        if [ "$NUM_CIRCUITS_IN_TABLE" -eq 2 ]; then
            pass_test "RESULTS_TABLE.md correctly shows 2 circuits"
        else
            fail_test "RESULTS_TABLE.md shows $NUM_CIRCUITS_IN_TABLE circuits (expected 2)"
        fi
    else
        fail_test "RESULTS_TABLE.md not generated"
    fi
else
    fail_test "Experiment pipeline failed with new parameters"
fi
echo ""

info_test "Restoring system for final verification..."
cp config.sh.test_backup config.sh
rm -rf results
cp -r results.test_backup results
echo ""

echo "=== TEST 9: Final Verification ==="
info_test "Verifying restored system..."
source config.sh
NUM_CIRCUITS=$(echo $CIRCUITS | wc -w)
if [ "$NUM_CIRCUITS" -eq 6 ]; then
    pass_test "Configuration restored to 6 circuits"
else
    fail_test "Configuration shows $NUM_CIRCUITS circuits (expected 6)"
fi

if [ -f "results/c499_output.log" ]; then
    pass_test "Original results restored"
else
    fail_test "Original results not fully restored"
fi
echo ""

echo "=========================================="
echo "TEST SUMMARY"
echo "=========================================="
echo -e "${GREEN}Passed: $PASS${NC}"
if [ $FAIL -gt 0 ]; then
    echo -e "${RED}Failed: $FAIL${NC}"
fi
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}ALL TESTS PASSED!${NC}"
    echo "Your system is fully functional and automated."
else
    echo -e "${RED}SOME TESTS FAILED!${NC}"
    echo "Please review the failures above."
fi

echo ""
echo "Test logs saved in:"
echo "  - /tmp/system_check.log"
echo "  - /tmp/run_test.log"
echo "  - /tmp/cleanup_test.log"
echo "  - /tmp/param_test.log"
