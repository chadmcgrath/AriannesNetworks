#!/usr/bin/env python3
"""
Script to download files from OSF repository m37q2 with clean organization.
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
        
        # Create organized directory structure
        docs_dir = Path("docs")
        src_dir = Path("src")
        data_dir = Path("data")
        figures_dir = Path("figures")
        
        docs_dir.mkdir(exist_ok=True)
        src_dir.mkdir(exist_ok=True)
        data_dir.mkdir(exist_ok=True)
        figures_dir.mkdir(exist_ok=True)
        
        # Process each file/folder
        for item in data.get('data', []):
            item_name = item.get('attributes', {}).get('name', 'unknown')
            item_kind = item.get('attributes', {}).get('kind', 'file')
            item_id = item.get('id', '')
            
            print(f"Processing {item_kind}: {item_name}")
            
            if item_kind == 'folder':
                # Use the correct API endpoint for folder contents
                folder_url = f"{base_url}/nodes/{node_id}/files/osfstorage/{item_id}/"
                download_folder_contents(folder_url, item_name, docs_dir, src_dir, data_dir, figures_dir)
            else:
                # Handle file - download directly
                download_url = item.get('links', {}).get('download', '')
                if download_url:
                    download_file(download_url, docs_dir / item_name)
                    
    except requests.RequestException as e:
        print(f"Error accessing OSF API: {e}")
    except Exception as e:
        print(f"Error: {e}")


def download_folder_contents(folder_url, folder_name, docs_dir, src_dir, data_dir, figures_dir):
    """Download contents of a folder with organized structure."""
    try:
        print(f"  Fetching folder contents from {folder_url}")
        response = requests.get(folder_url)
        response.raise_for_status()
        
        data = response.json()
        
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
                        # Organize files by type
                        target_path = organize_file(item_name, folder_name, docs_dir, src_dir, data_dir, figures_dir)
                        download_file(download_url, target_path)
                elif item_kind == 'folder':
                    # Recursively handle subfolders
                    subfolder_url = f"https://api.osf.io/v2/nodes/m37q2/files/osfstorage/{item_id}/"
                    download_folder_contents(subfolder_url, f"{folder_name}/{item_name}", docs_dir, src_dir, data_dir, figures_dir)
                    
    except Exception as e:
        print(f"Error downloading folder contents: {e}")


def organize_file(filename, folder_name, docs_dir, src_dir, data_dir, figures_dir):
    """Organize files into appropriate directories based on type and content."""
    
    # Determine target directory based on file type and folder name
    if filename.endswith('.R'):
        # R scripts go to src directory
        return src_dir / filename
    elif filename.endswith('.RData'):
        # R data files go to data directory
        return data_dir / filename
    elif filename.endswith('.csv'):
        # CSV data files go to data directory
        return data_dir / filename
    elif filename.endswith(('.png', '.jpg', '.jpeg', '.pdf')):
        if 'fig' in filename.lower() or 'figure' in folder_name.lower():
            # Figures go to figures directory
            return figures_dir / filename
        else:
            # Other images/PDFs go to docs
            return docs_dir / filename
    elif filename.endswith('.pdf'):
        # PDFs go to docs directory
        return docs_dir / filename
    else:
        # Everything else goes to docs
        return docs_dir / filename


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
