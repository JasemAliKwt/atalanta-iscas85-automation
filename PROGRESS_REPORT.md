# Progress Report
## Practical Evaluation of ATALANTA for Single Stuck-At ATPG on ISCAS'85 Combinational Benchmarks

**Student:** Jasem Ali  
**Date:** February 03, 2026  
**Due Date:** February 7, 2026

---

## 1. Project Objectives

The objective of this project is to evaluate the ATALANTA automatic test pattern generator (ATPG) tool on ISCAS'85 combinational benchmark circuits. Specifically, we aim to:

1. Measure fault coverage percentage for each circuit
2. Measure the number of generated test patterns
3. Measure runtime per circuit
4. Analyze how these metrics scale with circuit complexity

---

## 2. Work Completed

### 2.1 Environment Setup - COMPLETE

**Completed:** January 19-23, 2026

- **Operating System:** Ubuntu 24.04 LTS on Windows Subsystem for Linux (WSL)
- **ATALANTA Version:** 2.0
- **Compilation:** Successfully compiled from source using GCC
- **Benchmarks:** Automated download system implemented

**Current Configuration:**
- **Circuits Under Test:** 6 circuits
- **Circuit List:**  c432 c499 c880 c1355 c1908 c5315
- **ATALANTA Parameters:** default parameters (no special flags)

### 2.2 Experimental Execution - COMPLETE

**Completed:** February 03, 2026

All experiments successfully completed using ATALANTA with configured parameters.

**Automation Features Implemented:**
- Automatic circuit download from repository
- Automated experiment execution
- Automatic results extraction
- Automatic table generation
- Intelligent cleanup of unused files

**Results Collection:**
Successfully collected the following metrics for all 6 circuits:
- Fault coverage percentage
- Number of test patterns
- Total CPU time
- Number of backtrackings
- Circuit characteristics (inputs, outputs, gates, levels)

---

## 3. Preliminary Results

## Table 1: Circuit Characteristics and Test Results

| Circuit  | Inputs  | Outputs  | Gates  | Levels  | Fault Coverage (%)  | Test Patterns  | Backtrackings  | CPU Time (s)  |
|----------|---------|----------|--------|---------|---------------------|----------------|----------------|---------------|
| c432     | 36      | 7        | 160    | 17      | 99.046              | 85             | 47             | 0.000         |
| c499     | 41      | 32       | 202    | 11      | 96.570              | 94             | 245            | 0.017         |
| c880     | 60      | 26       | 383    | 24      | 100.000             | 200            | 0              | 0.017         |
| c1355    | 41      | 32       | 546    | 24      | 99.492              | 140            | 175            | 0.033         |
| c1908    | 33      | 25       | 880    | 40      | 99.468              | 193            | 95             | 0.067         |
| c5315    | 178     | 123      | 2307   | 49      | 98.879              | 780            | 87             | 0.317         |

## Analysis

### 3.2 Key Observations

**Fault Coverage:**
- Minimum coverage achieved: 96.570%
- Average coverage: 98.91%
- All circuits achieved high fault coverage
- Demonstrates ATALANTA effectiveness with current parameters

**Test Pattern Count:**
- Strong correlation with circuit size
- Scales with circuit complexity
- Demonstrates efficient test generation

**Runtime Performance:**
- All circuits completed quickly
- CPU time scales sub-linearly with circuit complexity
- Demonstrates efficiency of FAN algorithm

**Circuit-Specific Observations:**
- Backtracking varies by circuit structure, not just size
- Indicates varying fault detection difficulty across circuits

### 3.3 Preliminary Analysis

**Scalability:**
ATALANTA demonstrates good scalability across tested circuit sizes, maintaining consistently high fault coverage.

**Efficiency:**
Low CPU times and reasonable backtracking counts indicate efficient test generation using the FAN algorithm.

**Effectiveness:**
High fault coverage achieved across all circuits validates ATALANTA's effectiveness for combinational circuit ATPG.

