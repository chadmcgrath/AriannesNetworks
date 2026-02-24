#!/usr/bin/env python3
"""
Compare our results with the R code methodology
"""

import sys
import numpy as np
import pandas as pd
from pathlib import Path

# Add src to path
sys.path.append(str(Path(__file__).parent / "src"))

from network_analysis import PersonalityNetworkAnalyzer
from research_findings_50sim import ResearchFindings50Sim

def compare_with_r_code():
    """Compare our implementation with R code methodology"""
    
    print("🔍 COMPARING WITH R CODE METHODOLOGY")
    print("=" * 60)
    
    # Load data
    analyzer = PersonalityNetworkAnalyzer()
    analyzer.load_data("data/NEO_IPIP_1.csv")
    analyzer.preprocess_data()
    
    print(f"Data loaded: {analyzer.data_processed.shape}")
    
    # Use the exact same parameters as R code
    print("\n📊 R CODE PARAMETERS:")
    print("  Sample sizes: 84, 212, 339, 424 (proportions: 0.2, 0.5, 0.8, 1.0)")
    print("  Simulations: 50 (nSim = 50)")
    print("  Random seeds: 50 different seeds")
    print("  Sample ratio: 84→212 = 2.52x (not 2.5x)")
    
    # Run our implementation with R code parameters
    research_findings = ResearchFindings50Sim(analyzer)
    
    # Test with the exact R code sample sizes
    print("\n🧪 TESTING WITH R CODE SAMPLE SIZES:")
    
    # Test 1: 84 vs 212 samples (2.52x ratio)
    print("\nTest 1: 84 vs 212 samples (2.52x ratio)")
    results_84_212 = run_comparison_test(analyzer, research_findings, 84, 212, "84_212")
    
    # Test 2: 84 vs 339 samples (4.04x ratio) 
    print("\nTest 2: 84 vs 339 samples (4.04x ratio)")
    results_84_339 = run_comparison_test(analyzer, research_findings, 84, 339, "84_339")
    
    # Test 3: 84 vs 424 samples (5.05x ratio)
    print("\nTest 3: 84 vs 424 samples (5.05x ratio)")
    results_84_424 = run_comparison_test(analyzer, research_findings, 84, 424, "84_424")
    
    # Summary
    print("\n📈 SUMMARY OF RESULTS:")
    print(f"  84→212 (2.52x): {results_84_212['equivalent_ratio']:.2f}x")
    print(f"  84→339 (4.04x): {results_84_339['equivalent_ratio']:.2f}x") 
    print(f"  84→424 (5.05x): {results_84_424['equivalent_ratio']:.2f}x")
    
    # Check which ratio is closest to 2.5x
    ratios = {
        "2.52x": results_84_212['equivalent_ratio'],
        "4.04x": results_84_339['equivalent_ratio'],
        "5.05x": results_84_424['equivalent_ratio']
    }
    
    closest_to_2_5 = min(ratios.items(), key=lambda x: abs(x[1] - 2.5))
    print(f"\n🎯 Closest to 2.5x: {closest_to_2_5[0]} ratio gives {closest_to_2_5[1]:.2f}x")
    
    return results_84_212, results_84_339, results_84_424

def run_comparison_test(analyzer, research_findings, sample_size_1, sample_size_2, test_name):
    """Run a comparison test with specific sample sizes"""
    
    print(f"  Running {test_name} comparison...")
    
    # Run 10 simulations for testing (faster than 50)
    n_simulations = 10
    aggregation_effects = []
    sample_size_effects = []
    
    for sim in range(n_simulations):
        # Get all variables for aggregation
        all_vars = list(analyzer.data_processed.columns)
        
        # Create facet structure
        neo_facets = {}
        for i in range(1, 7):
            neo_items = [col for col in all_vars if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) > 1 and col[1:] == str(i)]
            if neo_items:
                neo_facets[f'facet_{i}'] = neo_items
        
        # Create aggregated variables
        import random
        random.seed(42 + sim)
        
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
                composite_name = f"{facet_name}_2items_sum_{test_name}_sim{sim}"
                analyzer.data_processed[composite_name] = (
                    analyzer.data_processed[selected_items].sum(axis=1)
                )
                agg_2_vars.append(composite_name)
        
        # Sample data with exact R code sample sizes
        sample_1_1 = analyzer.data_processed.sample(n=sample_size_1, random_state=123123 + sim)
        sample_1_2 = analyzer.data_processed.sample(n=sample_size_1, random_state=789789 + sim)
        sample_2_1 = analyzer.data_processed.sample(n=sample_size_2, random_state=456456 + sim)
        sample_2_2 = analyzer.data_processed.sample(n=sample_size_2, random_state=999999 + sim)
        
        # Run netcompare_func
        netcompare_1_1 = research_findings._netcompare_func(sample_1_1[agg_1_vars], sample_1_2[agg_1_vars])
        netcompare_2_1 = research_findings._netcompare_func(sample_1_1[agg_2_vars], sample_1_2[agg_2_vars])
        netcompare_1_2 = research_findings._netcompare_func(sample_2_1[agg_1_vars], sample_2_2[agg_1_vars])
        
        # Calculate effects
        aggregation_effect = abs(netcompare_2_1['diffcen.real'] - netcompare_1_1['diffcen.real'])
        sample_size_effect = abs(netcompare_1_2['diffcen.real'] - netcompare_1_1['diffcen.real'])
        
        aggregation_effects.append(aggregation_effect)
        sample_size_effects.append(sample_size_effect)
    
    # Calculate results
    avg_aggregation_effect = np.mean(aggregation_effects)
    avg_sample_size_effect = np.mean(sample_size_effects)
    equivalent_ratio = avg_aggregation_effect / avg_sample_size_effect if avg_sample_size_effect > 0 else 1.0
    
    print(f"    Aggregation effect: {avg_aggregation_effect:.3f}")
    print(f"    Sample size effect: {avg_sample_size_effect:.3f}")
    print(f"    Equivalent ratio: {equivalent_ratio:.2f}x")
    
    return {
        'aggregation_effect': avg_aggregation_effect,
        'sample_size_effect': avg_sample_size_effect,
        'equivalent_ratio': equivalent_ratio
    }

if __name__ == "__main__":
    compare_with_r_code()

