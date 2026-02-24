# Verify: Do 2-item@84 and 1-item@212 produce the SAME network consistency?
# The paper claims they should be comparable/equal

load("original files/Syntax (Neuroticism networks)/NEO & IPIP - P3_nSim50_results_all_N.RData")

cat(paste(rep("=", 70), collapse=""), "\n")
cat("VERIFYING: Do 2-item@84 and 1-item@212 produce the SAME network consistency?\n")
cat("The paper says they should be 'comparable' or 'the same'\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

# 1. Edge Correlation
cat("1. EDGE CORRELATION (Network Consistency - Edge Weights):\n")
if(exists("output2_N_DD_avg.edgecorr")) {
  df_edge <- output2_N_DD_avg.edgecorr
  val_2item_84 <- df_edge[df_edge$condition == "0.2_2", "avg.edgecorr_N"]
  val_1item_212 <- df_edge[df_edge$condition == "0.5_1", "avg.edgecorr_N"]
  
  cat(sprintf("  2-item@84:  %.4f\n", val_2item_84))
  cat(sprintf("  1-item@212: %.4f\n", val_1item_212))
  cat(sprintf("  Difference: %.4f\n", abs(val_2item_84 - val_1item_212)))
  cat(sprintf("  Are they the same? %s\n", ifelse(abs(val_2item_84 - val_1item_212) < 0.05, "YES (within 0.05)", "NO")))
  cat("\n")
}

# 2. Centrality Rank Correlation
cat("2. CENTRALITY RANK CORRELATION (Network Consistency - Centrality Scores):\n")
if(exists("output3_N_DD_expInfl_avg.rankcorr")) {
  df_cent <- output3_N_DD_expInfl_avg.rankcorr
  val_2item_84 <- df_cent[df_cent$condition == "0.2_2", "avg.rankcorr_expInfl_N"]
  val_1item_212 <- df_cent[df_cent$condition == "0.5_1", "avg.rankcorr_expInfl_N"]
  
  cat(sprintf("  2-item@84:  %.4f\n", val_2item_84))
  cat(sprintf("  1-item@212: %.4f\n", val_1item_212))
  cat(sprintf("  Difference: %.4f\n", abs(val_2item_84 - val_1item_212)))
  cat(sprintf("  Are they the same? %s\n", ifelse(abs(val_2item_84 - val_1item_212) < 0.05, "YES (within 0.05)", "NO")))
  cat("\n")
}

# Check what the paper actually says
cat(paste(rep("=", 70), collapse=""), "\n")
cat("PAPER'S CLAIM:\n")
cat("'strength of correlations were comparable when networks were estimated\n")
cat("with single-item indicators at n = 212 cases (r's = 0.53, 0.47, and 0.31, resp.),\n")
cat("or when networks were estimated with 2-item indicators at n = 84 cases\n")
cat("(r's = 0.51, 0.46, and 0.39, resp.)'\n")
cat("\n")
cat("So the paper is saying: 2-item@84 ≈ 1-item@212 (they produce similar values)\n")
cat(paste(rep("=", 70), collapse=""), "\n")

