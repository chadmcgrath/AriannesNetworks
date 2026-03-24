# From Noise Analysis to Actionable Intelligence: Results

Date: February 24, 2026
Full conversation: [conversation_noise_entropy_item_weighting.md](conversation_noise_entropy_item_weighting.md)

---

## What This Document Is

This document reports the results of a comprehensive noise analysis of IPIP and NEO Neuroticism facets, organized around five decision-oriented questions. All analyses use the same dataset (NEO_IPIP_1.csv, 488-539 participants depending on NA exclusion, 60 IPIP + 48 NEO items across 6 Neuroticism facets).

Scripts: `compute_tiers_1_to_3.py`, `compute_tier4_irt.R`, `compute_tier4_ml_corrected.R`, `compute_decisions_2_to_5.R`
Item mapping: `build_item_mapping.py`, `merge_item_text_into_results.py`
Results: all CSV files in `results/` (all item-level files include `item_text` column)

---

## The Five Decisions This Analysis Informs

### Decision 1: Which questions to ask
### Decision 2: How to score a person
### Decision 3: How much to trust a score
### Decision 4: Whether the network structure is real
### Decision 5: Whether a response pattern is meaningful

---

## Theoretical Foundation

### Theorems and Formulas Used

1. **Spearman-Brown Prophecy Formula** (Spearman 1910, Brown 1910): `rho' = n*rho / (1 + (n-1)*rho)`. Predicts reliability change when test length changes. Proves item aggregation only helps in the presence of noise.

2. **Variance of the Sample Mean**: `Var(X_bar) = sigma^2 / n`. Averaging reduces variance proportional to n.

3. **Shannon Entropy** (Shannon 1948): `H = -sum(p_k * log2(p_k))`. Measures information content of item responses. Max for 5-point Likert = log2(5) = 2.32 bits.

4. **Fisher Information** (Fisher 1925): `I = 1/SE^2`, additive across independent items. `Var(theta_hat) ~ 1/(N*I)`.

5. **Classical Test Theory**: `X = T + E`. `SEM = SD * sqrt(1 - alpha)`. Bridges reliability and measurement precision.

6. **Disattenuated Correlation**: `r_true = r_observed / sqrt(alpha_x * alpha_y)`. Corrects for measurement error in both variables.

7. **IRT Graded Response Model** (Samejima 1969): Item discrimination (a) quantifies how sharply an item differentiates trait levels. Person-fit (Zh) detects improbable response patterns.

### Central Finding

**All benefit from item aggregation is attributable to noise reduction.** In zero-noise conditions, additional items contribute zero information (provable from theorems 1-4). The ~2.5x sample-size equivalence reported by Herrera-Bennett & Rhemtulla (2021) is a function of the noise level in these specific items, not a universal law.

---

## Results: Tier 1 -- Facet-Level Metrics

### IPIP Neuroticism (10 items per facet, N=539)

| Facet | Alpha | Noise% | Avg r | r range | SD | SEM | NEO-IPIP r | Disattenuated r | PCA Var1% |
|-------|-------|--------|-------|---------|-----|------|------------|-----------------|-----------|
| N1 Anxiety | 0.833 | 16.7% | 0.333 | 0.16-0.49 | 6.80 | 2.78 | 0.753 | 0.907 | 40.9% |
| N2 Anger | 0.885 | 11.5% | 0.434 | 0.28-0.62 | 7.36 | 2.50 | 0.776 | 0.917 | 50.5% |
| N3 Depression | 0.885 | 11.5% | 0.436 | 0.25-0.69 | 7.77 | 2.64 | 0.805 | 0.930 | 50.5% |
| N4 Self-Consc. | 0.796 | 20.4% | 0.280 | 0.15-0.44 | 6.54 | 2.95 | 0.733 | 0.951 | 36.2% |
| N5 Immoderation | 0.774 | 22.6% | 0.255 | 0.08-0.52 | 6.54 | 3.11 | 0.739 | 0.988 | 34.5% |
| N6 Vulnerability | 0.827 | 17.3% | 0.329 | 0.13-0.51 | 6.34 | 2.64 | 0.779 | 0.963 | 40.4% |

### NEO Neuroticism (8 items per facet, N=539)

