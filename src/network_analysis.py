#!/usr/bin/env python3
"""
Network Analysis Application for Personality Research

This module implements network analysis techniques for personality traits,
specifically focusing on Agreeableness and Neuroticism networks using 
NEO and IPIP personality inventories, based on Herrera-Bennett & Rhemtulla (2021).

Features:
- Data preprocessing and cleaning
- Network construction and analysis
- Replicability testing
- Generalizability analysis
- Visualization tools
- Statistical validation
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import networkx as nx
import plotly.graph_objects as go
import plotly.express as px
from plotly.subplots import make_subplots
from scipy import stats
from scipy.spatial.distance import pdist, squareform
from scipy.cluster.hierarchy import linkage, dendrogram
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.metrics import adjusted_rand_score
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import RandomForestRegressor
import warnings
warnings.filterwarnings('ignore')

# Set style for better plots
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")


class PersonalityNetworkAnalyzer:
    """
    Main class for personality network analysis.
    
    This class implements the core functionality for analyzing personality
    networks, including data preprocessing, network construction, and
    replicability analysis.
    """
    
    def __init__(self, data_path: str = None):
        """
        Initialize the PersonalityNetworkAnalyzer.
        
        Args:
            data_path: Path to the CSV data file
        """
        self.data = None
        self.networks = {}
        self.results = {}
        self.figures = {}
        
        if data_path:
            self.load_data(data_path)
    
    def load_data(self, data_path: str) -> None:
        """
        Load personality data from CSV file.
        
        Args:
            data_path: Path to the CSV data file
        """
        try:
            self.data = pd.read_csv(data_path)
            print(f"Data loaded successfully: {self.data.shape[0]} participants, {self.data.shape[1]} variables")
            
            # Display basic information about the dataset
            self._display_data_info()
            
        except Exception as e:
            print(f"Error loading data: {e}")
            raise
    
    def _display_data_info(self) -> None:
        """Display basic information about the loaded dataset."""
        print("\n" + "="*50)
        print("DATASET INFORMATION")
        print("="*50)
        print(f"Shape: {self.data.shape}")
        print(f"Missing values: {self.data.isnull().sum().sum()}")
        print(f"Memory usage: {self.data.memory_usage(deep=True).sum() / 1024**2:.2f} MB")
        
        # Show column categories
        print("\nColumn Categories:")
        categories = {
            'NEO': [col for col in self.data.columns if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) <= 2],
            'IPIP': [col for col in self.data.columns if col.startswith(('I', 'a', 'b', 'c', 'd', 'e', 'h', 'm', 'n', 'p', 'q', 'r', 's', 'v', 'x'))],
            'Other': [col for col in self.data.columns if col not in 
                     [col for col in self.data.columns if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) <= 2] and
                     col not in [col for col in self.data.columns if col.startswith(('I', 'a', 'b', 'c', 'd', 'e', 'h', 'm', 'n', 'p', 'q', 'r', 's', 'v', 'x'))]]
        }
        
        for category, cols in categories.items():
            if cols:
                print(f"  {category}: {len(cols)} variables")
                if len(cols) <= 10:
                    print(f"    {cols}")
                else:
                    print(f"    {cols[:5]} ... {cols[-5:]}")
    
    def preprocess_data(self, method: str = 'complete', scale: bool = True) -> pd.DataFrame:
        """
        Preprocess the personality data.
        
        Args:
            method: Method for handling missing values ('complete', 'mean', 'median')
            scale: Whether to standardize the data
            
        Returns:
            Preprocessed DataFrame
        """
        if self.data is None:
            raise ValueError("No data loaded. Please load data first.")
        
        print("\n" + "="*50)
        print("DATA PREPROCESSING")
        print("="*50)
        
        # Create a copy for preprocessing
        data_processed = self.data.copy()
        
        # Handle missing values
        missing_before = data_processed.isnull().sum().sum()
        print(f"Missing values before preprocessing: {missing_before}")
        
        if method == 'complete':
            data_processed = data_processed.dropna()
            print(f"Complete case analysis: {data_processed.shape[0]} participants remaining")
        elif method == 'mean':
            data_processed = data_processed.fillna(data_processed.mean())
            print("Missing values filled with mean")
        elif method == 'median':
            data_processed = data_processed.fillna(data_processed.median())
            print("Missing values filled with median")
        
        missing_after = data_processed.isnull().sum().sum()
        print(f"Missing values after preprocessing: {missing_after}")
        
        # Standardize data if requested
        if scale:
            numeric_cols = data_processed.select_dtypes(include=[np.number]).columns
            scaler = StandardScaler()
            data_processed[numeric_cols] = scaler.fit_transform(data_processed[numeric_cols])
            print(f"Data standardized for {len(numeric_cols)} numeric variables")
        
        self.data_processed = data_processed
        return data_processed
    
    def construct_network(self, variables: list, method: str = 'correlation', 
                         threshold: float = 0.1, min_abs_corr: float = 0.1, 
                         network_name: str = None) -> nx.Graph:
        """
        Construct a network from personality variables.
        
        Args:
            variables: List of variable names to include in the network
            method: Method for network construction ('correlation', 'partial_correlation')
            threshold: Threshold for edge inclusion
            min_abs_corr: Minimum absolute correlation for edge inclusion
            
        Returns:
            NetworkX graph object
        """
        if not hasattr(self, 'data_processed'):
            raise ValueError("Data not preprocessed. Please run preprocess_data() first.")
        
        print(f"\nConstructing network with {len(variables)} variables using {method} method...")
        
        # Select variables
        network_data = self.data_processed[variables].dropna()
        
        if method == 'correlation':
            # Compute correlation matrix
            corr_matrix = network_data.corr()
            
        elif method == 'partial_correlation':
            # Compute partial correlation matrix
            from sklearn.covariance import GraphicalLasso
            gl = GraphicalLasso(alpha=0.1)
            precision_matrix = gl.fit(network_data).precision_
            corr_matrix = -precision_matrix / np.sqrt(np.outer(np.diag(precision_matrix), np.diag(precision_matrix)))
            np.fill_diagonal(corr_matrix, 1)
            corr_matrix = pd.DataFrame(corr_matrix, index=variables, columns=variables)
        
        # Create network
        G = nx.Graph()
        G.add_nodes_from(variables)
        
        # Add edges based on correlation threshold
        edges_added = 0
        for i in range(len(variables)):
            for j in range(i+1, len(variables)):
                corr_val = corr_matrix.loc[variables[i], variables[j]]
                if abs(corr_val) >= min_abs_corr:
                    G.add_edge(variables[i], variables[j], weight=corr_val)
                    edges_added += 1
        
        print(f"Network constructed: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges")
        print(f"Edge density: {nx.density(G):.3f}")
        
        # Store network and correlation matrix
        if network_name is None:
            network_name = f"{method}_{len(variables)}vars"
        self.networks[network_name] = {
            'graph': G,
            'correlation_matrix': corr_matrix,
            'variables': variables,
            'method': method
        }
        
        return G
    
    def analyze_network_properties(self, network_name: str) -> dict:
        """
        Analyze network properties and centrality measures.
        
        Args:
            network_name: Name of the network to analyze
            
        Returns:
            Dictionary containing network analysis results
        """
        if network_name not in self.networks:
            raise ValueError(f"Network '{network_name}' not found.")
        
        G = self.networks[network_name]['graph']
        
        print(f"\nAnalyzing network properties for {network_name}...")
        
        # Basic network properties
        properties = {
            'nodes': G.number_of_nodes(),
            'edges': G.number_of_edges(),
            'density': nx.density(G),
            'average_clustering': nx.average_clustering(G),
            'transitivity': nx.transitivity(G),
            'average_shortest_path_length': nx.average_shortest_path_length(G) if nx.is_connected(G) else None,
            'diameter': nx.diameter(G) if nx.is_connected(G) else None,
            'is_connected': nx.is_connected(G),
            'number_of_components': nx.number_connected_components(G)
        }
        
        # Centrality measures
        centrality_measures = {
            'degree': nx.degree_centrality(G),
            'betweenness': nx.betweenness_centrality(G),
            'closeness': nx.closeness_centrality(G)
        }
        
        # Try PageRank with error handling
        try:
            centrality_measures['pagerank'] = nx.pagerank(G, max_iter=1000)
        except nx.PowerIterationFailedConvergence:
            print("Warning: PageRank failed to converge, using degree centrality instead")
            centrality_measures['pagerank'] = nx.degree_centrality(G)
        
        # Try eigenvector centrality with error handling
        try:
            centrality_measures['eigenvector'] = nx.eigenvector_centrality(G, max_iter=1000)
        except nx.PowerIterationFailedConvergence:
            print("Warning: Eigenvector centrality failed to converge, using degree centrality instead")
            centrality_measures['eigenvector'] = nx.degree_centrality(G)
        
        # Create centrality DataFrame
        centrality_df = pd.DataFrame(centrality_measures)
        
        # Store results
        self.results[network_name] = {
            'properties': properties,
            'centrality_measures': centrality_measures,
            'centrality_dataframe': centrality_df
        }
        
        # Print summary
        print(f"Network Properties:")
        for key, value in properties.items():
            if value is not None:
                print(f"  {key}: {value:.3f}")
        
        print(f"\nTop 5 Most Central Nodes (by degree):")
        top_nodes = centrality_df.nlargest(5, 'degree')
        for idx, row in top_nodes.iterrows():
            print(f"  {idx}: degree={row['degree']:.3f}")
        
        return self.results[network_name]
    
    def visualize_network(self, network_name: str, layout: str = 'spring', 
                         figsize: tuple = (12, 8), save_path: str = None) -> None:
        """
        Visualize the network.
        
        Args:
            network_name: Name of the network to visualize
            layout: Layout algorithm ('spring', 'circular', 'random')
            figsize: Figure size
            save_path: Path to save the figure
        """
        if network_name not in self.networks:
            raise ValueError(f"Network '{network_name}' not found.")
        
        G = self.networks[network_name]['graph']
        
        # Create figure
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=figsize)
        
        # Network visualization
        if layout == 'spring':
            pos = nx.spring_layout(G, k=1, iterations=50)
        elif layout == 'circular':
            pos = nx.circular_layout(G)
        elif layout == 'random':
            pos = nx.random_layout(G)
        
        # Draw network
        nx.draw_networkx_nodes(G, pos, node_color='lightblue', 
                              node_size=300, alpha=0.7, ax=ax1)
        nx.draw_networkx_edges(G, pos, alpha=0.5, ax=ax1)
        nx.draw_networkx_labels(G, pos, font_size=8, ax=ax1)
        
        ax1.set_title(f'Network Visualization: {network_name}')
        ax1.axis('off')
        
        # Degree distribution
        degrees = [G.degree(n) for n in G.nodes()]
        ax2.hist(degrees, bins=20, alpha=0.7, color='skyblue', edgecolor='black')
        ax2.set_xlabel('Degree')
        ax2.set_ylabel('Frequency')
        ax2.set_title('Degree Distribution')
        ax2.grid(True, alpha=0.3)
        
        plt.tight_layout()
        
        if save_path:
            plt.savefig(save_path, dpi=300, bbox_inches='tight')
            print(f"Network visualization saved to {save_path}")
        
        plt.show()
        
        # Store figure
        self.figures[f"{network_name}_network"] = fig
    
    def create_interactive_network(self, network_name: str) -> go.Figure:
        """
        Create an interactive network visualization using Plotly.
        
        Args:
            network_name: Name of the network to visualize
            
        Returns:
            Plotly figure object
        """
        if network_name not in self.networks:
            raise ValueError(f"Network '{network_name}' not found.")
        
        G = self.networks[network_name]['graph']
        
        # Get layout
        pos = nx.spring_layout(G, k=1, iterations=50)
        
        # Prepare edge traces
        edge_x = []
        edge_y = []
        edge_info = []
        
        for edge in G.edges():
            x0, y0 = pos[edge[0]]
            x1, y1 = pos[edge[1]]
            edge_x.extend([x0, x1, None])
            edge_y.extend([y0, y1, None])
            
            weight = G[edge[0]][edge[1]].get('weight', 1)
            edge_info.append(f"{edge[0]} - {edge[1]}<br>Weight: {weight:.3f}")
        
        edge_trace = go.Scatter(x=edge_x, y=edge_y,
                               line=dict(width=0.5, color='#888'),
                               hoverinfo='none',
                               mode='lines')
        
        # Prepare node traces
        node_x = []
        node_y = []
        node_text = []
        node_info = []
        
        for node in G.nodes():
            x, y = pos[node]
            node_x.append(x)
            node_y.append(y)
            node_text.append(node)
            
            degree = G.degree(node)
            node_info.append(f"Node: {node}<br>Degree: {degree}")
        
        node_trace = go.Scatter(x=node_x, y=node_y,
                               mode='markers+text',
                               hoverinfo='text',
                               text=node_text,
                               textposition="middle center",
                               hovertext=node_info,
                               marker=dict(size=20,
                                         color='lightblue',
                                         line=dict(width=2, color='black')))
        
        # Create figure
        fig = go.Figure(data=[edge_trace, node_trace],
                       layout=go.Layout(title=f'Interactive Network: {network_name}',
                                      titlefont_size=16,
                                      showlegend=False,
                                      hovermode='closest',
                                      margin=dict(b=20,l=5,r=5,t=40),
                                      annotations=[ dict(
                                          text="Interactive network visualization",
                                          showarrow=False,
                                          xref="paper", yref="paper",
                                          x=0.005, y=-0.002,
                                          xanchor='left', yanchor='bottom',
                                          font=dict(color='gray', size=12)
                                      )],
                                      xaxis=dict(showgrid=False, zeroline=False, showticklabels=False),
                                      yaxis=dict(showgrid=False, zeroline=False, showticklabels=False)))
        
        return fig
    
    def bootstrap_analysis(self, network_name: str, n_bootstrap: int = 100, 
                          alpha: float = 0.05) -> dict:
        """
        Perform bootstrap analysis for network stability.
        
        Args:
            network_name: Name of the network to analyze
            n_bootstrap: Number of bootstrap samples
            alpha: Significance level
            
        Returns:
            Dictionary containing bootstrap results
        """
        if network_name not in self.networks:
            raise ValueError(f"Network '{network_name}' not found.")
        
        print(f"\nPerforming bootstrap analysis with {n_bootstrap} samples...")
        
        G = self.networks[network_name]['graph']
        variables = self.networks[network_name]['variables']
        method = self.networks[network_name]['method']
        
        # Get original data
        network_data = self.data_processed[variables].dropna()
        n_samples = len(network_data)
        
        # Bootstrap samples
        bootstrap_results = {
            'edge_stability': {},
            'centrality_stability': {},
            'network_properties': []
        }
        
        for i in range(n_bootstrap):
            if i % 20 == 0:
                print(f"  Bootstrap sample {i+1}/{n_bootstrap}")
            
            # Sample with replacement
            bootstrap_sample = network_data.sample(n=n_samples, replace=True)
            
            # Construct network
            if method == 'correlation':
                corr_matrix = bootstrap_sample.corr()
            else:
                # For partial correlation, use simplified approach
                corr_matrix = bootstrap_sample.corr()
            
            # Create bootstrap network
            G_bootstrap = nx.Graph()
            G_bootstrap.add_nodes_from(variables)
            
            for j in range(len(variables)):
                for k in range(j+1, len(variables)):
                    corr_val = corr_matrix.loc[variables[j], variables[k]]
                    if abs(corr_val) >= 0.1:  # Same threshold as original
                        G_bootstrap.add_edge(variables[j], variables[k], weight=corr_val)
            
            # Store edge stability
            for edge in G_bootstrap.edges():
                edge_key = tuple(sorted(edge))
                if edge_key not in bootstrap_results['edge_stability']:
                    bootstrap_results['edge_stability'][edge_key] = 0
                bootstrap_results['edge_stability'][edge_key] += 1
            
            # Calculate centrality measures for stability analysis
            try:
                centrality_measures = {
                    'degree': nx.degree_centrality(G_bootstrap),
                    'betweenness': nx.betweenness_centrality(G_bootstrap),
                    'closeness': nx.closeness_centrality(G_bootstrap)
                }
                
                # Store centrality stability (using degree centrality as primary measure)
                for node in G_bootstrap.nodes():
                    if node not in bootstrap_results['centrality_stability']:
                        bootstrap_results['centrality_stability'][node] = []
                    bootstrap_results['centrality_stability'][node].append(centrality_measures['degree'][node])
            except Exception as e:
                # If centrality calculation fails, skip it
                pass
            
            # Store network properties
            properties = {
                'density': nx.density(G_bootstrap),
                'average_clustering': nx.average_clustering(G_bootstrap),
                'transitivity': nx.transitivity(G_bootstrap)
            }
            bootstrap_results['network_properties'].append(properties)
        
        # Calculate stability percentages
        for edge_key in bootstrap_results['edge_stability']:
            bootstrap_results['edge_stability'][edge_key] /= n_bootstrap
        
        # Calculate confidence intervals for network properties
        properties_df = pd.DataFrame(bootstrap_results['network_properties'])
        confidence_intervals = {}
        for prop in properties_df.columns:
            ci_lower = np.percentile(properties_df[prop], (alpha/2) * 100)
            ci_upper = np.percentile(properties_df[prop], (1 - alpha/2) * 100)
            confidence_intervals[prop] = (ci_lower, ci_upper)
        
        bootstrap_results['confidence_intervals'] = confidence_intervals
        
        # Store results
        self.results[f"{network_name}_bootstrap"] = bootstrap_results
        
        print(f"Bootstrap analysis completed.")
        print(f"Edge stability range: {min(bootstrap_results['edge_stability'].values()):.3f} - {max(bootstrap_results['edge_stability'].values()):.3f}")
        
        return bootstrap_results
    
    def compare_networks(self, network1_name: str, network2_name: str) -> dict:
        """
        Compare two networks.
        
        Args:
            network1_name: Name of the first network
            network2_name: Name of the second network
            
        Returns:
            Dictionary containing comparison results
        """
        if network1_name not in self.networks or network2_name not in self.networks:
            raise ValueError("One or both networks not found.")
        
        print(f"\nComparing networks: {network1_name} vs {network2_name}")
        
        G1 = self.networks[network1_name]['graph']
        G2 = self.networks[network2_name]['graph']
        
        # Basic comparison
        comparison = {
            'network1': {
                'nodes': G1.number_of_nodes(),
                'edges': G1.number_of_edges(),
                'density': nx.density(G1),
                'average_clustering': nx.average_clustering(G1)
            },
            'network2': {
                'nodes': G2.number_of_nodes(),
                'edges': G2.number_of_edges(),
                'density': nx.density(G2),
                'average_clustering': nx.average_clustering(G2)
            }
        }
        
        # Edge overlap
        edges1 = set(G1.edges())
        edges2 = set(G2.edges())
        common_edges = edges1.intersection(edges2)
        all_edges = edges1.union(edges2)
        
        comparison['edge_overlap'] = {
            'common_edges': len(common_edges),
            'total_edges': len(all_edges),
            'jaccard_similarity': len(common_edges) / len(all_edges) if all_edges else 0
        }
        
        # Node overlap
        nodes1 = set(G1.nodes())
        nodes2 = set(G2.nodes())
        common_nodes = nodes1.intersection(nodes2)
        
        comparison['node_overlap'] = {
            'common_nodes': len(common_nodes),
            'total_nodes': len(nodes1.union(nodes2)),
            'jaccard_similarity': len(common_nodes) / len(nodes1.union(nodes2)) if nodes1.union(nodes2) else 0
        }
        
        # Store results
        comparison_name = f"{network1_name}_vs_{network2_name}"
        self.results[comparison_name] = comparison
        
        print(f"Network Comparison Results:")
        print(f"  Edge Jaccard Similarity: {comparison['edge_overlap']['jaccard_similarity']:.3f}")
        print(f"  Node Jaccard Similarity: {comparison['node_overlap']['jaccard_similarity']:.3f}")
        
        return comparison
    
    def generate_report(self, output_path: str = None) -> str:
        """
        Generate a comprehensive analysis report.
        
        Args:
            output_path: Path to save the report
            
        Returns:
            Report text
        """
        report = []
        report.append("="*80)
        report.append("PERSONALITY NETWORK ANALYSIS REPORT")
        report.append("="*80)
        report.append(f"Generated on: {pd.Timestamp.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append("")
        
        # Data summary
        if hasattr(self, 'data_processed'):
            report.append("DATA SUMMARY")
            report.append("-" * 40)
            report.append(f"Participants: {len(self.data_processed)}")
            report.append(f"Variables: {len(self.data_processed.columns)}")
            report.append(f"Missing values: {self.data_processed.isnull().sum().sum()}")
            report.append("")
        
        # Network summaries
        if self.networks:
            report.append("NETWORK SUMMARIES")
            report.append("-" * 40)
            for name, network_info in self.networks.items():
                G = network_info['graph']
                report.append(f"Network: {name}")
                report.append(f"  Nodes: {G.number_of_nodes()}")
                report.append(f"  Edges: {G.number_of_edges()}")
                report.append(f"  Density: {nx.density(G):.3f}")
                report.append(f"  Average Clustering: {nx.average_clustering(G):.3f}")
                report.append("")
        
        # Analysis results
        if self.results:
            report.append("ANALYSIS RESULTS")
            report.append("-" * 40)
            for name, result in self.results.items():
                if 'properties' in result:
                    report.append(f"Network Properties: {name}")
                    for prop, value in result['properties'].items():
                        if value is not None:
                            report.append(f"  {prop}: {value:.3f}")
                    report.append("")
        
        report_text = "\n".join(report)
        
        if output_path:
            with open(output_path, 'w') as f:
                f.write(report_text)
            print(f"Report saved to {output_path}")
        
        return report_text


def main():
    """
    Main function to demonstrate the network analysis capabilities.
    """
    print("Personality Network Analysis Application")
    print("=" * 50)
    
    # Initialize analyzer
    analyzer = PersonalityNetworkAnalyzer()
    
    # Load data
    try:
        analyzer.load_data('data/NEO_IPIP_1.csv')
    except Exception as e:
        print(f"Error loading data: {e}")
        print("Please ensure the data file exists at 'data/NEO_IPIP_1.csv'")
        return
    
    # Preprocess data
    analyzer.preprocess_data(method='complete', scale=True)
    
    # Define variable sets for different analyses
    neo_vars = [col for col in analyzer.data_processed.columns 
                if col.startswith(('N', 'E', 'O', 'A', 'C')) and len(col) <= 2]
    
    ipip_vars = [col for col in analyzer.data_processed.columns 
                 if col.startswith(('I', 'a', 'b', 'c', 'd', 'e', 'h', 'm', 'n', 'p', 'q', 'r', 's', 'v', 'x'))]
    
    # Limit to manageable number of variables for demonstration
    if len(neo_vars) > 20:
        neo_vars = neo_vars[:20]
    if len(ipip_vars) > 20:
        ipip_vars = ipip_vars[:20]
    
    print(f"\nSelected {len(neo_vars)} NEO variables and {len(ipip_vars)} IPIP variables for analysis")
    
    # Construct networks
    if neo_vars:
        print("\nConstructing NEO network...")
        neo_network = analyzer.construct_network(neo_vars, method='correlation')
        analyzer.analyze_network_properties('correlation_20vars')
        analyzer.visualize_network('correlation_20vars')
    
    if ipip_vars:
        print("\nConstructing IPIP network...")
        ipip_network = analyzer.construct_network(ipip_vars, method='correlation')
        analyzer.analyze_network_properties('correlation_20vars')
    
    # Generate report
    report = analyzer.generate_report('network_analysis_report.txt')
    print("\nAnalysis completed! Check the generated report for detailed results.")


if __name__ == "__main__":
    main()
