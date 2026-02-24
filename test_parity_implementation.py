#!/usr/bin/env python3
"""
Test the parity implementation to verify it matches R code results
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from src.network_analysis import PersonalityNetworkAnalyzer
from src.research_findings_parity import ResearchFindingsParity

def test_parity():
    """Test the parity implementation"""
    
    print("🔬 TESTING PARITY IMPLEMENTATION")
    print("=" * 50)
    
    # Load data
    analyzer = PersonalityNetworkAnalyzer("data/NEO_IPIP_1.csv")
    analyzer.load_data("data/NEO_IPIP_1.csv")
    analyzer.preprocess_data()
    
    print(f"Data loaded: {analyzer.data_processed.shape}")
    
    # Create parity implementation
    parity_findings = ResearchFindingsParity(analyzer)
    
    # Run the exact R code methodology
    results = parity_findings.demonstrate_item_aggregation_effects_parity()
    
    print("\n📊 PARITY VERIFICATION:")
    print("=" * 50)
    
    # Compare with R code results
    r_code_results = {
        'N_0.2_1': 0.372,  # R code: 0.37181687
        'N_0.2_2': 0.241,  # R code: 0.24126561
        'N_0.5_1': 0.267,  # R code: 0.26708953
        'N_0.5_2': 0.184,  # R code: 0.18413438
    }
    
    print("R Code Results vs Our Implementation:")
    for condition, expected in r_code_results.items():
        if condition in results:
            actual = results[condition]['glstr_diff']
            diff = abs(actual - expected)
            match = "✅" if diff < 0.1 else "❌"
            print(f"{condition}: R={expected:.3f}, Ours={actual:.3f}, Diff={diff:.3f} {match}")
        else:
            print(f"{condition}: ❌ Missing")
    
    # Check if we achieved parity
    all_close = True
    for condition, expected in r_code_results.items():
        if condition in results:
            actual = results[condition]['glstr_diff']
            if abs(actual - expected) > 0.1:
                all_close = False
                break
        else:
            all_close = False
            break
    
    if all_close:
        print("\n🎉 PARITY ACHIEVED! Results match R code within tolerance.")
    else:
        print("\n❌ PARITY NOT ACHIEVED. Results do not match R code.")
    
    return results

if __name__ == "__main__":
    test_parity()