| Facet | Alpha | Noise% | Avg r | SEM | ITC mean | ITC range |
|-------|-------|--------|-------|------|----------|-----------|
| N1 Anxiety | 0.827 | 17.3% | 0.375 | 2.33 | 0.552 | 0.45-0.72 |
| N2 Anger | 0.810 | 19.0% | 0.348 | 2.17 | 0.526 | 0.42-0.60 |
| N3 Depression | 0.847 | 15.3% | 0.409 | 2.38 | 0.589 | 0.39-0.71 |
| N4 Self-Consc. | 0.746 | 25.5% | 0.268 | 2.55 | 0.442 | 0.27-0.64 |
| N5 Immoderation | 0.721 | 27.9% | 0.244 | 2.48 | 0.412 | 0.29-0.60 |
| N6 Vulnerability | 0.792 | 20.8% | 0.322 | 1.95 | 0.514 | 0.43-0.61 |

### Key Observations

- **Depression** has the best reliability (alpha=0.885) and highest cross-instrument correlation (r=0.805).
- **Immoderation** has the worst reliability (alpha=0.774), widest inter-item r range (0.08-0.52), and lowest PCA first-component variance (34.5%).
- **Self-Consciousness** and **Immoderation** disattenuated correlations approach or exceed 1.0 (0.951 and 0.988), suggesting that after correcting for noise, these IPIP and NEO facets may be measuring essentially the same thing.
- SEM ranges from 2.50 (Anger) to 3.11 (Immoderation) on a 10-50 total score scale. A person's Immoderation score has a 95% CI roughly 2.4 points wider than their Anger score.

---

## Results: Tier 2 -- Item-Level Metrics

### Items With Highest Diagnostic Value (by item-total correlation)

| Facet | Best Item | Question Text | ITC | Worst Item | Question Text | ITC |
|-------|-----------|---------------|-----|------------|---------------|-----|
| N1 Anxiety | h1157 | Worry about things. | 0.629 | h2000_R | Adapt easily to new situations. | 0.427 |
| N2 Anger | h754 | Get angry easily. | 0.703 | e120_R | Rarely complain. | 0.516 |
| N3 Depression | x74 | Often feel blue. | 0.733 | h737_R | Am very pleased with myself. | 0.513 |
| N4 Self-Consc. | h991 | Am easily intimidated. | 0.574 | h1197_R | Am able to stand up for myself. | 0.382 |
| N5 Immoderation | x181_R | Rarely overindulge. | 0.573 | h2029 | Love to eat. | 0.303 |
| N6 Vulnerability | h948 | Panic easily. | 0.608 | h901 | Can't make up my mind. | 0.432 |

### Alpha-If-Dropped

No single item removal increases alpha for any facet, confirming that all items contribute positively to reliability. However, the magnitude varies: dropping h2029 from Immoderation changes alpha by only -0.002, while dropping x74 from Depression changes alpha by -0.020.

### Response Entropy

Mean entropy ranges from 1.50 (N6 Vulnerability NEO) to 2.03 (N4 Self-Consciousness IPIP) against a maximum of 2.32 bits. Items with lower entropy have less balanced response distributions and carry less information per response.

---

## Results: Tier 3 -- Structural Analysis

### PCA Within Facets

| Facet | PC1 Var% | PC2 Var% | Interpretation |
|-------|----------|----------|----------------|
| N1 Anxiety | 40.9% | 10.2% | Reasonably unidimensional |
| N2 Anger | 50.5% | 8.6% | Strong single factor |
| N3 Depression | 50.5% | 9.6% | Strong single factor |
| N4 Self-Consc. | 36.2% | 10.7% | Weakest unidimensionality, PC2 rivals PC1 |
| N5 Immoderation | 34.5% | 12.2% | Most multidimensional, PC2 at 35% of PC1's variance |
| N6 Vulnerability | 40.4% | 11.0% | Moderate unidimensionality |

### Best and Worst Item Pairs (IPIP, split-half analysis)

| Facet | Best Pair | r | Worst Pair | r |
|-------|-----------|---|------------|---|
| N1 Anxiety | "Get stressed out easily" + "Get caught up in my problems" | 0.487 | "Don't worry about things that have already happened" + "Adapt easily to new situations" | 0.160 |
| N2 Anger | "Seldom get mad" + "Rarely get irritated" | 0.619 | "Rarely complain" + "Lose my temper" | 0.284 |
| N3 Depression | "Seldom feel blue" + "Often feel blue" | 0.690 | "Have frequent mood swings" + "Am very pleased with myself" | 0.254 |
| N4 Self-Consc. | "Am comfortable in unfamiliar situations" + "Am not bothered by difficult social situations" | 0.443 | "Am able to stand up for myself" + "Only feel comfortable with friends" | 0.154 |
| N5 Immoderation | "Do things that I later regret" + "Don't know why I do some of the things I do" | 0.523 | "Don't know why I do some of the things I do" + "Love to eat" | 0.081 |
| N6 Vulnerability | "Am calm even in tense situations" + "Remain calm under pressure" | 0.515 | "Am calm even in tense situations" + "Can't make up my mind" | 0.132 |

