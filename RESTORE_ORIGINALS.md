# Restoring Original R Script Files

## Important: Original Files Must Not Be Modified

The original R script files from the Herrera-Bennett & Rhemtulla (2021) paper should **NOT** be modified. 

## Source

Original files are available from the OSF repository:
- **Repository**: https://osf.io/m37q2
- **Direct link**: https://osf.io/m37q2/files/osfstorage

## Files That Need to Be Restored

The following R script files should be restored to their original state from OSF:

1. `r_scripts/NEO & IPIP - P0 - all functions.R`
2. `r_scripts/NEO & IPIP - P1 - data pre-processing & whole-sample_N.R`
3. `r_scripts/NEO & IPIP - P1 - data pre-processing & whole-sample_NEOCA.R`
4. `r_scripts/NEO & IPIP - P2 - resampling_A.R`
5. `r_scripts/NEO & IPIP - P2 - resampling_N.R` ⚠️ **KNOWN TO BE MODIFIED**
6. `r_scripts/NEO & IPIP - P3 - netcompare & analysis_A.R`
7. `r_scripts/NEO & IPIP - P3 - netcompare & analysis_N.R`
8. `r_scripts/NEO & IPIP - Extra.R`

## How to Restore

### Option 1: Manual Download from OSF

1. Visit: https://osf.io/m37q2/files/osfstorage
2. Navigate to the folder containing the R scripts
3. Download each `.R` file
4. Replace the files in `r_scripts/` directory

### Option 2: Using OSF API (if available)

The OSF API can be used to programmatically download files, but manual download is recommended to ensure you get the exact originals.

## Current Status

- ⚠️ `NEO & IPIP - P2 - resampling_N.R` was modified (random.seeds code was added, then removed per user request)
- All other files should be checked against OSF originals

## New Files (Safe to Add)

These are new files I created - they don't modify originals:
- `calculate_centralization.R` - New analysis script
- `calculate_centralization_plan.md` - Documentation
- `run_all_analysis_N.R` - Master script (new)
- `run_p2_N_original_way.R` - Wrapper script (new)
- `docs/results_summary.md` - Documentation (new)
- `restore_original_files.py` - Utility script (new)

## Next Steps

1. Download original files from OSF
2. Replace modified files in `r_scripts/`
3. Verify all files match originals
4. Create git repository in personal account
5. Only then can originals be modified (with explicit permission)


