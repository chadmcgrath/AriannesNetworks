# Tier 4 ML: Random Forest item importance + Mutual Information community detection
# Includes model evaluation: cross-validation, baseline comparisons, stability checks.

library(ranger)
library(igraph)
library(infotheo)

set.seed(42)

# ---- Load and preprocess ----

data1 <- read.csv("data/NEO_IPIP_1.csv")

rev_items <- list(
  N1 = c("e141", "e150", "h1046", "h2000", "x138"),
  N2 = c("e120", "x191", "x23", "x231", "x265"),
  N3 = c("h737", "x129", "x156"),
  N4 = c("h1197", "x197", "x209", "x242"),
  N5 = c("e30", "x181", "x216", "x251", "x274"),
  N6 = c("e64", "h1281", "h44", "h470", "x79")
)
for (items in rev_items) {
  for (item in items) {
    data1[[paste0(item, "_R")]] <- 6 - data1[[item]]
  }
}

facets <- list(
  N1_Anxiety       = c("e141_R", "e150_R", "h1046_R", "h1157", "h2000_R", "h968", "h999", "x107", "x120", "x138_R"),
  N2_Anger         = c("e120_R", "h754", "h755", "h761", "x191_R", "x23_R", "x231_R", "x265_R", "x84", "x95"),
  N3_Depression    = c("e92", "h640", "h646", "h737_R", "h947", "x129_R", "x15", "x156_R", "x205", "x74"),
  N4_SelfConscious = c("h1197_R", "h1205", "h592", "h655", "h656", "h905", "h991", "x197_R", "x209_R", "x242_R"),
  N5_Immoderation  = c("e24", "e30_R", "e57", "h2029", "x133", "x145", "x181_R", "x216_R", "x251_R", "x274_R"),
  N6_Vulnerability = c("e64_R", "h1281_R", "h44_R", "h470_R", "h901", "h948", "h950", "h954", "h959", "x79_R")
)

all_items <- unlist(facets)
df <- data1[, all_items]
df <- df[complete.cases(df), ]
n <- nrow(df)
cat("Sample size:", n, "\n\n")

# ============================================================================
# PART 1: RANDOM FOREST ITEM IMPORTANCE WITH CROSS-VALIDATION
# ============================================================================

cat(strrep("=", 70), "\n")
cat("PART 1: RANDOM FOREST ITEM IMPORTANCE\n")
cat(strrep("=", 70), "\n\n")

rf_importance_all <- data.frame()
cv_results_all <- data.frame()

