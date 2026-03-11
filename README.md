# ATALANTA Automated Experiment System - By Jasem Ali

**Quick Start:** `./run_experiments.sh`

## Documentation

- **User Manual:** `./help.sh manual` or `less USER_MANUAL.md`
- **Setup Guide:** `./help.sh setup` or `less SETUP_DOCUMENTATION.md`
- **ATALANTA Help:** `./help.sh atalanta` or `./atalanta -h a`
- **Quick Reference:** `./help.sh quick`

## Essential Commands

| Command                        | Purpose                  |
|--------------------------------|--------------------------|
| `./run_experiments.sh`         | Run all experiments      |
| `./clean.sh`                   | Clean results directory  |
| `nano config.sh`               | Edit configuration       |
| `cat results/RESULTS_TABLE.md` | View results             |
| `./help.sh`                    | View help system         |

## Project Structure
```
.
├── atalanta              # ATALANTA executable
├── benchmarks/           # Circuit files
├── results/              # Experimental results
├── config.sh             # Configuration
├── run_experiments.sh    # Main runner
├── help.sh               # Help system
└── *.md                  # Documentation
```

```mermaid
flowchart TD
    A["<b>config.sh</b><br/>Load CIRCUITS, ATALANTA_FLAGS,<br/>BENCHMARK_DIR, RESULTS_DIR"] --> B["Create results/ directory"]
    B --> C{"For each circuit<br/>in CIRCUITS"}
    C --> D{"Benchmark<br/>.bench file exists?"}

    D -- No --> E["Download from<br/>TTU mirror (wget)"]
    E --> F["Convert CRLF → LF<br/>(dos2unix)"]
    F --> G

    D -- Yes --> G["<b>Run ATALANTA</b><br/>./atalanta $ATALANTA_FLAGS<br/>benchmarks/&lt;circuit&gt;.bench"]

    G --> H["Capture stdout →<br/>&lt;circuit&gt;_output.log"]
    H --> I["Move &lt;circuit&gt;.test →<br/>results/"]
    I --> J{"More circuits<br/>in CIRCUITS?"}
    J -- Yes --> C
    J -- No --> K

    subgraph Post-Processing
        K["<b>extract_results.sh</b><br/>Parse logs → SUMMARY.txt"] --> L["<b>generate_table.sh</b><br/>Build RESULTS_TABLE.md"]
        L --> M["<b>generate_progress_report.sh</b><br/>Build PROGRESS_REPORT.md"]
    end
```

For detailed instructions, run: `./help.sh manual`
