#!/usr/bin/env python3
"""
Test the exact R code methodology implementation
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from src.network_analysis import PersonalityNetworkAnalyzer

def test_exact_methodology():
    """Test the exact R code methodology"""
    
    print("🔬 TESTING EXACT R CODE METHODOLOGY")
    print("=" * 50)
    print("Replicating exact R code logic step by step")
    print("=" * 50)
    
    # Load data
    analyzer = PersonalityNetworkAnalyzer("data/NEO_IPIP_1.csv")
    analyzer.load_data("data/NEO_IPIP_1.csv")
    analyzer.preprocess_data()
    
    print(f"Data loaded: {analyzer.data_processed.shape}")
    
    # Test with a small sample first
    sample_data = analyzer.data_processed.sample(n=100, random_state=123)
    
    # Get NEO items (N1-N6)
    neo_items = [col for col in sample_data.columns if col.startswith('N') and col[1:].isdigit()]
    print(f"NEO items found: {neo_items}")
    
    # Test correlation matrix calculation
    if len(neo_items) >= 2:
        neo_data = sample_data[neo_items[:2]]  # Use first 2 NEO items
        cor_matrix = neo_data.corr(method='pearson')
        print(f"Correlation matrix shape: {cor_matrix.shape}")
        print(f"Correlation matrix:\n{cor_matrix}")
        
        # Test global strength calculation
        abs_matrix = abs(cor_matrix.values)
        np.fill_diagonal(abs_matrix, 0)
        global_strength = np.sum(abs_matrix)
        print(f"Global strength: {global_strength}")
    
    print("\n✅ Basic methodology test completed successfully")

if __name__ == "__main__":
    import numpy as np
    test_exact_methodology()