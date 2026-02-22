#!/bin/bash
# System Audit Script - Review all files and their purposes

echo "=========================================="
echo "ATALANTA System Audit"
echo "=========================================="
echo ""

echo "=== CORE EXECUTABLE ==="
ls -lh atalanta
echo ""

echo "=== CONFIGURATION FILES ==="
for file in config.sh; do
    if [ -f "$file" ]; then
        echo "FOUND: $file - NEEDED (experiment configuration)"
    fi
done
echo ""

echo "=== AUTOMATION SCRIPTS ==="
SCRIPTS=(
    "run_experiments.sh:Main experiment runner"
    "extract_results.sh:Extract data from logs"
    "generate_table.sh:Generate formatted results table"
    "clean.sh:Clean results for fresh run"
    "help.sh:Help system"
    "system_check.sh:System verification"
    "audit_system.sh:This audit script"
)

for entry in "${SCRIPTS[@]}"; do
    file="${entry%%:*}"
    purpose="${entry##*:}"
    if [ -f "$file" ]; then
        echo "FOUND: $file - $purpose"
    else
        echo "MISSING: $file"
    fi
done
echo ""

echo "=== DOCUMENTATION FILES ==="
DOCS=(
    "README.md:Quick start guide"
    "USER_MANUAL.md:Complete user manual"
    "SETUP_DOCUMENTATION.md:Setup instructions"
    "PROGRESS_REPORT.md:Progress report"
)

for entry in "${DOCS[@]}"; do
    file="${entry%%:*}"
    purpose="${entry##*:}"
    if [ -f "$file" ]; then
        size=$(wc -l < "$file")
        echo "FOUND: $file ($size lines) - $purpose"
    else
        echo "MISSING: $file"
    fi
done
echo ""

echo "=== BACKUP FILES (May be unnecessary) ==="
ls -lh *.backup 2>/dev/null | awk '{print "BACKUP: " $9 " - Can be deleted if not needed"}'
if [ $? -ne 0 ]; then
    echo "  None found"
fi
echo ""

echo "=== OLD/TEMPORARY FILES ==="
echo "Checking for potentially unnecessary files..."
OLD_FILES=(
    "*_test.log"
    "*.old"
    "*.bak"
    "*.tmp"
)

found_old=0
for pattern in "${OLD_FILES[@]}"; do
    files=$(ls $pattern 2>/dev/null)
    if [ -n "$files" ]; then
        echo "OLD FILE: $pattern - Can be deleted"
        found_old=1
    fi
done

if [ $found_old -eq 0 ]; then
    echo "  None found"
fi
echo ""

echo "=== BENCHMARKS DIRECTORY ==="
if [ -d "benchmarks" ]; then
    bench_count=$(ls ${BENCHMARK_DIR}/*.bench 2>/dev/null | wc -l)
    echo "FOUND: ${BENCHMARK_DIR}/ directory"
    echo "  Contains $bench_count .bench files"
    
    # Check for unnecessary files
    other_files=$(ls ${BENCHMARK_DIR}/* 2>/dev/null | grep -v ".bench$" | wc -l)
    if [ $other_files -gt 0 ]; then
        echo "WARNING: Non-.bench files found in benchmarks:"
        ls ${BENCHMARK_DIR}/* | grep -v ".bench$" | sed 's/^/    /'
    fi
fi
echo ""

echo "=== RESULTS DIRECTORY ==="
if [ -d "results" ]; then
    echo "FOUND: ${RESULTS_DIR}/ directory"
    
    # Count different file types
    logs=$(ls ${RESULTS_DIR}/*_output.log 2>/dev/null | wc -l)
    tests=$(ls ${RESULTS_DIR}/*.test 2>/dev/null | wc -l)
    
    echo "  $logs output logs"
    echo "  $tests test pattern files"
    
    if [ -f "${RESULTS_DIR}/SUMMARY.txt" ]; then
        echo "  FOUND: SUMMARY.txt"
    fi
    
    if [ -f "${RESULTS_DIR}/RESULTS_TABLE.md" ]; then
        echo "  FOUND: RESULTS_TABLE.md"
    fi
    
    # Check for duplicates or old versions
    if [ -f "${RESULTS_DIR}/RESULTS_TABLE_FIXED.md" ]; then
        echo "  DUPLICATE: RESULTS_TABLE_FIXED.md - Compare with RESULTS_TABLE.md"
    fi
fi
echo ""

echo "=== ATALANTA SOURCE/BUILD FILES ==="
echo "Checking for unnecessary build artifacts..."
BUILD_FILES=(
    "*.o"
    "*.cpp"
    "*.h"
    "*.dsp"
    "*.dsw"
    "*.vcproj"
    "*.opt"
    "*.positions"
)

build_found=0
for pattern in "${BUILD_FILES[@]}"; do
    count=$(ls $pattern 2>/dev/null | wc -l)
    if [ $count -gt 0 ]; then
        if [ $build_found -eq 0 ]; then
            echo "  Found source/build files (not needed after compilation):"
            build_found=1
        fi
        echo "    $count $pattern files"
    fi
done

if [ $build_found -eq 0 ]; then
    echo "  None found"
fi
echo ""

echo "=== DATA DIRECTORY ==="
if [ -d "data" ]; then
    data_count=$(ls data/*.bench 2>/dev/null | wc -l)
    echo "FOUND: data/ directory"
    echo "  Contains $data_count example circuits"
    echo "  NOTE: These are ATALANTA examples, not your ISCAS'85 benchmarks"
fi
echo ""

echo "=== ATALANTA_TUTORIALS DIRECTORY ==="
if [ -d "atalanta_tutorials" ]; then
    echo "FOUND: atalanta_tutorials/ directory"
    echo "  NOTE: Tutorial files, may not be needed"
fi
echo ""

echo "=========================================="
echo "CLEANUP RECOMMENDATIONS"
echo "=========================================="
echo ""
echo "Files you CAN safely delete:"
echo "  - *.backup files (if you're confident in current version)"
echo "  - *_test.log files (old test logs)"
echo "  - Any duplicate RESULTS_TABLE files"
echo "  - Build artifacts (*.o, *.positions, *.opt, etc.)"
echo ""
echo "Files you should KEEP:"
echo "  - atalanta (executable)"
echo "  - *.sh scripts (automation)"
echo "  - *.md documentation"
echo "  - config.sh (configuration)"
echo "  - ${BENCHMARK_DIR}/ (your circuits)"
echo "  - ${RESULTS_DIR}/ (experimental data)"
echo ""
echo "Files you DON'T need but can keep:"
echo "  - Source files (*.cpp, *.h) - only needed if recompiling"
echo "  - Build project files (*.dsp, *.dsw, *.vcproj)"
echo "  - data/ directory - ATALANTA examples (not your benchmarks)"
echo "  - atalanta_tutorials/ - Tutorial files"
echo ""
echo "To see detailed list of all files:"
echo "  ls -lh"
echo ""
