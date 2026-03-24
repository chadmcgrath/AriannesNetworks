# Decisions 2-5: Integration analyses
# Decision 2: Scoring method comparison (equal-weight vs IRT theta vs discrimination-weighted vs RF-predicted)
# Decision 3: Confidence classifier (predict person-fit from simple response features)
# Decision 4: Network re-estimation (raw vs IRT vs disattenuated)
# Decision 5: Person subtype discovery (residual clustering, anomaly detection)

library(mirt)
library(ranger)

set.seed(42)

# ============================================================================
# DATA SETUP (shared across all decisions)
# ============================================================================

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

all_ipip <- unlist(ipip_facets)
all_neo <- unlist(neo_facets)
all_items <- c(all_ipip, all_neo)
df <- data1[, all_items]
df <- df[complete.cases(df), ]
n <- nrow(df)
cat("Sample size:", n, "\n\n")

# Load pre-computed IRT parameters
irt_params <- read.csv("results/irt_item_parameters.csv")
irt_persons <- read.csv("results/irt_person_estimates.csv")

# ============================================================================
# DECISION 2: SCORING METHOD COMPARISON
# ============================================================================

cat(strrep("=", 70), "\n")
cat("DECISION 2: SCORING METHOD COMPARISON\n")
cat(strrep("=", 70), "\n\n")

scoring_results <- data.frame()

for (fname in names(ipip_facets)) {
  ipip_items <- ipip_facets[[fname]]
  neo_items <- neo_facets[[fname]]
  
  ipip_df <- df[, ipip_items]
  neo_score <- rowMeans(df[, neo_items])
  
  # Method 1: Equal-weight average
  score_equal <- rowMeans(ipip_df)
  
  # Method 2: IRT theta estimates
  # Need to re-fit because irt_persons has different row count (fitted on IPIP-only complete cases)
  mod <- mirt(ipip_df, model = 1, itemtype = "graded", verbose = FALSE)
  theta_mat <- fscores(mod, full.scores.SE = TRUE)
  score_irt <- theta_mat[, 1]
  
  # Method 3: Discrimination-weighted average
  a_params <- irt_params[irt_params$facet == fname, ]
  weights <- a_params$a[match(ipip_items, a_params$item)]
  weighted_items <- sweep(ipip_df, 2, weights, "*")
  score_discrim <- rowSums(weighted_items) / sum(weights)
  
  # Method 4: RF-predicted NEO score (10-fold CV to avoid overfitting)
  model_df <- cbind(ipip_df, neo_score = neo_score)
  k <- 10
  folds <- sample(rep(1:k, length.out = n))
  rf_preds <- numeric(n)
  for (fold in 1:k) {
    train_idx <- folds != fold
    test_idx <- folds == fold
    rf_mod <- ranger(neo_score ~ ., data = model_df[train_idx, ], num.trees = 500)
    rf_preds[test_idx] <- predict(rf_mod, model_df[test_idx, ])$predictions
  }
  score_rf <- rf_preds
  
  # Convergent validity: correlation with NEO
  r_equal <- cor(score_equal, neo_score)
  r_irt <- cor(score_irt, neo_score)
  r_discrim <- cor(score_discrim, neo_score)
  r_rf <- cor(score_rf, neo_score)
  
  scoring_results <- rbind(scoring_results, data.frame(
    facet = fname,
    method = c("EqualWeight", "IRT_Theta", "DiscrimWeighted", "RF_Predicted"),
    r_neo = round(c(r_equal, r_irt, r_discrim, r_rf), 4),
    stringsAsFactors = FALSE
  ))
  
  cat(fname, ":\n")
  cat("  Equal-weight r(NEO):", round(r_equal, 4), "\n")
  cat("  IRT theta r(NEO):   ", round(r_irt, 4), "\n")
  cat("  Discrim-wt r(NEO):  ", round(r_discrim, 4), "\n")
  cat("  RF predicted r(NEO):", round(r_rf, 4), "\n")
  
  best <- c("EqualWeight", "IRT_Theta", "DiscrimWeighted", "RF_Predicted")[
    which.max(c(r_equal, r_irt, r_discrim, r_rf))]
  cat("  Winner:", best, "\n\n")
}

