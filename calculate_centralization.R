# Script to calculate Network Centralization
# This will test the paper's 2.5x finding using the correct metric

library(qgraph)

# Load the data
load("NEO & IPIP - P3_nSim50_data_all_N.RData")

cat("=== CALCULATING NETWORK CENTRALIZATION ===\n\n")

# Function to calculate network centralization from Expected Influence centrality
# Formula: Centralization = Σ(max_centrality - centrality_i) / max_possible_centralization
calc_centralization <- function(centrality_values) {
  n <- length(centrality_values)
  if (n == 0 || all(is.na(centrality_values))) return(NA)
  
  max_cent <- max(centrality_values, na.rm = TRUE)
  sum_diff <- sum(max_cent - centrality_values, na.rm = TRUE)
  
  # Theoretical maximum for Expected Influence in a star network
  # For n nodes, max centralization occurs when one node connects to all others
  # The theoretical max depends on edge weights, but we can use Freeman's approach
  # For Expected Influence with positive edges, max = (n-1) * max_possible_edge_weight
  # Since we don't know max edge weight, we'll use a normalization approach
  
  # Option 1: Freeman's normalization (for unweighted)
  # max_possible = (n-2) * (n-1) / 2  # This is for degree centrality
  
  # Option 2: Use actual max possible from the data
  # We'll calculate this from the network structure
  
  # For now, let's use a simpler approach: normalize by (n-1)
  # This gives us centralization as a proportion
  max_possible <- (n - 1) * max_cent  # If one node had all connections
  
  if (max_possible == 0) return(0)
  
  centralization <- sum_diff / max_possible
  return(centralization)
}

# Function to extract centralization from a single network comparison
extract_centralization <- function(netcompare_result) {
  if (is.null(netcompare_result) || !is.list(netcompare_result)) return(c(NA, NA))
  
  # Check if it has the expected structure
  if (!("netmat_x_graph" %in% names(netcompare_result)) || 
      !("InExpectedInfluence_x" %in% names(netcompare_result))) {
    return(c(NA, NA))
  }
  
  # Get Expected Influence directly (already calculated in netcompare)
  expinf_x <- netcompare_result$InExpectedInfluence_x
  expinf_y <- netcompare_result$InExpectedInfluence_y
  
  if (is.null(expinf_x) || is.null(expinf_y)) return(c(NA, NA))
  
  # Calculate centralization
  centr_x <- calc_centralization(expinf_x)
  centr_y <- calc_centralization(expinf_y)
  
  return(c(centr_x, centr_y))
}

# Extract centralization for our three key conditions
cat("Extracting centralization for key conditions...\n\n")

# Condition 1: 1-item@84 (nSamp=0.2, nItems=1)
cat("1. 1-item@84 samples:\n")
centr_1_84_x <- centr_1_84_y <- numeric()
for (i in 1:length(netcompare_Nlist_0.2_1_DD)) {
  # Each simulation has multiple bootstrap samples
  for (j in 1:length(netcompare_Nlist_0.2_1_DD[[i]])) {
    if (is.list(netcompare_Nlist_0.2_1_DD[[i]][[j]])) {
      result <- extract_centralization(netcompare_Nlist_0.2_1_DD[[i]][[j]])
      if (!any(is.na(result))) {
        centr_1_84_x <- c(centr_1_84_x, result[1])
        centr_1_84_y <- c(centr_1_84_y, result[2])
      }
    }
  }
}
cat("   Network X (NEO): mean =", round(mean(centr_1_84_x, na.rm=TRUE), 4), 
    ", sd =", round(sd(centr_1_84_x, na.rm=TRUE), 4), "\n")
cat("   Network Y (IPIP): mean =", round(mean(centr_1_84_y, na.rm=TRUE), 4), 
    ", sd =", round(sd(centr_1_84_y, na.rm=TRUE), 4), "\n")
cat("   Overall mean =", round(mean(c(centr_1_84_x, centr_1_84_y), na.rm=TRUE), 4), "\n\n")

