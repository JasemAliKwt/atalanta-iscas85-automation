#!/bin/bash
# Dynamic cleanup script - automatically detects and removes redundant files

echo "=========================================="
echo "ATALANTA Dynamic Cleanup"
echo "=========================================="
echo ""

# Load configuration to know which circuits are active
source config.sh

echo "Scanning for redundant files..."
echo ""

CLEANUP_LIST=()
CLEANUP_DESC=()

# Function to add file to cleanup list
add_to_cleanup() {
    local file="$1"
    local desc="$2"
    CLEANUP_LIST+=("$file")
    CLEANUP_DESC+=("$desc")
}

# Scan for backup files
for file in *.backup; do
    if [ -f "$file" ]; then
        add_to_cleanup "$file" "Backup file"
    fi
done

# Scan for old/temp files with common patterns
for pattern in "*.old" "*.bak" "*.tmp" "*_test.log"; do
    for file in $pattern; do
        if [ -f "$file" ] && [ "$file" != "*.old" ] && [ "$file" != "*.bak" ] && [ "$file" != "*.tmp" ] && [ "$file" != "*_test.log" ]; then
            add_to_cleanup "$file" "Old/temporary file"
        fi
    done
done

# Scan for build artifacts
for pattern in "*.o" "*.opt" "*.positions"; do
    for file in $pattern; do
        if [ -f "$file" ] && [ "$file" != "*.o" ] && [ "$file" != "*.opt" ] && [ "$file" != "*.positions" ]; then
            add_to_cleanup "$file" "Build artifact"
        fi
    done
done

# Scan for vector files in benchmarks
if [ -d "$BENCHMARK_DIR" ]; then
    for file in $BENCHMARK_DIR/*.vec; do
        if [ -f "$file" ]; then
            add_to_cleanup "$file" "Vector file (not needed)"
        fi
    done
fi

# NEW: Check for unused circuit files (not in current config)
echo "Checking for unused circuits..."

# Get list of circuits from benchmark files
if [ -d "$BENCHMARK_DIR" ]; then
    for bench_file in $BENCHMARK_DIR/*.bench; do
        if [ -f "$bench_file" ]; then
            circuit=$(basename "$bench_file" .bench)
            
            # Check if this circuit is in the active CIRCUITS list
            if ! echo "$CIRCUITS" | grep -qw "$circuit"; then
                add_to_cleanup "$bench_file" "Unused circuit (not in config.sh)"
            fi
        fi
    done
fi

# Check for result files from unused circuits
if [ -d "$RESULTS_DIR" ]; then
    for result_file in $RESULTS_DIR/*_output.log; do
        if [ -f "$result_file" ]; then
            circuit=$(basename "$result_file" _output.log)
            
            # Check if this circuit is in the active CIRCUITS list
            if ! echo "$CIRCUITS" | grep -qw "$circuit"; then
                add_to_cleanup "$result_file" "Unused result log (circuit not in config.sh)"
                
                # Also check for associated test file
                test_file="$RESULTS_DIR/${circuit}.test"
                if [ -f "$test_file" ]; then
                    add_to_cleanup "$test_file" "Unused test file (circuit not in config.sh)"
                fi
            fi
        fi
    done
fi

# Check for duplicate result tables
if [ -f "results/RESULTS_TABLE_FIXED.md" ] && [ -f "results/RESULTS_TABLE.md" ]; then
    if cmp -s "results/RESULTS_TABLE.md" "results/RESULTS_TABLE_FIXED.md"; then
        add_to_cleanup "results/RESULTS_TABLE_FIXED.md" "Duplicate table (identical to RESULTS_TABLE.md)"
    fi
fi

# Display what will be removed
if [ ${#CLEANUP_LIST[@]} -eq 0 ]; then
    echo "No redundant files found. System is clean!"
    exit 0
fi

echo "Found ${#CLEANUP_LIST[@]} redundant file(s):"
echo ""

for i in "${!CLEANUP_LIST[@]}"; do
    echo "  [$((i+1))] ${CLEANUP_LIST[$i]}"
    echo "      Reason: ${CLEANUP_DESC[$i]}"
done

echo ""
echo "Active circuits in config.sh: $CIRCUITS"
echo ""
read -p "Remove these files? (y/n): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "Removing files..."
echo ""

for i in "${!CLEANUP_LIST[@]}"; do
    file="${CLEANUP_LIST[$i]}"
    if rm -f "$file"; then
        echo "Removed: $file"
    else
        echo "Failed to remove: $file"
    fi
done

echo ""
echo "Cleanup complete!"
echo ""