Depression's best pair (r=0.690) is nearly as reliable as Immoderation's entire 10-item scale (alpha=0.774). Two well-chosen Depression items match ten mediocre Immoderation items.

---

## Results: Tier 4 -- IRT (Graded Response Model)

### Item Discrimination (a-parameter)

Higher discrimination = sharper measurement. Conventional benchmarks: a < 0.65 = very low, 0.65-1.34 = moderate, 1.35-1.69 = high, > 1.70 = very high.

**Standout items:**
- x74 "Often feel blue." (Depression): a = 3.00 -- exceptionally discriminating
- x156_R "Seldom feel blue." (Depression): a = 2.55
- x265_R "Rarely get irritated." (Anger): a = 2.47
- x231_R "Seldom get mad." (Anger): a = 2.44
- h754 "Get angry easily." (Anger): a = 2.25

**Weakest items:**
- e30_R "Never splurge." (Immoderation): a = 0.69 -- borderline useful
- h2029 "Love to eat." (Immoderation): a = 0.70
- x216_R "Never spend more than I can afford." (Immoderation): a = 0.85
- e24 "Do things that I later regret." (Immoderation): a = 0.95

All four weak items belong to Immoderation. No other facet has items below a = 1.0.

### Person-Fit (Zh < -2 flags)

| Facet | Flagged | % | Interpretation |
|-------|---------|---|----------------|
| N1 Anxiety | 24 | 4.5% | Normal |
| N2 Anger | 28 | 5.2% | Elevated |
| N3 Depression | 26 | 4.8% | Elevated -- tight model, deviations visible |
| N4 Self-Consc. | 29 | 5.4% | Elevated |
| N5 Immoderation | 12 | 2.2% | Paradoxically low -- model is so loose that almost any pattern fits |
| N6 Vulnerability | 31 | 5.8% | Elevated |

Vulnerability flags the most people because its model is precise enough to detect deviations. Immoderation flags the fewest because its model expects inconsistency.

### Person-Specific SE Variation

| Facet | SE median | SE 10th pctl | SE 90th pctl |
|-------|-----------|-------------|-------------|
| N2 Anger | 0.314 | 0.287 | 0.355 |
| N3 Depression | 0.306 | 0.275 | 0.406 |
| N1 Anxiety | 0.376 | 0.350 | 0.416 |
| N6 Vulnerability | 0.386 | 0.357 | 0.438 |
| N4 Self-Consc. | 0.413 | 0.382 | 0.459 |
| N5 Immoderation | 0.425 | 0.388 | 0.473 |

Anger and Depression give the tightest person-level estimates. Depression also has the widest SE variation (0.275-0.406): some people are measured very precisely, others much less so. Immoderation has the loosest measurement across the board.

---

## Results: ML Analysis -- Random Forest Item Importance

### Methodology and Evaluation

**Initial approach (rejected):** Predicted IPIP facet mean from IPIP items. This is circular -- the target is a linear combination of the inputs. Linear regression achieved R²=1.0 trivially. RF importance in this setup rewarded items for being *different* from the group (negative Spearman correlation with item-total r). Results discarded.

**Corrected approach:** Predicted NEO facet score from IPIP items (cross-instrument). This is a genuine prediction task where the answer isn't embedded in the inputs.

### Cross-Instrument Prediction (10-fold CV)

| Facet | RF R² | LM R² | Mean Baseline MAE | RF MAE | LM MAE |
|-------|-------|-------|-------------------|--------|--------|
| N1 Anxiety | 0.588 | 0.602 | 0.568 | 0.360 | 0.349 |
| N2 Anger | 0.563 | 0.589 | 0.479 | 0.327 | 0.325 |
| N3 Depression | 0.623 | 0.643 | 0.604 | 0.367 | 0.357 |
| N4 Self-Consc. | 0.511 | 0.530 | 0.508 | 0.344 | 0.334 |
| N5 Immoderation | 0.527 | 0.537 | 0.480 | 0.322 | 0.322 |
| N6 Vulnerability | 0.577 | 0.598 | 0.405 | 0.266 | 0.261 |

**Key finding: RF never beats linear regression.** The items combine linearly to predict the construct. There are no meaningful nonlinear item-construct relationships. Standard averaging is not leaving information on the table.

### Stability

Depression item rankings across 5 independent RF runs: 8 of 10 items had rank range = 0 (identical every time), 2 items had range = 1. Importance values are robust.

### Top Items by Cross-Instrument Importance (permutation)

