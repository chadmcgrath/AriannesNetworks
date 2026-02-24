#!/usr/bin/env python3
"""
Test the established libraries implementation
This uses sklearn, networkx, and scipy - all established libraries
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from src.network_analysis import PersonalityNetworkAnalyzer
from src.research_findings_established import ResearchFindingsEstablished

def test_established_libraries():
    """Test the established libraries implementation"""
    
    print("🔬 TESTING ESTABLISHED LIBRARIES IMPLEMENTATION")
    print("=" * 50)
    print("Using sklearn, networkx, scipy - all established libraries")
    print("=" * 50)
    
    # Load data
    analyzer = PersonalityNetworkAnalyzer("data/NEO_IPIP_1.csv")
    analyzer.load_data("data/NEO_IPIP_1.csv")
    analyzer.preprocess_data()
    
    print(f"Data loaded: {analyzer.data_processed.shape}")
    
    # Create established libraries implementation
    established_findings = ResearchFindingsEstablished(analyzer)
    
    # Run the implementation using established libraries
    results = established_findings.demonstrate_item_aggregation_effects_established()
    
    print("\n📊 ESTABLISHED LIBRARIES VERIFICATION:")
    print("=" * 50)
    print("Using sklearn, networkx, scipy - all established libraries")
    
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
        print("This is the honest result using established Python libraries.")
    
    return results

if __name__ == "__main__":
    test_established_libraries()





