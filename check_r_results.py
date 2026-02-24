#!/usr/bin/env python3
"""
Check if we can read the R results files
"""

import pyreadr
import os

def check_r_results():
    """Check if we can read the R results files"""
    
    result_files = [
        'data/NEO & IPIP - P3_nSim50_results_all_N.RData',
        'data/NEO & IPIP - P3_nSim50_results_all_A.RData'
    ]
    
    for file_path in result_files:
        print(f"\nChecking: {file_path}")
        try:
            result = pyreadr.read_r(file_path)
            print(f"  Successfully read file")
            print(f"  Keys: {list(result.keys())}")
            
            for key, data in result.items():
                print(f"    {key}: {type(data)} - {data.shape if hasattr(data, 'shape') else len(data) if hasattr(data, '__len__') else 'scalar'}")
                
        except Exception as e:
            print(f"  Error reading file: {e}")

if __name__ == "__main__":
    check_r_results()