write.csv(scoring_results, "results/scoring_method_comparison.csv", row.names = FALSE)

# ============================================================================
# DECISION 3: CONFIDENCE CLASSIFIER
# ============================================================================

cat(strrep("=", 70), "\n")
cat("DECISION 3: CONFIDENCE CLASSIFIER\n")
cat(strrep("=", 70), "\n\n")

classifier_results <- data.frame()
feature_importance_all <- data.frame()

for (fname in names(ipip_facets)) {
  ipip_items <- ipip_facets[[fname]]
  ipip_df <- df[, ipip_items]
  
  # Get person-fit from fresh IRT model (matching rows)
  mod <- mirt(ipip_df, model = 1, itemtype = "graded", verbose = FALSE)
  pfit <- personfit(mod)
  flagged <- as.integer(pfit$Zh < -2)
  n_flagged <- sum(flagged, na.rm = TRUE)
  
  if (n_flagged < 5) {
    cat(fname, ": only", n_flagged, "flagged -- skipping classifier\n\n")
    next
  }
  
  # Build features from raw responses
  features <- data.frame(
    within_sd = apply(ipip_df, 1, sd),
    n_extreme = rowSums(ipip_df == 1 | ipip_df == 5),
    response_range = apply(ipip_df, 1, function(x) max(x) - min(x)),
    mean_response = rowMeans(ipip_df),
    n_midpoint = rowSums(ipip_df == 3)
  )
  
  # Straightlining: count of consecutive identical responses
  features$straightlining <- apply(ipip_df, 1, function(row) {
    max(rle(as.numeric(row))$lengths)
  })
  
  features$target <- flagged
  
  # 10-fold CV: logistic regression
  k <- 10
  folds <- sample(rep(1:k, length.out = n))
  lr_preds <- numeric(n)
  rf_preds_prob <- numeric(n)
  
  for (fold in 1:k) {
    train_idx <- folds != fold
    test_idx <- folds == fold
    
    train_data <- features[train_idx, ]
    test_data <- features[test_idx, ]
    
    # Logistic regression
    lr_mod <- glm(target ~ ., data = train_data, family = binomial)
    lr_preds[test_idx] <- predict(lr_mod, test_data, type = "response")
    
    # Random Forest
    train_data$target <- as.factor(train_data$target)
    rf_mod <- ranger(target ~ ., data = train_data, probability = TRUE, num.trees = 500)
    rf_preds_prob[test_idx] <- predict(rf_mod, test_data)$predictions[, "1"]
  }
  
  # Evaluate at threshold 0.5
  lr_class <- as.integer(lr_preds > 0.5)
  rf_class <- as.integer(rf_preds_prob > 0.5)
  
  # Precision/recall for logistic regression
  lr_tp <- sum(lr_class == 1 & flagged == 1, na.rm = TRUE)
  lr_fp <- sum(lr_class == 1 & flagged == 0, na.rm = TRUE)
  lr_fn <- sum(lr_class == 0 & flagged == 1, na.rm = TRUE)
  lr_precision <- ifelse(lr_tp + lr_fp > 0, lr_tp / (lr_tp + lr_fp), 0)
  lr_recall <- ifelse(lr_tp + lr_fn > 0, lr_tp / (lr_tp + lr_fn), 0)
  
  # Precision/recall for RF
  rf_tp <- sum(rf_class == 1 & flagged == 1, na.rm = TRUE)
  rf_fp <- sum(rf_class == 1 & flagged == 0, na.rm = TRUE)
  rf_fn <- sum(rf_class == 0 & flagged == 1, na.rm = TRUE)
  rf_precision <- ifelse(rf_tp + rf_fp > 0, rf_tp / (rf_tp + rf_fp), 0)
  rf_recall <- ifelse(rf_tp + rf_fn > 0, rf_tp / (rf_tp + rf_fn), 0)
  
  # AUC approximation using concordance
  lr_auc <- tryCatch({
    pos <- lr_preds[flagged == 1]
    neg <- lr_preds[flagged == 0]
    mean(outer(pos, neg, ">") + 0.5 * outer(pos, neg, "=="))
  }, error = function(e) NA)
  
  rf_auc <- tryCatch({
    pos <- rf_preds_prob[flagged == 1]
    neg <- rf_preds_prob[flagged == 0]
    mean(outer(pos, neg, ">") + 0.5 * outer(pos, neg, "=="))
  }, error = function(e) NA)
  
  classifier_results <- rbind(classifier_results, data.frame(
    facet = fname,
    n_flagged = n_flagged,
    base_rate = round(n_flagged / n * 100, 1),
    model = c("LogisticRegression", "RandomForest"),
    precision = round(c(lr_precision, rf_precision), 3),
    recall = round(c(lr_recall, rf_recall), 3),
    AUC = round(c(lr_auc, rf_auc), 3),
    stringsAsFactors = FALSE
  ))
  
  # Feature importance from full-data RF
  features$target <- as.factor(flagged)
  rf_full <- ranger(target ~ ., data = features, importance = "permutation", num.trees = 1000)
  imp <- data.frame(
    facet = fname,
    feature = names(rf_full$variable.importance),
    importance = as.numeric(rf_full$variable.importance),
    stringsAsFactors = FALSE
  )
  imp <- imp[order(-imp$importance), ]
  feature_importance_all <- rbind(feature_importance_all, imp)
  
  cat(fname, "(", n_flagged, "flagged,", round(n_flagged/n*100, 1), "% base rate):\n")
  cat("  LR: precision=", round(lr_precision, 3), " recall=", round(lr_recall, 3), " AUC=", round(lr_auc, 3), "\n")
  cat("  RF: precision=", round(rf_precision, 3), " recall=", round(rf_recall, 3), " AUC=", round(rf_auc, 3), "\n")
  cat("  Top feature:", imp$feature[1], "(importance:", round(imp$importance[1], 4), ")\n\n")
}