**Parameter Impact:**
With parameters: default parameters (no special flags)

---

## 4. Challenges Encountered and Solutions

### 4.1 File Format Issues
**Challenge:** Downloaded benchmark files had Windows-style line endings causing "INPUT is not valid" errors.

**Solution:** Implemented automatic line ending conversion using dos2unix utility. Now handled automatically during download.

### 4.2 Virtualization Support
**Challenge:** WSL installation initially failed due to disabled virtualization in BIOS.

**Solution:** Enabled Intel VT-x in BIOS settings (Security → System Security → Virtualization Technology).

### 4.3 Automation Requirements
**Challenge:** Manual execution and result extraction would be time-consuming and error-prone.

**Solution:** Created fully automated pipeline with:
- Automatic circuit download
- Automated experiment execution
- Automatic result extraction and formatting
- Intelligent file cleanup
- Dynamic configuration management

---

## 5. Work Remaining

### 5.1 Analysis and Discussion (Feb 6-23)
- Detailed analysis of coverage vs. circuit complexity trends
- Investigation of backtracking patterns
- Comparison with expected results from literature
- Discussion of implications and limitations

### 5.2 Final Report (Feb 24 - Mar 10)
- Write complete methodology section
- Expand results and discussion
- Create additional visualizations if needed
- Format according to report requirements
- Proofread and edit

### 5.3 Presentation (Mar 11-13)
- Create presentation slides
- Prepare talking points
- Practice presentation

---

## 6. Timeline Status

| Milestone              | Scheduled         | Actual         | Status       |
|------------------------|-------------------|----------------|--------------|
| Tool Installation      | Jan 19-21         | Jan 19-21      | Complete     |
| Proposal Draft         | Jan 21-23         | Jan 21-23      | Complete     |
| Proposal Submission    | Jan 23            | Jan 23         | Complete     |
| Experiment Runs        | Jan 24 - Feb 2    | Feb 2-3        | Complete     |
| Results Integration    | Feb 2-4           | Feb 3          | Complete     |
| Progress Report        | Feb 4-6           | Feb 3          | Complete     |
| Progress Submission    | Feb 6             | Feb 6-7        | On Schedule  |
| Final Analysis         | Feb 6-23          | -              | Upcoming     |
| Final Report           | Feb 24 - Mar 10   | -              | Upcoming     |
| Presentation Prep      | Mar 11-13         | -              | Upcoming     |
| Final Submission       | Mar 14            | -              | Scheduled    |

**Status:** Ahead of schedule - All experimental work complete

---

## 7. System Innovations

Beyond the basic requirements, this project implemented several advanced features:

**Automated Workflow:**
- One-command experiment execution
- Automatic handling of missing benchmarks
- Self-documenting result generation

**Intelligent System Management:**
- Dynamic configuration system (zero hardcoding)
- Automatic cleanup of unused files
- Integrated verification tools

**Reproducibility:**
- Complete setup documentation
- Automated pipeline ensures consistent results
- Configuration-driven experiments

---

## 8. Conclusion

The project is progressing well and is currently ahead of schedule. All experimental objectives have been met:

- ATALANTA successfully installed and validated  
- All 6 circuits tested  
- Fault coverage, test pattern count, and runtime data collected  
- Automated analysis and reporting system implemented  
- Results showing expected trends  

The preliminary results are promising, showing that ATALANTA achieves high fault coverage (minimum: 96.570%, average: 98.91%) across all tested circuits with efficient runtime performance using parameters: default parameters (no special flags). The next phase will focus on detailed analysis and preparing the final report.

No major obstacles are anticipated for the remaining work. The automated experimental pipeline developed during this phase will facilitate any additional experiments if needed for the final analysis.

---

**Submitted by:** Jasem Ali  
**Date:** February 03, 2026  
**Auto-generated from:** config.sh and experimental results
