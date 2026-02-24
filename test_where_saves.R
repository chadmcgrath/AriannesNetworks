# Quick test to determine where the P2 script saves its output
cat("Current working directory:", getwd(), "\n")
cat("Script location test\n")

# Check where input files are
if (file.exists("NEO & IPIP - P0_functions.Rdata")) {
  cat("P0_functions.Rdata found in:", getwd(), "\n")
} else {
  cat("P0_functions.Rdata NOT found in:", getwd(), "\n")
}

if (file.exists("NEO & IPIP - P1_nSim50_data_N.RData")) {
  cat("P1_nSim50_data_N.RData found in:", getwd(), "\n")
} else {
  cat("P1_nSim50_data_N.RData NOT found in:", getwd(), "\n")
}

# Test save location
test_save_path <- "NEO & IPIP - P2_nSim50_data_N.RData"
cat("Would save to:", file.path(getwd(), test_save_path), "\n")
cat("Full path:", normalizePath(test_save_path, mustWork = FALSE), "\n")



