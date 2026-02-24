# Try to extract results from existing RData files
library(qgraph)
library(bootnet)
library(dplyr)
library(psych)
library(ppcor)
library(RColorBrewer)
library(reshape2)
library(BDgraph)
library(rlist)
library(coefficientalpha)
library(NetworkComparisonTest)

# Load functions
source('r_scripts/NEO & IPIP - P0 - all functions.R')

# Try to load the results files
cat("Attempting to load results files...\n")

# Try to load the Neuroticism results
tryCatch({
  load('data/NEO & IPIP - P3_nSim50_results_all_N.RData')
  cat("Successfully loaded Neuroticism results\n")
  cat("Objects in environment:\n")
  print(ls())
  
  # Look for the key result objects
  if(exists('output1_N_DD_avg.glstr')) {
    cat("Found output1_N_DD_avg.glstr\n")
    print(str(output1_N_DD_avg.glstr))
    
    # Try to extract key results
    if(is.data.frame(output1_N_DD_avg.glstr)) {
      cat("Data frame dimensions:", dim(output1_N_DD_avg.glstr), "\n")
      cat("Column names:", colnames(output1_N_DD_avg.glstr), "\n")
      
      # Look for the key conditions
      if('N_0.5_1' %in% rownames(output1_N_DD_avg.glstr)) {
        cat("Found N_0.5_1 condition\n")
        result_051 <- output1_N_DD_avg.glstr['N_0.5_1', ]
        print(result_051)
      }
      
      if('N_0.5_3' %in% rownames(output1_N_DD_avg.glstr)) {
        cat("Found N_0.5_3 condition\n")
        result_053 <- output1_N_DD_avg.glstr['N_0.5_3', ]
        print(result_053)
      }
      
      if('N_0.5_8' %in% rownames(output1_N_DD_avg.glstr)) {
        cat("Found N_0.5_8 condition\n")
        result_058 <- output1_N_DD_avg.glstr['N_0.5_8', ]
        print(result_058)
      }
    }
  }
  
}, error = function(e) {
  cat("Error loading Neuroticism results:", e$message, "\n")
})

# Try to load the Agreeableness results
tryCatch({
  load('data/NEO & IPIP - P3_nSim50_results_all_A.RData')
  cat("Successfully loaded Agreeableness results\n")
  cat("Objects in environment:\n")
  print(ls())
  
  # Look for the key result objects
  if(exists('output1_A_DD_avg.glstr')) {
    cat("Found output1_A_DD_avg.glstr\n")
    print(str(output1_A_DD_avg.glstr))
    
    # Try to extract key results
    if(is.data.frame(output1_A_DD_avg.glstr)) {
      cat("Data frame dimensions:", dim(output1_A_DD_avg.glstr), "\n")
      cat("Column names:", colnames(output1_A_DD_avg.glstr), "\n")
      
      # Look for the key conditions
      if('A_0.5_1' %in% rownames(output1_A_DD_avg.glstr)) {
        cat("Found A_0.5_1 condition\n")
        result_051 <- output1_A_DD_avg.glstr['A_0.5_1', ]
        print(result_051)
      }
      
      if('A_0.5_3' %in% rownames(output1_A_DD_avg.glstr)) {
        cat("Found A_0.5_3 condition\n")
        result_053 <- output1_A_DD_avg.glstr['A_0.5_3', ]
        print(result_053)
      }
      
      if('A_0.5_8' %in% rownames(output1_A_DD_avg.glstr)) {
        cat("Found A_0.5_8 condition\n")
        result_058 <- output1_A_DD_avg.glstr['A_0.5_8', ]
        print(result_058)
      }
    }
  }
  
}, error = function(e) {
  cat("Error loading Agreeableness results:", e$message, "\n")
})

cat("Extraction completed.\n")





