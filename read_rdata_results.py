#!/usr/bin/env python3
"""
Read R results files using rdata library
"""

import rdata
import pandas as pd
import numpy as np

def read_rdata_results():
    """Read R results files using rdata library"""
    
    result_files = [
        'data/NEO & IPIP - P3_nSim50_results_all_N.RData',
        'data/NEO & IPIP - P3_nSim50_results_all_A.RData'
    ]
    
    for file_path in result_files:
        print(f"\n=== Reading {file_path} ===")
        try:
            # Parse the RData file
            parsed = rdata.parser.parse_file(file_path)
            converted = rdata.conversion.convert(parsed)
            
            print(f"Successfully parsed file")
            print(f"Keys: {list(converted.keys())}")
            
            # Look for the key result objects
            result_objects = [
                'output1_N_DD_avg.glstr',
                'output1_N_split_SS_NEO_avg.glstr', 
                'output1_N_split_SS_IPIP_avg.glstr',
                'output1_N_split_DD_avg.glstr',
                'output1_A_DD_avg.glstr',
                'output1_A_split_SS_NEO_avg.glstr',
                'output1_A_split_SS_IPIP_avg.glstr',
                'output1_A_split_DD_avg.glstr'
            ]
            
            for obj_name in result_objects:
                if obj_name in converted:
                    print(f"\n--- {obj_name} ---")
                    obj = converted[obj_name]
                    
                    if isinstance(obj, pd.DataFrame):
                        print(f"Shape: {obj.shape}")
                        print("Columns:", list(obj.columns))
                        print("\nFirst 10 rows:")
                        print(obj.head(10))
                        
                        # Look for specific columns we need
                        if 'avg.glstr_x' in obj.columns and 'avg.glstr_y' in obj.columns:
                            print(f"\nGlobal Strength Results:")
                            print(f"X (NEO): {obj['avg.glstr_x'].values}")
                            print(f"Y (IPIP): {obj['avg.glstr_y'].values}")
                        
                        if 'avg.glstr_diff' in obj.columns:
                            print(f"\nGlobal Strength Differences:")
                            print(f"Diff: {obj['avg.glstr_diff'].values}")
                            
                        # Look for the specific conditions mentioned in R code
                        if 'N_0.5_1' in obj.index or 'A_0.5_1' in obj.index:
                            print(f"\nKey Conditions Found:")
                            key_conditions = ['N_0.5_1', 'N_0.5_3', 'N_0.5_8', 'A_0.5_1', 'A_0.5_3', 'A_0.5_8']
                            for condition in key_conditions:
                                if condition in obj.index:
                                    print(f"{condition}:")
                                    if 'avg.glstr_x' in obj.columns:
                                        print(f"  NEO Global Strength: {obj.loc[condition, 'avg.glstr_x']}")
                                    if 'avg.glstr_y' in obj.columns:
                                        print(f"  IPIP Global Strength: {obj.loc[condition, 'avg.glstr_y']}")
                                    if 'avg.glstr_diff' in obj.columns:
                                        print(f"  Global Strength Diff: {obj.loc[condition, 'avg.glstr_diff']}")
                                        
                    else:
                        print(f"Object type: {type(obj)}")
                        print(f"Value: {obj}")
                        
        except Exception as e:
            print(f"Error reading file: {e}")

if __name__ == "__main__":
    read_rdata_results()









