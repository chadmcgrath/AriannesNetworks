# Check the detailed structure of OSF results files

cat("Checking Agreeableness results structure...\n")
load("original files/Syntax (Agreeableness networks)/NEO & IPIP - P3_nSim50_results_all_A.RData")

cat("\nAll objects:\n")
all_objs <- ls()
print(all_objs[1:20])  # First 20 objects

# Look for netcompare lists
netcompare_objs <- all_objs[grepl("netcompare", all_objs, ignore.case = TRUE)]
cat("\nNetcompare objects:\n")
print(netcompare_objs[1:10])

# Check structure of first netcompare object
if (length(netcompare_objs) > 0) {
  first_obj <- get(netcompare_objs[1])
  cat("\nStructure of", netcompare_objs[1], ":\n")
  print(str(first_obj, max.level = 2))
  
  # Check if it's a list and what's inside
  if (is.list(first_obj) && length(first_obj) > 0) {
    cat("\nFirst element structure:\n")
    print(str(first_obj[[1]], max.level = 1))
  }
}

# Look for output objects
output_objs <- all_objs[grepl("output", all_objs, ignore.case = TRUE)]
cat("\nOutput objects:\n")
print(output_objs)

if (length(output_objs) > 0) {
  first_output <- get(output_objs[1])
  cat("\nStructure of", output_objs[1], ":\n")
  print(str(first_output, max.level = 2))
  
  if (is.data.frame(first_output)) {
    cat("\nRow names:\n")
    print(head(rownames(first_output), 20))
    cat("\nColumn names:\n")
    print(colnames(first_output))
  }
}

rm(list = ls())

cat("\n\nChecking Neuroticism results structure...\n")
load("original files/Syntax (Neuroticism networks)/NEO & IPIP - P3_nSim50_results_all_N.RData")

cat("\nAll objects:\n")
all_objs <- ls()
print(all_objs[1:20])

# Look for output objects
output_objs <- all_objs[grepl("output", all_objs, ignore.case = TRUE)]
cat("\nOutput objects:\n")
print(output_objs)

if (length(output_objs) > 0) {
  first_output <- get(output_objs[1])
  cat("\nStructure of", output_objs[1], ":\n")
  print(str(first_output, max.level = 2))
  
  if (is.data.frame(first_output)) {
    cat("\nRow names:\n")
    print(head(rownames(first_output), 20))
    cat("\nColumn names:\n")
    print(colnames(first_output))
  }
}

