#!/usr/bin/env python3
"""
Download all files from OSF repository m37q2 and save to 'original files' folder.
"""

import requests
import json
import os
from pathlib import Path
import time

def download_file(url, target_path):
    """Download a file from URL."""
    try:
        response = requests.get(url, stream=True, timeout=30)
        response.raise_for_status()
        
        # Create directory if needed
        target_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Write file
        total_size = 0
        with open(target_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                if chunk:
                    f.write(chunk)
                    total_size += len(chunk)
        
        return True, total_size
    except Exception as e:
        return False, str(e)

def get_folder_contents(base_url, node_id, folder_path="", folder_name=""):
    """Recursively get all files from OSF folder."""
    files_to_download = []
    
    # Construct API URL
    if folder_path:
        api_url = f"{base_url}/nodes/{node_id}/files/osfstorage/{folder_path}/"
    else:
        api_url = f"{base_url}/nodes/{node_id}/files/osfstorage/"
    
    try:
        response = requests.get(api_url, timeout=30)
        response.raise_for_status()
        data = response.json()
        
        for item in data.get('data', []):
            item_name = item.get('attributes', {}).get('name', '')
            item_kind = item.get('attributes', {}).get('kind', 'file')
            item_id = item.get('id', '')
            
            if item_kind == 'folder':
                # Recursively get folder contents
                if folder_path:
                    new_path = f"{folder_path}/{item_id}"
                else:
                    new_path = item_id
                new_folder_name = folder_name + '/' + item_name if folder_name else item_name
                subfolder_files = get_folder_contents(base_url, node_id, new_path, new_folder_name)
                files_to_download.extend(subfolder_files)
            else:
                # It's a file
                download_url = item.get('links', {}).get('download', '')
                if download_url:
                    if folder_name:
                        file_path = folder_name + '/' + item_name
                    else:
                        file_path = item_name
                    
                    files_to_download.append({
                        'name': item_name,
                        'url': download_url,
                        'path': file_path
                    })
        
    except Exception as e:
        print(f"Error accessing folder: {e}")
    
    return files_to_download

def download_all_osf_files():
    """Download all files from OSF repository."""
    
    base_url = "https://api.osf.io/v2"
    node_id = "m37q2"
    target_dir = Path("original files")
    target_dir.mkdir(exist_ok=True)
    
    print("=" * 70)
    print("DOWNLOADING ALL FILES FROM OSF REPOSITORY")
    print("=" * 70)
    print(f"Repository: https://osf.io/{node_id}")
    print(f"Target directory: {target_dir.absolute()}")
    print()
    
    # Get all files
    print("Scanning repository structure...")
    all_files = get_folder_contents(base_url, node_id)
    
    if not all_files:
        print("⚠️  No files found via API. Trying alternative method...")
        print()
        print("Please visit: https://osf.io/m37q2/files/osfstorage")
        print("And download files manually, or use OSF's zip download feature.")
        return
    
    print(f"Found {len(all_files)} files to download")
    print()
    
    # Download each file
    downloaded = 0
    failed = 0
    total_size = 0
    
    for i, file_info in enumerate(all_files, 1):
        file_name = file_info['name']
        file_url = file_info['url']
        file_path = file_info.get('path', file_name)
        
        target_path = target_dir / file_path
        
        print(f"[{i}/{len(all_files)}] Downloading: {file_name}")
        
        success, result = download_file(file_url, target_path)
        
        if success:
            size_mb = result / (1024 * 1024)
            total_size += result
            print(f"  [OK] Downloaded ({size_mb:.2f} MB)")
            downloaded += 1
        else:
            print(f"  [FAILED] {result}")
            failed += 1
        
        # Small delay to be respectful
        time.sleep(0.5)
    
    print()
    print("=" * 70)
    print("DOWNLOAD SUMMARY")
    print("=" * 70)
    print(f"Total files: {len(all_files)}")
    print(f"Downloaded: {downloaded}")
    print(f"Failed: {failed}")
    print(f"Total size: {total_size / (1024 * 1024):.2f} MB")
    print(f"Files saved to: {target_dir.absolute()}")
    print("=" * 70)

if __name__ == "__main__":
    download_all_osf_files()

