"""
Tiers 1-3 analysis: item-level noise characterization for all Neuroticism facets.
Replicates P1 preprocessing (reverse coding, NA exclusion, facet selection) in Python,
then computes metrics not available in the original R pipeline.
"""

import pandas as pd
import numpy as np
from scipy import stats
from sklearn.decomposition import PCA
from itertools import combinations
import os
import json

# ---------------------------------------------------------------------------
# 1. Load and preprocess data (replicating P1 steps 1-3)
# ---------------------------------------------------------------------------

data = pd.read_csv("data/NEO_IPIP_1.csv")

# Reverse code IPIP items (6 - x, Likert 1-5 scale)
reverse_items = {
    # Neuroticism
    'N1': ['e141', 'e150', 'h1046', 'h2000', 'x138'],
    'N2': ['e120', 'x191', 'x23', 'x231', 'x265'],
    'N3': ['h737', 'x129', 'x156'],
    'N4': ['h1197', 'x197', 'x209', 'x242'],
    'N5': ['e30', 'x181', 'x216', 'x251', 'x274'],
    'N6': ['e64', 'h1281', 'h44', 'h470', 'x79'],
}
for facet, items in reverse_items.items():
    for item in items:
        data[f"{item}_R"] = 6 - data[item]

# Facet-item mappings (from P1 script lines 337-353)
IPIP_FACETS = {
    'N1_Anxiety':           ['e141_R', 'e150_R', 'h1046_R', 'h1157', 'h2000_R', 'h968', 'h999', 'x107', 'x120', 'x138_R'],
    'N2_Anger':             ['e120_R', 'h754', 'h755', 'h761', 'x191_R', 'x23_R', 'x231_R', 'x265_R', 'x84', 'x95'],
    'N3_Depression':        ['e92', 'h640', 'h646', 'h737_R', 'h947', 'x129_R', 'x15', 'x156_R', 'x205', 'x74'],
    'N4_SelfConscious':     ['h1197_R', 'h1205', 'h592', 'h655', 'h656', 'h905', 'h991', 'x197_R', 'x209_R', 'x242_R'],
    'N5_Immoderation':      ['e24', 'e30_R', 'e57', 'h2029', 'x133', 'x145', 'x181_R', 'x216_R', 'x251_R', 'x274_R'],
    'N6_Vulnerability':     ['e64_R', 'h1281_R', 'h44_R', 'h470_R', 'h901', 'h948', 'h950', 'h954', 'h959', 'x79_R'],
}

NEO_FACETS = {
    'N1_Anxiety':       ['I1', 'I31', 'I61', 'I91', 'I121', 'I151', 'I181', 'I211'],
    'N2_Anger':         ['I6', 'I36', 'I66', 'I96', 'I126', 'I156', 'I186', 'I216'],
    'N3_Depression':    ['I11', 'I41', 'I71', 'I101', 'I131', 'I161', 'I191', 'I221'],
    'N4_SelfConscious': ['I16', 'I46', 'I76', 'I106', 'I136', 'I166', 'I196', 'I226'],
    'N5_Immoderation':  ['I21', 'I51', 'I81', 'I111', 'I141', 'I171', 'I201', 'I231'],
    'N6_Vulnerability': ['I26', 'I56', 'I86', 'I116', 'I146', 'I176', 'I206', 'I236'],
}

# Select relevant columns and drop NA rows
all_cols = []
for items in list(IPIP_FACETS.values()) + list(NEO_FACETS.values()):
    all_cols.extend(items)
all_cols = ['id'] + all_cols
data_rel = data[all_cols].dropna()
n_persons = len(data_rel)
print(f"Sample size after NA exclusion: {n_persons}")

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

def cronbach_alpha(df):
    k = df.shape[1]
    item_vars = df.var(ddof=1)
    total_var = df.sum(axis=1).var(ddof=1)
    return (k / (k - 1)) * (1 - item_vars.sum() / total_var)

def item_total_correlations(df):
    """Corrected item-total correlation: correlation of each item with sum of OTHER items."""
    results = {}
    total = df.sum(axis=1)
    for col in df.columns:
        rest_total = total - df[col]
        r = df[col].corr(rest_total)
        results[col] = r
    return results

def alpha_if_dropped(df):
    results = {}
    for col in df.columns:
        remaining = df.drop(columns=[col])
        results[col] = cronbach_alpha(remaining)
    return results

