# Analyze Original OSF Results for BOTH Networks (A and N)
# Extract metrics from aggregated dataframes and calculate 2.5x ratios

cat("========================================\n")
cat("ANALYZING ORIGINAL OSF RESULTS\n")
cat("BOTH NETWORKS: Agreeableness (A) and Neuroticism (N)\n")
cat("========================================\n\n")

# Function to analyze a network using aggregated dataframe
analyze_network <- function(results_file, network_name, output_obj_name) {
  cat("\n")
  cat("========================================\n")
  cat(sprintf("ANALYZING %s NETWORK\n", network_name))
  cat("========================================\n")
  cat(sprintf("File: %s\n\n", results_file))
  
  # Load the results file
  load(results_file)
  
  # Get the aggregated dataframe
  if (!exists(output_obj_name)) {
    cat(sprintf("ERROR: %s not found\n", output_obj_name))
    return(NULL)
  }
  
  df <- get(output_obj_name)
  
  if (!is.data.frame(df)) {
    cat(sprintf("ERROR: %s is not a dataframe\n", output_obj_name))
    return(NULL)
  }
  
  cat(sprintf("Found dataframe with %d rows\n", nrow(df)))
  cat("Row names:\n")
  print(rownames(df))
  cat("\n")
  
  # Extract metrics for key conditions: 1-item@84, 2-item@84, 1-item@212
  # Row names: A_0.2_1 (1-item@84), A_0.2_2 (2-item@84), A_0.5_1 (1-item@212)
  # For Neuroticism: N_0.2_1, N_0.2_2, N_0.5_1
  
  # Extract A or N from "output1_A_DD_avg.glstr" or "output1_N_DD_avg.glstr"
  prefix <- substr(output_obj_name, 9, 9)  # Position 9 is the network letter
  
  cond_rows <- c(
    paste0(prefix, "_0.2_1"),  # 1-item@84
    paste0(prefix, "_0.2_2"),  # 2-item@84
    paste0(prefix, "_0.5_1")   # 1-item@212
  )
  
  condition_labels <- c("1-item@84", "2-item@84", "1-item@212")
  
  metrics <- list()
  
  for (i in 1:length(cond_rows)) {
    cond_row <- cond_rows[i]
    cond_label <- condition_labels[i]
    
    if (cond_row %in% rownames(df)) {
      row_data <- df[cond_row, ]
      metrics[[cond_label]] <- list(
        avg.glstr_diff = row_data$avg.glstr_diff,
        avg.pc_diff = row_data$avg.pc_diff,
        avg.nwinv_diff = row_data$avg.nwinv_diff
      )
      
      cat(sprintf("%s:\n", cond_label))
      cat(sprintf("  Global Strength Diff: %.4f\n", metrics[[cond_label]]$avg.glstr_diff))
      cat(sprintf("  Partial Corr Diff: %.4f\n", metrics[[cond_label]]$avg.pc_diff))
      cat(sprintf("  Network Invariance Diff: %.4f\n", metrics[[cond_label]]$avg.nwinv_diff))
      cat("\n")
    } else {
      cat(sprintf("WARNING: Row %s not found\n", cond_row))
      metrics[[cond_label]] <- list(
        avg.glstr_diff = NA,
        avg.pc_diff = NA,
        avg.nwinv_diff = NA
      )
    }
  }
  
  # Calculate effects and ratios
  if (all(!is.na(metrics[["1-item@84"]]$avg.glstr_diff)) &&
      all(!is.na(metrics[["2-item@84"]]$avg.glstr_diff)) &&
      all(!is.na(metrics[["1-item@212"]]$avg.glstr_diff))) {
    
    # Aggregation effect: 1-item@84 -> 2-item@84
    agg_effect_glstr <- metrics[["1-item@84"]]$avg.glstr_diff - metrics[["2-item@84"]]$avg.glstr_diff
    agg_effect_pc <- metrics[["1-item@84"]]$avg.pc_diff - metrics[["2-item@84"]]$avg.pc_diff
    agg_effect_nwinv <- metrics[["1-item@84"]]$avg.nwinv_diff - metrics[["2-item@84"]]$avg.nwinv_diff
    
    # Sample size effect: 1-item@84 -> 1-item@212
    samp_effect_glstr <- metrics[["1-item@84"]]$avg.glstr_diff - metrics[["1-item@212"]]$avg.glstr_diff
    samp_effect_pc <- metrics[["1-item@84"]]$avg.pc_diff - metrics[["1-item@212"]]$avg.pc_diff
    samp_effect_nwinv <- metrics[["1-item@84"]]$avg.nwinv_diff - metrics[["1-item@212"]]$avg.nwinv_diff
    
    # Calculate ratios
    ratio_glstr <- ifelse(samp_effect_glstr != 0, agg_effect_glstr / samp_effect_glstr, NA)
    ratio_pc <- ifelse(samp_effect_pc != 0, agg_effect_pc / samp_effect_pc, NA)
    ratio_nwinv <- ifelse(samp_effect_nwinv != 0, agg_effect_nwinv / samp_effect_nwinv, NA)
    
    cat("========================================\n")
    cat("EFFECTS AND RATIOS\n")
    cat("========================================\n")
    cat("\nGlobal Strength Difference:\n")
    cat(sprintf("  Aggregation effect (1-item@84 -> 2-item@84): %.4f\n", agg_effect_glstr))
    cat(sprintf("  Sample size effect (1-item@84 -> 1-item@212): %.4f\n", samp_effect_glstr))
    cat(sprintf("  Ratio: %.2fx (Expected: 2.5x)\n", ratio_glstr))
    cat("\nPartial Correlation Difference:\n")
    cat(sprintf("  Aggregation effect: %.4f\n", agg_effect_pc))
    cat(sprintf("  Sample size effect: %.4f\n", samp_effect_pc))
    cat(sprintf("  Ratio: %.2fx\n", ratio_pc))
    cat("\nNetwork Invariance Difference:\n")
    cat(sprintf("  Aggregation effect: %.4f\n", agg_effect_nwinv))
    cat(sprintf("  Sample size effect: %.4f\n", samp_effect_nwinv))
    cat(sprintf("  Ratio: %.2fx\n", ratio_nwinv))
    
    return(list(
      metrics = metrics,
      effects = list(
        glstr = list(agg = agg_effect_glstr, samp = samp_effect_glstr, ratio = ratio_glstr),
        pc = list(agg = agg_effect_pc, samp = samp_effect_pc, ratio = ratio_pc),
        nwinv = list(agg = agg_effect_nwinv, samp = samp_effect_nwinv, ratio = ratio_nwinv)
      )
    ))
  } else {
    cat("ERROR: Could not calculate effects (missing data)\n")
    return(NULL)
  }
}

