# AriannesNetworks - Personality Network Analysis

A Python application for analyzing personality networks using the NEO-IPIP dataset, based on the research by Herrera-Bennett & Rhemtulla (2021).

## 🚀 Quick Start

### 1. Setup Environment
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Run the GUI Application
```bash
# Simple GUI (Recommended)
python simple_working_gui.py

# Or use the launcher
python launch_simple_gui.py
```

## 📊 What It Does

The application performs network analysis on personality data:

1. **Loads Data**: Reads the NEO-IPIP dataset (857 participants, 2815 variables)
2. **Preprocesses Data**: Handles missing values and standardizes variables
3. **Constructs Networks**: Creates correlation-based networks for NEO and IPIP variables
4. **Analyzes Properties**: Calculates network metrics (density, clustering, centrality)
5. **Visualizes Results**: Displays network graphs and analysis results

## 🎯 GUI Features

- **Data Summary**: Dataset information and variable categorization
- **Network Properties**: Network metrics and statistics
- **Centrality Measures**: Most important nodes in each network
- **Visualizations**: Interactive network graphs
- **Research Findings**: Demonstrates key research conclusions about network replicability and generalizability

## 📁 Project Structure

```
AriannesNetworks/
├── data/                    # Dataset files
│   └── NEO_IPIP_1.csv      # Main dataset
├── src/                     # Source code
│   ├── network_analysis.py  # Core analysis engine
│   ├── research_findings.py # Research findings demonstration
│   ├── main.py             # Command-line interface
│   └── utils.py            # Utility functions
├── simple_working_gui.py   # Main GUI application
├── launch_simple_gui.py    # GUI launcher
├── demonstrate_findings.py # Research findings demonstration script
├── requirements.txt        # Python dependencies
└── README.md              # This file
```

## 🔬 Research Background

This project replicates the network analysis methodology from:
- **Paper**: Herrera-Bennett & Rhemtulla (2021) - "Network replicability & generalizability"
- **Dataset**: NEO-IPIP personality inventory data
- **Method**: Correlation-based network analysis with bootstrap validation

## 📋 Requirements

- Python 3.8+
- Required packages (see `requirements.txt`):
  - numpy, pandas, scipy, scikit-learn
  - matplotlib, seaborn, plotly
  - networkx
  - tkinter (usually included with Python)

## 🎮 Usage

1. **Launch GUI**: Run `python simple_working_gui.py`
2. **Load Data**: Click "📊 Load Data" (defaults to `data/NEO_IPIP_1.csv`)
3. **Run Analysis**: Click "🚀 Run Analysis"
4. **View Results**: Check the tabs for:
   - Data summary and variable counts
   - Network properties and metrics
   - Centrality measures for important nodes
   - Network visualizations
   - **Research findings** demonstrating key conclusions about network replicability and generalizability

### Research Findings Demonstration

Run the research findings script to see the key conclusions:
```bash
python demonstrate_findings.py
```

This demonstrates:
- **Sample Size Effects**: How larger samples provide 2.5x better network accuracy
- **Scale Differences**: How NEO and IPIP measures produce different network structures
- **Replicability Concerns**: How networks show stability issues across samples
- **Generalizability Issues**: How networks don't transfer well between different measures

## 🧪 Command Line Usage

```bash
# Run analysis from command line
python src/main.py

# Run with specific parameters
python src/main.py --data data/NEO_IPIP_1.csv --method correlation
```

## 📊 Output

The analysis produces:
- **Network Properties**: Nodes, edges, density, clustering, path length
- **Centrality Measures**: Degree, betweenness, closeness centrality
- **Visualizations**: Network graphs showing variable relationships
- **Statistical Results**: Bootstrap confidence intervals and comparisons

## 🔧 Development

To extend or modify the analysis:

1. **Core Logic**: Edit `src/network_analysis.py`
2. **GUI Interface**: Modify `simple_working_gui.py`
3. **Command Line**: Update `src/main.py`
4. **Utilities**: Add functions to `src/utils.py`

## 📚 Documentation

- **Research Paper**: `docs/` folder contains the original research
- **Dataset Info**: See data loading and preprocessing in `network_analysis.py`
- **Method Details**: Network construction and analysis methods documented in code

## 🐛 Troubleshooting

**Common Issues:**
- **Data not found**: Ensure `data/NEO_IPIP_1.csv` exists
- **Import errors**: Check virtual environment is activated
- **GUI issues**: Try running `python launch_simple_gui.py` instead

**Performance:**
- Analysis may take 30-60 seconds for full dataset
- Memory usage: ~100MB for dataset + analysis
- Network visualization may be slow for large networks

## 📄 License

This project is for educational and research purposes, based on the original research by Herrera-Bennett & Rhemtulla (2021).