def response_entropy(series):
    counts = series.value_counts(normalize=True)
    return -np.sum(counts * np.log2(counts))

def spearman_brown_2(r_bar):
    """Predicted reliability when doubling items (n=2)."""
    return 2 * r_bar / (1 + r_bar)

def equivalent_sample_multiplier(r_bar, n_original=84):
    """
    Derive the sample-size multiplier at which 1-item SE matches 2-item SE.
    Using Fisher z: SE(z) = 1/sqrt(n-3).
    For 2-item reliability rho2 vs 1-item reliability rho1:
    The effective sample size N* where SE(1-item@N*) = SE(2-item@84).
    """
    rho1 = r_bar
    rho2 = spearman_brown_2(r_bar)
    if rho1 <= 0 or rho2 <= 0 or rho1 >= 1 or rho2 >= 1:
        return float('nan')
    se_2item_84 = 1 / np.sqrt(n_original - 3)
    n_equiv = (1 / se_2item_84**2) + 3
    return n_equiv / n_original

# ---------------------------------------------------------------------------
# 2. Compute all metrics per facet
# ---------------------------------------------------------------------------

results_rows = []
item_detail_rows = []
split_half_rows = []
inter_item_matrices = {}

for facet_name, ipip_items in IPIP_FACETS.items():
    neo_items = NEO_FACETS[facet_name]
    
    ipip_df = data_rel[ipip_items].copy()
    neo_df = data_rel[neo_items].copy()
    k_ipip = len(ipip_items)
    k_neo = len(neo_items)
    
    # --- TIER 1: Pure arithmetic ---
    alpha_ipip = cronbach_alpha(ipip_df)
    alpha_neo = cronbach_alpha(neo_df)
    
    noise_ipip = 1 - alpha_ipip
    noise_neo = 1 - alpha_neo
    
    r_bar_ipip = alpha_ipip / (k_ipip + alpha_ipip * (1 - k_ipip))
    r_bar_neo = alpha_neo / (k_neo + alpha_neo * (1 - k_neo))
    
    sd_ipip = ipip_df.sum(axis=1).std(ddof=1)
    sd_neo = neo_df.sum(axis=1).std(ddof=1)
    sem_ipip = sd_ipip * np.sqrt(1 - alpha_ipip)
    sem_neo = sd_neo * np.sqrt(1 - alpha_neo)
    
    rho2_ipip = spearman_brown_2(r_bar_ipip)
    
    neo_ipip_corr = data_rel[neo_items].sum(axis=1).corr(data_rel[ipip_items].sum(axis=1))
    disattenuated = neo_ipip_corr / np.sqrt(alpha_neo * alpha_ipip)
    
    # --- TIER 2: Item-level metrics ---
    itc_ipip = item_total_correlations(ipip_df)
    aid_ipip = alpha_if_dropped(ipip_df)
    entropies_ipip = {col: response_entropy(ipip_df[col]) for col in ipip_items}
    
    itc_neo = item_total_correlations(neo_df)
    aid_neo = alpha_if_dropped(neo_df)
    entropies_neo = {col: response_entropy(neo_df[col]) for col in neo_items}
    
    # --- TIER 3: Inter-item correlations, PCA, split-half ---
    corr_matrix_ipip = ipip_df.corr()
    inter_item_matrices[f"IPIP_{facet_name}"] = corr_matrix_ipip
    
    mask = np.triu(np.ones(corr_matrix_ipip.shape, dtype=bool), k=1)
    upper_corrs = corr_matrix_ipip.values[mask]
    r_bar_actual = upper_corrs.mean()
    r_min = upper_corrs.min()
    r_max = upper_corrs.max()
    r_range = r_max - r_min
    
    pca = PCA(n_components=min(k_ipip, 5))
    pca.fit(ipip_df)
    var_explained_1 = pca.explained_variance_ratio_[0]
    var_explained_2 = pca.explained_variance_ratio_[1] if len(pca.explained_variance_ratio_) > 1 else 0
    
    # Split-half: all 45 pairs of 2 items
    pair_corrs = []
    for i, j in combinations(range(k_ipip), 2):
        col_i, col_j = ipip_items[i], ipip_items[j]
        r = ipip_df[col_i].corr(ipip_df[col_j])
        pair_mean = ipip_df[[col_i, col_j]].mean(axis=1)
        rest_cols = [c for c in ipip_items if c not in (col_i, col_j)]
        rest_mean = ipip_df[rest_cols].mean(axis=1)
        pair_rest_r = pair_mean.corr(rest_mean)
        pair_corrs.append({
            'facet': facet_name,
            'item_i': col_i,
            'item_j': col_j,
            'pair_r': r,
            'pair_vs_rest_r': pair_rest_r,
        })
        split_half_rows.append(pair_corrs[-1])
    
    pair_rs = [p['pair_r'] for p in pair_corrs]
    best_pair_idx = np.argmax(pair_rs)
    worst_pair_idx = np.argmin(pair_rs)
    
    # Store facet-level results
    results_rows.append({
        'facet': facet_name,
        'instrument': 'IPIP',
        'k': k_ipip,
        'alpha': round(alpha_ipip, 4),
        'noise_pct': round(noise_ipip * 100, 1),
        'r_bar_formula': round(r_bar_ipip, 4),
        'r_bar_actual': round(r_bar_actual, 4),
        'r_min': round(r_min, 4),
        'r_max': round(r_max, 4),
        'r_range': round(r_range, 4),
        'sd_total': round(sd_ipip, 2),
        'SEM': round(sem_ipip, 2),
        'spearman_brown_2item': round(rho2_ipip, 4),
        'neo_ipip_r': round(neo_ipip_corr, 4),
        'disattenuated_r': round(disattenuated, 4),
        'pca_var_explained_1': round(var_explained_1 * 100, 1),
        'pca_var_explained_2': round(var_explained_2 * 100, 1),
        'best_pair': f"{pair_corrs[best_pair_idx]['item_i']}+{pair_corrs[best_pair_idx]['item_j']}",
        'best_pair_r': round(pair_corrs[best_pair_idx]['pair_r'], 4),
        'worst_pair': f"{pair_corrs[worst_pair_idx]['item_i']}+{pair_corrs[worst_pair_idx]['item_j']}",
        'worst_pair_r': round(pair_corrs[worst_pair_idx]['pair_r'], 4),
        'itc_mean': round(np.mean(list(itc_ipip.values())), 4),
        'itc_min': round(min(itc_ipip.values()), 4),
        'itc_max': round(max(itc_ipip.values()), 4),
        'entropy_mean': round(np.mean(list(entropies_ipip.values())), 4),
    })
    
    results_rows.append({
        'facet': facet_name,
        'instrument': 'NEO',
        'k': k_neo,
        'alpha': round(alpha_neo, 4),
        'noise_pct': round(noise_neo * 100, 1),
        'r_bar_formula': round(r_bar_neo, 4),
        'sd_total': round(sd_neo, 2),
        'SEM': round(sem_neo, 2),
        'neo_ipip_r': round(neo_ipip_corr, 4),
        'disattenuated_r': round(disattenuated, 4),
        'itc_mean': round(np.mean(list(itc_neo.values())), 4),
        'itc_min': round(min(itc_neo.values()), 4),
        'itc_max': round(max(itc_neo.values()), 4),
        'entropy_mean': round(np.mean(list(entropies_neo.values())), 4),
    })
    
    # Store item-level details (IPIP)
    for item in ipip_items:
        item_detail_rows.append({
            'facet': facet_name,
            'instrument': 'IPIP',
            'item': item,
            'mean': round(ipip_df[item].mean(), 3),
            'sd': round(ipip_df[item].std(ddof=1), 3),
            'item_total_r': round(itc_ipip[item], 4),
            'alpha_if_dropped': round(aid_ipip[item], 4),
            'alpha_change': round(aid_ipip[item] - alpha_ipip, 4),
            'entropy': round(entropies_ipip[item], 4),
            'max_entropy': round(np.log2(5), 4),
            'entropy_pct': round(entropies_ipip[item] / np.log2(5) * 100, 1),
            'pca_loading_1': round(pca.components_[0, ipip_items.index(item)], 4),
        })
    
    # Store item-level details (NEO)
    pca_neo = PCA(n_components=min(k_neo, 5))
    pca_neo.fit(neo_df)
    for item in neo_items:
        item_detail_rows.append({
            'facet': facet_name,
            'instrument': 'NEO',
            'item': item,
            'mean': round(neo_df[item].mean(), 3),
            'sd': round(neo_df[item].std(ddof=1), 3),
            'item_total_r': round(itc_neo[item], 4),
            'alpha_if_dropped': round(aid_neo[item], 4),
            'alpha_change': round(aid_neo[item] - alpha_neo, 4),
            'entropy': round(entropies_neo[item], 4),
            'max_entropy': round(np.log2(5), 4),
            'entropy_pct': round(entropies_neo[item] / np.log2(5) * 100, 1),
            'pca_loading_1': round(pca_neo.components_[0, neo_items.index(item)], 4),
        })

