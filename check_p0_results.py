#!/usr/bin/env python3
"""
Check P0 functions file for results
"""

import pyreadr

def check_p0_results():
    """Check P0 functions file for results"""
    
    try:
        result = pyreadr.read_r('data/NEO & IPIP - P0_functions.RData')
        print(f"Keys: {list(result.keys())}")
        
        for key, data in result.items():
            print(f"\n--- {key} ---")
            print(f"Type: {type(data)}")
            
            if hasattr(data, 'shape'):
                print(f"Shape: {data.shape}")
                if hasattr(data, 'head'):
                    print("First 10 rows:")
                    print(data.head(10))
            else:
                print(f"Value: {data}")
                
    except Exception as e:
        print(f"Error reading file: {e}")

if __name__ == "__main__":
    check_p0_results()

