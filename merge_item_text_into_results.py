"""
Merge item text from item_code_to_text.csv into all item-level results files.
Then re-export enriched CSVs.
"""

import pandas as pd
import os

mapping = pd.read_csv("results/item_code_to_text.csv")
code_to_text = dict(zip(mapping['item_code'], mapping['item_text']))
code_to_facet = dict(zip(mapping['item_code'], mapping['facet']))

def add_text_column(df, item_col='item'):
    """Add item_text column by matching item codes."""
    df['item_text'] = df[item_col].map(code_to_text)
    return df

# 1. Item-level metrics
print("Processing item_level_metrics.csv...")
item_df = pd.read_csv("results/item_level_metrics.csv")
item_df = add_text_column(item_df)
cols = list(item_df.columns)
cols.remove('item_text')
idx = cols.index('item') + 1
cols.insert(idx, 'item_text')
item_df = item_df[cols]
item_df.to_csv("results/item_level_metrics.csv", index=False)
print(f"  Updated {len(item_df)} rows")

# 2. IRT item parameters
print("Processing irt_item_parameters.csv...")
irt_params = pd.read_csv("results/irt_item_parameters.csv")
irt_params = add_text_column(irt_params)
cols = list(irt_params.columns)
cols.remove('item_text')
idx = cols.index('item') + 1
cols.insert(idx, 'item_text')
irt_params = irt_params[cols]
irt_params.to_csv("results/irt_item_parameters.csv", index=False)
print(f"  Updated {len(irt_params)} rows")

# 3. IRT item information
print("Processing irt_item_information.csv...")
irt_info = pd.read_csv("results/irt_item_information.csv")
irt_info = add_text_column(irt_info)
cols = list(irt_info.columns)
cols.remove('item_text')
idx = cols.index('item') + 1
cols.insert(idx, 'item_text')
irt_info = irt_info[cols]
irt_info.to_csv("results/irt_item_information.csv", index=False)
print(f"  Updated {len(irt_info)} rows")

# 4. RF item importance (corrected)
print("Processing rf_item_importance_corrected.csv...")
rf_imp = pd.read_csv("results/rf_item_importance_corrected.csv")
rf_imp = add_text_column(rf_imp)
cols = list(rf_imp.columns)
cols.remove('item_text')
idx = cols.index('item') + 1
cols.insert(idx, 'item_text')
rf_imp = rf_imp[cols]
rf_imp.to_csv("results/rf_item_importance_corrected.csv", index=False)
print(f"  Updated {len(rf_imp)} rows")

# 5. Community detection
print("Processing community_detection.csv...")
comm = pd.read_csv("results/community_detection.csv")
comm = add_text_column(comm)
cols = list(comm.columns)
cols.remove('item_text')
idx = cols.index('item') + 1
cols.insert(idx, 'item_text')
comm = comm[cols]
comm.to_csv("results/community_detection.csv", index=False)
print(f"  Updated {len(comm)} rows")

# 6. Split-half pairs (two item columns)
print("Processing split_half_pairs.csv...")
split = pd.read_csv("results/split_half_pairs.csv")
split['item_i_text'] = split['item_i'].map(code_to_text)
split['item_j_text'] = split['item_j'].map(code_to_text)
cols = list(split.columns)
for c in ['item_i_text', 'item_j_text']:
    cols.remove(c)
idx_i = cols.index('item_i') + 1
cols.insert(idx_i, 'item_i_text')
idx_j = cols.index('item_j') + 1
cols.insert(idx_j, 'item_j_text')
split = split[cols]
split.to_csv("results/split_half_pairs.csv", index=False)
print(f"  Updated {len(split)} rows")

# 7. Confidence classifier feature importance
print("Processing confidence_classifier_feature_importance.csv...")
feat_imp = pd.read_csv("results/confidence_classifier_feature_importance.csv")
feat_imp.to_csv("results/confidence_classifier_feature_importance.csv", index=False)
print(f"  No item column (features, not items)")

# 8. Anomaly facet drivers
print("Processing anomaly_facet_drivers.csv...")
anom = pd.read_csv("results/anomaly_facet_drivers.csv")
anom.to_csv("results/anomaly_facet_drivers.csv", index=False)
print(f"  No item column (facet-level)")

# 9. Update inter-item correlation matrices with item text labels
for facet in ['N1_Anxiety', 'N2_Anger', 'N3_Depression', 'N4_SelfConscious', 'N5_Immoderation', 'N6_Vulnerability']:
    fname = f"results/inter_item_corr_IPIP_{facet}.csv"
    if os.path.exists(fname):
        print(f"Processing {fname}...")
        corr = pd.read_csv(fname, index_col=0)
        text_labels = [f"{col} ({code_to_text.get(col, '?')})" for col in corr.columns]
        corr_labeled = corr.copy()
        corr_labeled.columns = text_labels
        corr_labeled.index = text_labels
        corr_labeled.to_csv(fname.replace('.csv', '_labeled.csv'))
        print(f"  Saved labeled version")

print("\nDone. All item-level results now include question text.")