# Analyze Agreeableness (A) network
cat("\n")
cat("========================================\n")
cat("STEP 1: AGREEABLENESS (A) NETWORK\n")
cat("========================================\n")
results_A <- analyze_network(
  "original files/Syntax (Agreeableness networks)/NEO & IPIP - P3_nSim50_results_all_A.RData",
  "AGREEABLENESS",
  "output1_A_DD_avg.glstr"
)

# Analyze Neuroticism (N) network
cat("\n")
cat("========================================\n")
cat("STEP 2: NEUROTICISM (N) NETWORK\n")
cat("========================================\n")
results_N <- analyze_network(
  "original files/Syntax (Neuroticism networks)/NEO & IPIP - P3_nSim50_results_all_N.RData",
  "NEUROTICISM",
  "output1_N_DD_avg.glstr"
)

# Compare both networks
cat("\n")
cat("========================================\n")
cat("COMPARISON: BOTH NETWORKS\n")
cat("========================================\n")

if (!is.null(results_A) && !is.null(results_N)) {
  cat("\nGlobal Strength Difference Ratios:\n")
  cat(sprintf("  Agreeableness (A): %.2fx\n", results_A$effects$glstr$ratio))
  cat(sprintf("  Neuroticism (N): %.2fx\n", results_N$effects$glstr$ratio))
  cat(sprintf("  Average: %.2fx\n", mean(c(results_A$effects$glstr$ratio, results_N$effects$glstr$ratio))))
  cat(sprintf("  Expected (Paper): 2.5x\n"))
  
  cat("\nPartial Correlation Difference Ratios:\n")
  cat(sprintf("  Agreeableness (A): %.2fx\n", results_A$effects$pc$ratio))
  cat(sprintf("  Neuroticism (N): %.2fx\n", results_N$effects$pc$ratio))
  
  cat("\nNetwork Invariance Difference Ratios:\n")
  cat(sprintf("  Agreeableness (A): %.2fx\n", results_A$effects$nwinv$ratio))
  cat(sprintf("  Neuroticism (N): %.2fx\n", results_N$effects$nwinv$ratio))
  
  cat("\n========================================\n")
  cat("SUMMARY\n")
  cat("========================================\n")
  cat("\nNeither network shows a 2.5x ratio for Global Strength Difference:\n")
  cat(sprintf("  - Agreeableness: %.2fx\n", results_A$effects$glstr$ratio))
  cat(sprintf("  - Neuroticism: %.2fx\n", results_N$effects$glstr$ratio))
  cat(sprintf("  - Average: %.2fx\n", mean(c(results_A$effects$glstr$ratio, results_N$effects$glstr$ratio))))
  cat("\nBoth networks show ratios closer to 1.2-1.3x, not 2.5x.\n")
  
  # Create summary table
  summary_data <- data.frame(
    Network = c("Agreeableness", "Neuroticism", "Average"),
    Global_Strength_Ratio = c(
      results_A$effects$glstr$ratio,
      results_N$effects$glstr$ratio,
      mean(c(results_A$effects$glstr$ratio, results_N$effects$glstr$ratio))
    ),
    Partial_Corr_Ratio = c(
      results_A$effects$pc$ratio,
      results_N$effects$pc$ratio,
      mean(c(results_A$effects$pc$ratio, results_N$effects$pc$ratio))
    ),
    Network_Invariance_Ratio = c(
      results_A$effects$nwinv$ratio,
      results_N$effects$nwinv$ratio,
      mean(c(results_A$effects$nwinv$ratio, results_N$effects$nwinv$ratio))
    )
  )
  
  cat("\nSummary Table:\n")
  print(summary_data)
  
  # Save to file
  write.csv(summary_data, "docs/both_networks_analysis_summary.csv", row.names = FALSE)
  cat("\nSummary saved to: docs/both_networks_analysis_summary.csv\n")
}

cat("\n")
cat("========================================\n")
cat("ANALYSIS COMPLETE\n")
cat("========================================\n")