write.csv(classifier_results, "results/confidence_classifier_results.csv", row.names = FALSE)
write.csv(feature_importance_all, "results/confidence_classifier_feature_importance.csv", row.names = FALSE)

# ============================================================================
# DECISION 4: NETWORK RE-ESTIMATION
# ============================================================================

cat(strrep("=", 70), "\n")
cat("DECISION 4: NETWORK RE-ESTIMATION\n")
cat(strrep("=", 70), "\n\n")

# Compute facet scores using 3 methods
facet_names <- names(ipip_facets)
n_facets <- length(facet_names)

# Method 1: Raw averages
raw_scores <- matrix(NA, n, n_facets)
colnames(raw_scores) <- facet_names
for (i in 1:n_facets) {
  raw_scores[, i] <- rowMeans(df[, ipip_facets[[facet_names[i]]]])
}

# Method 2: IRT theta scores (re-fitted on complete cases)
irt_scores <- matrix(NA, n, n_facets)
colnames(irt_scores) <- facet_names
for (i in 1:n_facets) {
  fdf <- df[, ipip_facets[[facet_names[i]]]]
  mod <- mirt(fdf, model = 1, itemtype = "graded", verbose = FALSE)
  irt_scores[, i] <- fscores(mod)[, 1]
}

# Method 3: Discrimination-weighted averages
discrim_scores <- matrix(NA, n, n_facets)
colnames(discrim_scores) <- facet_names
for (i in 1:n_facets) {
  items <- ipip_facets[[facet_names[i]]]
  a_vals <- irt_params[irt_params$facet == facet_names[i], ]
  weights <- a_vals$a[match(items, a_vals$item)]
  weighted <- sweep(df[, items], 2, weights, "*")
  discrim_scores[, i] <- rowSums(weighted) / sum(weights)
}

# Compute correlation matrices (networks)
raw_net <- cor(raw_scores)
irt_net <- cor(irt_scores)
discrim_net <- cor(discrim_scores)

# Disattenuated network
alphas <- c(0.8334, 0.8846, 0.8847, 0.7964, 0.7743, 0.8267)
names(alphas) <- facet_names
disatt_net <- raw_net
for (i in 1:n_facets) {
  for (j in 1:n_facets) {
    if (i != j) {
      disatt_net[i, j] <- raw_net[i, j] / sqrt(alphas[i] * alphas[j])
    }
  }
}

