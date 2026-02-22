#!/bin/bash
# Help system for ATALANTA Automated Pipeline

# Load config for directory names
if [ -f "config.sh" ]; then
    source config.sh
fi

# Set defaults if not loaded
RESULTS_DIR="${RESULTS_DIR:-results}"

case "$1" in
    "manual"|"")
        less USER_MANUAL.md
        ;;
    "setup")
        less SETUP_DOCUMENTATION.md
        ;;
    "atalanta")
        ./atalanta -h a
        ;;
    "quick")
        cat << EOF
=== QUICK REFERENCE ===

Basic Commands:
  ./run_experiments.sh       - Run all experiments
  ./clean.sh                 - Clean results
  nano config.sh             - Edit configuration
  
View Results:
  cat ${RESULTS_DIR}/SUMMARY.txt         - Raw summary
  cat ${RESULTS_DIR}/RESULTS_TABLE.md    - Formatted table
  
Help:
  ./help.sh manual    - View full user manual
  ./help.sh setup     - View setup documentation
  ./help.sh atalanta  - View ATALANTA manual
  ./help.sh quick     - This quick reference
EOF
        ;;
    *)
        echo "Usage: ./help.sh [manual|setup|atalanta|quick]"
        echo ""
        echo "  manual   - View user manual (default)"
        echo "  setup    - View setup documentation"
        echo "  atalanta - View ATALANTA manual"
        echo "  quick    - Quick reference guide"
        ;;
esac