# ---------------------------------------------------------------------------
# 3. Save results
# ---------------------------------------------------------------------------

os.makedirs("results", exist_ok=True)

facet_df = pd.DataFrame(results_rows)
facet_df.to_csv("results/facet_level_metrics.csv", index=False)

item_df = pd.DataFrame(item_detail_rows)
item_df.to_csv("results/item_level_metrics.csv", index=False)

split_df = pd.DataFrame(split_half_rows)
split_df.to_csv("results/split_half_pairs.csv", index=False)

# Save inter-item correlation matrices
for name, matrix in inter_item_matrices.items():
    matrix.to_csv(f"results/inter_item_corr_{name}.csv")

print(f"\nSaved to results/:")
print(f"  facet_level_metrics.csv  ({len(facet_df)} rows)")
print(f"  item_level_metrics.csv   ({len(item_df)} rows)")
print(f"  split_half_pairs.csv     ({len(split_df)} rows)")
print(f"  6 inter-item correlation matrices")

# ---------------------------------------------------------------------------
# 4. Print summary tables
# ---------------------------------------------------------------------------

print("\n" + "="*80)
print("TIER 1: FACET-LEVEL METRICS (IPIP Neuroticism)")
print("="*80)
ipip_facets = facet_df[facet_df['instrument'] == 'IPIP']
cols = ['facet', 'alpha', 'noise_pct', 'r_bar_actual', 'SEM', 'neo_ipip_r', 'disattenuated_r', 'pca_var_explained_1']
print(ipip_facets[cols].to_string(index=False))

