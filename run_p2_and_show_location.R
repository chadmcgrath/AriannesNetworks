# Script to run P2 resampling and show where results are saved
cat("=== P2 Resampling Script Location Test ===\n")
cat("Current working directory:", getwd(), "\n\n")

# Check if we're in the right directory
if (file.exists("NEO & IPIP - P0_functions.Rdata") && 
    file.exists("NEO & IPIP - P1_nSim50_data_N.RData")) {
  cat("Input files found in current directory\n")
  cat("Script will save to:", file.path(getwd(), "NEO & IPIP - P2_nSim50_data_N.RData"), "\n")
  cat("Full absolute path:", normalizePath("NEO & IPIP - P2_nSim50_data_N.RData", mustWork = FALSE), "\n\n")
  
  # Now source the actual script
  cat("Running P2 resampling script...\n")
  cat("This will take approximately 30-60 minutes...\n")
  source("r_scripts/NEO & IPIP - P2 - resampling_N.R")
  
  cat("\n=== Script completed ===\n")
  cat("Results saved to:", normalizePath("NEO & IPIP - P2_nSim50_data_N.RData", mustWork = FALSE), "\n")
} else {
  cat("ERROR: Input files not found in current directory\n")
  cat("Looking for:\n")
  cat("  - NEO & IPIP - P0_functions.Rdata\n")
  cat("  - NEO & IPIP - P1_nSim50_data_N.RData\n")
  cat("\nPlease run this script from the project root directory\n")
}



