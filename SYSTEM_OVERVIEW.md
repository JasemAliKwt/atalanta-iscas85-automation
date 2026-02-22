# ATALANTA Automated Experiment System - Complete Overview

**Project:** Practical Evaluation of ATALANTA for Single Stuck-At ATPG on ISCAS'85 Benchmarks
**Student:** Jasem Ali
**Last Updated:** February 3, 2026

---

## Directory Structure
```
~/atalanta-project/Atalanta/
│
├── atalanta                          # ATALANTA executable (451KB)
│
├── CONFIGURATION
│   └── config.sh                     # Main configuration file
│
├── AUTOMATION SCRIPTS (8 scripts)
│   ├── run_experiments.sh            # Main experiment runner (calls extract & generate)
│   ├── extract_results.sh            # Extract data from logs (auto-called)
│   ├── generate_table.sh             # Generate formatted table (auto-called)
│   ├── generate_progress_report.sh   # Generate progress report (auto-called)
│   ├── clean.sh                      # Clean results directory
│   ├── help.sh                       # Help system
│   ├── cleanup_unnecessary.sh        # Safe cleanup script
│   └── config.sh                     # Configuration file
│
├── DOCUMENTATION (4 files)
│   ├── README.md                     # Quick start guide
│   ├── USER_MANUAL.md                # Complete manual (260 lines)
│   ├── SETUP_DOCUMENTATION.md        # Setup guide (220 lines)
│   ├── PROGRESS_REPORT.md            # Progress report (203 lines)
│   └── SYSTEM_OVERVIEW.md            # This file
│
├── benchmarks/                       # Your ISCAS'85 circuits
│   ├── c432.bench
│   ├── c499.bench
│   ├── c880.bench
│   ├── c1355.bench
│   ├── c1908.bench
│   └── c5315.bench
│
└── results/                          # Experimental results
    ├── c432_output.log
    ├── c432.test
    ├── c499_output.log
    ├── c499.test
    ├── c880_output.log
    ├── c880.test
    ├── c1355_output.log
    ├── c1355.test
    ├── c1908_output.log
    ├── c1908.test
    ├── c5315_output.log
    ├── c5315.test
    ├── SUMMARY.txt                   # Extracted results summary
    └── RESULTS_TABLE.md              # Formatted results table
```

---

## File Descriptions

### Core Executable

**atalanta**
- The ATALANTA ATPG tool (version 2.0)
- Compiled from source using GCC
- Size: 451KB
- Usage: `./atalanta [options] circuit.bench`

---

### Configuration

**config.sh**
- Central configuration file
- Defines which circuits to test
- Sets ATALANTA parameters
- Specifies directory locations
- **Edit this file to change experiments**

Current configuration:
```bash
CIRCUITS="c432 c499 c880 c1355 c1908 c5315"
BENCHMARK_DIR="benchmarks"
RESULTS_DIR="results"
ATALANTA_FLAGS=""  # Default parameters
```

---

### Automation Scripts

**run_experiments.sh**
- Main experiment runner
- Runs ATALANTA on all configured circuits
- Measures wall-clock time
- Automatically calls extract_results.sh when done
- Usage: `./run_experiments.sh`

**extract_results.sh**
- Parses output logs
- Extracts key metrics (coverage, patterns, runtime)
- Creates SUMMARY.txt
- Automatically calls generate_table.sh
- Usage: `./extract_results.sh`

**generate_table.sh**
- Creates formatted markdown table
- Properly aligned columns
- Includes analysis section
- Output: results/RESULTS_TABLE.md
- Usage: `./generate_table.sh`

**clean.sh**
- Removes all results
- Prepares for fresh experiment run
- Does NOT delete benchmarks or scripts
- Usage: `./clean.sh`

**help.sh**
- Interactive help system
- Access to all documentation
- Usage:
  - `./help.sh` or `./help.sh manual` - User manual
  - `./help.sh setup` - Setup documentation
  - `./help.sh atalanta` - ATALANTA manual
  - `./help.sh quick` - Quick reference

