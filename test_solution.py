#!/usr/bin/env python3
"""
Test the solution using sklearn.covariance.GraphicalLassoCV
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from src.network_analysis import PersonalityNetworkAnalyzer
from src.research_findings_solution import ResearchFindingsSolution

def test_solution():
    """Test the solution using established Python library"""
    
    print("🔬 TESTING SOLUTION: sklearn.covariance.GraphicalLassoCV")
    print("=" * 50)
    print("This is the established Python equivalent of R's ggmModSelect")
    print("=" * 50)
    
    # Load data
    analyzer = PersonalityNetworkAnalyzer("data/NEO_IPIP_1.csv")
    analyzer.load_data("data/NEO_IPIP_1.csv")
    analyzer.preprocess_data()
    
    print(f"Data loaded: {analyzer.data_processed.shape}")
    
    # Create solution implementation
    solution_findings = ResearchFindingsSolution(analyzer)
    
    # Run the solution
    results = solution_findings.demonstrate_item_aggregation_effects_solution()
    
    print("\n📊 SOLUTION VERIFICATION:")
    print("=" * 50)
    
    # Compare with R code results
    r_code_results = {
        'N_0.2_1': 0.372,
        'N_0.2_2': 0.241,
        'N_0.5_1': 0.267,
        'N_0.5_2': 0.184,
    }
    
    print("R Code Results vs Our Solution:")
    for condition, expected in r_code_results.items():
        if condition in results:
            actual = results[condition]['glstr_diff']
            diff = abs(actual - expected)
            match = "✅" if diff < 0.1 else "❌"
            print(f"{condition}: R={expected:.3f}, Ours={actual:.3f}, Diff={diff:.3f} {match}")
        else:
            print(f"{condition}: ❌ Missing")
    
    # Check parity
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
        print("This is the honest result using sklearn.covariance.GraphicalLassoCV.")
    
    return results

if __name__ == "__main__":
    test_solution()





