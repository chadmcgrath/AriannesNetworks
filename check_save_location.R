# Quick script to determine where P2 script saves its output
cat("=== Determining P2 Script Save Location ===\n\n")

# Check current working directory
cat("Current working directory:", getwd(), "\n\n")

# Check where input files are
p0_file <- "NEO & IPIP - P0_functions.Rdata"
p1_file <- "NEO & IPIP - P1_nSim50_data_N.RData"

if (file.exists(p0_file)) {
  cat("P0_functions.Rdata found at:", normalizePath(p0_file), "\n")
} else {
  cat("P0_functions.Rdata NOT found in current directory\n")
}

if (file.exists(p1_file)) {
  cat("P1_nSim50_data_N.RData found at:", normalizePath(p1_file), "\n")
} else {
  cat("P1_nSim50_data_N.RData NOT found in current directory\n")
}

# Determine save location
save_file <- "NEO & IPIP - P2_nSim50_data_N.RData"
save_path <- normalizePath(save_file, mustWork = FALSE)

cat("\n=== SAVE LOCATION ===\n")
cat("The P2 script will save to:\n")
cat("  Relative path:", save_file, "\n")
cat("  Absolute path:", save_path, "\n")
cat("  Directory:", dirname(save_path), "\n")



