# Tier 4 ML CORRECTED: Random Forest with valid prediction targets
# Previous version was circular (predicting mean of items from those items).
# This version predicts NEO facet score from IPIP items (cross-instrument).

library(ranger)

set.seed(42)

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

ipip_facets <- list(
  N1_Anxiety       = c("e141_R", "e150_R", "h1046_R", "h1157", "h2000_R", "h968", "h999", "x107", "x120", "x138_R"),
  N2_Anger         = c("e120_R", "h754", "h755", "h761", "x191_R", "x23_R", "x231_R", "x265_R", "x84", "x95"),
  N3_Depression    = c("e92", "h640", "h646", "h737_R", "h947", "x129_R", "x15", "x156_R", "x205", "x74"),
  N4_SelfConscious = c("h1197_R", "h1205", "h592", "h655", "h656", "h905", "h991", "x197_R", "x209_R", "x242_R"),
  N5_Immoderation  = c("e24", "e30_R", "e57", "h2029", "x133", "x145", "x181_R", "x216_R", "x251_R", "x274_R"),
  N6_Vulnerability = c("e64_R", "h1281_R", "h44_R", "h470_R", "h901", "h948", "h950", "h954", "h959", "x79_R")
)

neo_facets <- list(
  N1_Anxiety       = c("I1", "I31", "I61", "I91", "I121", "I151", "I181", "I211"),
  N2_Anger         = c("I6", "I36", "I66", "I96", "I126", "I156", "I186", "I216"),
  N3_Depression    = c("I11", "I41", "I71", "I101", "I131", "I161", "I191", "I221"),
  N4_SelfConscious = c("I16", "I46", "I76", "I106", "I136", "I166", "I196", "I226"),
  N5_Immoderation  = c("I21", "I51", "I81", "I111", "I141", "I171", "I201", "I231"),
  N6_Vulnerability = c("I26", "I56", "I86", "I116", "I146", "I176", "I206", "I236")
)

all_items <- c(unlist(ipip_facets), unlist(neo_facets))
df <- data1[, all_items]
df <- df[complete.cases(df), ]
n <- nrow(df)
cat("Sample size:", n, "\n\n")

# ============================================================================
# CROSS-INSTRUMENT RF: Predict NEO facet score from IPIP items
# ============================================================================

cat(strrep("=", 70), "\n")
cat("CROSS-INSTRUMENT RF: Predict NEO facet from IPIP items\n")
cat(strrep("=", 70), "\n\n")

rf_importance_all <- data.frame()
cv_results_all <- data.frame()

