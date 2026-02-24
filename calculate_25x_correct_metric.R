# Calculate 2.5x ratio using the CORRECT metric: Centrality Rank Correlation
# This is what the paper actually tested: "consistency in centrality scores"

load("original files/Syntax (Neuroticism networks)/NEO & IPIP - P3_nSim50_results_all_N.RData")

cat(paste(rep("=", 70), collapse=""), "\n")
cat("CALCULATING 2.5X RATIO USING CORRECT METRIC\n")
cat("Metric: Centrality Rank Correlation (consistency in centrality scores)\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

if(exists("output3_N_DD_expInfl_avg.rankcorr")) {
  df <- output3_N_DD_expInfl_avg.rankcorr
  
  # Extract values for the three conditions
  # 0.2_1 = 1-item@84 (sample size 0.2 = 84, 1 item)
  # 0.2_2 = 2-item@84 (sample size 0.2 = 84, 2 items)
  # 0.5_1 = 1-item@212 (sample size 0.5 = 212, 1 item)
  
  val_1item_84 <- df[df$condition == "0.2_1", "avg.rankcorr_expInfl_N"]
  val_2item_84 <- df[df$condition == "0.2_2", "avg.rankcorr_expInfl_N"]
  val_1item_212 <- df[df$condition == "0.5_1", "avg.rankcorr_expInfl_N"]
  
  cat("Values:\n")
  cat(sprintf("  1-item@84:  %.4f\n", val_1item_84))
  cat(sprintf("  2-item@84:  %.4f\n", val_2item_84))
  cat(sprintf("  1-item@212: %.4f\n", val_1item_212))
  cat("\n")
  
  # Calculate effects
  # Aggregation effect: improvement from 1-item to 2-item at same sample size (84)
  agg_effect <- val_2item_84 - val_1item_84
  
  # Sample size effect: improvement from 84 to 212 samples with same aggregation (1-item)
  samp_effect <- val_1item_212 - val_1item_84
  
  # Ratio: how many times larger is aggregation effect compared to sample size effect?
  ratio <- agg_effect / samp_effect
  
  cat("Effects:\n")
  cat(sprintf("  Aggregation effect (1-item@84 → 2-item@84): %.4f\n", agg_effect))
  cat(sprintf("  Sample size effect (1-item@84 → 1-item@212): %.4f\n", samp_effect))
  cat("\n")
  cat("2.5x Ratio Calculation:\n")
  cat(sprintf("  Ratio = %.4f / %.4f = %.2fx\n", agg_effect, samp_effect, ratio))
  cat(sprintf("  Expected (Paper): 2.5x\n"))
  cat("\n")
  
  if(abs(ratio - 2.5) < 0.3) {
    cat("✅ RESULT: SUPPORTS the paper's 2.5x finding!\n")
  } else {
    cat("❌ RESULT: Does NOT support the paper's 2.5x finding\n")
    cat(sprintf("   Ratio (%.2fx) is far from expected 2.5x\n", ratio))
  }
  
} else {
  cat("ERROR: output3_N_DD_expInfl_avg.rankcorr not found\n")
}

