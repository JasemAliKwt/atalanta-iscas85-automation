#!/bin/bash
# Clean all results to prepare for fresh run

source config.sh

echo "Cleaning previous results..."
rm -rf $RESULTS_DIR
mkdir -p $RESULTS_DIR
echo "Results directory cleaned and ready for new experiments"
