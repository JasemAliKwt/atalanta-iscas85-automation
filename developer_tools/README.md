# Developer Tools

These scripts are for system maintenance and testing - not for end users.

## Scripts:
- **audit_hardcoding.sh** - Check for hardcoded values in all scripts
- **audit_system.sh** - Complete file system audit
- **system_check.sh** - Verify system integrity (27 checks)
- **verify_and_visualize.sh** - System visualization and verification
- **test_complete_system.sh** - Comprehensive end-to-end testing (20 tests)

## When to use:
- After making changes to automation scripts
- Before releasing updates
- When troubleshooting issues
- To verify everything still works after modifications

## Usage:
```bash
cd developer_tools
./system_check.sh           # Quick verification
./test_complete_system.sh   # Full test suite
./audit_hardcoding.sh       # Check for hardcoding
```

**Note:** These are NOT needed for normal operation.
