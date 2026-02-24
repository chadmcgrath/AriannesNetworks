#!/usr/bin/env python3
"""
Utility functions for personality network analysis.

This module contains helper functions and utilities for data processing,
statistical analysis, and visualization in the context of personality
network research.
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from scipy.spatial.distance import pdist, squareform
from sklearn.metrics import adjusted_rand_score, normalized_mutual_info_score
from typing import List, Dict, Tuple, Optional, Union
import warnings
warnings.filterwarnings('ignore')


def calculate_correlation_stability(corr_matrices: List[pd.DataFrame], 
                                  threshold: float = 0.1) -> Dict[str, float]:
    """
    Calculate stability of correlations across multiple samples.
    
    Args:
        corr_matrices: List of correlation matrices
        threshold: Minimum correlation threshold for stability calculation
        
    Returns:
        Dictionary containing stability metrics
    """
    if len(corr_matrices) < 2:
        raise ValueError("At least 2 correlation matrices required")
    
    # Get common variables
    common_vars = set(corr_matrices[0].columns)
    for matrix in corr_matrices[1:]:
        common_vars = common_vars.intersection(set(matrix.columns))
    
    common_vars = sorted(list(common_vars))
    
    # Extract correlations for common variables
    correlations = []
    for matrix in corr_matrices:
        corr_values = []
        for i in range(len(common_vars)):
            for j in range(i+1, len(common_vars)):
                corr_val = matrix.loc[common_vars[i], common_vars[j]]
                if abs(corr_val) >= threshold:
                    corr_values.append(corr_val)
        correlations.append(corr_values)
    
    # Calculate stability metrics
    correlations_array = np.array(correlations)
    
    stability_metrics = {
        'mean_correlation': np.mean(correlations_array),
        'std_correlation': np.std(correlations_array),
        'correlation_stability': 1 - np.std(correlations_array) / (np.mean(np.abs(correlations_array)) + 1e-8),
        'n_stable_edges': np.sum(np.std(correlations_array, axis=0) < 0.1),
        'total_edges': correlations_array.shape[1]
    }
    
    return stability_metrics


def perform_permutation_test(observed_stat: float, null_distribution: np.ndarray, 
                           alternative: str = 'two-sided') -> Tuple[float, float]:
    """
    Perform permutation test for statistical significance.
    
    Args:
        observed_stat: Observed test statistic
        null_distribution: Array of null distribution values
        alternative: Type of test ('two-sided', 'greater', 'less')
        
    Returns:
        Tuple of (p-value, effect size)
    """
    n_permutations = len(null_distribution)
    
    if alternative == 'two-sided':
        p_value = np.mean(np.abs(null_distribution) >= np.abs(observed_stat))
    elif alternative == 'greater':
        p_value = np.mean(null_distribution >= observed_stat)
    elif alternative == 'less':
        p_value = np.mean(null_distribution <= observed_stat)
    else:
        raise ValueError("Alternative must be 'two-sided', 'greater', or 'less'")
    
    # Effect size (Cohen's d)
    effect_size = (observed_stat - np.mean(null_distribution)) / np.std(null_distribution)
    
    return p_value, effect_size


def calculate_network_similarity(network1_edges: set, network2_edges: set) -> Dict[str, float]:
    """
    Calculate similarity between two networks.
    
    Args:
        network1_edges: Set of edges from first network
        network2_edges: Set of edges from second network
        
    Returns:
        Dictionary containing similarity metrics
    """
    # Jaccard similarity
    intersection = network1_edges.intersection(network2_edges)
    union = network1_edges.union(network2_edges)
    jaccard_similarity = len(intersection) / len(union) if union else 0
    
    # Overlap coefficient
    overlap_coefficient = len(intersection) / min(len(network1_edges), len(network2_edges)) if min(len(network1_edges), len(network2_edges)) > 0 else 0
    
    # Dice coefficient
    dice_coefficient = 2 * len(intersection) / (len(network1_edges) + len(network2_edges)) if (len(network1_edges) + len(network2_edges)) > 0 else 0
    
    similarity_metrics = {
        'jaccard_similarity': jaccard_similarity,
        'overlap_coefficient': overlap_coefficient,
        'dice_coefficient': dice_coefficient,
        'common_edges': len(intersection),
        'total_edges_network1': len(network1_edges),
        'total_edges_network2': len(network2_edges)
    }
    
    return similarity_metrics


def create_heatmap_plot(data: pd.DataFrame, title: str = "Correlation Matrix", 
                       figsize: Tuple[int, int] = (10, 8), 
                       save_path: Optional[str] = None) -> plt.Figure:
    """
    Create a correlation heatmap plot.
    
    Args:
        data: DataFrame containing correlation matrix
        title: Title for the plot
        figsize: Figure size
        save_path: Path to save the figure
        
    Returns:
        Matplotlib figure object
    """
    fig, ax = plt.subplots(figsize=figsize)
    
    # Create heatmap
    mask = np.triu(np.ones_like(data, dtype=bool))
    sns.heatmap(data, mask=mask, annot=True, cmap='RdBu_r', center=0,
                square=True, linewidths=0.5, cbar_kws={"shrink": 0.8},
                fmt='.2f', ax=ax)
    
    ax.set_title(title, fontsize=14, fontweight='bold')
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
        print(f"Heatmap saved to {save_path}")
    
    return fig


def create_centrality_plot(centrality_data: pd.DataFrame, 
                          title: str = "Centrality Measures Comparison",
                          figsize: Tuple[int, int] = (12, 8),
                          save_path: Optional[str] = None) -> plt.Figure:
    """
    Create a plot comparing centrality measures.
    
    Args:
        centrality_data: DataFrame containing centrality measures
        title: Title for the plot
        figsize: Figure size
        save_path: Path to save the figure
        
    Returns:
        Matplotlib figure object
    """
    fig, axes = plt.subplots(2, 2, figsize=figsize)
    axes = axes.ravel()
    
    centrality_measures = ['degree', 'betweenness', 'closeness', 'eigenvector']
    
    for i, measure in enumerate(centrality_measures):
        if measure in centrality_data.columns:
            # Sort by centrality value
            sorted_data = centrality_data.sort_values(measure, ascending=True)
            
            # Plot top 15 nodes
            top_nodes = sorted_data.tail(15)
            
            axes[i].barh(range(len(top_nodes)), top_nodes[measure])
            axes[i].set_yticks(range(len(top_nodes)))
            axes[i].set_yticklabels(top_nodes.index, fontsize=8)
            axes[i].set_xlabel(measure.capitalize())
            axes[i].set_title(f'Top 15 Nodes by {measure.capitalize()}')
            axes[i].grid(True, alpha=0.3)
    
    plt.suptitle(title, fontsize=16, fontweight='bold')
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
        print(f"Centrality plot saved to {save_path}")
    
    return fig


def calculate_effect_sizes(group1: np.ndarray, group2: np.ndarray) -> Dict[str, float]:
    """
    Calculate various effect size measures between two groups.
    
    Args:
        group1: First group data
        group2: Second group data
        
    Returns:
        Dictionary containing effect size measures
    """
    # Cohen's d
    pooled_std = np.sqrt(((len(group1) - 1) * np.var(group1, ddof=1) + 
                         (len(group2) - 1) * np.var(group2, ddof=1)) / 
                        (len(group1) + len(group2) - 2))
    cohens_d = (np.mean(group1) - np.mean(group2)) / pooled_std
    
    # Hedges' g (bias-corrected Cohen's d)
    correction_factor = 1 - (3 / (4 * (len(group1) + len(group2)) - 9))
    hedges_g = cohens_d * correction_factor
    
    # Glass's delta
    glass_delta = (np.mean(group1) - np.mean(group2)) / np.std(group2, ddof=1)
    
    # Common Language Effect Size (CLES)
    # Probability that a randomly selected value from group1 is greater than group2
    cles = np.mean([np.mean(x > group2) for x in group1])
    
    effect_sizes = {
        'cohens_d': cohens_d,
        'hedges_g': hedges_g,
        'glass_delta': glass_delta,
        'cles': cles
    }
    
    return effect_sizes


def create_bootstrap_plot(bootstrap_results: Dict, 
                         title: str = "Bootstrap Analysis Results",
                         figsize: Tuple[int, int] = (12, 8),
                         save_path: Optional[str] = None) -> plt.Figure:
    """
    Create plots for bootstrap analysis results.
    
    Args:
        bootstrap_results: Dictionary containing bootstrap results
        title: Title for the plot
        figsize: Figure size
        save_path: Path to save the figure
        
    Returns:
        Matplotlib figure object
    """
    fig, axes = plt.subplots(2, 2, figsize=figsize)
    axes = axes.ravel()
    
    # Edge stability distribution
    if 'edge_stability' in bootstrap_results:
        edge_stabilities = list(bootstrap_results['edge_stability'].values())
        axes[0].hist(edge_stabilities, bins=20, alpha=0.7, color='skyblue', edgecolor='black')
        axes[0].set_xlabel('Edge Stability')
        axes[0].set_ylabel('Frequency')
        axes[0].set_title('Edge Stability Distribution')
        axes[0].grid(True, alpha=0.3)
    
    # Network properties over bootstrap samples
    if 'network_properties' in bootstrap_results:
        properties_df = pd.DataFrame(bootstrap_results['network_properties'])
        
        for i, prop in enumerate(['density', 'average_clustering', 'transitivity']):
            if prop in properties_df.columns and i < 3:
                axes[i+1].hist(properties_df[prop], bins=20, alpha=0.7, 
                              color=['lightcoral', 'lightgreen', 'lightyellow'][i], 
                              edgecolor='black')
                axes[i+1].set_xlabel(prop.replace('_', ' ').title())
                axes[i+1].set_ylabel('Frequency')
                axes[i+1].set_title(f'{prop.replace("_", " ").title()} Distribution')
                axes[i+1].grid(True, alpha=0.3)
    
    plt.suptitle(title, fontsize=16, fontweight='bold')
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
        print(f"Bootstrap plot saved to {save_path}")
    
    return fig


def validate_data_quality(data: pd.DataFrame, 
                         min_completeness: float = 0.8) -> Dict[str, Union[bool, float, int]]:
    """
    Validate data quality for network analysis.
    
    Args:
        data: DataFrame to validate
        min_completeness: Minimum completeness threshold
        
    Returns:
        Dictionary containing validation results
    """
    n_participants, n_variables = data.shape
    
    # Calculate completeness
    completeness = 1 - (data.isnull().sum().sum() / (n_participants * n_variables))
    
    # Check for constant variables
    constant_vars = (data.nunique() == 1).sum()
    
    # Check for highly correlated variables (potential duplicates)
    numeric_data = data.select_dtypes(include=[np.number])
    if len(numeric_data.columns) > 1:
        corr_matrix = numeric_data.corr()
        high_corr_pairs = np.sum(np.abs(corr_matrix.values) > 0.95) - len(corr_matrix.columns)
    else:
        high_corr_pairs = 0
    
    # Check for outliers (using IQR method)
    outlier_count = 0
    for col in numeric_data.columns:
        Q1 = numeric_data[col].quantile(0.25)
        Q3 = numeric_data[col].quantile(0.75)
        IQR = Q3 - Q1
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR
        outliers = ((numeric_data[col] < lower_bound) | (numeric_data[col] > upper_bound)).sum()
        outlier_count += outliers
    
    validation_results = {
        'is_valid': completeness >= min_completeness and constant_vars == 0,
        'completeness': completeness,
        'n_participants': n_participants,
        'n_variables': n_variables,
        'constant_variables': constant_vars,
        'highly_correlated_pairs': high_corr_pairs,
        'total_outliers': outlier_count,
        'outlier_percentage': (outlier_count / (n_participants * len(numeric_data.columns))) * 100
    }
    
    return validation_results


def create_summary_statistics(data: pd.DataFrame) -> pd.DataFrame:
    """
    Create comprehensive summary statistics for the dataset.
    
    Args:
        data: DataFrame to analyze
        
    Returns:
        DataFrame containing summary statistics
    """
    numeric_data = data.select_dtypes(include=[np.number])
    
    summary_stats = pd.DataFrame({
        'count': numeric_data.count(),
        'mean': numeric_data.mean(),
        'std': numeric_data.std(),
        'min': numeric_data.min(),
        '25%': numeric_data.quantile(0.25),
        '50%': numeric_data.median(),
        '75%': numeric_data.quantile(0.75),
        'max': numeric_data.max(),
        'skewness': numeric_data.skew(),
        'kurtosis': numeric_data.kurtosis(),
        'missing': numeric_data.isnull().sum(),
        'missing_pct': (numeric_data.isnull().sum() / len(numeric_data)) * 100
    })
    
    return summary_stats


def export_results_to_excel(results: Dict, filename: str) -> None:
    """
    Export analysis results to Excel file with multiple sheets.
    
    Args:
        results: Dictionary containing results to export
        filename: Output filename
    """
    with pd.ExcelWriter(filename, engine='openpyxl') as writer:
        for sheet_name, data in results.items():
            if isinstance(data, pd.DataFrame):
                data.to_excel(writer, sheet_name=sheet_name)
            elif isinstance(data, dict):
                # Convert dictionary to DataFrame
                df = pd.DataFrame([data])
                df.to_excel(writer, sheet_name=sheet_name, index=False)
            else:
                # Convert other data types to string and create DataFrame
                df = pd.DataFrame({'Value': [str(data)]})
                df.to_excel(writer, sheet_name=sheet_name, index=False)
    
    print(f"Results exported to {filename}")


# Example usage and testing functions
def run_example_analysis():
    """Run example analysis to demonstrate utility functions."""
    print("Running example analysis with utility functions...")
    
    # Create sample data
    np.random.seed(42)
    n_participants = 100
    n_variables = 10
    
    # Generate correlated data
    base_data = np.random.randn(n_participants, n_variables)
    correlation_structure = np.random.randn(n_variables, n_variables)
    correlation_structure = correlation_structure @ correlation_structure.T
    correlation_structure = correlation_structure / np.sqrt(np.diag(correlation_structure))
    
    data = base_data @ correlation_structure
    data = pd.DataFrame(data, columns=[f'Var_{i+1}' for i in range(n_variables)])
    
    # Validate data quality
    validation = validate_data_quality(data)
    print(f"Data validation: {validation}")
    
    # Create summary statistics
    summary = create_summary_statistics(data)
    print(f"Summary statistics shape: {summary.shape}")
    
    # Calculate correlation matrix
    corr_matrix = data.corr()
    
    # Create heatmap
    fig = create_heatmap_plot(corr_matrix, title="Example Correlation Matrix")
    plt.show()
    
    print("Example analysis completed!")


if __name__ == "__main__":
    run_example_analysis()
