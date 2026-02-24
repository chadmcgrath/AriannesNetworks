# What Metric Does the Paper Use for the 2.5x Finding?

## Current Situation

The user has correctly pointed out that I have NOT been comparing the correct metric to the 2.5x finding. I need to determine what the paper actually means by "network centralization" or whatever metric they use.

## What I've Been Comparing (WRONG)

I've been comparing:
1. **Global Strength Difference** - Ratio: 1.25x (Neuroticism), -0.24x (Agreeableness)
2. **Network Centralization (various methods)** - Ratios: 0.72x to 1.77x
3. **Partial Correlation Difference** - Ratios: 0.12x to -0.10x
4. **Network Invariance** - Ratios: -0.16x to -0.48x

**None of these match 2.5x**, which suggests I'm using the wrong metric.

## What I Need to Find Out

1. **What exact metric does the paper use?**
   - Is it really "network centralization"?
   - Or is it something else (variance of centrality, coefficient of variation, etc.)?

2. **How do they calculate it?**
   - What R package/function?
   - What exact formula?
   - What normalization method?

3. **What do they compare?**
   - Do they compare centralization values directly?
   - Or do they compare some transformation of centralization?
   - Do they compare variance/standard deviation of centrality?

## Available Data in Results Files

From the `output1_N_DD_avg.glstr` dataframe, I have:
- `avg.glstr_x`, `avg.glstr_y`, `avg.glstr_diff` (Global Strength)
- `avg.pc_diff` (Partial Correlation Difference)
- `avg.nwinv_diff` (Network Invariance)
- `expinfl_1st_x_freq_N1` through `expinfl_1st_x_freq_N6` (Centrality frequencies)
- `grdmean.abs_esize_x_NCT`, `sd.grdmean.abs_esize_x_NCT` (Edge size statistics)

**I do NOT see a centralization metric directly in the results files.**

## Possible Interpretations

1. **The paper might calculate centralization from Expected Influence values** (which are in the raw data but not aggregated)
2. **The paper might use variance or standard deviation of centrality** as a proxy for centralization
3. **The paper might use a different term** (not "centralization" but something else)
4. **The paper might calculate it differently** than the standard Freeman formula

## Next Steps

I need to:
1. **Read the PDF paper** to find the exact metric name and calculation method
2. **Check if there's a centralization calculation in the R scripts** that I missed
3. **Look for variance/SD of centrality** as a possible metric
4. **Check if the paper uses a different comparison method** (not ratio of effects, but something else)

## Request for Clarification

Since I cannot directly read PDFs, I need the user to help identify:
- What exact metric name does the paper use?
- What section of the paper describes it?
- What is the exact calculation or formula?

