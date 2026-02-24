#!/usr/bin/env python3
"""
Detailed examination of RData files to compare with our results
"""

import pyreadr
import pandas as pd
import numpy as np
import os

def examine_rdata_detailed(filepath):
    """Examine an RData file in detail"""
    print(f"\n{'='*80}")
    print(f"EXAMINING: {os.path.basename(filepath)}")
    print(f"{'='*80}")
    
    try:
        result = pyreadr.read_r(filepath)
        print(f"Keys in file: {list(result.keys())}")
        
        for key, data in result.items():
            print(f"\n--- {key} ---")
            print(f"Type: {type(data)}")
            
            if hasattr(data, 'shape'):
                print(f"Shape: {data.shape}")
                if isinstance(data, pd.DataFrame):
                    print(f"Columns: {list(data.columns)}")
                    print(f"Data types: {data.dtypes.to_dict()}")
                    print(f"First 10 rows:")
                    print(data.head(10))
                    print(f"Last 10 rows:")
                    print(data.tail(10))
                    
                    # Look for specific patterns
                    if 'glstr' in str(data.columns).lower():
                        print(f"GLOBAL STRENGTH DATA FOUND!")
                        print(f"Values: {data.values.flatten()[:20]}...")
                    
                    if 'diffcen' in str(data.columns).lower():
                        print(f"CENTRALITY DIFFERENCE DATA FOUND!")
                        print(f"Values: {data.values.flatten()[:20]}...")
                        
                elif isinstance(data, pd.Series):
                    print(f"Values: {data.values[:20]}...")
                    print(f"Mean: {data.mean():.4f}")
                    print(f"Std: {data.std():.4f}")
                else:
                    print(f"Array data: {data[:20] if hasattr(data, '__getitem__') else data}")
            else:
                print(f"Value: {data}")
                
    except Exception as e:
        print(f"Error reading file: {e}")

def main():
    """Main function to examine RData files"""
    data_dir = "data"
    
    # Focus on the key files that might contain our results
    key_files = [
        "NEO & IPIP - P2_nSim50_data_N.RData",  # Resampling data
        "NEO & IPIP - P3_nSim50_data_all_N.RData",  # Analysis data
        "NEO & IPIP - P3_nSim50_results_all_N.RData",  # Results data
    ]
    
    for filename in key_files:
        filepath = os.path.join(data_dir, filename)
        if os.path.exists(filepath):
            examine_rdata_detailed(filepath)
        else:
            print(f"File not found: {filename}")

if __name__ == "__main__":
    main()

