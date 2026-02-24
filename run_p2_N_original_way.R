# Replicate the original workflow that worked
# This loads P2_A file first to get random.seeds, then runs P2_N

cat("=== REPLICATING ORIGINAL WORKFLOW ===\n")
cat("This is how P2_N was run successfully before\n\n")

# Step 1: Load P2_A file to get random.seeds into environment
cat("Step 1: Loading P2_A file to get random.seeds...\n")
load("data/NEO & IPIP - P2_nSim50_data_A.RData")

if (exists("random.seeds")) {
  cat("✓ random.seeds loaded from P2_A file\n")
  cat("  Length:", length(random.seeds), "\n")
  cat("  First 3 values:", paste(head(random.seeds, 3), collapse=", "), "\n\n")
  
  # Step 2: Now source P2_N script (it will use random.seeds from environment)
  cat("Step 2: Running P2_N resampling script...\n")
  cat("  (random.seeds is now in environment, so P2_N can use it)\n\n")
  
  source("r_scripts/NEO & IPIP - P2 - resampling_N.R")
  
  cat("\n=== P2_N SCRIPT COMPLETED ===\n")
  cat("Results saved to:", normalizePath("NEO & IPIP - P2_nSim50_data_N.RData", mustWork = FALSE), "\n")
} else {
  stop("ERROR: random.seeds not found in P2_A file. Cannot proceed.")
}



