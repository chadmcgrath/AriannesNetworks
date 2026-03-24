# Tier 4: IRT Graded Response Model for IPIP Neuroticism facets
# Produces: item parameters (discrimination, thresholds), person theta estimates,
# person-fit (l_z), item information, and SE per person.

library(mirt)

# ---- Load and preprocess (replicating P1 steps) ----

data1 <- read.csv("data/NEO_IPIP_1.csv")

# Reverse code IPIP Neuroticism items (6 - x)
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

# Select columns and drop NAs
all_items <- unlist(facets)
df <- data1[, all_items]
df <- df[complete.cases(df), ]
cat("Sample size:", nrow(df), "\n")

# ---- Fit GRM and extract results per facet ----

item_params_all <- data.frame()
person_results_all <- data.frame()
item_info_all <- data.frame()

for (fname in names(facets)) {
  cat("\n===", fname, "===\n")
  items <- facets[[fname]]
  fdf <- df[, items]
  
  mod <- mirt(fdf, model = 1, itemtype = "graded", verbose = FALSE)
  
  # Item parameters: discrimination (a1) and thresholds (d1..d4)
  coefs <- coef(mod, simplify = TRUE, IRTpars = TRUE)$items
  iparams <- as.data.frame(coefs)
  iparams$item <- rownames(iparams)
  iparams$facet <- fname
  item_params_all <- rbind(item_params_all, iparams)
  
  # Person theta estimates with SE
  theta <- fscores(mod, full.scores.SE = TRUE)
  
  # Person-fit
  pfit <- personfit(mod)
  
  person_df <- data.frame(
    person_id = 1:nrow(fdf),
    facet = fname,
    theta = theta[, 1],
    SE_theta = theta[, 2],
    Zh = pfit$Zh
  )
  person_results_all <- rbind(person_results_all, person_df)
  
  # Item information at theta = -2, -1, 0, 1, 2
  theta_points <- matrix(c(-2, -1, 0, 1, 2), ncol = 1)
  info_mat <- matrix(NA, nrow = length(items), ncol = 5)
  for (j in 1:length(items)) {
    einfo <- extract.item(mod, j)
    info_mat[j, ] <- iteminfo(einfo, theta_points)
  }
  colnames(info_mat) <- paste0("info_theta_", c("neg2", "neg1", "0", "pos1", "pos2"))
  info_df <- data.frame(
    facet = fname,
    item = items,
    info_mat
  )
  item_info_all <- rbind(item_info_all, info_df)
  
  # Print summary
  cat("  Discrimination (a) range:", round(min(coefs[, "a"]), 2), "to", round(max(coefs[, "a"]), 2), "\n")
  cat("  Person SE range:", round(min(theta[, 2]), 3), "to", round(max(theta[, 2]), 3), "\n")
  cat("  Person-fit Zh < -2:", sum(pfit$Zh < -2, na.rm = TRUE), "of", nrow(fdf), "\n")
}

# ---- Save results ----

write.csv(item_params_all, "results/irt_item_parameters.csv", row.names = FALSE)
write.csv(person_results_all, "results/irt_person_estimates.csv", row.names = FALSE)
write.csv(item_info_all, "results/irt_item_information.csv", row.names = FALSE)

# Summary: flagged persons per facet
cat("\n\n=== PERSON-FIT SUMMARY (Zh < -2) ===\n")
for (fname in names(facets)) {
  pf <- person_results_all[person_results_all$facet == fname, ]
  n_flagged <- sum(pf$Zh < -2, na.rm = TRUE)
  cat(fname, ": ", n_flagged, " of ", nrow(pf), " (", round(n_flagged/nrow(pf)*100, 1), "%)\n", sep = "")
}

# Summary: item discrimination rankings
cat("\n=== ITEM DISCRIMINATION RANKINGS ===\n")
for (fname in names(facets)) {
  ip <- item_params_all[item_params_all$facet == fname, c("item", "a")]
  ip <- ip[order(-ip$a), ]
  cat("\n", fname, ":\n", sep = "")
  for (i in 1:nrow(ip)) {
    cat("  ", ip$item[i], ": a =", round(ip$a[i], 3), "\n")
  }
}

# Summary: SE variation across persons
cat("\n=== PERSON SE VARIATION (how trust varies by person) ===\n")
for (fname in names(facets)) {
  pf <- person_results_all[person_results_all$facet == fname, ]
  cat(fname, ": SE median =", round(median(pf$SE_theta), 3),
      ", SE at 10th pctl =", round(quantile(pf$SE_theta, 0.1), 3),
      ", SE at 90th pctl =", round(quantile(pf$SE_theta, 0.9), 3), "\n")
}

cat("\nDone. Results saved to results/irt_*.csv\n")