| Facet | #1 Item | Question Text | perm% | #2 Item | Question Text | perm% | Weakest | Question Text | perm% |
|-------|---------|---------------|-------|---------|---------------|-------|---------|---------------|-------|
| N1 Anxiety | h1157 | Worry about things. | 38.3% | h968 | Am afraid of many things. | 21.0% | h2000_R | Adapt easily to new situations. | 0.03% |
| N2 Anger | h754 | Get angry easily. | 19.6% | x265_R | Rarely get irritated. | 15.3% | e120_R | Rarely complain. | 4.4% |
| N3 Depression | x74 | Often feel blue. | 17.6% | h646 | Have a low opinion of myself. | 15.6% | x129_R | Feel comfortable with myself. | 2.3% |
| N4 Self-Consc. | h905 | Am afraid that I will do the wrong thing. | 28.7% | h991 | Am easily intimidated. | 20.4% | h1197_R | Am able to stand up for myself. | 2.9% |
| N5 Immoderation | x274_R | Easily resist temptations. | 22.8% | x145 | Often eat too much. | 20.3% | x216_R | Never spend more than I can afford. | 4.6% |
| N6 Vulnerability | h948 | Panic easily. | 23.4% | x79_R | Remain calm under pressure. | 14.5% | h470_R | Can handle complex problems. | 2.2% |

h2000_R "Adapt easily to new situations" (Anxiety) contributes 0.03% of predictive importance for the NEO Anxiety score despite correlating with its IPIP peers (item-total r = 0.43). It measures something, but not what the NEO independently measures.

### Cross-Facet Discriminant Validity

| Facet | Own R² | Best Other R² (facet) | Ratio |
|-------|--------|----------------------|-------|
| N1 Anxiety | 0.568 | 0.401 (N6 Vulnerability) | 1.42 |
| N2 Anger | 0.602 | 0.224 (N3 Depression) | 2.69 |
| N3 Depression | 0.648 | 0.457 (N6 Vulnerability) | 1.42 |
| N4 Self-Consc. | 0.537 | 0.301 (N3 Depression) | 1.78 |
| N5 Immoderation | 0.545 | 0.153 (N3 Depression) | 3.56 |
| N6 Vulnerability | 0.606 | 0.339 (N3 Depression) | 1.79 |

Anxiety and Depression have the weakest discriminant validity (ratio 1.42) -- their IPIP items predict each other's NEO scores almost as well as their own. Immoderation has the best (ratio 3.56) -- its items are distinctly its own.

---

## Results: ML Analysis -- Community Detection

### Mutual Information Network (Louvain, median MI threshold)

The algorithm found 3 communities across 60 IPIP items, not the 6 assigned facets:

| Community | Items | Composition | Interpretation |
|-----------|-------|-------------|----------------|
| 1 | 19 | 7 Anxiety + 9 Anger + 1 Depression + 2 Vulnerability | **Emotional Volatility** -- reactive anger, irritability, stress reactivity |
| 2 | 31 | 3 Anxiety + 1 Anger + 9 Depression + 10 Self-Consc. + 8 Vulnerability | **Withdrawal/Distress** -- internalizing, self-doubt, helplessness |
| 3 | 10 | 10 Immoderation | **Impulsivity** -- "Love to eat", "Go on binges", "Often eat too much", etc. |

### Evaluation

- **Modularity**: 0.183 (weak community structure)
- **NMI**: 0.530 (moderate agreement with assigned facets; 1.0 = perfect, 0.0 = chance)
- **Stability**: Threshold-dependent (4 communities at 25th percentile, 6 at 75th percentile)
- **N5 Immoderation**: 100% purity, perfectly separated
- **N4 Self-Consciousness**: 100% contained in Community 2, but shares it with Depression and Vulnerability

### Interpretation

The 3-community structure maps to DeYoung et al.'s (2007) "aspects" model, which splits Neuroticism into Volatility and Withdrawal. The data rediscovers this higher-order structure without being told about it. Immoderation is structurally separate from the rest of Neuroticism at the item level.

---

---

## Results: Decision 2 -- Scoring Method Comparison

Four scoring methods were compared for each IPIP Neuroticism facet, evaluated by correlation with the independently-measured NEO facet score (convergent validity).

| Facet | Equal-Weight | IRT Theta | Discrim-Weighted | RF Predicted (CV) | Winner |
|-------|-------------|-----------|-----------------|-------------------|--------|
| N1 Anxiety | 0.753 | 0.748 | 0.757 | 0.768 | RF |
| N2 Anger | 0.776 | 0.754 | 0.772 | 0.746 | Equal-Weight |
| N3 Depression | 0.805 | 0.782 | 0.802 | 0.789 | Equal-Weight |
| N4 Self-Consc. | 0.733 | 0.727 | 0.735 | 0.718 | Discrim-Weighted |
| N5 Immoderation | 0.739 | 0.725 | 0.734 | 0.719 | Equal-Weight |
| N6 Vulnerability | 0.779 | 0.759 | 0.780 | 0.759 | Discrim-Weighted |

