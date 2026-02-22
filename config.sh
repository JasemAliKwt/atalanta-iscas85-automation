#!/bin/bash
# ATALANTA Experiment Configuration
# Edit this file to change circuits, parameters, or directories

# Circuits to test (add/remove as needed)
CIRCUITS=" c432 c499 c880 c1355 c1908 c5315"

# Directories
BENCHMARK_DIR="benchmarks"
RESULTS_DIR="results"

ATALANTA_FLAGS=""  # Default: no special flags (uncomment examples below to use)
# ATALANTA Parameters - modify these to change test generation behavior
# ATALANTA_FLAGS=""  # Default: no special flags
# Examples:
# ATALANTA_FLAGS="-b 20"           # Change backtrack limit to 20
# ATALANTA_FLAGS="-r 32"           # Change random patterns to 32
# ATALANTA_FLAGS="-D 10"           # Diagnostic mode with 10 patterns per fault
# ATALANTA_FLAGS="-c 0"            # No test compaction

# Output files
SUMMARY_FILE="${RESULTS_DIR}/SUMMARY.txt"
TABLE_FILE="${RESULTS_DIR}/RESULTS_TABLE.md"
