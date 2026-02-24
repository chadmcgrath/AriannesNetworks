#!/usr/bin/env python3
"""
Test with exact R code random seeds
"""

import sys
import numpy as np
import pandas as pd
from pathlib import Path

# Add src to path
sys.path.append(str(Path(__file__).parent / "src"))

from network_analysis import PersonalityNetworkAnalyzer
from research_findings_50sim import ResearchFindings50Sim

def test_with_exact_r_seeds():
    """Test with the exact random seeds from the R code"""
    
    print("🔍 TESTING WITH EXACT R CODE RANDOM SEEDS")
    print("=" * 60)
    
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
    
    # Run test with exact R seeds
    research_findings = ResearchFindings50Sim(analyzer)
    results = run_with_exact_seeds(analyzer, research_findings, r_seeds)
    
    print(f"\n📊 RESULTS WITH EXACT R SEEDS:")
    print(f"  Aggregation effect: {results['aggregation_effect']:.3f}")
    print(f"  Sample size effect: {results['sample_size_effect']:.3f}")
    print(f"  Equivalent ratio: {results['equivalent_ratio']:.2f}x")
    print(f"  Distance from 2.5x: {abs(results['equivalent_ratio'] - 2.5):.2f}")
    
    return results

def run_with_exact_seeds(analyzer, research_findings, r_seeds):
    """Run the test with exact R code random seeds"""
    
    aggregation_effects = []
    sample_size_effects = []
    
    # Use first 10 seeds for testing (faster)
    test_seeds = r_seeds[:10]
    
    for i, seed in enumerate(test_seeds):
        print(f"  Simulation {i+1}/10 with seed {seed}...")
        
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
        
        # Sample data using exact R seed
        sample_84_1 = analyzer.data_processed.sample(n=84, random_state=int(seed))
        sample_84_2 = analyzer.data_processed.sample(n=84, random_state=int(seed) + 1000)
        sample_212_1 = analyzer.data_processed.sample(n=212, random_state=int(seed) + 2000)
        sample_212_2 = analyzer.data_processed.sample(n=212, random_state=int(seed) + 3000)
        
        # Run netcompare_func
        netcompare_1_84 = research_findings._netcompare_func(sample_84_1[agg_1_vars], sample_84_2[agg_1_vars])
        netcompare_2_84 = research_findings._netcompare_func(sample_84_1[agg_2_vars], sample_84_2[agg_2_vars])
        netcompare_1_212 = research_findings._netcompare_func(sample_212_1[agg_1_vars], sample_212_2[agg_1_vars])
        
        # Calculate effects
        aggregation_effect = abs(netcompare_2_84['diffcen.real'] - netcompare_1_84['diffcen.real'])
        sample_size_effect = abs(netcompare_1_212['diffcen.real'] - netcompare_1_84['diffcen.real'])
        
        aggregation_effects.append(aggregation_effect)
        sample_size_effects.append(sample_size_effect)
        
        print(f"    Aggregation: {aggregation_effect:.3f}, Sample size: {sample_size_effect:.3f}")
    
    # Calculate results
    avg_aggregation_effect = np.mean(aggregation_effects)
    avg_sample_size_effect = np.mean(sample_size_effects)
    equivalent_ratio = avg_aggregation_effect / avg_sample_size_effect if avg_sample_size_effect > 0 else 1.0
    
    return {
        'aggregation_effect': avg_aggregation_effect,
        'sample_size_effect': avg_sample_size_effect,
        'equivalent_ratio': equivalent_ratio,
        'n_simulations': len(test_seeds)
    }

if __name__ == "__main__":
    test_with_exact_r_seeds()

