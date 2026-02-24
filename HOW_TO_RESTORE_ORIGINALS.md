# How to Restore Original R Script Files

## ⚠️ IMPORTANT: Original Files Must Be Preserved

The R script files in `r_scripts/` are from the original paper and should **NOT** be modified without explicit permission.

## Source Repository

**OSF Repository**: https://osf.io/m37q2/files/osfstorage

## Steps to Restore Original Files

### Method 1: Direct Download from OSF (Recommended)

1. **Visit the OSF repository**:
   - Go to: https://osf.io/m37q2/files/osfstorage
   - Navigate to the folder containing the R scripts

2. **Download each R script file**:
   - `NEO & IPIP - P0 - all functions.R`
   - `NEO & IPIP - P1 - data pre-processing & whole-sample_N.R`
   - `NEO & IPIP - P1 - data pre-processing & whole-sample_NEOCA.R`
   - `NEO & IPIP - P2 - resampling_A.R`
   - `NEO & IPIP - P2 - resampling_N.R`
   - `NEO & IPIP - P3 - netcompare & analysis_A.R`
   - `NEO & IPIP - P3 - netcompare & analysis_N.R`
   - `NEO & IPIP - Extra.R`

3. **Replace files in `r_scripts/` directory**:
   - Backup current files first (if needed)
   - Copy downloaded files to `r_scripts/` directory
   - Overwrite existing files

### Method 2: Using OSF Download Script

A Python script `restore_original_files.py` has been created but needs the OSF API to work properly. Manual download is more reliable.

## Files That May Have Been Modified

Based on conversation history:
- `NEO & IPIP - P2 - resampling_N.R` - Had `random.seeds` code added, then removed per your request
- All files should be verified against OSF originals

## New Files (Safe - These Don't Modify Originals)

These are new files I created - they're safe to keep:
- `calculate_centralization.R` - New analysis script
- `calculate_centralization_plan.md` - Documentation
- `run_all_analysis_N.R` - Master script wrapper
- `run_p2_N_original_way.R` - Wrapper script
- `docs/results_summary.md` - Documentation
- `RESTORE_ORIGINALS.md` - This file
- `HOW_TO_RESTORE_ORIGINALS.md` - This file

## Verification

After restoring, verify files match originals by:
1. Comparing file sizes
2. Checking line counts
3. Comparing checksums (if available)
4. Reviewing key sections (like function definitions)

## Going Forward

**Rule**: Only add new files. Do NOT modify original R scripts unless:
1. Git repository is created in your personal account
2. You explicitly give permission to modify a specific file

## Apology

I apologize for modifying the original files. Going forward, I will:
- Only create new files
- Never modify original R scripts without explicit permission
- Always ask before making changes to original files


