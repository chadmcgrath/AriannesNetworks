# CORRECT METRIC FOUND: Centrality Rank Correlation

## What the Paper Actually Says

**Page 30 of Main Paper:**
> "going from a single indicator to two improved **consistency in centrality scores** as much as increasing the sample size by 2.5 times."

**Page 22 of Main Paper:**
> "aggregating across two items (i.e., one additional indicator) yielded the same improvement in **network consistency** as increasing the sample size by 2.5 times."

## The Correct Metric

The paper is NOT talking about "network centralization" - it's talking about **"consistency in centrality scores"** which is measured by:

**Centrality Rank Correlation** (Spearman correlation of Expected Influence centrality scores between networks)

This is stored in our results as: `avg.rankcorr_expInfl_N`

## Calculation from Original OSF Results

Using the original OSF Neuroticism network results:

| Condition | Centrality Rank Correlation |
|-----------|----------------------------|
| 1-item@84 | 0.1704 |
| 2-item@84 | 0.4552 |
| 1-item@212 | 0.4679 |

**Effects:**
- **Aggregation effect** (1-item@84 → 2-item@84): **0.2848**
- **Sample size effect** (1-item@84 → 1-item@212): **0.2974**
- **Ratio**: 0.2848 / 0.2974 = **0.96x**

## Result

❌ **The ratio is 0.96x, NOT 2.5x**

The aggregation effect and sample size effect are **almost equal** (0.96x), not 2.5x different as the paper claims.

## What This Means

The paper's 2.5x finding is **NOT supported** by the original OSF results when using the correct metric (Centrality Rank Correlation / consistency in centrality scores).

The improvement from going from 1-item to 2-item is approximately **equal** to the improvement from increasing sample size from 84 to 212, not 2.5 times larger.

