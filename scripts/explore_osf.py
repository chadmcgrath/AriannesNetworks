#!/usr/bin/env python3
"""
Script to explore OSF repository structure.
"""

import requests
import json


def explore_osf():
    """Explore the OSF repository structure."""
    
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
        
        # Print the full response structure
        print("\nFull API response:")
        print(json.dumps(data, indent=2))
        
        # Process each file/folder
        for i, item in enumerate(data.get('data', [])):
            print(f"\n--- Item {i+1} ---")
            print(f"ID: {item.get('id', 'N/A')}")
            print(f"Type: {item.get('type', 'N/A')}")
            print(f"Name: {item.get('attributes', {}).get('name', 'N/A')}")
            print(f"Kind: {item.get('attributes', {}).get('kind', 'N/A')}")
            print(f"Links: {item.get('links', {})}")
                    
    except requests.RequestException as e:
        print(f"Error accessing OSF API: {e}")
    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    explore_osf()
