#!/bin/bash
# Automated ATALANTA Experiment Pipeline with Auto-Download

# Load configuration
source config.sh

# Create results directory
mkdir -p $RESULTS_DIR

# Base URL for ISCAS'85 benchmarks
BENCHMARK_URL="https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/bench"

echo "========================================"
echo "ATALANTA Automated Experiment Pipeline"
echo "Date: $(date)"
echo "Circuits: $CIRCUITS"
echo "Parameters: $ATALANTA_FLAGS"
echo "========================================"
echo ""

# Function to download and prepare benchmark
download_benchmark() {
    local circuit=$1
    local bench_file="${BENCHMARK_DIR}/${circuit}.bench"
    
    if [ ! -f "$bench_file" ]; then
        echo "Benchmark ${circuit}.bench not found. Downloading..."
        
        # Create benchmarks directory if it doesn't exist
        mkdir -p "$BENCHMARK_DIR"
        
        # Download
        if wget -q "${BENCHMARK_URL}/${circuit}.bench" -O "$bench_file"; then
            echo "  Downloaded ${circuit}.bench"
            
            # Convert line endings
            if command -v dos2unix &> /dev/null; then
                dos2unix "$bench_file" 2>/dev/null
                echo "  Converted line endings"
            else
                echo "  WARNING: dos2unix not available, may have line ending issues"
            fi
            
            return 0
        else
            echo "  ERROR: Failed to download ${circuit}.bench"
            echo "  Check if circuit exists at: ${BENCHMARK_URL}/${circuit}.bench"
            return 1
        fi
    else
        echo "Benchmark ${circuit}.bench found"
        return 0
    fi
}

# Check and download benchmarks
echo "=== Checking Benchmarks ==="
for circuit in $CIRCUITS; do
    if ! download_benchmark "$circuit"; then
        echo "ERROR: Cannot proceed without ${circuit}.bench"
        echo "Please verify circuit name or download manually"
        exit 1
    fi
done
echo ""

# Run experiments
for circuit in $CIRCUITS; do
    echo "=========================================="
    echo "Running ${circuit}..."
    echo "=========================================="
    
    bench_file="${BENCHMARK_DIR}/${circuit}.bench"
    output_log="${RESULTS_DIR}/${circuit}_output.log"
    test_file="${circuit}.test"
    
    # Run ATALANTA with timing
    start_time=$(date +%s.%N)
    ./atalanta $ATALANTA_FLAGS "$bench_file" > "$output_log" 2>&1
    end_time=$(date +%s.%N)
    
    # Calculate wall-clock time
    runtime=$(echo "$end_time - $start_time" | bc)
    echo "  Wall-clock runtime: ${runtime} seconds"
    
    # Move test pattern file
    if [ -f "$test_file" ]; then
        mv "$test_file" "${RESULTS_DIR}/"
        echo "  Test patterns saved"
    fi
    
    echo "  ${circuit} complete!"
    echo ""
done

echo "========================================"
echo "All experiments complete!"
echo "Results saved in ${RESULTS_DIR}/"
echo ""
echo "Running automated analysis..."
./extract_results.sh
echo "Generating progress report..."
./generate_progress_report.sh
echo "========================================"
