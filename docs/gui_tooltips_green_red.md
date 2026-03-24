# GUI Tooltips: Green/Red Logic

Tooltips for each metric explain what it measures, the methodology, and what green vs red means. Apply threshold-based rules uniformly—no facet-specific exceptions.

---

## Overview / Tier 1

| Element | Green tooltip | Red tooltip |
|---------|---------------|-------------|
| **Alpha** | α≥0.88: Strong internal consistency; items hang together well; scores are reliable. | α<0.80: Concerning; more measurement error; use scores with wider confidence. |
| **SEM** | <2.6: Tight 95% CI; person scores are precise. | >3.0: Wide CI; scores have more uncertainty; avoid over-interpreting small differences. |
| **Noise %** | <15%: Low error; facet measures cleanly. | >20%: Higher error; facet noisier. |
| **Disattenuated r** | ≥0.95: IPIP and NEO measure same construct; high convergent validity. | — |
| **PCA PC1 %** | >45%: Strong single factor; facet is unidimensional. | <36%: Weaker; PC2 rivals PC1; facet may be multidimensional. |

---

## Decision 1: Which questions

| Element | Green tooltip | Red tooltip |
|---------|---------------|-------------|
| **Best/worst pair r** | r>0.5: Items agree well; either would work as a short-form. | r<0.15: Items barely correlate; may not tap same construct; interpret with caution. |
| **IRT discrimination (a)** | a>2.0: Exceptionally discriminating; sharp measurement. | a<1.0: Borderline; item adds little information. |
| **RF permutation %** | High %: Item predicts NEO score well. | <5%: Item contributes little to cross-instrument prediction. |
| **Discriminant ratio** | >2.5: Items predict their facet distinctly; good discriminant validity. | <1.5: Items predict other facets nearly as well; weaker separation. |

---

## Decision 2: How to score

| Element | Green tooltip | Red tooltip |
|---------|---------------|-------------|
| **r(NEO)** | High r: Good convergent validity with criterion. | Low r: Weaker agreement. |
| **Method comparison** | Max difference ~0.023: Negligible; simple averaging is fine. | — |

---

## Decision 3: Trust a score (Classifier)

| Element | Green tooltip | Red tooltip |
|---------|---------------|-------------|
| **AUC** | ≥0.95: Reliable ranking of high vs low risk of person-fit flag. | <0.85: Less reliable ranking. **Caveat (n_flagged<15):** AUC varies across folds; use for ranking facets, not absolute comparison. |
| **Precision** | Of those predicted flagged, high % are actually flagged. | **Caveat (n_flagged<15):** With few positives, one extra TP/FP can change precision by 10%+; treat as rough estimate. |
| **Recall** | Of those actually flagged, high % correctly predicted. | **Caveat (n_flagged<15):** Small n_flagged means recall is volatile; useful to see if model finds any positives; exact value is unreliable. |
| **Base rate** | — | **Caveat (base_rate<3%):** Few positives; AUC, precision, and recall will vary more; interpret cautiously. |

---

## Decision 4: Network

| Element | Green tooltip | Red tooltip |
|---------|---------------|-------------|
| **Centrality rank** | High: Facet is well connected in the network. | Low (rank 6): Facet is peripheral. |
| **Centrality stability** | Identical ranks across all 4 scoring methods: Robust; topology is real. | — |

---

## Decision 5: Response patterns

| Element | Green tooltip | Red tooltip |
|---------|---------------|-------------|
| **Silhouette** | >0.5: Clear cluster structure. | <0.1: No meaningful subtypes; people vary continuously. |
| **Jaccard (IRT vs anomaly)** | — | <0.2: Two methods flag largely different people; complementary, not redundant. |
| **Anomaly ratio** | — | High ratio: Anomalous persons deviate more on this facet. |

---

## General principle

**Threshold-based, agnostic:** Apply green/red and caveats based on the numbers and thresholds, not on which facet it is. Show caveats (e.g. n_flagged<15) for any facet that meets the condition.
