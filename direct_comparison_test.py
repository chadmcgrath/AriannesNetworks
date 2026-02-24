#!/usr/bin/env python3
"""
Direct comparison test - run our implementation and show results
"""

import sys
import numpy as np
import pandas as pd
from pathlib import Path

# Add src to path
sys.path.append(str(Path(__file__).parent / "src"))

from network_analysis import PersonalityNetworkAnalyzer
from research_findings_50sim import ResearchFindings50Sim

def direct_comparison_test():
    """Run our implementation and show results"""
    
    print("🔍 DIRECT COMPARISON TEST")
    print("=" * 50)
    print("Running our implementation to see what results we get")
    print("=" * 50)
    
    # Load data
    analyzer = PersonalityNetworkAnalyzer()
    analyzer.load_data("data/NEO_IPIP_1.csv")
    analyzer.preprocess_data()
    
    print(f"Data loaded: {analyzer.data_processed.shape}")
    
    # Get the exact random seeds from R code
    import pyreadr
    result = pyreadr.read_r('data/NEO & IPIP - P2_nSim50_data_A.RData')
    r_seeds = result['random.seeds'].values.flatten()
    print(f"Using {len(r_seeds)} exact R code random seeds")
    
    # Run our implementation
    research_findings = ResearchFindings50Sim(analyzer)
    
    # Test the exact same conditions as R code
    print("\n🧪 TESTING R CODE CONDITIONS:")
    print("Condition: 1-item vs 2-item aggregation at n=84 vs n=212")
    
    # Run with first 5 seeds for quick test
    test_seeds = r_seeds[:5]
    
    results_1item_84 = []
    results_2item_84 = []
    results_1item_212 = []
    
    for i, seed in enumerate(test_seeds):
        print(f"\n  Simulation {i+1}/5 with seed {seed}:")
        
        # Get all variables for aggregation
        all_vars = list(analyzer.data_processed.columns)
        
        # Create facet structure
        neo_facets = {}
        for j in range(1, 7):
            neo_items = [col for col in all_vars if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) > 1 and col[1:] == str(j)]
            if neo_items:
                neo_facets[f'facet_{j}'] = neo_items
        
        # Create aggregated variables using exact R seed
        import random
        random.seed(int(seed))
        
        # 1 item per facet
        agg_1_vars = []
        for facet_name in list(neo_facets.keys())[:6]:
            facet_items = neo_facets[facet_name]
            if facet_items:
                selected_item = random.choice(facet_items)
                agg_1_vars.append(selected_item)
        
        # 2 items per facet
        agg_2_vars = []
        for facet_name in list(neo_facets.keys())[:6]:
            facet_items = neo_facets[facet_name]
            if len(facet_items) >= 2:
                selected_items = random.sample(facet_items, 2)
                composite_name = f"{facet_name}_2items_sum_seed{seed}"
                analyzer.data_processed[composite_name] = (
                    analyzer.data_processed[selected_items].sum(axis=1)
                )
                agg_2_vars.append(composite_name)
        
        # Sample data
        sample_84_1 = analyzer.data_processed.sample(n=84, random_state=int(seed))
        sample_84_2 = analyzer.data_processed.sample(n=84, random_state=int(seed) + 1000)
        sample_212_1 = analyzer.data_processed.sample(n=212, random_state=int(seed) + 2000)
        sample_212_2 = analyzer.data_processed.sample(n=212, random_state=int(seed) + 3000)
        
        # Run netcompare_func for each condition
        netcompare_1_84 = research_findings._netcompare_func(sample_84_1[agg_1_vars], sample_84_2[agg_1_vars])
        netcompare_2_84 = research_findings._netcompare_func(sample_84_1[agg_2_vars], sample_84_2[agg_2_vars])
        netcompare_1_212 = research_findings._netcompare_func(sample_212_1[agg_1_vars], sample_212_2[agg_1_vars])
        
        # Store results
        results_1item_84.append(netcompare_1_84)
        results_2item_84.append(netcompare_2_84)
        results_1item_212.append(netcompare_1_212)
        
        # Print results
        print(f"    1-item@84: glstr={netcompare_1_84['glstrinv.real']:.3f}, einv={np.mean(netcompare_1_84['einv.real']):.3f}, diffcen={float(netcompare_1_84['diffcen.real']):.3f}")
        print(f"    2-item@84: glstr={netcompare_2_84['glstrinv.real']:.3f}, einv={np.mean(netcompare_2_84['einv.real']):.3f}, diffcen={float(netcompare_2_84['diffcen.real']):.3f}")
        print(f"    1-item@212: glstr={netcompare_1_212['glstrinv.real']:.3f}, einv={np.mean(netcompare_1_212['einv.real']):.3f}, diffcen={float(netcompare_1_212['diffcen.real']):.3f}")
    
    # Calculate averages
    print(f"\n📊 AVERAGE RESULTS:")
    
    avg_glstr_1_84 = np.mean([r['glstrinv.real'] for r in results_1item_84])
    avg_glstr_2_84 = np.mean([r['glstrinv.real'] for r in results_2item_84])
    avg_glstr_1_212 = np.mean([r['glstrinv.real'] for r in results_1item_212])
    
    avg_einv_1_84 = np.mean([np.mean(r['einv.real']) for r in results_1item_84])
    avg_einv_2_84 = np.mean([np.mean(r['einv.real']) for r in results_2item_84])
    avg_einv_1_212 = np.mean([np.mean(r['einv.real']) for r in results_1item_212])
    
    avg_diffcen_1_84 = np.mean([float(r['diffcen.real']) for r in results_1item_84])
    avg_diffcen_2_84 = np.mean([float(r['diffcen.real']) for r in results_2item_84])
    avg_diffcen_1_212 = np.mean([float(r['diffcen.real']) for r in results_1item_212])
    
    print(f"  Global Strength (glstrinv.real):")
    print(f"    1-item@84: {avg_glstr_1_84:.3f}")
    print(f"    2-item@84: {avg_glstr_2_84:.3f}")
    print(f"    1-item@212: {avg_glstr_1_212:.3f}")
    
    print(f"  Edge Invariance (einv.real):")
    print(f"    1-item@84: {avg_einv_1_84:.3f}")
    print(f"    2-item@84: {avg_einv_2_84:.3f}")
    print(f"    1-item@212: {avg_einv_1_212:.3f}")
    
    print(f"  Centrality Difference (diffcen.real):")
    print(f"    1-item@84: {avg_diffcen_1_84:.3f}")
    print(f"    2-item@84: {avg_diffcen_2_84:.3f}")
    print(f"    1-item@212: {avg_diffcen_1_212:.3f}")
    
    # Calculate the 2.5x finding
    print(f"\n🎯 2.5X FINDING CALCULATION:")
    
    # Aggregation effect: 2-item@84 - 1-item@84
    aggregation_effect_glstr = avg_glstr_2_84 - avg_glstr_1_84
    aggregation_effect_einv = avg_einv_2_84 - avg_einv_1_84
    aggregation_effect_diffcen = avg_diffcen_2_84 - avg_diffcen_1_84
    
    # Sample size effect: 1-item@212 - 1-item@84
    sample_size_effect_glstr = avg_glstr_1_212 - avg_glstr_1_84
    sample_size_effect_einv = avg_einv_1_212 - avg_einv_1_84
    sample_size_effect_diffcen = avg_diffcen_1_212 - avg_diffcen_1_84
    
    print(f"  Aggregation effect (2-item@84 - 1-item@84):")
    print(f"    Global Strength: {aggregation_effect_glstr:.3f}")
    print(f"    Edge Invariance: {aggregation_effect_einv:.3f}")
    print(f"    Centrality Diff: {aggregation_effect_diffcen:.3f}")
    
    print(f"  Sample size effect (1-item@212 - 1-item@84):")
    print(f"    Global Strength: {sample_size_effect_glstr:.3f}")
    print(f"    Edge Invariance: {sample_size_effect_einv:.3f}")
    print(f"    Centrality Diff: {sample_size_effect_diffcen:.3f}")
    
    # Calculate ratios
    ratio_glstr = aggregation_effect_glstr / sample_size_effect_glstr if sample_size_effect_glstr != 0 else 0
    ratio_einv = aggregation_effect_einv / sample_size_effect_einv if sample_size_effect_einv != 0 else 0
    ratio_diffcen = aggregation_effect_diffcen / sample_size_effect_diffcen if sample_size_effect_diffcen != 0 else 0
    
    print(f"  Equivalent ratios (should be ~2.5x):")
    print(f"    Global Strength: {ratio_glstr:.2f}x")
    print(f"    Edge Invariance: {ratio_einv:.2f}x")
    print(f"    Centrality Diff: {ratio_diffcen:.2f}x")
    
    return {
        'glstr_ratio': ratio_glstr,
        'einv_ratio': ratio_einv,
        'diffcen_ratio': ratio_diffcen
    }

if __name__ == "__main__":
    direct_comparison_test()