**developer_tools/system_check.sh**
- Verifies system integrity
- Checks all files exist
- Tests ATALANTA functionality
- Reports pass/fail status
- Usage: `cd developer_tools && ./system_check.sh`

**developer_tools/audit_system.sh**
- Reviews all files
- Identifies unnecessary files
- Provides cleanup recommendations
- Usage: `cd developer_tools && ./audit_system.sh`

**cleanup_unnecessary.sh**
- Removes build artifacts safely
- Removes old test logs
- Removes vector files from benchmarks
- Interactive (asks for confirmation)
- Usage: `./cleanup_unnecessary.sh`

- Removes source files (can recompile if needed)
- Removes example data directories
- More aggressive cleanup
- Interactive (asks for confirmation)

---

### Documentation

**README.md** (34 lines)
- Quick start guide
- Essential commands
- Directory structure overview
- Links to detailed documentation

**USER_MANUAL.md** (260 lines)
- Complete user manual
- Detailed usage instructions
- Configuration guide
- Troubleshooting section
- Advanced usage examples

**SETUP_DOCUMENTATION.md** (220 lines)
- Complete environment setup guide
- Installation steps documented
- System requirements
- All commands used during setup
- For reproducibility in research paper

**PROGRESS_REPORT.md** (203 lines)
- Progress report for submission
- Completed work summary
- Preliminary results
- Timeline status
- Next steps
- Ready for submission (Due: Feb 7)

**SYSTEM_OVERVIEW.md**
- This document
- Complete system inventory
- File purposes and relationships
- Workflow documentation

---

### Benchmarks

