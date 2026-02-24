#!/usr/bin/env python3
"""
Main application entry point for AriannesNetworks.

This module provides the main application logic and serves as the entry point
for the AriannesNetworks project. It integrates the network analysis capabilities
for personality research based on Herrera-Bennett & Rhemtulla (2021).
"""

import sys
import argparse
from typing import Optional
from pathlib import Path

# Import our network analysis module
try:
    from .network_analysis import PersonalityNetworkAnalyzer
except ImportError:
    try:
        from network_analysis import PersonalityNetworkAnalyzer
    except ImportError:
        print("Warning: Network analysis module not found. Basic functionality only.")
        PersonalityNetworkAnalyzer = None


def greet(name: Optional[str] = None) -> str:
    """
    Generate a greeting message.
    
    Args:
        name: Optional name to include in the greeting.
        
    Returns:
        A greeting message string.
    """
    if name:
        return f"Hello, {name}! Welcome to AriannesNetworks - Personality Network Analysis."
    return "Hello! Welcome to AriannesNetworks - Personality Network Analysis."


def run_network_analysis(data_path: str, analysis_type: str = "full") -> int:
    """
    Run network analysis on personality data.
    
    Args:
        data_path: Path to the data file
        analysis_type: Type of analysis to run ('full', 'quick', 'demo')
        
    Returns:
        Exit code (0 for success, non-zero for error)
    """
    if PersonalityNetworkAnalyzer is None:
        print("Error: Network analysis module not available.")
        return 1
    
    try:
        print("Starting Personality Network Analysis...")
        print("=" * 50)
        
        # Initialize analyzer
        analyzer = PersonalityNetworkAnalyzer()
        
        # Load data
        analyzer.load_data(data_path)
        
        # Preprocess data
        analyzer.preprocess_data(method='complete', scale=True)
        
        # Get available variables
        all_vars = list(analyzer.data_processed.columns)
        
        # Define variable sets
        neo_vars = [col for col in all_vars 
                   if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) <= 2]
        
        ipip_vars = [col for col in all_vars 
                    if col.startswith(('I', 'a', 'b', 'c', 'd', 'e', 'h', 'm', 'n', 'p', 'q', 'r', 's', 'v', 'x'))]
        
        # Limit variables based on analysis type
        if analysis_type == "demo":
            neo_vars = neo_vars[:10] if len(neo_vars) > 10 else neo_vars
            ipip_vars = ipip_vars[:10] if len(ipip_vars) > 10 else ipip_vars
        elif analysis_type == "quick":
            neo_vars = neo_vars[:15] if len(neo_vars) > 15 else neo_vars
            ipip_vars = ipip_vars[:15] if len(ipip_vars) > 15 else ipip_vars
        
        print(f"Analysis type: {analysis_type}")
        print(f"Selected {len(neo_vars)} NEO variables and {len(ipip_vars)} IPIP variables")
        
        networks_created = []
        
        # Construct NEO network
        if neo_vars:
            print(f"\nConstructing NEO network with {len(neo_vars)} variables...")
            neo_network_name = f'neo_correlation_{len(neo_vars)}vars'
            neo_network = analyzer.construct_network(neo_vars, method='correlation', network_name=neo_network_name)
            analyzer.analyze_network_properties(neo_network_name)
            networks_created.append('NEO')
            
            if analysis_type in ["full", "quick"]:
                analyzer.visualize_network(neo_network_name, save_path='figures/neo_network.png')
        
        # Construct IPIP network
        if ipip_vars:
            print(f"\nConstructing IPIP network with {len(ipip_vars)} variables...")
            ipip_network_name = f'ipip_correlation_{len(ipip_vars)}vars'
            ipip_network = analyzer.construct_network(ipip_vars, method='correlation', network_name=ipip_network_name)
            analyzer.analyze_network_properties(ipip_network_name)
            networks_created.append('IPIP')
            
            if analysis_type in ["full", "quick"]:
                analyzer.visualize_network(ipip_network_name, save_path='figures/ipip_network.png')
        
        # Bootstrap analysis for full analysis
        if analysis_type == "full" and networks_created:
            print(f"\nPerforming bootstrap analysis...")
            # Use the last created network for bootstrap analysis
            last_network_name = list(analyzer.networks.keys())[-1]
            analyzer.bootstrap_analysis(last_network_name, n_bootstrap=50)
        
        # Generate report
        report_path = f'network_analysis_report_{analysis_type}.txt'
        report = analyzer.generate_report(report_path)
        
        print(f"\nAnalysis completed successfully!")
        print(f"Networks created: {', '.join(networks_created)}")
        print(f"Report saved to: {report_path}")
        
        return 0
        
    except Exception as e:
        print(f"Error during network analysis: {e}", file=sys.stderr)
        return 1


def show_help() -> None:
    """Show help information about the application."""
    help_text = """
AriannesNetworks - Personality Network Analysis Application

This application implements network analysis techniques for personality traits,
specifically focusing on Agreeableness and Neuroticism networks using 
NEO and IPIP personality inventories, based on Herrera-Bennett & Rhemtulla (2021).

USAGE:
    python src/main.py [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -d, --data PATH         Path to the data file (default: data/NEO_IPIP_1.csv)
    -a, --analysis TYPE     Analysis type: demo, quick, or full (default: demo)
    -n, --name NAME         Your name for personalized greeting

ANALYSIS TYPES:
    demo    - Quick demonstration with limited variables (10 each)
    quick   - Standard analysis with moderate variables (15 each)
    full    - Complete analysis with all variables and bootstrap testing

EXAMPLES:
    python src/main.py --name "Dr. Smith" --analysis demo
    python src/main.py --data "my_data.csv" --analysis full
    python src/main.py --help

FEATURES:
    - Data preprocessing and cleaning
    - Network construction and analysis
    - Replicability testing (bootstrap analysis)
    - Network visualization
    - Statistical validation
    - Comprehensive reporting

For more information, see the documentation in docs/documentation.md
"""
    print(help_text)


def main() -> int:
    """
    Main application entry point.
    
    Returns:
        Exit code (0 for success, non-zero for error).
    """
    parser = argparse.ArgumentParser(
        description="AriannesNetworks - Personality Network Analysis",
        add_help=False
    )
    
    parser.add_argument('-h', '--help', action='store_true',
                       help='Show help message')
    parser.add_argument('-d', '--data', type=str, default='data/NEO_IPIP_1.csv',
                       help='Path to the data file')
    parser.add_argument('-a', '--analysis', type=str, choices=['demo', 'quick', 'full'],
                       default='demo', help='Analysis type')
    parser.add_argument('-n', '--name', type=str,
                       help='Your name for personalized greeting')
    
    # Parse arguments
    args = parser.parse_args()
    
    # Show help if requested
    if args.help:
        show_help()
        return 0
    
    try:
        # Generate greeting
        message = greet(args.name)
        print(message)
        print()
        
        # Check if data file exists
        data_path = Path(args.data)
        if not data_path.exists():
            print(f"Error: Data file not found at {data_path}")
            print("Please ensure the data file exists or specify the correct path with --data")
            return 1
        
        # Run network analysis
        return run_network_analysis(str(data_path), args.analysis)
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
