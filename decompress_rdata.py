#!/usr/bin/env python3
"""
Decompress and analyze RData files
"""

import gzip
import struct
import re

def decompress_rdata():
    """Decompress RData files and extract readable data"""
    
    result_files = [
        'data/NEO & IPIP - P3_nSim50_results_all_N.RData',
        'data/NEO & IPIP - P3_nSim50_results_all_A.RData'
    ]
    
    for file_path in result_files:
        print(f"\n=== Analyzing {file_path} ===")
        try:
            # Decompress the file
            with gzip.open(file_path, 'rb') as f:
                data = f.read()
            
            print(f"Decompressed size: {len(data)} bytes")
            
            # Convert to string and look for patterns
            text = data.decode('utf-8', errors='ignore')
            
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
            
            print(f"\nLooking for result objects...")
            for obj_name in result_objects:
                if obj_name in text:
                    print(f"✓ Found: {obj_name}")
                    
                    # Try to extract data around this object
                    start = text.find(obj_name)
                    if start != -1:
                        # Look for numerical data in the surrounding text
                        context = text[max(0, start-200):start+1000]
                        
                        # Look for numbers that might be results
                        numbers = re.findall(r'-?\d+\.\d+', context)
                        if numbers:
                            print(f"  Numbers found: {numbers[:10]}")  # First 10 numbers
                        
                        # Look for specific conditions
                        conditions = re.findall(r'[NA]_0\.\d+_\d+', context)
                        if conditions:
                            print(f"  Conditions found: {conditions}")
                            
                else:
                    print(f"✗ Not found: {obj_name}")
            
            # Look for any numerical patterns that might be results
            print(f"\nLooking for numerical patterns...")
            
            # Look for sequences of numbers that might be results
            number_sequences = re.findall(r'-?\d+\.\d+(?:\s+-?\d+\.\d+){2,}', text)
            if number_sequences:
                print(f"Number sequences found: {number_sequences[:5]}")
            
            # Look for specific patterns like "avg.glstr"
            avg_patterns = re.findall(r'avg\.glstr[^,]*', text)
            if avg_patterns:
                print(f"avg.glstr patterns: {avg_patterns[:5]}")
                
        except Exception as e:
            print(f"Error analyzing file: {e}")

if __name__ == "__main__":
    decompress_rdata()









