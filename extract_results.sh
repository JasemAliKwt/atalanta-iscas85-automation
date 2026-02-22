#!/bin/bash
# Automated Results Extraction and Table Generation

# Load configuration
source config.sh

echo "Extracting results from all circuits..."

# Create summary file
echo "=== ATALANTA EXPERIMENTAL RESULTS SUMMARY ===" > $SUMMARY_FILE
echo "Date: $(date)" >> $SUMMARY_FILE
echo "Parameters: $ATALANTA_FLAGS" >> $SUMMARY_FILE
echo "" >> $SUMMARY_FILE

# Extract data for each circuit
for circuit in $CIRCUITS; do
    output_log="${RESULTS_DIR}/${circuit}_output.log"
    
    if [ ! -f "$output_log" ]; then
        echo "WARNING: Output log not found for $circuit"
        continue
    fi
    
    echo "========== $circuit ==========" >> $SUMMARY_FILE
    grep "Number of primary inputs" "$output_log" >> $SUMMARY_FILE
    grep "Number of primary outputs" "$output_log" >> $SUMMARY_FILE
    grep "Number of gates" "$output_log" >> $SUMMARY_FILE
    grep "Level of the circuit" "$output_log" >> $SUMMARY_FILE
    grep "Fault coverage" "$output_log" >> $SUMMARY_FILE
    grep "Number of test patterns" "$output_log" | head -1 >> $SUMMARY_FILE
    grep "Total number of backtrackings" "$output_log" >> $SUMMARY_FILE
    grep -A 4 "5. CPU time" "$output_log" | grep "Total" >> $SUMMARY_FILE
    echo "" >> $SUMMARY_FILE
done

echo "Results extracted to: $SUMMARY_FILE"

# Generate formatted table
./generate_table.sh

echo "Analysis complete!"