# Print networks
cat("--- RAW CORRELATION NETWORK ---\n")
print(round(raw_net, 3))

cat("\n--- IRT THETA NETWORK ---\n")
print(round(irt_net, 3))

cat("\n--- DISCRIMINATION-WEIGHTED NETWORK ---\n")
print(round(discrim_net, 3))

cat("\n--- DISATTENUATED NETWORK ---\n")
print(round(disatt_net, 3))

# Centrality: strength (sum of absolute edge weights)
raw_strength <- rowSums(abs(raw_net)) - 1
irt_strength <- rowSums(abs(irt_net)) - 1
discrim_strength <- rowSums(abs(discrim_net)) - 1
disatt_strength <- rowSums(abs(disatt_net)) - 1

centrality_df <- data.frame(
  facet = facet_names,
  raw_strength = round(raw_strength, 4),
  irt_strength = round(irt_strength, 4),
  discrim_strength = round(discrim_strength, 4),
  disatt_strength = round(disatt_strength, 4),
  raw_rank = rank(-raw_strength),
  irt_rank = rank(-irt_strength),
  discrim_rank = rank(-discrim_strength),
  disatt_rank = rank(-disatt_strength)
)

cat("\n--- STRENGTH CENTRALITY ---\n")
print(centrality_df)

# Edge comparison: which edges change most?
edge_comparison <- data.frame()
for (i in 1:(n_facets - 1)) {
  for (j in (i + 1):n_facets) {
    edge_comparison <- rbind(edge_comparison, data.frame(
      edge = paste(facet_names[i], "-", facet_names[j]),
      raw = round(raw_net[i, j], 4),
      irt = round(irt_net[i, j], 4),
      discrim = round(discrim_net[i, j], 4),
      disattenuated = round(disatt_net[i, j], 4),
      change_raw_to_disatt = round(disatt_net[i, j] - raw_net[i, j], 4),
      pct_change = round((disatt_net[i, j] - raw_net[i, j]) / abs(raw_net[i, j]) * 100, 1),
      stringsAsFactors = FALSE
    ))
  }
}

cat("\n--- EDGE COMPARISON (largest changes under disattenuation) ---\n")
edge_comparison <- edge_comparison[order(-abs(edge_comparison$change_raw_to_disatt)), ]
print(edge_comparison)

# Key question: does N5's peripherality survive?
cat("\n--- KEY QUESTION: N5 IMMODERATION PERIPHERALITY ---\n")
cat("N5 strength rank: raw=", centrality_df$raw_rank[5],
    " irt=", centrality_df$irt_rank[5],
    " discrim=", centrality_df$discrim_rank[5],
    " disatt=", centrality_df$disatt_rank[5], "\n")

# Save
write.csv(centrality_df, "results/network_centrality_comparison.csv", row.names = FALSE)
write.csv(edge_comparison, "results/network_edge_comparison.csv", row.names = FALSE)

# Save network matrices
write.csv(raw_net, "results/network_raw.csv")
write.csv(irt_net, "results/network_irt.csv")
write.csv(discrim_net, "results/network_discrim.csv")
write.csv(disatt_net, "results/network_disattenuated.csv")

# ============================================================================
# DECISION 5: PERSON SUBTYPE DISCOVERY
# ============================================================================

cat("\n", strrep("=", 70), "\n")
cat("DECISION 5: PERSON SUBTYPE DISCOVERY\n")
cat(strrep("=", 70), "\n\n")

# --- 5A: Residual profiles from IRT ---
cat("--- 5A: RESIDUAL PROFILES ---\n")

residual_profiles <- matrix(NA, n, length(all_ipip))
colnames(residual_profiles) <- all_ipip

person_fit_combined <- data.frame(person_id = 1:n)

for (fname in names(ipip_facets)) {
  items <- ipip_facets[[fname]]
  fdf <- df[, items]
  
  mod <- mirt(fdf, model = 1, itemtype = "graded", verbose = FALSE)
  theta <- fscores(mod)[, 1]
  
  # Expected score per item per person
  for (j in 1:length(items)) {
    eitem <- extract.item(mod, j)
    # Expected score = sum(k * P(X=k)) for k = 1..5
    probs <- probtrace(eitem, matrix(theta, ncol = 1))
    expected <- rowSums(sweep(probs, 2, 1:ncol(probs), "*"))
    residual_profiles[, items[j]] <- fdf[, j] - expected
  }
  
  pfit <- personfit(mod)
  person_fit_combined[[paste0("Zh_", fname)]] <- pfit$Zh
}

