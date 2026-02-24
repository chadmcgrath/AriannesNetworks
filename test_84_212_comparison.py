#!/usr/bin/env python3
"""
Test the 84→212 comparison specifically
"""

import sys
import numpy as np
import pandas as pd
from pathlib import Path

# Add src to path
sys.path.append(str(Path(__file__).parent / "src"))

from network_analysis import PersonalityNetworkAnalyzer
from research_findings_50sim import ResearchFindings50Sim

def test_84_212_comparison():
    """Test the 84→212 comparison specifically"""
    
    print("🔍 TESTING 84→212 COMPARISON (2.52x ratio)")
    print("=" * 60)
    
    # Load data
    analyzer = PersonalityNetworkAnalyzer()
    analyzer.load_data("data/NEO_IPIP_1.csv")
    analyzer.preprocess_data()
    
    print(f"Data loaded: {analyzer.data_processed.shape}")
    print(f"Available for sampling: {len(analyzer.data_processed)} participants")
    
    # Check if we can sample 212
    if len(analyzer.data_processed) < 212:
        print(f"❌ Cannot sample 212 from {len(analyzer.data_processed)} participants")
        return
    
    # Run multiple tests with different simulation counts
    simulation_counts = [5, 10, 20, 50]
    
    for n_sims in simulation_counts:
        print(f"\n🧪 TESTING WITH {n_sims} SIMULATIONS:")
        
        research_findings = ResearchFindings50Sim(analyzer)
        results = run_84_212_test(analyzer, research_findings, n_sims)
        
        print(f"  Results: {results['equivalent_ratio']:.2f}x")
        print(f"  Aggregation effect: {results['aggregation_effect']:.3f}")
        print(f"  Sample size effect: {results['sample_size_effect']:.3f}")
        
        # Check how close to 2.5x
        distance_from_2_5 = abs(results['equivalent_ratio'] - 2.5)
        print(f"  Distance from 2.5x: {distance_from_2_5:.2f}")

def run_84_212_test(analyzer, research_findings, n_simulations):
    """Run the 84→212 test with specified number of simulations"""
    
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
                composite_name = f"{facet_name}_2items_sum_sim{sim}"
                analyzer.data_processed[composite_name] = (
                    analyzer.data_processed[selected_items].sum(axis=1)
                )
                agg_2_vars.append(composite_name)
        
        # Sample data: 84 vs 212
        sample_84_1 = analyzer.data_processed.sample(n=84, random_state=123123 + sim)
        sample_84_2 = analyzer.data_processed.sample(n=84, random_state=789789 + sim)
        sample_212_1 = analyzer.data_processed.sample(n=212, random_state=456456 + sim)
        sample_212_2 = analyzer.data_processed.sample(n=212, random_state=999999 + sim)
        
        # Run netcompare_func
        netcompare_1_84 = research_findings._netcompare_func(sample_84_1[agg_1_vars], sample_84_2[agg_1_vars])
        netcompare_2_84 = research_findings._netcompare_func(sample_84_1[agg_2_vars], sample_84_2[agg_2_vars])
        netcompare_1_212 = research_findings._netcompare_func(sample_212_1[agg_1_vars], sample_212_2[agg_1_vars])
        
        # Calculate effects
        aggregation_effect = abs(netcompare_2_84['diffcen.real'] - netcompare_1_84['diffcen.real'])
        sample_size_effect = abs(netcompare_1_212['diffcen.real'] - netcompare_1_84['diffcen.real'])
        
        aggregation_effects.append(aggregation_effect)
        sample_size_effects.append(sample_size_effect)
    
    # Calculate results
    avg_aggregation_effect = np.mean(aggregation_effects)
    avg_sample_size_effect = np.mean(sample_size_effects)
    equivalent_ratio = avg_aggregation_effect / avg_sample_size_effect if avg_sample_size_effect > 0 else 1.0
    
    return {
        'aggregation_effect': avg_aggregation_effect,
        'sample_size_effect': avg_sample_size_effect,
        'equivalent_ratio': equivalent_ratio,
        'n_simulations': n_simulations
    }

if __name__ == "__main__":
    test_84_212_comparison()