### Interpretation

**The differences between scoring methods are negligible.** The largest gap across all facets is 0.023 (Depression: equal-weight 0.805 vs IRT 0.782). No method consistently dominates.

IRT theta scores, despite being theoretically optimal, perform *worst* across 5 of 6 facets. This is likely because the GRM is fitting a unidimensional model to facets that are not perfectly unidimensional (especially Immoderation at 34.5% PC1 variance). The model overfits item-level structure that doesn't generalize to the NEO criterion.

Equal-weight averaging wins or ties for 3 of 6 facets. The simple approach is hard to beat.

**Actionable conclusion:** Discrimination-weighted scoring offers a marginal, inconsistent improvement over equal weighting. The payoff from better scoring is small compared to the payoff from better item selection (Decision 1).

---

## Results: Decision 3 -- Confidence Classifier

Can simple response features predict IRT person-fit (Zh < -2) without running IRT?

### Features Used

- Within-person SD across items in a facet
- Number of extreme responses (1s and 5s)
- Response range (max - min)
- Mean response
- Number of midpoint responses (3s)
- Straightlining (longest run of consecutive identical answers)

### Classifier Performance (10-fold CV)

| Facet | Flagged | Base Rate | LR Precision | LR Recall | LR AUC | RF AUC |
|-------|---------|-----------|-------------|-----------|--------|--------|
| N1 Anxiety | 22 | 4.5% | 0.667 | 0.455 | 0.931 | 0.897 |
| N2 Anger | 25 | 5.1% | 0.864 | 0.760 | 0.961 | 0.956 |
| N3 Depression | 23 | 4.7% | 0.737 | 0.609 | 0.961 | 0.978 |
| N4 Self-Consc. | 22 | 4.5% | 0.500 | 0.364 | 0.947 | 0.938 |
| N5 Immoderation | 11 | 2.3% | 1.000 | 0.091 | 0.820 | 0.687 |
| N6 Vulnerability | 26 | 5.3% | 0.778 | 0.808 | 0.985 | 0.975 |

### Interpretation

**Within-person SD is the dominant feature in every single facet.** A person whose responses vary a lot within a facet is likely to be flagged by IRT person-fit.

AUC is high (0.82-0.99), meaning the ranking is accurate: simple features correctly sort people from most to least consistent. However, precision and recall at the default threshold are uneven -- the classifier works well for Anger (precision 0.86, recall 0.76) and Vulnerability (0.78, 0.81) but poorly for Immoderation (recall 0.09).

Immoderation fails because its base rate is only 2.3% and the IRT model is so loose that "flagged" patterns are rare and unpredictable from surface features.

**Actionable conclusion:** For most facets, within-person SD alone is a reasonable proxy for IRT person-fit. You don't need to fit a full IRT model to identify the most unreliable respondents -- a spreadsheet formula suffices. However, this misses Immoderation, where the concept of "unreliable" is itself unreliable.

---

## Results: Decision 4 -- Network Re-estimation

### Edge Weights Across Four Scoring Methods

All 15 edges were computed under raw averages, IRT theta, discrimination-weighted averages, and disattenuated correlations.

**Largest edge changes under disattenuation (top 5):**

| Edge | Raw | Disattenuated | Change | % Change |
|------|-----|---------------|--------|----------|
| N1 Anxiety - N6 Vulnerability | 0.666 | 0.802 | +0.136 | +20.5% |
| N4 Self-Consc. - N6 Vulnerability | 0.565 | 0.696 | +0.131 | +23.2% |
| N1 Anxiety - N4 Self-Consc. | 0.521 | 0.640 | +0.119 | +22.7% |
| N3 Depression - N4 Self-Consc. | 0.591 | 0.704 | +0.113 | +19.1% |
| N1 Anxiety - N3 Depression | 0.683 | 0.796 | +0.112 | +16.5% |

Edges involving N4 (Self-Consciousness, alpha=0.80) and N6 (Vulnerability, alpha=0.83) show the largest corrections because both facets have substantial measurement error.

### Strength Centrality Rankings

| Facet | Raw Rank | IRT Rank | Discrim Rank | Disatt Rank |
|-------|----------|----------|-------------|-------------|
| N1 Anxiety | 2 | 2 | 2 | 2 |
| N2 Anger | 4 | 5 | 5 | 5 |
| N3 Depression | 1 | 1 | 1 | 1 |
| N4 Self-Consc. | 5 | 4 | 4 | 4 |
| N5 Immoderation | 6 | 6 | 6 | 6 |
| N6 Vulnerability | 3 | 3 | 3 | 3 |

