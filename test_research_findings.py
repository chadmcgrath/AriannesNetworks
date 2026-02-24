#!/usr/bin/env python3
"""
Integration test for research findings to debug issues
"""

import sys
import traceback
from pathlib import Path

# Add src to path
sys.path.append(str(Path(__file__).parent / "src"))

from network_analysis import PersonalityNetworkAnalyzer
from research_findings_50sim import ResearchFindings50Sim

def test_research_findings():
    """Test the research findings implementation step by step"""
    
    print("🧪 INTEGRATION TEST: Research Findings")
    print("=" * 50)
    
    try:
        # Step 1: Load data
        print("Step 1: Loading data...")
        analyzer = PersonalityNetworkAnalyzer()
        data_path = "data/NEO_IPIP_1.csv"
        
        print(f"  Loading from: {data_path}")
        analyzer.load_data(data_path)
        print(f"  ✅ Data loaded: {analyzer.data.shape}")
        
        # Step 2: Preprocess data
        print("\nStep 2: Preprocessing data...")
        analyzer.preprocess_data()
        print(f"  ✅ Data preprocessed: {analyzer.data_processed.shape}")
        
        # Step 3: Initialize research findings
        print("\nStep 3: Initializing research findings...")
        research_findings = ResearchFindings50Sim(analyzer)
        print("  ✅ Research findings initialized")
        
        # Step 4: Test individual components
        print("\nStep 4: Testing individual components...")
        
        # Test data access
        all_vars = list(analyzer.data_processed.columns)
        print(f"  Variables available: {len(all_vars)}")
        
        # Test facet creation
        neo_facets = {}
        for i in range(1, 7):
            neo_items = [col for col in all_vars if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) > 1 and col[1:] == str(i)]
            if neo_items:
                neo_facets[f'facet_{i}'] = neo_items
                print(f"  Facet {i}: {len(neo_items)} items")
        
        if len(neo_facets) < 6:
            print(f"  ❌ Not enough facets: {len(neo_facets)}")
            return False
        
        # Test sampling
        print("\nStep 5: Testing sampling...")
        try:
            sample_84 = analyzer.data_processed.sample(n=84, random_state=123123)
            sample_212 = analyzer.data_processed.sample(n=212, random_state=456456)
            print(f"  ✅ Sampling works: 84={len(sample_84)}, 212={len(sample_212)}")
        except Exception as e:
            print(f"  ❌ Sampling failed: {e}")
            return False
        
        # Test netcompare_func
        print("\nStep 6: Testing netcompare_func...")
        try:
            # Create simple test data
            import pandas as pd
            import numpy as np
            
            # Create test correlation matrices
            test_data1 = pd.DataFrame(np.random.randn(84, 6))
            test_data2 = pd.DataFrame(np.random.randn(84, 6))
            
            result = research_findings._netcompare_func(test_data1, test_data2)
            print(f"  ✅ netcompare_func works: {list(result.keys())}")
        except Exception as e:
            print(f"  ❌ netcompare_func failed: {e}")
            traceback.print_exc()
            return False
        
        # Test ggm_mod_select
        print("\nStep 7: Testing ggm_mod_select...")
        try:
            cor_matrix = test_data1.corr()
            result = research_findings._ggm_mod_select(cor_matrix, 84)
            print(f"  ✅ ggm_mod_select works: shape={result.shape}")
        except Exception as e:
            print(f"  ❌ ggm_mod_select failed: {e}")
            traceback.print_exc()
            return False
        
        # Step 8: Run full research findings (with fewer simulations for testing)
        print("\nStep 8: Running research findings (test mode)...")
        try:
            # Temporarily modify to run fewer simulations for testing
            original_method = research_findings.demonstrate_item_aggregation_effects
            
            def test_method():
                print("🔬 TESTING RESEARCH FINDINGS (2 simulations)")
                print("=" * 50)
                
                # Run just 2 simulations for testing
                n_simulations = 2
                print(f"Running {n_simulations} simulations for testing...")
                
                aggregation_effects = []
                sample_size_effects = []
                
                for sim in range(n_simulations):
                    print(f"  Simulation {sim+1}/{n_simulations}...")
                    
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
                    
                    # Sample data
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
                    
                    print(f"    Aggregation effect: {aggregation_effect:.3f}")
                    print(f"    Sample size effect: {sample_size_effect:.3f}")
                
                # Calculate results
                import numpy as np
                avg_aggregation_effect = np.mean(aggregation_effects)
                avg_sample_size_effect = np.mean(sample_size_effects)
                equivalent_ratio = avg_aggregation_effect / avg_sample_size_effect if avg_sample_size_effect > 0 else 1.0
                
                print(f"\n📊 TEST RESULTS:")
                print(f"   Average aggregation effect: {avg_aggregation_effect:.3f}")
                print(f"   Average sample size effect: {avg_sample_size_effect:.3f}")
                print(f"   Equivalent ratio: {equivalent_ratio:.2f}x")
                
                return {
                    'aggregation_effect': avg_aggregation_effect,
                    'sample_size_effect': avg_sample_size_effect,
                    'equivalent_ratio': equivalent_ratio
                }
            
            # Run the test
            result = test_method()
            print(f"  ✅ Research findings test completed: {result}")
            
        except Exception as e:
            print(f"  ❌ Research findings failed: {e}")
            traceback.print_exc()
            return False
        
        print("\n🎉 ALL TESTS PASSED!")
        return True
        
    except Exception as e:
        print(f"\n❌ INTEGRATION TEST FAILED: {e}")
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = test_research_findings()
    if success:
        print("\n✅ Integration test completed successfully!")
    else:
        print("\n❌ Integration test failed!")
        sys.exit(1)