cat("Residual profile matrix:", nrow(residual_profiles), "persons x", ncol(residual_profiles), "items\n")

# --- 5B: k-means clustering on residual profiles ---
cat("\n--- 5B: K-MEANS CLUSTERING ON RESIDUAL PROFILES ---\n")

# Remove any rows with NA residuals
valid_rows <- complete.cases(residual_profiles)
resid_clean <- residual_profiles[valid_rows, ]

silhouette_scores <- numeric(4)
cluster_results <- list()

for (k_val in 2:5) {
  km <- kmeans(resid_clean, centers = k_val, nstart = 25, iter.max = 100)
  sil <- cluster::silhouette(km$cluster, dist(resid_clean, method = "euclidean"))
  silhouette_scores[k_val - 1] <- mean(sil[, 3])
  cluster_results[[k_val - 1]] <- km
  cat("  k =", k_val, ": silhouette =", round(mean(sil[, 3]), 4), 
      ", sizes:", paste(km$size, collapse = ", "), "\n")
}

best_k <- which.max(silhouette_scores) + 1
cat("  Best k:", best_k, "(silhouette:", round(max(silhouette_scores), 4), ")\n")

# Characterize the best clustering
best_km <- cluster_results[[best_k - 1]]
cat("\n  Cluster profiles (mean residual per facet):\n")
for (cl in 1:best_k) {
  cl_rows <- resid_clean[best_km$cluster == cl, ]
  cat("  Cluster", cl, "(n=", nrow(cl_rows), "):\n")
  for (fname in names(ipip_facets)) {
    items <- ipip_facets[[fname]]
    mean_resid <- mean(cl_rows[, items])
    cat("    ", fname, ":", round(mean_resid, 3), "\n")
  }
}

# --- 5C: Anomaly detection ---
cat("\n--- 5C: ANOMALY DETECTION ---\n")

# Check if isotree is available; if not, use LOF from dbscan or a manual approach
has_isotree <- requireNamespace("isotree", quietly = TRUE)
has_dbscan <- requireNamespace("dbscan", quietly = TRUE)

if (!has_isotree && !has_dbscan) {
  cat("Installing isotree...\n")
  install.packages("isotree", repos = "https://cloud.r-project.org", quiet = TRUE)
  has_isotree <- requireNamespace("isotree", quietly = TRUE)
}

# Use all 60 IPIP items for anomaly detection
ipip_full <- df[, all_ipip]

if (has_isotree) {
  library(isotree)
  iso_model <- isolation.forest(ipip_full, ntrees = 500, nthreads = 1)
  anomaly_scores <- predict(iso_model, ipip_full)
  
  # Flag top 5% as anomalies
  threshold <- quantile(anomaly_scores, 0.95)
  anomaly_flag <- as.integer(anomaly_scores >= threshold)
  n_anomalies <- sum(anomaly_flag)
  
  cat("Isolation Forest: ", n_anomalies, " anomalies flagged (top 5%)\n")
  cat("  Score range:", round(min(anomaly_scores), 4), "to", round(max(anomaly_scores), 4), "\n")
  cat("  Threshold (95th pctl):", round(threshold, 4), "\n")
} else if (has_dbscan) {
  library(dbscan)
  lof_scores <- lof(ipip_full, minPts = 10)
  threshold <- quantile(lof_scores, 0.95)
  anomaly_flag <- as.integer(lof_scores >= threshold)
  anomaly_scores <- lof_scores
  n_anomalies <- sum(anomaly_flag)
  cat("LOF: ", n_anomalies, " anomalies flagged (top 5%)\n")
} else {
  cat("No anomaly detection package available. Using Mahalanobis distance.\n")
  center <- colMeans(ipip_full)
  cov_mat <- cov(ipip_full)
  mah_dist <- mahalanobis(ipip_full, center, cov_mat)
  threshold <- quantile(mah_dist, 0.95)
  anomaly_flag <- as.integer(mah_dist >= threshold)
  anomaly_scores <- mah_dist
  n_anomalies <- sum(anomaly_flag)
  cat("Mahalanobis: ", n_anomalies, " anomalies flagged (top 5%)\n")
}

