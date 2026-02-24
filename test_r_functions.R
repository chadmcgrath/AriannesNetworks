# Test R functions to get key results
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

# Load the data
setwd('data')
data <- read.csv('NEO_IPIP_1.csv')

# Load functions
source('../r_scripts/NEO & IPIP - P0 - all functions.R')

# Test with a small sample to see if we can get results
# Let's try to run just one simulation to see what happens
set.seed(123)

# Create a small test
n_test <- 100  # Small sample for testing
test_data <- data[1:n_test, ]

# Try to run netcompare_func with small data
# This should give us an idea of what the function returns
cat("Testing netcompare_func with small sample...\n")

# We need to create the N.list structure first
# Let's try to understand what the function expects
cat("Data dimensions:", dim(test_data), "\n")
cat("Column names (first 10):", colnames(test_data)[1:10], "\n")

# Try to find NEO and IPIP columns
neo_cols <- grep("^[NEOAC][0-9]", colnames(test_data), value=TRUE)
ipip_cols <- grep("^[a-z][0-9]", colnames(test_data), value=TRUE)

cat("NEO columns found:", length(neo_cols), "\n")
cat("IPIP columns found:", length(ipip_cols), "\n")

# Let's try to create a simple test
if(length(neo_cols) > 0 && length(ipip_cols) > 0) {
  # Create simple test data
  neo_data <- test_data[, neo_cols[1:min(6, length(neo_cols))]]
  ipip_data <- test_data[, ipip_cols[1:min(6, length(ipip_cols))]]
  
  # Remove missing values
  neo_data <- na.omit(neo_data)
  ipip_data <- na.omit(ipip_data)
  
  cat("NEO data dimensions:", dim(neo_data), "\n")
  cat("IPIP data dimensions:", dim(ipip_data), "\n")
  
  # Try to run a simple network comparison
  if(nrow(neo_data) > 10 && nrow(ipip_data) > 10) {
    cat("Attempting network comparison...\n")
    
    # Try to run netcompare_func
    tryCatch({
      result <- netcompare_func(neo_data, ipip_data)
      cat("Success! Result structure:\n")
      print(str(result))
      cat("Key values:\n")
      if(!is.null(result$glstrinv.real)) cat("glstrinv.real:", result$glstrinv.real, "\n")
      if(!is.null(result$einv.real)) cat("einv.real:", result$einv.real, "\n")
      if(!is.null(result$diffcen.real)) cat("diffcen.real:", result$diffcen.real, "\n")
    }, error = function(e) {
      cat("Error in netcompare_func:", e$message, "\n")
    })
  }
}

cat("Test completed.\n")





