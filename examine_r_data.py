#!/usr/bin/env python3
"""
Script to examine R data files and compare with our results
"""

import pyreadr
import pandas as pd
import numpy as np
import os

def examine_rdata_file(filepath):
    """Examine an RData file and print its contents"""
    print(f"\n{'='*60}")
    print(f"EXAMINING: {filepath}")
    print(f"{'='*60}")
    
    try:
        result = pyreadr.read_r(filepath)
        print(f"Keys in file: {list(result.keys())}")
        
        for key, data in result.items():
            print(f"\n--- {key} ---")
            if hasattr(data, 'shape'):
                print(f"Shape: {data.shape}")
                print(f"Type: {type(data)}")
                if isinstance(data, pd.DataFrame):
                    print(f"Columns: {list(data.columns)}")
                    print(f"First few rows:")
                    print(data.head())
                elif isinstance(data, pd.Series):
                    print(f"Values: {data.values[:10]}...")
                else:
                    print(f"Data type: {type(data)}")
                    print(f"First few values: {data[:10] if hasattr(data, '__getitem__') else data}")
            else:
                print(f"Type: {type(data)}")
                print(f"Value: {data}")
                
    except Exception as e:
        print(f"Error reading file: {e}")

def main():
    """Main function to examine all R data files"""
    data_dir = "data"
    
    # List all RData files
    rdata_files = [f for f in os.listdir(data_dir) if f.endswith('.RData')]
    
    print(f"Found {len(rdata_files)} RData files:")
    for f in rdata_files:
        print(f"  - {f}")
    
    # Examine each file
    for filename in rdata_files:
        filepath = os.path.join(data_dir, filename)
        examine_rdata_file(filepath)

if __name__ == "__main__":
    main()

