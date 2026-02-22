# ATALANTA Automated Experiment System - User Manual

**Version:** 1.0
**Date:** February 3, 2026 
**Author:** Jasem Ali 
**Project:** Practical Evaluation of ATALANTA for Single Stuck-At ATPG on ISCAS'85 Benchmarks

---

## Table of Contents
1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [System Architecture](#system-architecture)
4. [Detailed Usage Guide](#detailed-usage-guide)
5. [Modifying Experiments](#modifying-experiments)
6. [Understanding Results](#understanding-results)
7. [Advanced Features](#advanced-features)
8. [Troubleshooting](#troubleshooting)

---

## Overview

This automated system runs ATALANTA (Automatic Test Pattern Generator) on ISCAS'85 benchmark circuits and automatically collects, analyzes, and formats results for research purposes.

### What This System Does:
- Runs ATALANTA on multiple circuits automatically 
- Auto-downloads missing circuits
- Collects fault coverage, test patterns, and runtime data 
- Generates formatted summary tables 
- Provides easy configuration for different experiments 
- Intelligently cleans up unused files

### Prerequisites:
- Ubuntu/Linux environment (WSL on Windows works)
- ATALANTA compiled and working
- Internet connection (for auto-download feature)

---

## Quick Start

### First Time Setup
```bash
# Navigate to ATALANTA directory
cd ~/atalanta-project/Atalanta

# Ensure all scripts are executable
chmod +x *.sh

# Run experiments
./run_experiments.sh
```

### View Results
```bash
# View formatted table
cat results/RESULTS_TABLE.md

# View raw summary
cat results/SUMMARY.txt
```

---

## System Architecture

### File Structure
```
~/atalanta-project/Atalanta/
│
├── atalanta                     # ATALANTA executable
├── benchmarks/                  # Benchmark circuit files
├── results/                     # All experimental results
├── config.sh                    # Configuration file (EDIT THIS)
├── run_experiments.sh           # Main experiment runner
├── extract_results.sh           # Results extractor
├── generate_table.sh            # Table generator
├── clean.sh                     # Clean results directory
├── cleanup_unnecessary.sh       # Remove unused files
├── help.sh                      # Help system
└── *.md                         # Documentation
```

---

## Detailed Usage Guide

### Running Experiments

#### Run Everything (Recommended)
```bash
./run_experiments.sh
```
This automatically:
1. Checks for missing circuits and downloads them
2. Runs ATALANTA on all circuits
3. Collects results
4. Generates summary and tables

#### Clean and Rerun
```bash
./clean.sh
./run_experiments.sh
```

---

## Modifying Experiments

### Changing Which Circuits to Test

Edit `config.sh`:
```bash
nano config.sh
```

Modify the CIRCUITS line:
```bash
# Test only 3 circuits
CIRCUITS="c432 c499 c880"

# Test all 6 circuits
CIRCUITS="c432 c499 c880 c1355 c1908 c5315"
```

Save and run experiments - missing circuits will auto-download!

### Changing ATALANTA Parameters

Edit `config.sh`:
```bash
nano config.sh
```

Available parameters:
- `-b N` : Backtrack limit (default: 10)
- `-r N` : Random pattern packets (default: 16)
- `-L` : Enable learning
- `-s N` : Random seed

Example:
```bash
ATALANTA_FLAGS="-b 20 -r 32"
```

---

## Understanding Results

### Results Table Format
```
| Circuit | Inputs | Outputs | Gates | Levels | Fault Coverage (%) | Test Patterns | Backtrackings | CPU Time (s) |
```

**Column Descriptions:**
- **Fault Coverage (%)**: Percentage of faults detected (higher is better, >95% is excellent)
- **Test Patterns**: Number of test vectors after compaction (fewer is better)
- **Backtrackings**: Search difficulty indicator
- **CPU Time (s)**: Total generation time

---

## Advanced Features

### Auto-Download Missing Circuits

The system automatically downloads missing benchmark circuits when you run experiments.

**How it works:**
1. Add circuit to config.sh: `CIRCUITS="c432 c499 c2670"`
2. Run: `./run_experiments.sh`
3. System auto-downloads c2670 if missing
4. Converts line endings automatically
5. Proceeds with experiments

**Supported Circuits:**
c17, c432, c499, c880, c1355, c1908, c2670, c3540, c5315, c6288, c7552

**Note:** Requires internet connection.

---

### Auto-Cleanup Unused Circuits

Removes files for circuits no longer in your configuration.

**Usage:**
```bash
# 1. Remove circuit from config
nano config.sh
CIRCUITS="c432 c880 c5315"  # removed c499, c1355, c1908

# 2. Run cleanup
./cleanup_unnecessary.sh
```

**What it removes:**
- Unused benchmark files (.bench)
- Unused result logs (_output.log)
- Unused test files (.test)
- Backup files (.backup)
- Build artifacts (.o, .opt, .positions)

**Safety:** Shows what will be removed and requires confirmation.

---

## Troubleshooting

### Common Issues

**Issue: "Permission denied" when running scripts**
```bash
chmod +x *.sh
```

**Issue: "Benchmark file not found"**
- Just run `./run_experiments.sh` - it will auto-download!

**Issue: "INPUT is not valid" error**
- Line ending problem. System auto-fixes during download
- Manual fix: `dos2unix benchmarks/*.bench`

**Issue: Empty results**
```bash
./clean.sh
./run_experiments.sh
```

---

## Quick Reference

### Essential Commands

| Command | Purpose |
|---------|---------|
| `./run_experiments.sh` | Run all experiments |
| `./clean.sh` | Clean results |
| `./cleanup_unnecessary.sh` | Remove unused files |
| `nano config.sh` | Edit configuration |
| `cat results/RESULTS_TABLE.md` | View results |
| `./help.sh` | Access help system |

---

## Summary

For most users, you only need:
1. `./run_experiments.sh` to run experiments
2. `config.sh` to modify settings
3. `results/RESULTS_TABLE.md` for your paper

The system handles everything else automatically!

---

**Document Version:** 1.0 
**Last Updated:** February 2026
