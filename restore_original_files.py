#!/usr/bin/env python3
"""
Script to download and restore original R script files from OSF repository.
DO NOT MODIFY ORIGINAL FILES - only restore them.
"""

import requests
import os
from pathlib import Path

def download_osf_file(file_url, target_path):
    """Download a file from OSF."""
    try:
        print(f"Downloading {target_path.name}...")
        response = requests.get(file_url, stream=True)
        response.raise_for_status()
        
        # Create directory if needed
        target_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Write file
        with open(target_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        
        print(f"  ✓ Saved to {target_path}")
        return True
    except Exception as e:
        print(f"  ✗ Error downloading {target_path.name}: {e}")
        return False

def restore_original_r_scripts():
    """Restore original R script files from OSF repository."""
    
    # OSF repository base URL
    osf_base = "https://osf.io"
    node_id = "m37q2"
    
    # R script files that need to be restored
    r_scripts = [
        "NEO & IPIP - P0 - all functions.R",
        "NEO & IPIP - P1 - data pre-processing & whole-sample_N.R",
        "NEO & IPIP - P1 - data pre-processing & whole-sample_NEOCA.R",
        "NEO & IPIP - P2 - resampling_A.R",
        "NEO & IPIP - P2 - resampling_N.R",
        "NEO & IPIP - P3 - netcompare & analysis_A.R",
        "NEO & IPIP - P3 - netcompare & analysis_N.R",
        "NEO & IPIP - Extra.R"
    ]
    
    # Target directory
    target_dir = Path("r_scripts")
    target_dir.mkdir(exist_ok=True)
    
    print("=" * 60)
    print("RESTORING ORIGINAL R SCRIPT FILES FROM OSF")
    print("=" * 60)
    print(f"OSF Repository: https://osf.io/{node_id}")
    print(f"Target directory: {target_dir}")
    print()
    
    # Try to get file listing from OSF API
    api_url = f"https://api.osf.io/v2/nodes/{node_id}/files/osfstorage/"
    
    try:
        print("Fetching file listing from OSF API...")
        response = requests.get(api_url)
        response.raise_for_status()
        data = response.json()
        
        # Create a mapping of file names to download URLs
        file_map = {}
        for item in data.get('data', []):
            name = item.get('attributes', {}).get('name', '')
            if name.endswith('.R'):
                download_url = item.get('links', {}).get('download', '')
                if download_url:
                    file_map[name] = download_url
        
        # Download each R script
        restored = 0
        for script_name in r_scripts:
            if script_name in file_map:
                target_path = target_dir / script_name
                if download_osf_file(file_map[script_name], target_path):
                    restored += 1
            else:
                print(f"  ⚠ {script_name} not found in OSF repository")
        
        print()
        print("=" * 60)
        print(f"Restored {restored} of {len(r_scripts)} R script files")
        print("=" * 60)
        
    except Exception as e:
        print(f"Error accessing OSF API: {e}")
        print()
        print("Manual restoration required:")
        print("1. Visit: https://osf.io/m37q2/files/osfstorage")
        print("2. Download each R script file")
        print("3. Place in r_scripts/ directory")

if __name__ == "__main__":
    restore_original_r_scripts()


