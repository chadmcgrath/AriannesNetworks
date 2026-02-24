#!/usr/bin/env r
# R script to install required packages for network analysis

# List of required packages
required_packages <- c(
  # Core network analysis packages
  "qgraph",
  "bootnet", 
  "mgm",
  
  # Data manipulation and analysis
  "dplyr",
  "tidyverse",
  "psych",
  "corrplot",
  
  # Visualization
  "ggplot2",
  "igraph",
  "RColorBrewer",
  
  # Statistical analysis
  "MASS",
  "Matrix",
  "corpcor",
  
  # Additional utilities
  "parallel",
  "doParallel",
  "foreach"
)

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      cat("Installing package:", pkg, "\n")
      install.packages(pkg, dependencies = TRUE)
    } else {
      cat("Package", pkg, "is already installed\n")
    }
  }
}

# Install packages
cat("Installing required R packages for network analysis...\n")
install_if_missing(required_packages)

cat("All required packages have been installed!\n")
cat("You can now run the network analysis scripts.\n")
