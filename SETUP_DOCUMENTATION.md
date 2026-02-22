# ATALANTA Setup Documentation for Research Paper

**Project:** Practical Evaluation of ATALANTA for Single Stuck-At ATPG on ISCAS'85 Combinational Benchmarks
**Date:** February 3, 2026
**Student:** Jasem Ali

---

## 1. System Environment

### 1.1 Operating System
- **Host OS:** Windows 10/11
- **Virtualization:** Windows Subsystem for Linux (WSL) version 2
- **Linux Distribution:** Ubuntu 24.04 LTS (running on WSL)

### 1.2 Hardware Requirements
- **Virtualization:** Intel VT-x / AMD-V enabled in BIOS
  - For HP computers: Access BIOS → Security → System Security → Enable "Virtualization Technology (VTx)"

---

## 2. Installation Steps

### 2.1 Enable WSL on Windows
1. Open PowerShell as Administrator
2. Run: `wsl --install`
3. Restart computer
4. Open Ubuntu from Start menu
5. Create username and password when prompted

### 2.2 Install Build Tools
After WSL/Ubuntu is ready, install required development tools:
```bash
# Update package lists
sudo apt update

# Install C++ compiler, make, wget, git, and dos2unix
sudo apt install build-essential wget git dos2unix -y
```

**Compiler Version Used:**
- GCC/G++ version: 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04)
- Make version: 4.3 (GNU Make)

---

## 3. ATALANTA Installation

### 3.1 Download ATALANTA Source Code
```bash
# Create project directory
mkdir ~/atalanta-project
cd ~/atalanta-project

# Clone ATALANTA repository
git clone https://github.com/hsluoyz/Atalanta.git
cd Atalanta
```

**ATALANTA Version:** 2.0
**Source:** https://github.com/hsluoyz/Atalanta
**Original Developer:** Dong S. Ha (Virginia Tech)

### 3.2 Compile ATALANTA
```bash
# Compile using make
make
```

**Compilation Notes:**
- Compilation successful with warnings about deprecated 'register' keyword
- Warnings are harmless (related to old C++ code style)
- Executable "atalanta" created successfully

### 3.3 Verify Installation
```bash
# Test ATALANTA
./atalanta -h g
```

---

## 4. Benchmark Circuit Setup

### 4.1 Download ISCAS'85 Benchmark Circuits
Circuits downloaded from TTU (Tallinn University of Technology) mirror:
```bash
# Create benchmarks directory
mkdir benchmarks
cd benchmarks

# Download required ISCAS'85 circuits (in ISCAS89 format)
wget https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/bench/c432.bench
wget https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/bench/c499.bench
wget https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/bench/c880.bench
wget https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/bench/c1355.bench
wget https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/bench/c1908.bench
wget https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/bench/c5315.bench

cd ..
```

**Benchmark Source:** https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/

### 4.2 Fix File Format
ATALANTA requires Unix-style line endings. Convert downloaded files:
```bash
# Convert all benchmark files from DOS to Unix format
dos2unix benchmarks/*.bench
```

**Critical Step:** This conversion was necessary because the downloaded files had Windows-style line endings that caused "INPUT is not valid" errors.

---

## 5. Experimental Setup

### 5.1 ATALANTA Configuration
**Default parameters used (no special flags):**
- Random pattern limit: 16 packets (-r 16)
- Backtrack limit: 10 (-b 10)
- Test pattern generation mode: RPT + DTPG + TC
- Test compaction: REVERSE + SHUFFLE (-c 2)
- Initial seed: Based on system time (-s 0)

### 5.2 Circuits Under Test
Six ISCAS'85 combinational benchmark circuits were used:
- c432, c499, c880, c1355, c1908, c5315

Circuit characteristics (inputs, outputs, gates, levels) are automatically extracted during experiment execution and can be found in `results/RESULTS_TABLE.md` after running experiments.

For detailed circuit specifications, refer to the ISCAS'85 benchmark documentation.

---

## 6. Experiment Execution

### 6.1 Test Run
Initial validation run on c432:
```bash
./atalanta benchmarks/c432.bench
```

**Result:** Successfully generated test patterns (see results/RESULTS_TABLE.md for current metrics)

### 6.2 Automated Batch Execution
Created automation script to run all circuits.

See `run_experiments.sh` for complete implementation.

Key features:
- Auto-downloads missing circuits
- Runs all configured circuits
- Measures runtime
- Automatically processes results

Execute all experiments:
```bash
chmod +x run_experiments.sh
./run_experiments.sh
```

---

## 7. Data Collection

Results stored in `results/` directory:
- `<circuit>_output.log`: Complete ATALANTA output including statistics
- `<circuit>.test`: Generated test patterns

**Key metrics extracted from each log:**
1. Fault coverage (%)
2. Number of test patterns (after compaction)
3. CPU time (seconds)
4. Number of collapsed faults
5. Number of redundant/aborted faults
6. Total number of backtrackings

---

## 8. Reproducibility Notes

### 8.1 Environment Variables
No special environment variables required beyond standard WSL/Ubuntu setup.

### 8.2 Random Seed
ATALANTA uses system time as random seed by default. For reproducible results, specific seed can be set using `-s` flag.

### 8.3 File Locations
- ATALANTA executable: `~/atalanta-project/Atalanta/atalanta`
- Benchmark circuits: `~/atalanta-project/Atalanta/benchmarks/`
- Results: `~/atalanta-project/Atalanta/results/`

---

## 9. Known Issues and Solutions

### Issue 1: "INPUT is not valid" Error
**Cause:** Downloaded benchmark files had Windows-style (CRLF) line endings
**Solution:** Convert using `dos2unix benchmarks/*.bench`

### Issue 2: Virtualization Not Enabled
**Cause:** WSL requires hardware virtualization support
**Solution:** Enable Intel VT-x or AMD-V in BIOS settings

### Issue 3: Compilation Warnings
**Cause:** ATALANTA uses deprecated 'register' keyword
**Impact:** None - warnings can be safely ignored, compilation succeeds

---

## 10. References

1. ATALANTA Source Code: https://github.com/hsluoyz/Atalanta
2. ISCAS'85 Benchmarks: https://www.pld.ttu.ee/~maksim/benchmarks/iscas85/
3. H. K. Lee and D. S. Ha, "On the Generation of Test Patterns for Combinational Circuits," Technical Report No. 12_93, Dep't of Electrical Eng., Virginia Polytechnic Institute and State University, 1993.

---

**End of Setup Documentation**
