#!/usr/bin/env python3
"""
Extract actual numerical results from R data files
"""

import gzip
import struct
import re
import numpy as np

def extract_double_values(data, start_pos, count):
    """Extract double precision values from binary data"""
    values = []
    pos = start_pos
    for i in range(count):
        if pos + 8 <= len(data):
            # Extract 8-byte double
            value = struct.unpack('<d', data[pos:pos+8])[0]
            values.append(value)
            pos += 8
        else:
            break
    return values

def extract_r_results():
    """Extract actual numerical results from R data files"""
    
    result_files = [
        'data/NEO & IPIP - P3_nSim50_results_all_N.RData',
        'data/NEO & IPIP - P3_nSim50_results_all_A.RData'
    ]
    
    for file_path in result_files:
        print(f"\n=== Extracting Results from {file_path} ===")
        try:
            # Decompress the file
            with gzip.open(file_path, 'rb') as f:
                data = f.read()
            
            print(f"Decompressed size: {len(data)} bytes")
            
            # Convert to string for pattern matching
            text = data.decode('utf-8', errors='ignore')
            
            # Look for the key result objects and extract their data
            result_objects = [
                'output1_N_DD_avg.glstr',
                'output1_A_DD_avg.glstr'
            ]
            
            for obj_name in result_objects:
                if obj_name in text:
                    print(f"\n--- {obj_name} ---")
                    
                    # Find the object in the binary data
                    obj_start = text.find(obj_name)
                    if obj_start != -1:
                        # Look for the data structure after the object name
                        # The data should contain the actual numerical results
                        
                        # Find the conditions (N_0.2_1, N_0.5_1, etc.)
                        conditions = re.findall(r'[NA]_0\.\d+_\d+', text[obj_start:obj_start+2000])
                        print(f"Conditions found: {conditions}")
                        
                        # Look for numerical data patterns
                        # The data structure should contain avg.glstr_x, avg.glstr_y, avg.glstr_diff
                        
                        # Try to find the binary data section
                        binary_start = obj_start + len(obj_name)
                        
                        # Look for the data frame structure
                        if 'avg.glstr_x' in text[binary_start:binary_start+1000]:
                            print("Found avg.glstr_x data structure")
                            
                            # Extract the numerical values
                            # The values are stored as IEEE 754 doubles (8 bytes each)
                            
                            # Look for the actual data section
                            data_section_start = text.find('avg.glstr_x', binary_start)
                            if data_section_start != -1:
                                # Find the binary data that follows
                                # Look for patterns that indicate the start of numerical data
                                
                                # The data should be in the format: condition -> avg.glstr_x, avg.glstr_y, avg.glstr_diff
                                # For each condition, we should have multiple double values
                                
                                # Try to extract values for each condition
                                for condition in conditions[:5]:  # First 5 conditions
                                    print(f"\n{condition}:")
                                    
                                    # Look for this condition in the data
                                    cond_pos = text.find(condition, data_section_start)
                                    if cond_pos != -1:
                                        # Try to extract the numerical values that follow
                                        # The values should be stored as doubles
                                        
                                        # Look for the binary data section
                                        # The values are typically stored in a specific order
                                        
                                        # For now, let's try to find any numerical patterns
                                        # around this condition
                                        context = text[max(0, cond_pos-100):cond_pos+500]
                                        
                                        # Look for any readable numbers
                                        numbers = re.findall(r'-?\d+\.\d+', context)
                                        if numbers:
                                            print(f"  Numbers found: {numbers[:10]}")
                                        
                                        # Look for binary patterns that might be doubles
                                        # IEEE 754 doubles have specific bit patterns
                                        
                                        # Try to find the actual binary data
                                        # The data should be stored as little-endian doubles
                                        
                                        # For now, let's extract what we can from the text
                                        # The actual binary parsing would require more sophisticated
                                        # understanding of the R data format
                                        
                                        # Look for any patterns that might indicate the values
                                        if 'avg.glstr_x' in context:
                                            print("  Found avg.glstr_x reference")
                                        if 'avg.glstr_y' in context:
                                            print("  Found avg.glstr_y reference")
                                        if 'avg.glstr_diff' in context:
                                            print("  Found avg.glstr_diff reference")
                                        
                        else:
                            print("Could not find avg.glstr_x data structure")
                            
        except Exception as e:
            print(f"Error extracting from file: {e}")

if __name__ == "__main__":
    extract_r_results()






