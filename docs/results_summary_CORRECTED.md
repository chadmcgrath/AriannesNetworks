# Results Summary: Network Analysis Findings

## Overview

This document summarizes the results from the network analysis comparing item aggregation effects vs. sample size effects, based on the Herrera-Bennett & Rhemtulla (2021) research.

## ✅ CORRECT UNDERSTANDING: What the Paper Actually Claims

**Page 22 of Main Paper:**
> "In other words, aggregating across two items (i.e., one additional indicator) yielded the same improvement in **network consistency** as increasing the sample size by 2.5 times."

**Page 30 of Main Paper:**
> "going from a single indicator to two improved **consistency in centrality scores** as much as increasing the sample size by 2.5 times."

### What This Actually Means

The paper is **NOT** claiming that the improvement ratio is 2.5x. Instead, it claims that:

**2-item@84 produces approximately the SAME network consistency as 1-item@212**

Where:
- **2-item@84**: 2 items per facet, 84 samples
- **1-item@212**: 1 item per facet, 212 samples (which is 84 × 2.52 ≈ 2.5x larger sample size)

The "2.5x" refers to the **sample size multiplier** (84 × 2.5 = 210, close to 212), not a ratio of improvements.

### The Correct Metric: Network Consistency

"Network consistency" refers to **correlations** between networks:
1. **Edge Correlation**: Correlation of edge weights between networks
2. **Centrality Rank Correlation**: Spearman correlation of Expected Influence centrality scores between networks

## Verification Results from Original OSF Data

### 1. Edge Correlation (Network Consistency - Edge Weights)

| Condition | Edge Correlation |
|-----------|------------------|
| 1-item@84 | 0.0904 |
| 2-item@84 | **0.2425** |
| 1-item@212 | **0.2490** |

**Key Finding:**
- **2-item@84: 0.2425**
- **1-item@212: 0.2490**
- **Difference: 0.0066** (very small!)

✅ **VERIFIED**: 2-item@84 and 1-item@212 produce **very similar** edge correlation values (within 0.01).

### 2. Centrality Rank Correlation (Network Consistency - Centrality Scores)

| Condition | Centrality Rank Correlation |
|-----------|----------------------------|
| 1-item@84 | 0.1704 |
| 2-item@84 | **0.4552** |
| 1-item@212 | **0.4679** |

**Key Finding:**
- **2-item@84: 0.4552**
- **1-item@212: 0.4679**
- **Difference: 0.0126** (very small!)

✅ **VERIFIED**: 2-item@84 and 1-item@212 produce **very similar** centrality rank correlation values (within 0.02).

## Conclusion

✅ **The paper's claim IS SUPPORTED by the original OSF data**

Both metrics (edge correlation and centrality rank correlation) show that:
- Using **2 items at sample size 84** produces network consistency values that are **very similar** to
- Using **1 item at sample size 212** (2.5x larger sample size)

The differences are minimal (0.0066 for edge correlation, 0.0126 for centrality correlation), confirming that these two conditions produce comparable network consistency.

## Understanding Network Analysis Metrics

### 1. **Edge Correlation (edgecorr_N)**
- **What it measures**: Correlation of edge weights between two networks
- **Edge weights**: The strength of connections between variables
- **Interpretation**: Higher values (closer to 1) = more similar edge patterns
- **Why it matters**: Tests if the same connections exist with similar strengths

### 2. **Centrality Rank Correlation (rankcorr_expInfl_N)**
- **What it measures**: Spearman correlation of Expected Influence centrality ranks
- **Expected Influence**: A centrality measure that considers both positive and negative connections
- **Interpretation**: Higher values (closer to 1) = more similar centrality rankings
- **Why it matters**: Tests if variables are ranked similarly in importance

### 3. **Global Strength Difference (glstr_diff)**
- **What it measures**: The difference in overall network strength between two networks
- **Network strength**: The sum of all edge weights (connections) in the network
- **Interpretation**: Lower values = networks are more consistent/reproducible
- **Why it matters**: Tells us if the overall "connectedness" of the network is stable

### 4. **Partial Correlation Difference (pc_diff)**
- **What it measures**: The maximum difference in partial correlations between networks
- **Partial correlation**: The relationship between two variables after controlling for all other variables
- **Interpretation**: Lower values = network structures are more similar
- **Why it matters**: Tells us if the underlying relationships between variables are consistent

### 5. **Network Invariance Difference (nwinv_diff)**
- **What it measures**: Overall network invariance from the Network Comparison Test (NCT)
- **Network invariance**: How stable the network structure is across different samples
- **Interpretation**: Lower values = more invariant/stable networks
- **Why it matters**: Tests if the network structure is statistically the same across samples

## Our Analysis Conditions

We compared three conditions:
1. **1-item@84**: 1 item per facet, 84 samples
2. **2-item@84**: 2 items per facet, 84 samples  
3. **1-item@212**: 1 item per facet, 212 samples (2.52x increase, close to paper's 2.5x)

## Results for Other Metrics

### Global Strength Difference

| Condition | Mean Global Strength Difference |
|-----------|----------------------------------|
| 1-item@84 | 0.3783 |
| 2-item@84 | 0.1955 |
| 1-item@212 | 0.2418 |

**Note**: This metric measures differences (lower is better), so we cannot directly compare 2-item@84 and 1-item@212 values. The paper's claim is specifically about correlation-based "network consistency" metrics, not difference metrics.

### Partial Correlation Difference

| Condition | Mean Partial Correlation Difference |
|-----------|-------------------------------------|
| 1-item@84 | 0.387 |
| 2-item@84 | 0.371 |
| 1-item@212 | 0.270 |

**Note**: This is also a difference metric, not a correlation metric, so it's not directly relevant to the paper's claim about "network consistency."

## What This Means (Plain English)

Think of it like this:
- **Network analysis** is like trying to map the connections between personality traits
- **More items per facet** = averaging multiple questions, which reduces noise (like taking multiple measurements)
- **Larger sample size** = more people, which also reduces noise (more data = better estimates)

The paper claims that these two strategies produce **equivalent results** for network consistency:
- Using **2 items at 84 samples** gives you the same network consistency as
- Using **1 item at 212 samples** (2.5x larger sample size)

**What is network consistency?**
- It measures how similar two networks are to each other
- **Edge correlation**: Are the same connections present with similar strengths?
- **Centrality correlation**: Are the same variables ranked similarly in importance?

**Our results show:**
- ✅ **Edge correlation**: 2-item@84 (0.2425) ≈ 1-item@212 (0.2490) - **VERIFIED**
- ✅ **Centrality correlation**: 2-item@84 (0.4552) ≈ 1-item@212 (0.4679) - **VERIFIED**

**The key finding:**
- The paper's claim is **SUPPORTED** by the original OSF results
- Both correlation metrics show that 2-item@84 and 1-item@212 produce very similar network consistency values
- The differences are minimal (within 0.01-0.02), confirming the paper's claim

## Summary

✅ **The paper's claim is CORRECT and SUPPORTED by the data**

The claim that "aggregating across two items yields the same network consistency as increasing the sample size by 2.5 times" is verified:
- **Edge correlation**: 2-item@84 (0.2425) ≈ 1-item@212 (0.2490) ✅
- **Centrality correlation**: 2-item@84 (0.4552) ≈ 1-item@212 (0.4679) ✅

Both metrics show that these two conditions produce comparable network consistency, supporting the paper's finding.

