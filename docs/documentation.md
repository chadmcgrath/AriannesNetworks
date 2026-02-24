# Network Replicability & Generalizability Research

## Project Overview

This repository contains the research materials and code for the study "Network replicability & generalizability" by Herrera-Bennett & Rhemtulla (2021). The project examines network analysis methodologies for personality traits, specifically focusing on Agreeableness and Neuroticism networks using NEO and IPIP personality inventories.

## Source

This project is based on the Open Science Framework (OSF) repository: [https://osf.io/m37q2/files/osfstorage](https://osf.io/m37q2/files/osfstorage)

## Project Structure

```
ariannes-networks/
├── src/                    # R scripts for analysis
│   ├── NEO & IPIP - P0 - all functions.R
│   ├── NEO & IPIP - P1 - data pre-processing & whole-sample_NEOCA.R
│   ├── NEO & IPIP - P1 - data pre-processing & whole-sample_N.R
│   ├── NEO & IPIP - P2 - resampling_A.R
│   ├── NEO & IPIP - P2 - resampling_N.R
│   ├── NEO & IPIP - P3 - netcompare & analysis_A.R
│   ├── NEO & IPIP - P3 - netcompare & analysis_N.R
│   └── NEO & IPIP - Extra.R
├── data/                   # Data files and RData objects
│   ├── NEO_IPIP_1.csv
│   ├── NEO & IPIP - P0_functions.RData
│   ├── NEO & IPIP - P1_nSim50_data_A.RData
│   ├── NEO & IPIP - P1_nSim50_data_NEOCA.RData
│   ├── NEO & IPIP - P1_nSim50_data_N.RData
│   ├── NEO & IPIP - P2_nSim50_data_A.RData
│   ├── NEO & IPIP - P2_nSim50_data_N.RData
│   ├── NEO & IPIP - P3_nSim50_data_all_A.RData
│   ├── NEO & IPIP - P3_nSim50_data_all_N.RData
│   ├── NEO & IPIP - P3_nSim50_results_all_A.RData
│   └── NEO & IPIP - P3_nSim50_results_all_N.RData
├── figures/                # Research figures and plots
│   ├── Fig4_N.png
│   ├── Fig5_N.png
│   ├── Fig6_N.png
│   ├── Fig7_N.png
│   ├── Fig8_N.png
│   ├── FigA1_A.png
│   ├── FigA5_A.png
│   ├── FigR2_N.png
│   ├── FigR3_N.png
│   └── FigS2_N.png
├── docs/                   # Documentation
│   ├── documentation.md
│   └── Herrera-Bennett & Rhemtulla [2021, preprint] - Network replicability & generalizability_Supplementary_R1.pdf
├── tests/                  # Test files
├── scripts/                # Utility scripts
└── README.md              # Project overview
```

## Research Components

### 1. Data Processing (P1)
- **NEOCA Analysis**: `NEO & IPIP - P1 - data pre-processing & whole-sample_NEOCA.R`
- **Neuroticism Analysis**: `NEO & IPIP - P1 - data pre-processing & whole-sample_N.R`

### 2. Resampling Analysis (P2)
- **Agreeableness Networks**: `NEO & IPIP - P2 - resampling_A.R`
- **Neuroticism Networks**: `NEO & IPIP - P2 - resampling_N.R`

### 3. Network Comparison & Analysis (P3)
- **Agreeableness Networks**: `NEO & IPIP - P3 - netcompare & analysis_A.R`
- **Neuroticism Networks**: `NEO & IPIP - P3 - netcompare & analysis_N.R`

### 4. Core Functions
- **All Functions**: `NEO & IPIP - P0 - all functions.R`
- **Extra Analysis**: `NEO & IPIP - Extra.R`

## Data Files

### Primary Dataset
- `NEO_IPIP_1.csv`: Main dataset containing NEO and IPIP personality inventory responses

### Processed Data Objects
- **P1 Data**: Pre-processed datasets for each analysis
- **P2 Data**: Resampling results (nSim50 = 50 simulations)
- **P3 Data**: Network comparison results and analysis outputs

## Figures

The figures directory contains visualizations from the research:
- **Fig4-8_N.png**: Main neuroticism network figures
- **FigA1_A.png, FigA5_A.png**: Agreeableness network figures
- **FigR2_N.png, FigR3_N.png**: Replicability figures
- **FigS2_N.png**: Supplementary figure

## Methodology

This research employs network analysis techniques to examine:
1. **Personality Network Structure**: Using NEO and IPIP personality inventories
2. **Replicability**: Testing network stability across different samples
3. **Generalizability**: Comparing networks across different personality measures
4. **Resampling Analysis**: Bootstrap and permutation methods for network validation

## Dependencies

The R scripts require the following packages (inferred from the analysis):
- Network analysis packages (likely `qgraph`, `bootnet`, `mgm`)
- Data manipulation packages (`dplyr`, `tidyverse`)
- Statistical packages (`psych`, `corrplot`)
- Visualization packages (`ggplot2`, `igraph`)

## Usage

1. **Setup**: Install required R packages
2. **Data Preparation**: Run P1 scripts for data preprocessing
3. **Resampling**: Execute P2 scripts for network resampling analysis
4. **Analysis**: Run P3 scripts for network comparison and analysis
5. **Visualization**: Generate figures using the analysis outputs

## Citation

Herrera-Bennett, A., & Rhemtulla, M. (2021). Network replicability & generalizability. *Preprint*. Retrieved from [https://osf.io/m37q2](https://osf.io/m37q2)

## License

This research is made available under the terms specified in the original OSF repository.

## Contact

For questions about this research, please refer to the original OSF repository or contact the authors.