# --- 5D: Cross-reference anomalies with IRT person-fit ---
cat("\n--- 5D: CROSS-REFERENCE ANOMALY vs IRT PERSON-FIT ---\n")

# A person is IRT-flagged if Zh < -2 on ANY facet
any_zh_flag <- apply(person_fit_combined[, grep("Zh_", names(person_fit_combined))], 1, 
                     function(row) any(row < -2, na.rm = TRUE))
any_zh_flag <- as.integer(any_zh_flag)

both_flagged <- sum(anomaly_flag == 1 & any_zh_flag == 1)
only_anomaly <- sum(anomaly_flag == 1 & any_zh_flag == 0)
only_zh <- sum(anomaly_flag == 0 & any_zh_flag == 1)
neither <- sum(anomaly_flag == 0 & any_zh_flag == 0)

cat("  Confusion matrix (Anomaly vs IRT person-fit):\n")
cat("                    IRT OK   IRT Flagged\n")
cat("  Anomaly OK:      ", neither, "     ", only_zh, "\n")
cat("  Anomaly Flagged: ", only_anomaly, "      ", both_flagged, "\n")

# Agreement
n_total <- n
agreement <- (both_flagged + neither) / n_total
cat("\n  Agreement:", round(agreement * 100, 1), "%\n")
cat("  Both flagged:", both_flagged, "\n")
cat("  Only anomaly detector:", only_anomaly, "\n")
cat("  Only IRT person-fit:", only_zh, "\n")

# Jaccard similarity for flagged sets
jaccard <- both_flagged / (both_flagged + only_anomaly + only_zh)
cat("  Jaccard similarity of flagged sets:", round(jaccard, 3), "\n")

# --- 5E: What drives the anomalies? ---
cat("\n--- 5E: WHAT DRIVES ANOMALIES? ---\n")

# For anomaly-flagged persons, which facets have the most extreme residuals?
if (n_anomalies > 0) {
  anom_resids <- residual_profiles[anomaly_flag == 1, ]
  norm_resids <- residual_profiles[anomaly_flag == 0, ]
  
  cat("  Mean absolute residual per facet (anomalous vs normal):\n")
  facet_drivers <- data.frame()
  for (fname in names(ipip_facets)) {
    items <- ipip_facets[[fname]]
    anom_mar <- mean(abs(anom_resids[, items]))
    norm_mar <- mean(abs(norm_resids[, items]))
    ratio <- anom_mar / norm_mar
    cat("    ", fname, ": anomalous=", round(anom_mar, 3), 
        " normal=", round(norm_mar, 3), " ratio=", round(ratio, 2), "\n")
    facet_drivers <- rbind(facet_drivers, data.frame(
      facet = fname, anom_mean_abs_resid = round(anom_mar, 4),
      normal_mean_abs_resid = round(norm_mar, 4), ratio = round(ratio, 3),
      stringsAsFactors = FALSE))
  }
  write.csv(facet_drivers, "results/anomaly_facet_drivers.csv", row.names = FALSE)
}

# Save clustering and anomaly results
cluster_assignment <- data.frame(
  person_id = 1:n,
  cluster = NA,
  anomaly_score = anomaly_scores,
  anomaly_flag = anomaly_flag,
  irt_any_flag = any_zh_flag
)
cluster_assignment$cluster[valid_rows] <- best_km$cluster

write.csv(cluster_assignment, "results/person_subtypes_and_anomalies.csv", row.names = FALSE)
write.csv(person_fit_combined, "results/person_fit_all_facets.csv", row.names = FALSE)

# Silhouette summary
sil_df <- data.frame(k = 2:5, silhouette = round(silhouette_scores, 4))
write.csv(sil_df, "results/clustering_silhouette_scores.csv", row.names = FALSE)

cat("\nAll Decision 2-5 results saved to results/\n")
cat("Done.\n")
