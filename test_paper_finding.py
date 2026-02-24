#!/usr/bin/env python3
"""
Test the exact paper finding: 2-item aggregation ≈ 2.5x sample size
"""

import sys
import numpy as np
import pandas as pd
from pathlib import Path

# Add src to path
sys.path.append(str(Path(__file__).parent / "src"))

from network_analysis import PersonalityNetworkAnalyzer
from research_findings_50sim import ResearchFindings50Sim

def test_paper_finding():
    """Test the exact paper finding: 2-item aggregation ≈ 2.5x sample size"""
    
    print("🔍 TESTING PAPER FINDING: 2-item aggregation ≈ 2.5x sample size")
    print("=" * 70)
    print("Paper says: 'aggregating across two items yielded the same improvement")
    print("in network consistency as increasing the sample size by 2.5 times'")
    print("=" * 70)
    
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
    results = test_paper_comparison(analyzer, research_findings, r_seeds)
    
    print(f"\n📊 PAPER FINDING TEST RESULTS:")
    print(f"  Network consistency improvement from 1→2 items: {results['aggregation_improvement']:.3f}")
    print(f"  Network consistency improvement from 84→212 samples: {results['sample_size_improvement']:.3f}")
    print(f"  Ratio (should be ~2.5x): {results['ratio']:.2f}x")
    print(f"  Distance from 2.5x: {abs(results['ratio'] - 2.5):.2f}")
    
    return results

def test_paper_comparison(analyzer, research_findings, r_seeds):
    """Test the paper's exact comparison"""
    
    # Use first 10 seeds for testing
    test_seeds = r_seeds[:10]
    
    # Store results for each condition
    consistency_1item_84 = []
    consistency_2item_84 = []
    consistency_1item_212 = []
    
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
        
        # Sample data for each condition
        sample_84_1 = analyzer.data_processed.sample(n=84, random_state=int(seed))
        sample_84_2 = analyzer.data_processed.sample(n=84, random_state=int(seed) + 1000)
        sample_212_1 = analyzer.data_processed.sample(n=212, random_state=int(seed) + 2000)
        sample_212_2 = analyzer.data_processed.sample(n=212, random_state=int(seed) + 3000)
        
        # Test each condition: measure network consistency
        # Network consistency = edge correlation stability (einv.real)
        
        # Condition 1: 1-item indicators at n=84
        netcompare_1_84 = research_findings._netcompare_func(sample_84_1[agg_1_vars], sample_84_2[agg_1_vars])
        consistency_1item_84.append(np.mean(netcompare_1_84['einv.real']))  # Edge correlation stability
        
        # Condition 2: 2-item indicators at n=84  
        netcompare_2_84 = research_findings._netcompare_func(sample_84_1[agg_2_vars], sample_84_2[agg_2_vars])
        consistency_2item_84.append(np.mean(netcompare_2_84['einv.real']))  # Edge correlation stability
        
        # Condition 3: 1-item indicators at n=212
        netcompare_1_212 = research_findings._netcompare_func(sample_212_1[agg_1_vars], sample_212_2[agg_1_vars])
        consistency_1item_212.append(np.mean(netcompare_1_212['einv.real']))  # Edge correlation stability
        
        print(f"    1-item@84: {np.mean(netcompare_1_84['einv.real']):.3f}, 2-item@84: {np.mean(netcompare_2_84['einv.real']):.3f}, 1-item@212: {np.mean(netcompare_1_212['einv.real']):.3f}")
    
    # Calculate improvements
    avg_consistency_1item_84 = np.mean(consistency_1item_84)
    avg_consistency_2item_84 = np.mean(consistency_2item_84)
    avg_consistency_1item_212 = np.mean(consistency_1item_212)
    
    # Paper finding: 2-item improvement ≈ 2.5x sample size improvement
    aggregation_improvement = avg_consistency_2item_84 - avg_consistency_1item_84
    sample_size_improvement = avg_consistency_1item_212 - avg_consistency_1item_84
    
    # Ratio should be ~2.5x
    ratio = aggregation_improvement / sample_size_improvement if sample_size_improvement > 0 else 1.0
    
    print(f"\n📈 CONSISTENCY VALUES:")
    print(f"  1-item indicators at n=84: {avg_consistency_1item_84:.3f}")
    print(f"  2-item indicators at n=84: {avg_consistency_2item_84:.3f}")
    print(f"  1-item indicators at n=212: {avg_consistency_1item_212:.3f}")
    
    return {
        'consistency_1item_84': avg_consistency_1item_84,
        'consistency_2item_84': avg_consistency_2item_84,
        'consistency_1item_212': avg_consistency_1item_212,
        'aggregation_improvement': aggregation_improvement,
        'sample_size_improvement': sample_size_improvement,
        'ratio': ratio
    }

if __name__ == "__main__":
    test_paper_finding()