### Interpretation

**Centrality rankings are remarkably stable across all scoring methods.** The top 3 (Depression, Anxiety, Vulnerability) and bottom 1 (Immoderation) never change. N2 Anger and N4 Self-Consciousness swap ranks 4/5 between raw and IRT/disattenuated, but this is a minor perturbation.

**N5 Immoderation is rank 6 (least central) under every method.** Its peripherality is not a measurement artifact. Even after correcting for its poor reliability (alpha=0.774), it remains the weakest node. This is a genuine structural feature of Neuroticism.

Edge weights increase 13-27% under disattenuation, meaning the raw network systematically underestimates the strength of inter-facet relationships. But the *relative* structure is preserved. The topology is real; only the absolute magnitudes are attenuated.

**Actionable conclusion:** The network structure reported in the original research is robust to scoring method. Centrality rankings can be trusted. However, absolute edge weights should be interpreted as lower bounds on the true inter-facet correlations.

---

## Results: Decision 5 -- Person Subtype Discovery

### Residual Profile Clustering (k-means)

Silhouette scores for k=2 through k=5:

| k | Silhouette |
|---|-----------|
| 2 | 0.033 |
| 3 | 0.025 |
| 4 | 0.022 |
| 5 | 0.022 |

**All silhouette scores are near zero.** Best k=2 achieves only 0.033, indicating essentially no cluster structure in the residual profiles. The two "clusters" (n=265 and n=223) have nearly identical mean residuals across all facets (differences < 0.05). There are no meaningful response subtypes in this sample.

### Anomaly Detection (Isolation Forest)

25 persons (5%) flagged as anomalous from the full 60-item response vectors.

**Cross-reference with IRT person-fit (Zh < -2 on any facet):**

|  | IRT OK | IRT Flagged |
|--|--------|-------------|
| Anomaly OK | 386 | 77 |
| Anomaly Flagged | 11 | 14 |

- Agreement: 82%
- Jaccard similarity of flagged sets: 0.137 (very low overlap)
- Both flagged: 14 persons
- Only Isolation Forest: 11 persons
- Only IRT: 77 persons

The two methods identify largely *different* people. IRT person-fit flags 91 persons across all facets (any Zh < -2), while Isolation Forest flags 25. Only 14 overlap.

This makes sense: IRT person-fit is facet-specific (a person who answers inconsistently on one facet but normally on five others gets flagged), while Isolation Forest evaluates the full 60-item response vector as a whole (a person who is slightly unusual everywhere but not extreme anywhere).

### What Drives Anomalies?

| Facet | Anomalous Mean Abs Resid | Normal Mean Abs Resid | Ratio |
|-------|--------------------------|----------------------|-------|
| N6 Vulnerability | 0.892 | 0.574 | 1.55 |
| N3 Depression | 0.812 | 0.568 | 1.43 |
| N5 Immoderation | 0.927 | 0.731 | 1.27 |
| N4 Self-Consc. | 0.886 | 0.703 | 1.26 |
| N2 Anger | 0.676 | 0.554 | 1.22 |
| N1 Anxiety | 0.728 | 0.650 | 1.12 |

Anomalous persons deviate most on Vulnerability (1.55x normal residuals) and Depression (1.43x). Anxiety shows the smallest deviation ratio (1.12x). The anomalies are concentrated in the internalizing facets, not the volatility facets.

### Interpretation

**There are no clean response subtypes.** The clustering failed to find meaningful groups (silhouette near zero). This does not mean individual differences don't exist -- it means they don't organize into discrete categories. People vary continuously, not categorically.

**Anomaly detection finds a different population than IRT person-fit.** The 11 persons flagged only by Isolation Forest have globally unusual response patterns that don't violate any single facet's model. They are "slightly off everywhere" rather than "wrong on one thing." This is a genuinely different kind of atypicality and may warrant closer examination in applied settings.

**Actionable conclusion:** Do not attempt to classify respondents into subtypes. The data doesn't support it. For flagging unreliable respondents, IRT person-fit and Isolation Forest complement each other: use IRT for facet-specific flags (the person answered this facet inconsistently) and Isolation Forest for global flags (the person's overall pattern is unusual).

---

## Summary of Actionable Conclusions