# Condition 2: 2-item@84 (nSamp=0.2, nItems=2)
cat("2. 2-item@84 samples:\n")
centr_2_84_x <- centr_2_84_y <- numeric()
for (i in 1:length(netcompare_Nlist_0.2_2_DD)) {
  for (j in 1:length(netcompare_Nlist_0.2_2_DD[[i]])) {
    if (is.list(netcompare_Nlist_0.2_2_DD[[i]][[j]])) {
      result <- extract_centralization(netcompare_Nlist_0.2_2_DD[[i]][[j]])
      if (!any(is.na(result))) {
        centr_2_84_x <- c(centr_2_84_x, result[1])
        centr_2_84_y <- c(centr_2_84_y, result[2])
      }
    }
  }
}
cat("   Network X (NEO): mean =", round(mean(centr_2_84_x, na.rm=TRUE), 4), 
    ", sd =", round(sd(centr_2_84_x, na.rm=TRUE), 4), "\n")
cat("   Network Y (IPIP): mean =", round(mean(centr_2_84_y, na.rm=TRUE), 4), 
    ", sd =", round(sd(centr_2_84_y, na.rm=TRUE), 4), "\n")
cat("   Overall mean =", round(mean(c(centr_2_84_x, centr_2_84_y), na.rm=TRUE), 4), "\n\n")

# Condition 3: 1-item@212 (nSamp=0.5, nItems=1)
cat("3. 1-item@212 samples:\n")
centr_1_212_x <- centr_1_212_y <- numeric()
for (i in 1:length(netcompare_Nlist_0.5_1_DD)) {
  for (j in 1:length(netcompare_Nlist_0.5_1_DD[[i]])) {
    if (is.list(netcompare_Nlist_0.5_1_DD[[i]][[j]])) {
      result <- extract_centralization(netcompare_Nlist_0.5_1_DD[[i]][[j]])
      if (!any(is.na(result))) {
        centr_1_212_x <- c(centr_1_212_x, result[1])
        centr_1_212_y <- c(centr_1_212_y, result[2])
      }
    }
  }
}
cat("   Network X (NEO): mean =", round(mean(centr_1_212_x, na.rm=TRUE), 4), 
    ", sd =", round(sd(centr_1_212_x, na.rm=TRUE), 4), "\n")
cat("   Network Y (IPIP): mean =", round(mean(centr_1_212_y, na.rm=TRUE), 4), 
    ", sd =", round(sd(centr_1_212_y, na.rm=TRUE), 4), "\n")
cat("   Overall mean =", round(mean(c(centr_1_212_x, centr_1_212_y), na.rm=TRUE), 4), "\n\n")

# Calculate effects
mean_1_84 <- mean(c(centr_1_84_x, centr_1_84_y), na.rm=TRUE)
mean_2_84 <- mean(c(centr_2_84_x, centr_2_84_y), na.rm=TRUE)
mean_1_212 <- mean(c(centr_1_212_x, centr_1_212_y), na.rm=TRUE)

cat("=== 2.5X FINDING CALCULATION ===\n\n")
cat("Network Centralization values:\n")
cat("  1-item@84:  ", round(mean_1_84, 4), "\n")
cat("  2-item@84:  ", round(mean_2_84, 4), "\n")
cat("  1-item@212: ", round(mean_1_212, 4), "\n\n")

# Note: For centralization, we need to think about what "improvement" means
# Higher centralization = more centralized network
# The paper says aggregation improves centralization, so we expect:
# centralization(2-item@84) > centralization(1-item@84)
# centralization(1-item@212) > centralization(1-item@84)

agg_effect <- mean_2_84 - mean_1_84
samp_effect <- mean_1_212 - mean_1_84
ratio <- agg_effect / samp_effect

cat("Effects:\n")
cat("  Aggregation effect (2-item@84 - 1-item@84): ", round(agg_effect, 4), "\n")
cat("  Sample size effect (1-item@212 - 1-item@84): ", round(samp_effect, 4), "\n")
cat("  Ratio (should be ~2.5x): ", round(ratio, 2), "x\n\n")

if (abs(ratio - 2.5) < 0.5) {
  cat("✅ KEY FINDING SUPPORTED: Ratio is close to 2.5x\n")
} else {
  cat("⚠️  Ratio differs from expected 2.5x\n")
}

cat("\nNote: This calculation uses Expected Influence centrality.\n")
cat("The normalization method may need adjustment based on the paper's exact method.\n")

