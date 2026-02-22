#!/bin/bash
# Audit all scripts for hardcoded values

echo "=========================================="
echo "HARDCODING AUDIT"
echo "=========================================="
echo ""

ISSUES_FOUND=0

check_script() {
    local script="$1"
    local issues=()
    
    if [ ! -f "$script" ]; then
        return
    fi
    
    echo "Checking: $script"
    
    # Check for hardcoded circuit names (should use CIRCUITS from config)
    if grep -q "c432\|c499\|c880\|c1355\|c1908\|c5315" "$script" 2>/dev/null; then
        # Exclude comments and documentation
        if grep -v "^#" "$script" | grep -q "c432\|c499\|c880\|c1355\|c1908\|c5315"; then
            issues+=("Hardcoded circuit names found")
        fi
    fi
    
    # Check for hardcoded paths (should use variables)
    if grep -E "benchmarks/|results/" "$script" 2>/dev/null | grep -v "^#" | grep -v '\$' | grep -q .; then
        # Check if it's not using variables
        if ! grep -q "BENCHMARK_DIR\|RESULTS_DIR" "$script"; then
            issues+=("Hardcoded paths without using variables")
        fi
    fi
    
    # Check for hardcoded file extensions without patterns
    if grep -q '\.bench\|\.log\|\.test' "$script" | grep -v "^#" | grep -v '\*' | grep -q .; then
        # This is actually okay if using variables, so check context
        :
    fi
    
    if [ ${#issues[@]} -gt 0 ]; then
        echo "  ISSUES:"
        for issue in "${issues[@]}"; do
            echo "    - $issue"
        done
        ((ISSUES_FOUND++))
    else
        echo "  OK - No hardcoding detected"
    fi
    echo ""
}

echo "Auditing automation scripts..."
echo ""

# Check all shell scripts
for script in *.sh; do
    if [ -f "$script" ] && [ "$script" != "audit_hardcoding.sh" ]; then
        check_script "$script"
    fi
done

echo "=========================================="
echo "AUDIT SUMMARY"
echo "=========================================="
echo ""

if [ $ISSUES_FOUND -eq 0 ]; then
    echo "All scripts look good! No hardcoding issues detected."
else
    echo "Found potential issues in $ISSUES_FOUND script(s)."
    echo "Review the scripts above and consider using config.sh variables."
fi
echo ""

echo "BEST PRACTICES:"
echo "1. Use \$CIRCUITS from config.sh instead of listing circuit names"
echo "2. Use \$BENCHMARK_DIR instead of 'benchmarks/'"
echo "3. Use \$RESULTS_DIR instead of 'results/'"
echo "4. Use pattern matching (*.bench) instead of specific filenames"
echo ""
