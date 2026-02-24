#!/usr/bin/env python3
"""
Read R results files using rpy2
"""

import rpy2.robjects as ro
import pandas as pd
import numpy as np

def read_r_results():
    """Read R results files and extract the actual results"""
    
    # Load the R results file
    try:
        print("Loading R results file...")
        ro.r('load("data/NEO & IPIP - P3_nSim50_results_all_N.RData")')
        
        # Get list of loaded objects
        objects = ro.r('ls()')
        print(f"Loaded R objects: {list(objects)}")
        
        # Look for the key result objects
        result_objects = [
            'output1_N_DD_avg.glstr',
            'output1_N_split_SS_NEO_avg.glstr', 
            'output1_N_split_SS_IPIP_avg.glstr',
            'output1_N_split_DD_avg.glstr'
        ]
        
        for obj_name in result_objects:
            try:
                print(f"\n--- {obj_name} ---")
                obj = ro.r(obj_name)
                
                # Convert to pandas DataFrame
                if hasattr(obj, 'rx2'):
                    # It's a data frame
                    df = pd.DataFrame(obj)
                    print(f"Shape: {df.shape}")
                    print("Columns:", list(df.columns))
                    print("\nFirst 10 rows:")
                    print(df.head(10))
                    
                    # Look for specific columns we need
                    if 'avg.glstr_x' in df.columns and 'avg.glstr_y' in df.columns:
                        print(f"\nGlobal Strength Results:")
                        print(f"X (NEO): {df['avg.glstr_x'].values}")
                        print(f"Y (IPIP): {df['avg.glstr_y'].values}")
                    
                    if 'avg.glstr_diff' in df.columns:
                        print(f"\nGlobal Strength Differences:")
                        print(f"Diff: {df['avg.glstr_diff'].values}")
                        
                else:
                    print(f"Object type: {type(obj)}")
                    print(f"Value: {obj}")
                    
            except Exception as e:
                print(f"Error reading {obj_name}: {e}")
                
    except Exception as e:
        print(f"Error loading R file: {e}")

if __name__ == "__main__":
    read_r_results()