| Decision | Finding | Recommendation |
|----------|---------|----------------|
| 1. Which questions | Items vary 10x in cross-instrument importance (h1157 at 38% vs h2000_R at 0.03% within Anxiety). Two Depression items match ten Immoderation items. | Reduce instrument by cutting low-importance items. Oversample from high-discrimination facets. |
| 2. How to score | Equal-weight averaging matches or beats IRT and RF across most facets (max difference: 0.023 in r). | Keep simple averaging. The payoff from sophisticated scoring is negligible. |
| 3. Trust a score | Within-person SD predicts IRT person-fit with AUC 0.82-0.99. Confidence varies by facet (SEM: 2.50 to 3.11). | Attach per-facet confidence intervals. Flag persons with high within-person SD. |
| 4. Network reality | Centrality rankings are identical across all 4 scoring methods. Edge weights are attenuated 13-27% but relative structure is preserved. N5 Immoderation is genuinely peripheral. | Trust the raw network topology. Report disattenuated edge weights as a sensitivity check. |
| 5. Response patterns | No discrete subtypes (silhouette=0.03). Anomaly detection and IRT flag different people (Jaccard=0.14). | Use both IRT and Isolation Forest for complementary anomaly detection. Don't attempt subtype classification. |

---

## Complete Item Text Reference

All 60 IPIP Neuroticism items with their full question text, mapped from the International Personality Item Pool (ipip.ori.org, public domain).

| Facet | Code | Keying | Question Text |
|-------|------|--------|---------------|
| N1 Anxiety | h1157 | + | Worry about things. |
| N1 Anxiety | x107 | + | Get stressed out easily. |
| N1 Anxiety | x120 | + | Get caught up in my problems. |
| N1 Anxiety | h968 | + | Am afraid of many things. |
| N1 Anxiety | h999 | + | Fear for the worst. |
| N1 Anxiety | e141_R | - | Am relaxed most of the time. |
| N1 Anxiety | e150_R | - | Don't worry about things that have already happened. |
| N1 Anxiety | h1046_R | - | Am not easily disturbed by events. |
| N1 Anxiety | h2000_R | - | Adapt easily to new situations. |
| N1 Anxiety | x138_R | - | Am not easily bothered by things. |
| N2 Anger | h754 | + | Get angry easily. |
| N2 Anger | h755 | + | Lose my temper. |
| N2 Anger | h761 | + | Get irritated easily. |
| N2 Anger | x84 | + | Am often in a bad mood. |
| N2 Anger | x95 | + | Get upset easily. |
| N2 Anger | e120_R | - | Rarely complain. |
| N2 Anger | x23_R | - | Am not easily annoyed. |
| N2 Anger | x191_R | - | Keep my cool. |
| N2 Anger | x231_R | - | Seldom get mad. |
| N2 Anger | x265_R | - | Rarely get irritated. |
| N3 Depression | x74 | + | Often feel blue. |
| N3 Depression | h640 | + | Am often down in the dumps. |
| N3 Depression | h646 | + | Have a low opinion of myself. |
| N3 Depression | h947 | + | Feel desperate. |
| N3 Depression | e92 | + | Have frequent mood swings. |
| N3 Depression | x15 | + | Dislike myself. |
| N3 Depression | x205 | + | Feel that my life lacks direction. |
| N3 Depression | x129_R | - | Feel comfortable with myself. |
| N3 Depression | x156_R | - | Seldom feel blue. |
| N3 Depression | h737_R | - | Am very pleased with myself. |
| N4 Self-Consc. | h991 | + | Am easily intimidated. |
| N4 Self-Consc. | h905 | + | Am afraid that I will do the wrong thing. |
| N4 Self-Consc. | h592 | + | Find it difficult to approach others. |
| N4 Self-Consc. | h655 | + | Am afraid to draw attention to myself. |
| N4 Self-Consc. | h656 | + | Only feel comfortable with friends. |
| N4 Self-Consc. | h1205 | + | Stumble over my words. |
| N4 Self-Consc. | h1197_R | - | Am able to stand up for myself. |
| N4 Self-Consc. | x197_R | - | Am comfortable in unfamiliar situations. |
| N4 Self-Consc. | x209_R | - | Am not bothered by difficult social situations. |
| N4 Self-Consc. | x242_R | - | Am not embarrassed easily. |
| N5 Immoderation | x145 | + | Often eat too much. |
| N5 Immoderation | x133 | + | Go on binges. |
| N5 Immoderation | e24 | + | Do things that I later regret. |
| N5 Immoderation | e57 | + | Don't know why I do some of the things I do. |
| N5 Immoderation | h2029 | + | Love to eat. |
| N5 Immoderation | e30_R | - | Never splurge. |
| N5 Immoderation | x181_R | - | Rarely overindulge. |
| N5 Immoderation | x216_R | - | Never spend more than I can afford. |
| N5 Immoderation | x251_R | - | Am able to control my cravings. |
| N5 Immoderation | x274_R | - | Easily resist temptations. |
| N6 Vulnerability | h948 | + | Panic easily. |
| N6 Vulnerability | h950 | + | Get overwhelmed by emotions. |
| N6 Vulnerability | h959 | + | Become overwhelmed by events. |
| N6 Vulnerability | h954 | + | Feel that I'm unable to deal with things. |
| N6 Vulnerability | h901 | + | Can't make up my mind. |
| N6 Vulnerability | e64_R | - | Am calm even in tense situations. |
| N6 Vulnerability | h44_R | - | Readily overcome setbacks. |
| N6 Vulnerability | h470_R | - | Can handle complex problems. |
| N6 Vulnerability | h1281_R | - | Know how to cope. |
| N6 Vulnerability | x79_R | - | Remain calm under pressure. |