**benchmarks/** directory contains 6 ISCAS'85 circuits in ISCAS89 format:

| Circuit | Inputs | Outputs | Gates | Description                |
|---------|--------|---------|-------|----------------------------|
| c432    | 36     | 7       | 160   | Priority decoder           |
| c499    | 41     | 32      | 202   | ECAT (error correction)    |
| c880    | 60     | 26      | 383   | ALU circuit                |
| c1355   | 41     | 32      | 546   | ECAT (error correction)    |
| c1908   | 33     | 25      | 880   | Controller circuit         |
| c5315   | 178    | 123     | 2307  | ALU circuit                |

**Note:** These are fixed circuit specifications from the ISCAS'85 benchmark suite, not experimental results.

Source: TTU (Tallinn University of Technology) mirror
URL: https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/

---

### Results

**results/** directory contains:

**Output Logs (6 files):**
- c432_output.log, c499_output.log, c880_output.log, etc.
- Complete ATALANTA output
- Includes all statistics and timing information
- Used by extraction scripts to generate tables

**Test Pattern Files (6 files):**
- c432.test, c499.test, c880.test, etc.
- Generated test patterns (after compaction)
- Can be used for circuit validation
- Format: ISCAS test pattern format

**SUMMARY.txt**
- Extracted results from all circuits
- Raw data in text format
- Automatically generated by extract_results.sh

**RESULTS_TABLE.md**
- Formatted results table
- Ready for inclusion in report
- Includes analysis and observations
- Automatically generated by generate_table.sh

---

## System Workflow

### 1. Normal Experiment Run
```
User runs: ./run_experiments.sh
     ↓
Loads config.sh (which circuits, parameters)
     ↓
For each circuit:
  - Runs ./atalanta benchmarks/CIRCUIT.bench
  - Captures output to results/CIRCUIT_output.log
  - Moves CIRCUIT.test to results/
     ↓
Automatically runs: ./extract_results.sh
     ↓
Parses all logs, creates SUMMARY.txt
     ↓
Automatically runs: ./generate_table.sh
     ↓
Creates formatted RESULTS_TABLE.md
     ↓
Done! Results ready for analysis
```

### 2. Modify and Rerun
```
User edits: config.sh (change parameters or circuits)
     ↓
User runs: ./clean.sh (remove old results)
     ↓
User runs: ./run_experiments.sh (fresh run)
     ↓
New results automatically generated
```

### 3. View Results
```
Option 1: cat results/RESULTS_TABLE.md (formatted table)
Option 2: cat results/SUMMARY.txt (raw data)
Option 3: cat results/c432_output.log (detailed log for one circuit)
```

### 4. Get Help
```
./help.sh           → User manual
./help.sh setup     → Setup guide
./help.sh atalanta  → ATALANTA manual
./help.sh quick     → Quick reference
```

---

## Experimental Data Summary

### Current Results

To see current experimental results, run:
```bash
cat results/RESULTS_TABLE.md
```

Or view the summary:
```bash
cat results/SUMMARY.txt
```

Results are automatically generated from the latest experiment run.

---

## System Capabilities

### What You Can Do

1. **Run Experiments**
   - Single circuit: `./atalanta benchmarks/c432.bench`
   - All circuits: `./run_experiments.sh`

2. **Modify Experiments**
   - Edit `config.sh` to change circuits or parameters
   - Clean and rerun for fresh results

3. **Analyze Results**
   - View formatted table: `cat results/RESULTS_TABLE.md`
   - View raw data: `cat results/SUMMARY.txt`
   - View detailed logs: `cat results/c432_output.log`

4. **Access Documentation**
   - Quick start: `cat README.md`
   - Full manual: `./help.sh manual`
   - Setup guide: `./help.sh setup`


5. **Maintain System**
   - Clean results: `./clean.sh`
   - Safe cleanup: `./cleanup_unnecessary.sh`

---

## ATALANTA Parameters Available

You can modify experiments by editing `config.sh` and setting `ATALANTA_FLAGS`:

| Parameter | Description              | Default | Example      |
|-----------|--------------------------|---------|--------------|
| `-b N`    | Backtrack limit          | 10      | `-b 20`      |
| `-B N`    | Dynamic backtrack limit  | 0       | `-B 30`      |
| `-r N`    | Random pattern packets   | 16      | `-r 32`      |
| `-c N`    | Compaction shuffle limit | 2       | `-c 5`       |
| `-s N`    | Random seed              | time    | `-s 12345`   |
| `-L`      | Enable learning          | off     | `-L`         |
| `-D N`    | Diagnostic mode          | off     | `-D 20`      |

Example configuration for high backtrack limit:
````bash
ATALANTA_FLAGS="-b 20 -B 40"
```

---

## Dependencies

**Required:**
- Ubuntu/Linux (WSL works)
- GCC/G++ (for compilation)
- Make
- Bash

**Installed:**
- dos2unix (for file format conversion)
- wget (for downloading benchmarks)
- git (for ATALANTA source)

---

## Access from Windows

Your Ubuntu files are accessible from Windows at:
```
\\wsl$\Ubuntu\home\jasemali\atalanta-project\Atalanta\
```

Or in File Explorer: Type `\\wsl$` in address bar

You can copy files to Windows desktop from there.

---

## Project Status

**Completed:**
- Environment setup
- ATALANTA installation
- Benchmark download
- Automation system creation
- All experiments run
- Results collected and analyzed
- Documentation complete

**Current Phase:**
- Progress report ready for submission

**Next Steps:**
- Submit progress report (Due: Feb 7)
- Final analysis (Feb 6-23)
- Final report (Feb 24 - Mar 10)
- Presentation (Mar 11-13)

---

## Quick Command Reference
```bash
# Run everything
./run_experiments.sh

# Clean and rerun
./clean.sh && ./run_experiments.sh

# View results
cat results/RESULTS_TABLE.md

# Get help
./help.sh



# Configure experiments
nano config.sh
```

---

**Document Version:** 1.0
**Last Updated:** February 3, 2026