for (fname in names(facets)) {
  items <- facets[[fname]]
  fdf <- df[, items]
  facet_score <- rowMeans(fdf)
  model_df <- cbind(fdf, facet_score = facet_score)
  
  # --- 10-fold cross-validation: RF vs linear regression vs single-best-item ---
  k <- 10
  folds <- sample(rep(1:k, length.out = n))
  
  rf_preds <- numeric(n)
  lm_preds <- numeric(n)
  best_item_preds <- numeric(n)
  
  # Find the best single item (highest item-total correlation on full data)
  itc <- sapply(items, function(item) cor(fdf[[item]], facet_score - fdf[[item]]))
  best_item <- names(which.max(itc))
  
  for (fold in 1:k) {
    train_idx <- folds != fold
    test_idx <- folds == fold
    
    # RF
    rf_mod <- ranger(facet_score ~ ., data = model_df[train_idx, ], 
                     importance = "impurity", num.trees = 500)
    rf_preds[test_idx] <- predict(rf_mod, model_df[test_idx, ])$predictions
    
    # Linear regression
    lm_mod <- lm(facet_score ~ ., data = model_df[train_idx, ])
    lm_preds[test_idx] <- predict(lm_mod, model_df[test_idx, ])
    
    # Single best item (scaled to match facet_score range)
    train_best <- fdf[[best_item]][train_idx]
    train_score <- facet_score[train_idx]
    slope <- cov(train_best, train_score) / var(train_best)
    intercept <- mean(train_score) - slope * mean(train_best)
    best_item_preds[test_idx] <- intercept + slope * fdf[[best_item]][test_idx]
  }
  
  # Compute CV metrics
  rf_r2 <- 1 - sum((facet_score - rf_preds)^2) / sum((facet_score - mean(facet_score))^2)
  lm_r2 <- 1 - sum((facet_score - lm_preds)^2) / sum((facet_score - mean(facet_score))^2)
  best_r2 <- 1 - sum((facet_score - best_item_preds)^2) / sum((facet_score - mean(facet_score))^2)
  
  rf_mae <- mean(abs(facet_score - rf_preds))
  lm_mae <- mean(abs(facet_score - lm_preds))
  best_mae <- mean(abs(facet_score - best_item_preds))
  
  cv_results_all <- rbind(cv_results_all, data.frame(
    facet = fname,
    model = c("RandomForest", "LinearRegression", "SingleBestItem"),
    R2_cv = round(c(rf_r2, lm_r2, best_r2), 4),
    MAE_cv = round(c(rf_mae, lm_mae, best_mae), 4),
    stringsAsFactors = FALSE
  ))
  
  cat(fname, ":\n")
  cat("  RF R²:", round(rf_r2, 4), " LM R²:", round(lm_r2, 4), 
      " Best-item R²:", round(best_r2, 4), " (", best_item, ")\n")
  cat("  RF MAE:", round(rf_mae, 4), " LM MAE:", round(lm_mae, 4), 
      " Best-item MAE:", round(best_mae, 4), "\n")
  
  # --- Full-data RF for importance (not for prediction) ---
  rf_full <- ranger(facet_score ~ ., data = model_df, 
                    importance = "impurity", num.trees = 1000)
  
  imp <- data.frame(
    facet = fname,
    item = names(rf_full$variable.importance),
    rf_importance = as.numeric(rf_full$variable.importance),
    stringsAsFactors = FALSE
  )
  imp$rf_importance_pct <- round(imp$rf_importance / sum(imp$rf_importance) * 100, 2)
  imp$itc_rank <- rank(-itc[imp$item])
  imp$rf_rank <- rank(-imp$rf_importance)
  imp$rank_difference <- imp$itc_rank - imp$rf_rank
  imp <- imp[order(-imp$rf_importance), ]
  
  rf_importance_all <- rbind(rf_importance_all, imp)
  
  # Check rank correlation between RF importance and item-total correlation
  rho <- cor(imp$rf_importance, itc[imp$item], method = "spearman")
  cat("  RF vs item-total-r rank correlation (Spearman):", round(rho, 3), "\n\n")
}

# --- Stability check: run RF 5 times with different seeds ---
cat("\n--- RF STABILITY CHECK (N3_Depression, 5 runs) ---\n")
dep_items <- facets[["N3_Depression"]]
dep_df <- df[, dep_items]
dep_score <- rowMeans(dep_df)
dep_model <- cbind(dep_df, facet_score = dep_score)

rank_matrix <- matrix(NA, nrow = length(dep_items), ncol = 5)
rownames(rank_matrix) <- dep_items
for (run in 1:5) {
  set.seed(run * 100)
  rf_tmp <- ranger(facet_score ~ ., data = dep_model, importance = "impurity", num.trees = 1000)
  rank_matrix[, run] <- rank(-rf_tmp$variable.importance[dep_items])
}
cat("  Item ranks across 5 runs:\n")
for (item in dep_items) {
  cat("    ", item, ":", paste(rank_matrix[item, ], collapse = ", "), 
      " (range:", diff(range(rank_matrix[item, ])), ")\n")
}


# ============================================================================
# PART 2: MUTUAL INFORMATION NETWORK + COMMUNITY DETECTION
# ============================================================================

cat("\n", strrep("=", 70), "\n")
cat("PART 2: MUTUAL INFORMATION NETWORK + COMMUNITY DETECTION\n")
cat(strrep("=", 70), "\n\n")

# Discretize responses (already 1-5 integers, but infotheo wants factors)
df_disc <- as.data.frame(lapply(df, as.factor))

# Compute pairwise MI matrix
n_items <- ncol(df)
mi_matrix <- matrix(0, n_items, n_items)
colnames(mi_matrix) <- rownames(mi_matrix) <- colnames(df)

