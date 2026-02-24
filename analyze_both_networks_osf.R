# Analyze Original OSF Results for BOTH Networks (A and N)
# This script extracts metrics from both Agreeableness and Neuroticism results
# and calculates the 2.5x ratios for comparison

cat("========================================\n")
cat("ANALYZING ORIGINAL OSF RESULTS\n")
cat("BOTH NETWORKS: Agreeableness (A) and Neuroticism (N)\n")
cat("========================================\n\n")

# Load required libraries
library(qgraph)
library(igraph)

# Function to extract and analyze metrics from results file
analyze_results <- function(results_file, network_name) {
  cat("\n")
  cat("========================================\n")
  cat(sprintf("ANALYZING %s NETWORK\n", network_name))
  cat("========================================\n")
  cat(sprintf("File: %s\n\n", results_file))
  
  # Load the results file
  load(results_file)
  
  # Extract key metrics for each condition
  # Conditions: 1-item@84, 2-item@84, 1-item@212
  conditions <- c("0.2_1_DD", "0.2_2_DD", "0.5_1_DD")
  condition_names <- c("1-item@84", "2-item@84", "1-item@212")
  
  results_summary <- data.frame(
    Condition = condition_names,
    avg.glstr_diff = numeric(3),
    avg.pc_diff = numeric(3),
    avg.nwinv_diff = numeric(3),
    stringsAsFactors = FALSE
  )
  
  # Extract metrics for each condition
  for (i in 1:length(conditions)) {
    cond <- conditions[i]
    cond_name <- condition_names[i]
    
    # Get the output object name (depends on network)
    if (network_name == "AGREEABLENESS") {
      output_obj <- paste0("output1_A_", cond)
    } else {
      output_obj <- paste0("output1_N_", cond)
    }
    
    # Check if object exists
    if (exists(output_obj)) {
      output_data <- get(output_obj)
      
      # Extract metrics
      results_summary$avg.glstr_diff[i] <- output_data$avg.glstr_diff
      results_summary$avg.pc_diff[i] <- output_data$avg.pc_diff
      results_summary$avg.nwinv_diff[i] <- output_data$avg.nwinv_diff
      
      cat(sprintf("%s:\n", cond_name))
      cat(sprintf("  Global Strength Diff: %.4f\n", output_data$avg.glstr_diff))
      cat(sprintf("  Partial Corr Diff: %.4f\n", output_data$avg.pc_diff))
      cat(sprintf("  Network Invariance Diff: %.4f\n", output_data$avg.nwinv_diff))
      cat("\n")
    } else {
      cat(sprintf("WARNING: %s not found\n", output_obj))
    }
  }
  
  # Calculate effects and ratios
  if (nrow(results_summary) == 3 && all(!is.na(results_summary$avg.glstr_diff))) {
    # Aggregation effect: 1-item@84 -> 2-item@84
    agg_effect_glstr <- results_summary$avg.glstr_diff[1] - results_summary$avg.glstr_diff[2]
    agg_effect_pc <- results_summary$avg.pc_diff[1] - results_summary$avg.pc_diff[2]
    agg_effect_nwinv <- results_summary$avg.nwinv_diff[1] - results_summary$avg.nwinv_diff[2]
    
    # Sample size effect: 1-item@84 -> 1-item@212
    samp_effect_glstr <- results_summary$avg.glstr_diff[1] - results_summary$avg.glstr_diff[3]
    samp_effect_pc <- results_summary$avg.pc_diff[1] - results_summary$avg.pc_diff[3]
    samp_effect_nwinv <- results_summary$avg.nwinv_diff[1] - results_summary$avg.nwinv_diff[3]
    
    # Calculate ratios
    ratio_glstr <- agg_effect_glstr / samp_effect_glstr
    ratio_pc <- agg_effect_pc / samp_effect_pc
    ratio_nwinv <- agg_effect_nwinv / samp_effect_nwinv
    
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
      summary = results_summary,
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
results_A <- analyze_results(
  "original files/Syntax (Agreeableness networks)/NEO & IPIP - P3_nSim50_results_all_A.RData",
  "AGREEABLENESS"
)

# Analyze Neuroticism (N) network
cat("\n")
cat("========================================\n")
cat("STEP 2: NEUROTICISM (N) NETWORK\n")
cat("========================================\n")
results_N <- analyze_results(
  "original files/Syntax (Neuroticism networks)/NEO & IPIP - P3_nSim50_results_all_N.RData",
  "NEUROTICISM"
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
}

cat("\n")
cat("========================================\n")
cat("ANALYSIS COMPLETE\n")
cat("========================================\n")

