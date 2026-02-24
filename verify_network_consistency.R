# Verify the 2.5x finding using "network consistency" metrics
# The paper mentions both edge correlations AND centrality correlations

load("original files/Syntax (Neuroticism networks)/NEO & IPIP - P3_nSim50_results_all_N.RData")

cat(paste(rep("=", 70), collapse=""), "\n")
cat("VERIFYING 2.5X FINDING: Network Consistency\n")
cat("The paper says: 'network consistency' refers to correlations\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

# 1. Edge Correlation (network consistency - edge weights)
cat("1. EDGE CORRELATION (Edge Weight Consistency):\n")
if(exists("output2_N_DD_avg.edgecorr")) {
  df_edge <- output2_N_DD_avg.edgecorr
  val1_edge <- df_edge[df_edge$condition == "0.2_1", "avg.edgecorr_N"]
  val2_edge <- df_edge[df_edge$condition == "0.2_2", "avg.edgecorr_N"]
  val3_edge <- df_edge[df_edge$condition == "0.5_1", "avg.edgecorr_N"]
  
  cat(sprintf("  1-item@84:  %.4f\n", val1_edge))
  cat(sprintf("  2-item@84:  %.4f\n", val2_edge))
  cat(sprintf("  1-item@212: %.4f\n", val3_edge))
  
  agg_edge <- val2_edge - val1_edge
  samp_edge <- val3_edge - val1_edge
  ratio_edge <- agg_edge / samp_edge
  
  cat(sprintf("  Aggregation effect: %.4f\n", agg_edge))
  cat(sprintf("  Sample size effect: %.4f\n", samp_edge))
  cat(sprintf("  Ratio: %.2fx (Expected: 2.5x)\n\n", ratio_edge))
} else {
  cat("  Data not found\n\n")
}

# 2. Centrality Rank Correlation (network consistency - centrality scores)
cat("2. CENTRALITY RANK CORRELATION (Centrality Score Consistency):\n")
if(exists("output3_N_DD_expInfl_avg.rankcorr")) {
  df_cent <- output3_N_DD_expInfl_avg.rankcorr
  val1_cent <- df_cent[df_cent$condition == "0.2_1", "avg.rankcorr_expInfl_N"]
  val2_cent <- df_cent[df_cent$condition == "0.2_2", "avg.rankcorr_expInfl_N"]
  val3_cent <- df_cent[df_cent$condition == "0.5_1", "avg.rankcorr_expInfl_N"]
  
  cat(sprintf("  1-item@84:  %.4f\n", val1_cent))
  cat(sprintf("  2-item@84:  %.4f\n", val2_cent))
  cat(sprintf("  1-item@212: %.4f\n", val3_cent))
  
  agg_cent <- val2_cent - val1_cent
  samp_cent <- val3_cent - val1_cent
  ratio_cent <- agg_cent / samp_cent
  
  cat(sprintf("  Aggregation effect: %.4f\n", agg_cent))
  cat(sprintf("  Sample size effect: %.4f\n", samp_cent))
  cat(sprintf("  Ratio: %.2fx (Expected: 2.5x)\n\n", ratio_cent))
} else {
  cat("  Data not found\n\n")
}

# Summary
cat(paste(rep("=", 70), collapse=""), "\n")
cat("SUMMARY:\n")
cat("The paper claims: 'network consistency' improves 2.5x with aggregation\n")
cat("This refers to correlations (edge weights AND centrality scores)\n")
cat(paste(rep("=", 70), collapse=""), "\n")