for (fname in names(ipip_facets)) {
  ipip_items <- ipip_facets[[fname]]
  neo_items <- neo_facets[[fname]]
  
  ipip_df <- df[, ipip_items]
  neo_score <- rowMeans(df[, neo_items])
  
  model_df <- cbind(ipip_df, neo_score = neo_score)
  
  # --- 10-fold cross-validation ---
  k <- 10
  folds <- sample(rep(1:k, length.out = n))
  
  rf_preds <- numeric(n)
  lm_preds <- numeric(n)
  mean_preds <- numeric(n)  # baseline: always predict mean of training set
  
  for (fold in 1:k) {
    train_idx <- folds != fold
    test_idx <- folds == fold
    
    rf_mod <- ranger(neo_score ~ ., data = model_df[train_idx, ], 
                     importance = "impurity", num.trees = 500)
    rf_preds[test_idx] <- predict(rf_mod, model_df[test_idx, ])$predictions
    
    lm_mod <- lm(neo_score ~ ., data = model_df[train_idx, ])
    lm_preds[test_idx] <- predict(lm_mod, model_df[test_idx, ])
    
    mean_preds[test_idx] <- mean(neo_score[train_idx])
  }
  
  # CV metrics
  ss_total <- sum((neo_score - mean(neo_score))^2)
  rf_r2 <- 1 - sum((neo_score - rf_preds)^2) / ss_total
  lm_r2 <- 1 - sum((neo_score - lm_preds)^2) / ss_total
  mean_r2 <- 0  # by definition
  
  rf_mae <- mean(abs(neo_score - rf_preds))
  lm_mae <- mean(abs(neo_score - lm_preds))
  mean_mae <- mean(abs(neo_score - mean(neo_score)))
  
  cv_results_all <- rbind(cv_results_all, data.frame(
    facet = fname,
    model = c("RandomForest", "LinearRegression", "MeanBaseline"),
    R2_cv = round(c(rf_r2, lm_r2, mean_r2), 4),
    MAE_cv = round(c(rf_mae, lm_mae, mean_mae), 4),
    stringsAsFactors = FALSE
  ))
  
  cat(fname, ":\n")
  cat("  RF R²:", round(rf_r2, 4), " | LM R²:", round(lm_r2, 4),
      " | Mean baseline MAE:", round(mean_mae, 4), "\n")
  cat("  RF MAE:", round(rf_mae, 4), " | LM MAE:", round(lm_mae, 4), "\n")
  cat("  RF beats LM?", rf_r2 > lm_r2, "\n")
  
  # --- Full-data RF for importance ---
  rf_full <- ranger(neo_score ~ ., data = model_df, 
                    importance = "impurity", num.trees = 1000)
  
  # Also get permutation importance (more trustworthy than impurity for correlated predictors)
  rf_perm <- ranger(neo_score ~ ., data = model_df,
                    importance = "permutation", num.trees = 1000)
  
  imp <- data.frame(
    facet = fname,
    item = names(rf_full$variable.importance),
    rf_impurity_importance = as.numeric(rf_full$variable.importance),
    rf_permutation_importance = as.numeric(rf_perm$variable.importance[names(rf_full$variable.importance)]),
    stringsAsFactors = FALSE
  )
  imp$impurity_pct <- round(imp$rf_impurity_importance / sum(imp$rf_impurity_importance) * 100, 2)
  imp$perm_pct <- round(imp$rf_permutation_importance / sum(pmax(imp$rf_permutation_importance, 0)) * 100, 2)
  imp <- imp[order(-imp$rf_permutation_importance), ]
  
  # Compare impurity vs permutation ranking
  rho <- cor(imp$rf_impurity_importance, imp$rf_permutation_importance, method = "spearman")
  cat("  Impurity vs permutation rank corr:", round(rho, 3), "\n\n")
  
  rf_importance_all <- rbind(rf_importance_all, imp)
}

# --- Stability check: N3_Depression, 5 seeds ---
cat("\n--- STABILITY CHECK (N3_Depression, permutation importance, 5 runs) ---\n")
dep_ipip <- ipip_facets[["N3_Depression"]]
dep_neo_score <- rowMeans(df[, neo_facets[["N3_Depression"]]])
dep_model <- cbind(df[, dep_ipip], neo_score = dep_neo_score)

rank_matrix <- matrix(NA, nrow = length(dep_ipip), ncol = 5)
rownames(rank_matrix) <- dep_ipip
for (run in 1:5) {
  set.seed(run * 100)
  rf_tmp <- ranger(neo_score ~ ., data = dep_model, importance = "permutation", num.trees = 1000)
  rank_matrix[, run] <- rank(-rf_tmp$variable.importance[dep_ipip])
}
cat("  Item ranks across 5 runs:\n")
for (item in dep_ipip) {
  ranks <- rank_matrix[item, ]
  cat("    ", item, ":", paste(ranks, collapse = ", "),
      " | range:", diff(range(ranks)), "\n")
}

# --- Sanity check: Do IPIP items predict the WRONG NEO facet? ---
cat("\n--- CROSS-FACET PREDICTION (do IPIP items bleed into wrong facets?) ---\n")
for (fname in names(ipip_facets)) {
  ipip_items <- ipip_facets[[fname]]
  ipip_df <- df[, ipip_items]
  
  r2_per_target <- c()
  for (target_facet in names(neo_facets)) {
    target_score <- rowMeans(df[, neo_facets[[target_facet]]])
    # Quick R² from correlation
    r <- cor(rowMeans(ipip_df), target_score)
    r2_per_target[target_facet] <- round(r^2, 3)
  }
  
  own <- r2_per_target[fname]
  best_other <- max(r2_per_target[names(r2_per_target) != fname])
  best_other_name <- names(which.max(r2_per_target[names(r2_per_target) != fname]))
  cat(fname, ": own R²=", own, " | best other R²=", best_other, 
      " (", best_other_name, ") | discriminant ratio:", round(own/best_other, 2), "\n")
}

# ---- Save ----
write.csv(rf_importance_all, "results/rf_item_importance_corrected.csv", row.names = FALSE)
write.csv(cv_results_all, "results/rf_cv_evaluation_corrected.csv", row.names = FALSE)

cat("\nCorrected results saved to results/rf_*_corrected.csv\n")