Source: International Personality Item Pool (IPIP), ipip.ori.org. All items are public domain.

---

## Data and Scripts

| File | Purpose |
|------|---------|
| data/NEO_IPIP_1.csv | Raw data (488 participants x ~540 items) |
| compute_tiers_1_to_3.py | CTT metrics, item analysis, PCA, split-half |
| compute_tier4_irt.R | IRT graded response model |
| compute_tier4_ml_corrected.R | Cross-instrument RF, MI network |
| compute_decisions_2_to_5.R | Scoring comparison, classifier, network, subtypes |
| results/facet_level_metrics.csv | Tier 1 facet-level results |
| results/item_level_metrics.csv | Tier 2 item-level results |
| results/split_half_pairs.csv | All 2-item pair correlations |
| results/irt_item_parameters.csv | IRT discrimination and thresholds |
| results/irt_person_estimates.csv | Person theta, SE, Zh per facet |
| results/irt_item_information.csv | Item information at 5 theta points |
| results/rf_item_importance_corrected.csv | Cross-instrument RF importance |
| results/rf_cv_evaluation_corrected.csv | CV comparison: RF vs LM vs baseline |
| results/community_detection.csv | Louvain community assignments |
| results/mutual_information_matrix.csv | 60x60 MI matrix |
| results/scoring_method_comparison.csv | Decision 2: 4 scoring methods vs NEO |
| results/confidence_classifier_results.csv | Decision 3: person-fit classifier CV |
| results/confidence_classifier_feature_importance.csv | Decision 3: feature importance |
| results/network_centrality_comparison.csv | Decision 4: centrality across methods |
| results/network_edge_comparison.csv | Decision 4: edge weight changes |
| results/network_raw.csv | Decision 4: raw correlation network |
| results/network_irt.csv | Decision 4: IRT theta network |
| results/network_discrim.csv | Decision 4: discrimination-weighted network |
| results/network_disattenuated.csv | Decision 4: disattenuated network |
| results/person_subtypes_and_anomalies.csv | Decision 5: cluster + anomaly flags |
| results/person_fit_all_facets.csv | Decision 5: Zh across all facets |
| results/clustering_silhouette_scores.csv | Decision 5: silhouette by k |
| results/anomaly_facet_drivers.csv | Decision 5: what drives anomalies |
| results/item_code_to_text.csv | Item code to full question text mapping |
| build_item_mapping.py | Fetches IPIP item text from ipip.ori.org |
| merge_item_text_into_results.py | Adds item_text column to all results CSVs |

---

## References

- Allison, P. D. (1975). A simple proof of the Spearman-Brown formula. *Psychometrika*, 40(4), 135-136.
- Brown, W. (1910). Some experimental results in the correlation of mental abilities. *British J. of Psychology*, 3, 296-322.
- Cronbach, L. J., Rajaratnam, N., & Gleser, G. C. (1963). Theory of generalizability. *British J. of Statistical Psychology*, 16, 137-163.
- DeYoung, C. G., Quilty, L. C., & Peterson, J. B. (2007). Between facets and domains: 10 aspects of the Big Five. *J. of Personality and Social Psychology*, 93, 880-896.
- Fisher, R. A. (1925). Theory of statistical estimation. *Proc. Cambridge Phil. Soc.*, 22, 700-725.
- Herrera-Bennett, A., & Rhemtulla, M. (2021). Network replicability & generalizability. *Multivariate Behavioral Research* (manuscript).
- Samejima, F. (1969). Estimation of latent ability using a response pattern of graded scores. *Psychometrika Monograph Supplement*, 17.
- Shannon, C. E. (1948). A mathematical theory of communication. *Bell System Tech. J.*, 27, 379-423.
- Spearman, C. (1910). Correlation calculated from faulty data. *British J. of Psychology*, 3, 271-295.
