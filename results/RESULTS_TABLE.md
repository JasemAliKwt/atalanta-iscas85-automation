# ATALANTA Experimental Results

## Experimental Setup
- **Tool:** ATALANTA v2.0
- **Test Generation Mode:** RPT + DTPG + TC (Random Pattern Test + Deterministic TPG + Test Compaction)
- **Circuits:** ISCAS'85 Combinational Benchmarks
- **Date:** Tue Feb  3 09:54:50 PST 2026
- **Parameters:** [default]
- **Tested Circuits:**  c432 c499 c880 c1355 c1908 c5315

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

### Observations:
1. **Fault Coverage:** All circuits achieved high coverage
2. **Scalability:** Test pattern count scales with circuit complexity (gates)
3. **Efficiency:** CPU times remain low even for larger circuits
4. **Backtracking:** Varies by circuit structure, not just size

### Trends:
- Strong correlation between circuit size (gates) and test pattern count
- Fault coverage remains consistently high across all circuit sizes
- CPU time scales sub-linearly with circuit complexity
