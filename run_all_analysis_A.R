# Master script to run all analysis steps for Agreeableness (A) dimension
# This script runs P0, P1, P2, and P3 in sequence to generate all results

cat("========================================\n")
cat("MASTER ANALYSIS SCRIPT - AGREEABLENESS (A)\n")
cat("========================================\n\n")

start_time <- Sys.time()
cat("Start time:", format(start_time), "\n\n")

# Check if we're in the right directory
if (!file.exists("NEO_IPIP_1.csv")) {
  stop("ERROR: NEO_IPIP_1.csv not found. Please run from project root directory.")
}

# ========================================
# STEP 0: Create P0 functions (if needed)
# ========================================
cat("STEP 0: Checking P0 functions...\n")
if (!file.exists("NEO & IPIP - P0_functions.Rdata")) {
  cat("  P0 functions file not found. Creating it...\n")
  source("r_scripts/NEO & IPIP - P0 - all functions.R")
  cat("  P0 functions created.\n")
} else {
  cat("  P0 functions file exists. Skipping creation.\n")
}
cat("\n")

# ========================================
# STEP 1: Data Pre-processing (P1)
# ========================================
cat("STEP 1: Running data pre-processing (P1) for Agreeableness...\n")
p1_start <- Sys.time()
source("r_scripts/NEO & IPIP - P1 - data pre-processing & whole-sample_NEOCA.R")
p1_end <- Sys.time()
p1_duration <- as.numeric(difftime(p1_end, p1_start, units = "mins"))
cat("  P1 completed in", round(p1_duration, 2), "minutes\n")
cat("  Output: NEO & IPIP - P1_nSim50_data_A.RData\n\n")

# ========================================
# STEP 2: Resampling (P2)
# ========================================
cat("STEP 2: Running resampling (P2) for Agreeableness...\n")
p2_start <- Sys.time()
source("r_scripts/NEO & IPIP - P2 - resampling_A.R")
p2_end <- Sys.time()
p2_duration <- as.numeric(difftime(p2_end, p2_start, units = "mins"))
cat("  P2 completed in", round(p2_duration, 2), "minutes\n")
cat("  Output: NEO & IPIP - P2_nSim50_data_A.RData\n\n")

# ========================================
# STEP 3: Network Comparison & Analysis (P3)
# ========================================
cat("STEP 3: Running network comparison & analysis (P3) for Agreeableness...\n")
cat("  WARNING: This step will take 30-60 minutes (network analysis is computationally intensive)\n")
p3_start <- Sys.time()
source("r_scripts/NEO & IPIP - P3 - netcompare & analysis_A.R")
p3_end <- Sys.time()
p3_duration <- as.numeric(difftime(p3_end, p3_start, units = "mins"))
cat("  P3 completed in", round(p3_duration, 2), "minutes\n")
cat("  Output: NEO & IPIP - P3_nSim50_data_all_A.RData\n")
cat("  Output: NEO & IPIP - P3_nSim50_results_all_A.RData\n\n")

# ========================================
# SUMMARY
# ========================================
end_time <- Sys.time()
total_duration <- as.numeric(difftime(end_time, start_time, units = "mins"))

cat("========================================\n")
cat("ALL ANALYSIS STEPS COMPLETED\n")
cat("========================================\n")
cat("Total duration:", round(total_duration, 2), "minutes\n")
cat("End time:", format(end_time), "\n\n")

cat("Generated files:\n")
cat("  1. NEO & IPIP - P0_functions.Rdata\n")
cat("  2. NEO & IPIP - P1_nSim50_data_A.RData\n")
cat("  3. NEO & IPIP - P2_nSim50_data_A.RData\n")
cat("  4. NEO & IPIP - P3_nSim50_data_all_A.RData\n")
cat("  5. NEO & IPIP - P3_nSim50_results_all_A.RData\n\n")

cat("All results are in the project root directory:\n")
cat("  ", getwd(), "\n")

