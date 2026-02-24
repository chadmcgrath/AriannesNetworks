#!/usr/bin/env python3
"""
Script to download files from OSF repository m37q2 using correct API endpoints.
"""

import requests
import json
import os
from pathlib import Path


def download_osf_files():
    """Download files from OSF repository m37q2."""
    
    # OSF API endpoints
    base_url = "https://api.osf.io/v2"
    node_id = "m37q2"
    
    # Get file listing
    files_url = f"{base_url}/nodes/{node_id}/files/osfstorage/"
    
    try:
        print(f"Fetching file listing from {files_url}")
        response = requests.get(files_url)
        response.raise_for_status()
        
        data = response.json()
        print(f"Found {len(data.get('data', []))} items")
        
        # Create docs directory if it doesn't exist
        docs_dir = Path("docs")
        docs_dir.mkdir(exist_ok=True)
        
        # Process each file/folder
        for item in data.get('data', []):
            item_name = item.get('attributes', {}).get('name', 'unknown')
            item_kind = item.get('attributes', {}).get('kind', 'file')
            item_id = item.get('id', '')
            
            print(f"Processing {item_kind}: {item_name}")
            
            if item_kind == 'folder':
                # Use the correct API endpoint for folder contents
                folder_url = f"{base_url}/nodes/{node_id}/files/osfstorage/{item_id}/"
                download_folder_contents(folder_url, docs_dir / item_name)
            else:
                # Handle file - download directly
                download_url = item.get('links', {}).get('download', '')
                if download_url:
                    download_file(download_url, docs_dir / item_name)
                    
    except requests.RequestException as e:
        print(f"Error accessing OSF API: {e}")
    except Exception as e:
        print(f"Error: {e}")


def download_folder_contents(folder_url, target_dir):
    """Download contents of a folder."""
    try:
        print(f"  Fetching folder contents from {folder_url}")
        response = requests.get(folder_url)
        response.raise_for_status()
        
        data = response.json()
        target_dir.mkdir(exist_ok=True)
        
        # Handle both list and single item responses
        items = data.get('data', [])
        if not isinstance(items, list):
            items = [items] if items else []
        
        print(f"  Found {len(items)} items in folder")
        
        for item in items:
            if isinstance(item, dict):
                item_name = item.get('attributes', {}).get('name', 'unknown')
                item_kind = item.get('attributes', {}).get('kind', 'file')
                item_id = item.get('id', '')
                
                print(f"    Processing {item_kind}: {item_name}")
                
                if item_kind == 'file':
                    download_url = item.get('links', {}).get('download', '')
                    if download_url:
                        download_file(download_url, target_dir / item_name)
                elif item_kind == 'folder':
                    # Recursively handle subfolders
                    subfolder_url = f"https://api.osf.io/v2/nodes/m37q2/files/osfstorage/{item_id}/"
                    download_folder_contents(subfolder_url, target_dir / item_name)
                    
    except Exception as e:
        print(f"Error downloading folder contents: {e}")


def download_file(download_url, target_path):
    """Download a single file."""
    try:
        print(f"      Downloading: {target_path.name}")
        response = requests.get(download_url)
        response.raise_for_status()
        
        # Ensure parent directory exists
        target_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Write file
        with open(target_path, 'wb') as f:
            f.write(response.content)
            
        print(f"      Downloaded: {target_path}")
        
    except Exception as e:
        print(f"Error downloading file {target_path}: {e}")


if __name__ == "__main__":
    download_osf_files()