print("\n" + "="*80)
print("TIER 1: FACET-LEVEL METRICS (NEO Neuroticism)")
print("="*80)
neo_facets = facet_df[facet_df['instrument'] == 'NEO']
cols_neo = ['facet', 'alpha', 'noise_pct', 'r_bar_formula', 'SEM', 'itc_mean', 'itc_min', 'itc_max']
print(neo_facets[cols_neo].to_string(index=False))

print("\n" + "="*80)
print("TIER 2: BEST AND WORST ITEMS PER FACET (IPIP, by item-total correlation)")
print("="*80)
for facet_name in IPIP_FACETS:
    facet_items = item_df[(item_df['facet'] == facet_name) & (item_df['instrument'] == 'IPIP')]
    facet_items = facet_items.sort_values('item_total_r', ascending=False)
    alpha_val = ipip_facets[ipip_facets['facet'] == facet_name]['alpha'].values[0]
    print(f"\n--- {facet_name} (alpha={alpha_val}) ---")
    cols_item = ['item', 'mean', 'sd', 'item_total_r', 'alpha_if_dropped', 'alpha_change', 'entropy', 'pca_loading_1']
    print(facet_items[cols_item].to_string(index=False))

print("\n" + "="*80)
print("TIER 3: BEST AND WORST 2-ITEM PAIRS (IPIP)")
print("="*80)
for facet_name in IPIP_FACETS:
    facet_pairs = split_df[split_df['facet'] == facet_name].sort_values('pair_r', ascending=False)
    top3 = facet_pairs.head(3)
    bot3 = facet_pairs.tail(3)
    print(f"\n--- {facet_name} ---")
    print(f"  Best pairs:  {list(zip(top3['item_i'], top3['item_j'], top3['pair_r'].round(3)))}")
    print(f"  Worst pairs: {list(zip(bot3['item_i'], bot3['item_j'], bot3['pair_r'].round(3)))}")

print("\n" + "="*80)
print("TIER 3: PCA VARIANCE EXPLAINED (IPIP)")
print("="*80)
pca_cols = ['facet', 'pca_var_explained_1', 'pca_var_explained_2']
print(ipip_facets[pca_cols].to_string(index=False))

print("\n" + "="*80)
print("CROSS-INSTRUMENT: OBSERVED vs DISATTENUATED CORRELATIONS")
print("="*80)
cross_cols = ['facet', 'neo_ipip_r', 'disattenuated_r']
print(ipip_facets[cross_cols].to_string(index=False))

print("\nDone.")