cat("Computing MI matrix (", n_items, "x", n_items, ")...\n")
for (i in 1:(n_items - 1)) {
  for (j in (i + 1):n_items) {
    mi_val <- mutinformation(df_disc[, i], df_disc[, j])
    mi_matrix[i, j] <- mi_val
    mi_matrix[j, i] <- mi_val
  }
}
cat("Done.\n")

# --- Build graph and detect communities ---

# Threshold: keep edges with MI > median (to avoid a fully connected hairball)
upper_tri <- mi_matrix[upper.tri(mi_matrix)]
threshold <- median(upper_tri)
cat("MI threshold (median):", round(threshold, 4), "\n")

adj_matrix <- mi_matrix
adj_matrix[adj_matrix < threshold] <- 0

g <- graph_from_adjacency_matrix(adj_matrix, mode = "undirected", weighted = TRUE, diag = FALSE)

# Louvain community detection
comm <- cluster_louvain(g)
membership <- membership(comm)
modularity_score <- modularity(comm)
cat("Louvain modularity:", round(modularity_score, 4), "\n")
cat("Number of communities detected:", max(membership), "\n\n")

# --- Evaluate: do detected communities match assigned facets? ---

# Create true facet labels
true_labels <- rep(NA, n_items)
names(true_labels) <- colnames(df)
for (fname in names(facets)) {
  true_labels[facets[[fname]]] <- fname
}

# Compare
community_df <- data.frame(
  item = colnames(df),
  assigned_facet = true_labels,
  detected_community = membership,
  stringsAsFactors = FALSE
)

# For each detected community, which facet is most represented?
cat("--- COMMUNITY COMPOSITION ---\n")
for (c_id in sort(unique(membership))) {
  c_items <- community_df[community_df$detected_community == c_id, ]
  facet_counts <- table(c_items$assigned_facet)
  dominant <- names(which.max(facet_counts))
  purity <- max(facet_counts) / sum(facet_counts)
  cat("Community", c_id, "(", nrow(c_items), "items):",
      paste(names(facet_counts), facet_counts, sep = "=", collapse = ", "),
      " | Dominant:", dominant, "| Purity:", round(purity * 100, 1), "%\n")
}

# For each assigned facet, how many communities do its items span?
cat("\n--- FACET COHERENCE ---\n")
for (fname in names(facets)) {
  f_items <- community_df[community_df$assigned_facet == fname, ]
  n_communities <- length(unique(f_items$detected_community))
  dominant_comm <- names(which.max(table(f_items$detected_community)))
  in_dominant <- sum(f_items$detected_community == as.integer(dominant_comm))
  cat(fname, ": spans", n_communities, "communities,",
      in_dominant, "of", nrow(f_items), "in dominant community\n")
}

# --- Stability check: vary threshold ---
cat("\n--- COMMUNITY STABILITY CHECK (varying MI threshold) ---\n")
for (pctl in c(0.25, 0.50, 0.75)) {
  thresh <- quantile(upper_tri, pctl)
  adj_tmp <- mi_matrix
  adj_tmp[adj_tmp < thresh] <- 0
  g_tmp <- graph_from_adjacency_matrix(adj_tmp, mode = "undirected", weighted = TRUE, diag = FALSE)
  comm_tmp <- cluster_louvain(g_tmp)
  cat("  Threshold at", pctl*100, "th pctl (", round(thresh, 4), "):",
      max(membership(comm_tmp)), "communities, modularity =", 
      round(modularity(comm_tmp), 4), "\n")
}

# --- Normalized Mutual Information between detected and true labels ---
nmi <- mutinformation(as.factor(true_labels), as.factor(membership)) / 
       sqrt(entropy(as.factor(true_labels)) * entropy(as.factor(membership)))
cat("\nNormalized MI between detected communities and assigned facets:", round(nmi, 4), "\n")
cat("  (1.0 = perfect match, 0.0 = no relationship)\n")

# ---- Save results ----

write.csv(rf_importance_all, "results/rf_item_importance.csv", row.names = FALSE)
write.csv(cv_results_all, "results/rf_cv_evaluation.csv", row.names = FALSE)
write.csv(community_df, "results/community_detection.csv", row.names = FALSE)
write.csv(as.data.frame(mi_matrix), "results/mutual_information_matrix.csv")

cat("\nResults saved to results/rf_*.csv and results/community_detection.csv\n")
