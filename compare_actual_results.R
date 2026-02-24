# Compare actual R code results with our Python implementation
# Focus on achieving parity, not on 2.5x finding

library(qgraph)
library(bootnet)
library(dplyr)
library(psych)
library(ppcor)
library(RColorBrewer)
library(reshape2)
library(BDgraph)
library(rlist)
library(coefficientalpha)
library(NetworkComparisonTest)

# Load functions
source('r_scripts/NEO & IPIP - P0 - all functions.R')

# Load the actual R results
load('data/NEO & IPIP - P3_nSim50_results_all_N.RData')

cat("=== ACTUAL R CODE RESULTS ===\n")
cat("Neuroticism (N) Results:\n")

# Extract key results for comparison
if(exists('output1_N_DD_avg.glstr')) {
  results <- output1_N_DD_avg.glstr
  
  # Focus on the key conditions: 1-item vs 2-item at different sample sizes
  # Look for conditions that match our Python implementation
  
  # Sample size 84 (0.2 proportion)
  n_02_1 <- results[results$nSamp == "0.2" & grepl("_1$", rownames(results)), ]
  n_02_2 <- results[results$nSamp == "0.2" & grepl("_2$", rownames(results)), ]
  
  # Sample size 212 (0.5 proportion)  
  n_05_1 <- results[results$nSamp == "0.5" & grepl("_1$", rownames(results)), ]
  n_05_2 <- results[results$nSamp == "0.5" & grepl("_2$", rownames(results)), ]
  
  cat("\nSample Size 84 (0.2):\n")
  if(nrow(n_02_1) > 0) {
    cat("1-item: glstr_diff =", n_02_1$avg.glstr_diff, "\n")
  }
  if(nrow(n_02_2) > 0) {
    cat("2-item: glstr_diff =", n_02_2$avg.glstr_diff, "\n")
  }
  
  cat("\nSample Size 212 (0.5):\n")
  if(nrow(n_05_1) > 0) {
    cat("1-item: glstr_diff =", n_05_1$avg.glstr_diff, "\n")
  }
  if(nrow(n_05_2) > 0) {
    cat("2-item: glstr_diff =", n_05_2$avg.glstr_diff, "\n")
  }
  
  # Calculate the exact ratios that our Python code should match
  cat("\n=== R CODE RATIOS ===\n")
  
  # Aggregation effect (1-item to 2-item at same sample size)
  if(nrow(n_05_1) > 0 && nrow(n_05_2) > 0) {
    agg_effect_212 <- n_05_2$avg.glstr_diff / n_05_1$avg.glstr_diff
    cat("Aggregation effect (1→2 items at n=212):", agg_effect_212, "\n")
  }
  
  if(nrow(n_02_1) > 0 && nrow(n_02_2) > 0) {
    agg_effect_84 <- n_02_2$avg.glstr_diff / n_02_1$avg.glstr_diff
    cat("Aggregation effect (1→2 items at n=84):", agg_effect_84, "\n")
  }
  
  # Sample size effect (84 to 212 at same aggregation level)
  if(nrow(n_02_1) > 0 && nrow(n_05_1) > 0) {
    sample_effect_1item <- n_05_1$avg.glstr_diff / n_02_1$avg.glstr_diff
    cat("Sample size effect (84→212 at 1-item):", sample_effect_1item, "\n")
  }
  
  if(nrow(n_02_2) > 0 && nrow(n_05_2) > 0) {
    sample_effect_2item <- n_05_2$avg.glstr_diff / n_02_2$avg.glstr_diff
    cat("Sample size effect (84→212 at 2-item):", sample_effect_2item, "\n")
  }
  
  # Show all available conditions for reference
  cat("\n=== ALL AVAILABLE CONDITIONS ===\n")
  print(results[, c("nSamp", "nSampValue", "avg.glstr_diff")])
}

cat("\n=== PYTHON IMPLEMENTATION TARGET ===\n")
cat("Our Python code should produce these exact same ratios:\n")
cat("- Aggregation effect: Should match R code aggregation ratios\n")
cat("- Sample size effect: Should match R code sample size ratios\n")
cat("- Global strength values: Should match R code glstr_diff values\n")

cat("\n=== PARITY CHECK ===\n")
cat("To achieve parity, our Python implementation must:\n")
cat("1. Use the same sample sizes (84, 212)\n")
cat("2. Use the same item aggregations (1, 2, 3, 5, 8)\n")
cat("3. Produce the same glstr_diff values\n")
cat("4. Produce the same ratio calculations\n")
cat("5. Use the same random seeds for reproducibility\n")





