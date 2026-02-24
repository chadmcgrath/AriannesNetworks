#!/usr/bin/env python3
"""
Manually extract key results from R data by analyzing patterns
"""

import gzip
import re

def manual_extract_results():
    """Manually extract key results from R data files"""
    
    result_files = [
        'data/NEO & IPIP - P3_nSim50_results_all_N.RData',
        'data/NEO & IPIP - P3_nSim50_results_all_A.RData'
    ]
    
    for file_path in result_files:
        print(f"\n=== Manual Extraction from {file_path} ===")
        try:
            # Decompress the file
            with gzip.open(file_path, 'rb') as f:
                data = f.read()
            
            # Convert to string
            text = data.decode('utf-8', errors='ignore')
            
            # Look for the key conditions and extract what we can
            if 'N_' in file_path:
                # Neuroticism data
                print("Neuroticism (N) Results:")
                
                # Look for the key conditions mentioned in the R code
                key_conditions = ['N_0.5_1', 'N_0.5_3', 'N_0.5_8']
                
                for condition in key_conditions:
                    print(f"\n--- {condition} ---")
                    
                    # Find this condition in the data
                    cond_pos = text.find(condition)
                    if cond_pos != -1:
                        # Look for numerical data around this condition
                        context = text[max(0, cond_pos-200):cond_pos+1000]
                        
                        # Look for any numbers that might be results
                        numbers = re.findall(r'-?\d+\.\d+', context)
                        if numbers:
                            print(f"  Numbers found: {numbers[:20]}")  # First 20 numbers
                        
                        # Look for specific patterns
                        if 'avg.glstr_x' in context:
                            print("  Found avg.glstr_x reference")
                        if 'avg.glstr_y' in context:
                            print("  Found avg.glstr_y reference")
                        if 'avg.glstr_diff' in context:
                            print("  Found avg.glstr_diff reference")
                        
                        # Try to find the actual values
                        # The values should be stored as doubles in the binary data
                        # Let's look for any patterns that might indicate the values
                        
                        # Look for the data structure
                        if 'data.frame' in context:
                            print("  Found data.frame structure")
                        
                        # Look for any readable text that might contain results
                        readable_text = re.sub(r'[^\x20-\x7E]', ' ', context)
                        readable_text = ' '.join(readable_text.split())
                        
                        # Look for any patterns that might be results
                        if '0.' in readable_text:
                            # Extract any decimal numbers
                            decimal_numbers = re.findall(r'0\.\d+', readable_text)
                            if decimal_numbers:
                                print(f"  Decimal numbers: {decimal_numbers[:10]}")
                        
            else:
                # Agreeableness data
                print("Agreeableness (A) Results:")
                
                # Look for the key conditions mentioned in the R code
                key_conditions = ['A_0.5_1', 'A_0.5_3', 'A_0.5_8']
                
                for condition in key_conditions:
                    print(f"\n--- {condition} ---")
                    
                    # Find this condition in the data
                    cond_pos = text.find(condition)
                    if cond_pos != -1:
                        # Look for numerical data around this condition
                        context = text[max(0, cond_pos-200):cond_pos+1000]
                        
                        # Look for any numbers that might be results
                        numbers = re.findall(r'-?\d+\.\d+', context)
                        if numbers:
                            print(f"  Numbers found: {numbers[:20]}")  # First 20 numbers
                        
                        # Look for specific patterns
                        if 'avg.glstr_x' in context:
                            print("  Found avg.glstr_x reference")
                        if 'avg.glstr_y' in context:
                            print("  Found avg.glstr_y reference")
                        if 'avg.glstr_diff' in context:
                            print("  Found avg.glstr_diff reference")
                        
                        # Try to find the actual values
                        # Look for any readable text that might contain results
                        readable_text = re.sub(r'[^\x20-\x7E]', ' ', context)
                        readable_text = ' '.join(readable_text.split())
                        
                        # Look for any patterns that might be results
                        if '0.' in readable_text:
                            # Extract any decimal numbers
                            decimal_numbers = re.findall(r'0\.\d+', readable_text)
                            if decimal_numbers:
                                print(f"  Decimal numbers: {decimal_numbers[:10]}")
                                
        except Exception as e:
            print(f"Error extracting from file: {e}")

if __name__ == "__main__":
    manual_extract_results()





