# Plan to Calculate Network Centralization

## What We Need to Do

### Step 1: Understand Network Centralization

**Network Centralization** is a network-level measure calculated from node-level centrality values:

**Formula:**
```
Centralization = Σ(max_centrality - centrality_i) / max_possible_centralization
```

Where:
- `max_centrality` = the maximum centrality value in the network
- `centrality_i` = centrality value for each node i
- `max_possible_centralization` = theoretical maximum (for a star network with n nodes)

**For Expected Influence centrality:**
- Max possible = (n-1) × max_edge_weight (for a star network)
- Or we can use Freeman's general formula normalized by theoretical maximum

### Step 2: Extract Required Data

We need:
1. **Network matrices** (`netmat_x_graph` and `netmat_y_graph`) from each network comparison
2. These are available in the `netcompare_Nlist_*_DD` objects in `P3_nSim50_data_all_N.RData`

### Step 3: Calculate Centrality for Each Network

For each network matrix:
1. Use the `centrality()` function from `qgraph` package (already used in the code)
2. Extract `InExpectedInfluence` values (this is what the paper likely uses)
3. This gives us centrality values for each node (6 nodes for Neuroticism facets)

### Step 4: Calculate Network Centralization

For each network:
1. Get all centrality values: `cent_values = [c1, c2, c3, c4, c5, c6]`
2. Find maximum: `max_cent = max(cent_values)`
3. Calculate sum of differences: `sum_diff = Σ(max_cent - ci) for all i`
4. Calculate theoretical maximum (for star network):
   - For Expected Influence: depends on edge weights
   - Alternative: Use Freeman's normalization: `max_possible = (n-2) × (n-1)` for unweighted, or calculate from actual max possible edge weights
5. Centralization = `sum_diff / max_possible`

### Step 5: Compare Across Conditions

Calculate centralization for:
- **1-item@84**: Average centralization across all simulations
- **2-item@84**: Average centralization across all simulations  
- **1-item@212**: Average centralization across all simulations

Then calculate:
- **Aggregation effect** = centralization(2-item@84) - centralization(1-item@84)
- **Sample size effect** = centralization(1-item@212) - centralization(1-item@84)
- **Ratio** = aggregation_effect / sample_size_effect (should be ~2.5x)

## Implementation Steps

1. Load the P3 data file
2. Extract network matrices from `netcompare_Nlist_0.2_1_DD`, `netcompare_Nlist_0.2_2_DD`, `netcompare_Nlist_0.5_1_DD`
3. For each network matrix:
   - Calculate Expected Influence centrality
   - Calculate network centralization
4. Average centralization across all 50 simulations for each condition
5. Calculate effects and ratio
6. Compare to paper's 2.5x finding

## R Code Structure Needed

```r
# Function to calculate network centralization from centrality values
calc_centralization <- function(centrality_values) {
  n <- length(centrality_values)
  max_cent <- max(centrality_values)
  sum_diff <- sum(max_cent - centrality_values)
  
  # Theoretical maximum for Expected Influence (star network)
  # This depends on edge weights - may need to calculate from actual network
  # For now, use Freeman's normalization approach
  max_possible <- (n - 2) * (n - 1)  # This may need adjustment
  
  centralization <- sum_diff / max_possible
  return(centralization)
}

# Extract and calculate for each condition
# ... (see implementation script)
```

## Challenges

1. **Theoretical Maximum**: The max possible centralization depends on edge weights. We may need to:
   - Calculate from actual network structure
   - Use a normalization that accounts for weighted edges
   - Check the paper's exact method

2. **Which Centrality Measure**: The paper may use:
   - Expected Influence (most likely, based on code)
   - Strength
   - Betweenness
   - Or a combination

3. **Normalization**: Different normalization methods exist:
   - Freeman's normalization
   - Normalization by theoretical maximum
   - Raw centralization values

## Next Steps

1. Create R script to extract network matrices
2. Calculate centrality for each network
3. Implement centralization calculation
4. Test on a few networks first
5. Calculate for all conditions
6. Compare results to paper's finding


