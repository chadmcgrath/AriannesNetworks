# Check what objects exist in the OSF results files

cat("========================================\n")
cat("CHECKING OBJECTS IN OSF RESULTS FILES\n")
cat("========================================\n\n")

# Check Agreeableness results
cat("AGREEABLENESS (A) RESULTS:\n")
cat("File: original files/Syntax (Agreeableness networks)/NEO & IPIP - P3_nSim50_results_all_A.RData\n")
load("original files/Syntax (Agreeableness networks)/NEO & IPIP - P3_nSim50_results_all_A.RData")
cat("\nObjects in environment:\n")
all_objects <- ls()
print(all_objects)

# Look for output objects
output_objects <- all_objects[grepl("output", all_objects, ignore.case = TRUE)]
cat("\nOutput objects found:\n")
print(output_objects)

# Check structure of first output object if exists
if (length(output_objects) > 0) {
  first_obj <- get(output_objects[1])
  cat("\nStructure of", output_objects[1], ":\n")
  print(str(first_obj))
  if (is.data.frame(first_obj)) {
    cat("\nFirst few rows:\n")
    print(head(first_obj))
    cat("\nRow names:\n")
    print(rownames(first_obj))
  }
}

# Clear environment
rm(list = ls())

cat("\n\n")
cat("========================================\n")
cat("NEUROTICISM (N) RESULTS:\n")
cat("File: original files/Syntax (Neuroticism networks)/NEO & IPIP - P3_nSim50_results_all_N.RData\n")
load("original files/Syntax (Neuroticism networks)/NEO & IPIP - P3_nSim50_results_all_N.RData")
cat("\nObjects in environment:\n")
all_objects <- ls()
print(all_objects)

# Look for output objects
output_objects <- all_objects[grepl("output", all_objects, ignore.case = TRUE)]
cat("\nOutput objects found:\n")
print(output_objects)

# Check structure of first output object if exists
if (length(output_objects) > 0) {
  first_obj <- get(output_objects[1])
  cat("\nStructure of", output_objects[1], ":\n")
  print(str(first_obj))
  if (is.data.frame(first_obj)) {
    cat("\nFirst few rows:\n")
    print(head(first_obj))
    cat("\nRow names:\n")
    print(rownames(first_obj))
  }
}

cat("\n")
cat("========================================\n")
cat("CHECK COMPLETE\n")
cat("========================================\n")

