#NEO & IPIP datasets

library(doParallel)
library(dplyr)
library(psych)
library(qgraph)
library(BDgraph)
library(ppcor)
library(rlist)
library(RColorBrewer)
library(reshape2)
library(stats)
library(bootnet)
library(coefficientalpha)

registerDoParallel(cores=4)



##########



### FUNCTIONS



### Data-preprocessing functions (P1)


# function to remove NAs from dataframes
noNA_func <- function(df) {
  tmp <- df[complete.cases(df), ]
}



#**********



## Resampling functions (P2)


### functions to randomly select 0.2 proportion of rows (i.e. 84 cases) 

# new resampling (without replacement) for each draw
func_SE_0.2 <- function(df, size, replace) {
  tmp <- df[sample(nrow(df), size = 84, replace = FALSE), ]
}

# split full sample into 2 subsamples of nSamp=0.2
func_SE_0.2_split <- function(df, size, replace) {
  allrows <- 1:nrow(df)
  tmp1rows <- sample(allrows, size = 84, replace = FALSE)
  
  restrows <- allrows[-tmp1rows]
  tmp2rows <- sample(restrows, size = 84, replace = FALSE)
  
  tmp1 <- df[tmp1rows, ]
  tmp2 <- df[tmp2rows, ]
  
  res <- list(half1_0.2=tmp1, half2_0.2=tmp2)
}



### functions to randomly select 0.5 proportion of rows (i.e. 212 cases)

# new resampling (without replacement) for each draw
func_SE_0.5 <- function(df, size, replace) {
  tmp <- df[sample(nrow(df), size = 212, replace = FALSE), ]
}

# split full sample into 2 subsamples of nSamp=0.5
func_SE_0.5_split <- function(df, size, replace) {
  allrows <- 1:nrow(df)
  tmp1rows <- sample(allrows, size = 212, replace = FALSE)
  
  restrows <- allrows[-tmp1rows]
  tmp2rows <- sample(restrows, size = 212, replace = FALSE)
  
  tmp1 <- df[tmp1rows, ]
  tmp2 <- df[tmp2rows, ]
  
  res <- list(half1_0.5=tmp1, half2_0.5=tmp2)
}



### function to randomly select 0.8 proportion of rows (i.e. 339 cases) 
# new resampling (without replacement) for each draw
func_SE_0.8 <- function(df, size, replace) {
  tmp <- df[sample(nrow(df), size = 339, replace = FALSE), ]
}



### function to randomly select 1.0 proportion of rows (i.e. 424 cases) 
# new resampling (without replacement) for each draw
func_SE_1.0 <- function(df, size, replace) {
  tmp <- df[sample(nrow(df), size = 424, replace = FALSE), ]
}



random.seeds <- sample.int(n = 10000, size = 50, replace = FALSE) #create vector of random seeds

# function to randomly select 1 column (i.e. 1 item) per facet
func_colselect_1 <- function(df, size, replace) {
  tmp <- df[,sample(ncol(df), size = 1, replace = FALSE)]
}

# function to randomly select the same 1 column (i.e. same 1 item) per facet
func_colselect_1same <- function(df, size, replace) {
  set.seed(random.seeds[l]) #set random seed such that for each iteration, new set of same items are drawn (for each pair of indep samples)
  tmp <- df[,sample(ncol(df), size = 1, replace = FALSE)]
}

# function to randomly select 2 columns (i.e. 2 items) per facet
func_colselect_2 <- function(df, size, replace) {
  tmp <- df[,sample(ncol(df), size = 2, replace = FALSE)]
}

# function to randomly select the same 2 columns (i.e. same 2 items) per facet
func_colselect_2same <- function(df, size, replace) {
  set.seed(random.seeds[l]) #set random seed such that for each iteration, new set of same items are drawn (for each pair of indep samples)
  tmp <- df[,sample(ncol(df), size = 2, replace = FALSE)]
}

# function to randomly select 3 columns (i.e. 3 items) per facet
func_colselect_3 <- function(df, size, replace) {
  tmp <- df[,sample(ncol(df), size = 3, replace = FALSE)]
}

# function to randomly select the same 3 columns (i.e. same 3 items) per facet
func_colselect_3same <- function(df, size, replace) {
  set.seed(random.seeds[l]) #set random seed such that for each iteration, new set of same items are drawn (for each pair of indep samples)
  tmp <- df[,sample(ncol(df), size = 3, replace = FALSE)]
}

# function to randomly select 5 columns (i.e. 5 items) per facet
func_colselect_5 <- function(df, size, replace) {
  tmp <- df[,sample(ncol(df), size = 5, replace = FALSE)]
}

# function to randomly select the same 5 columns (i.e. same 5 items) per facet
func_colselect_5same <- function(df, size, replace) {
  set.seed(random.seeds[l]) #set random seed such that for each iteration, new set of same items are drawn (for each pair of indep samples)
  tmp <- df[,sample(ncol(df), size = 5, replace = FALSE)]
}

# function to randomly select 8 columns (i.e. 8 items) per facet
func_colselect_8 <- function(df, size, replace) {
  tmp <- df[,sample(ncol(df), size = 8, replace = FALSE)]
}

# function to randomly select the same 8 columns (i.e. same 8 items) per facet
func_colselect_8same <- function(df, size, replace) {
  set.seed(random.seeds[l]) #set random seed such that for each iteration, new set of same items are drawn (for each pair of indep samples)
  tmp <- df[,sample(ncol(df), size = 8, replace = FALSE)]
}



#**********



### Netcompare functions (P3)


## NOTES:
# "netcompare_func" = independent samples, low iterations (it = 1), p-values not relevant
# "netcompare_func_paired = dependent samples, low iterations (it = 1), p-values not relevant
# "netcompare_func_pval = independent samples, high iterations (it = 1000), invariance tests & p-values relevant
# "netcompare_func_paired_pval = dependent samples, high iterations (it = 1000), invariance tests & p-values relevant



## netcompare function for independent data USING non-regularized estimation
netcompare_func <- function(x, y) {
  
  ### compute correlation matrices
  
  cor_x <- stats::cor(x, method = "pearson") #returns correlation matrix (treats data as continuous)
  cor_y <- stats::cor(y, method = "pearson") #returns correlation matrix (treats data as continuous)
  
  
  ### run non-regularized estimation method (corMethod = "cor" from bootnet_ggmModSelect)
  
  x_ggmModSelect <- bootnet::estimateNetwork(x, "ggmModSelect")
  y_ggmModSelect <- bootnet::estimateNetwork(y, "ggmModSelect")
  
  
  ### run Network Comparison Test::NCT function (input complete bootnet object)
  
  tmp <- NCT(data1 = x_ggmModSelect, data2 = y_ggmModSelect, it = 1, binary.data = FALSE, abs = TRUE, paired = FALSE,
             make.positive.definite = FALSE, test.edges = TRUE, edges = "all", p.adjust.methods = "bonferroni",
             test.centrality = TRUE, centrality = c("closeness", "betweenness", "strength", "expectedInfluence"),
             verbose = TRUE)
  
  maxdiffedges_NCT <- which(tmp$einv.real == max(tmp$einv.real), arr.ind = TRUE) #returns pair of nodes with largest difference re: NCT
  
  
  ### compute unweighted adjacency matrices
  
  netmat_x <- qgraph::ggmModSelect(S = cor_x, n = dim(x)[1], start = "glasso") #estimate network #returns partial correlation matrix & criterion
  adjmat_x = ifelse(netmat_x$graph == 0, 0, 1) #returns unweighted adjacency matrix
  nx <- dim(x)[1]
  
  netmat_y <- qgraph::ggmModSelect(S = cor_y, n = dim(y)[1], start = "glasso") #estimate network #returns partial correlation matrix & criterion
  adjmat_y = ifelse(netmat_y$graph == 0, 0, 1) #returns unweighted adjacency matrix
  ny <- dim(y)[1]
  
  
  ### compute centrality indices (from ggmModSelect estimated network)
  
  centrality_x <- centrality(netmat_x$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE) 
  centrality_y <- centrality(netmat_y$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  
  
  ### tally similarities / differences btw networks (from unweighted adjacency matrices)
  
  adjmat_x_table <- table(adjmat_x) #table of data1 (x) adjmat edges
  adjmat_y_table <- table(adjmat_y) #table of data2 (y) adjmat edges
  
  adjmat_x_table["0"] <- (adjmat_x_table["0"]-6)/2 #adjust adjmat_x_table for only upper.tri; count data1 (x) "0" values
  adjmat_x_table["1"] <- adjmat_x_table["1"]/2 #adjust adjmat_x_table for only upper.tri; count data1 (x) "1" values
  adjmat_y_table["0"] <- (adjmat_y_table["0"]-6)/2 #adjust adjmat_y_table for only upper.tri; count data2 (y) "0" values
  adjmat_y_table["1"] <- adjmat_y_table["1"]/2 #adjust adjmat_y_table for only upper.tri; count data2 (y) "1" values
  
  adjmat_diff <- adjmat_x - adjmat_y #subtract data2 (y) adjacency matrix from data1 (x) adj mat (to determine where diffs exist)
  adjmat_table <- table(adjmat_diff) #table of x - y: edges absent to present (-1), edges same (0), edges present to absent (1)
  adjmat_table["-1"] <- adjmat_table["-1"]/2 #adjust adjmat_table for only upper.tri; count "-1" values
  adjmat_table["0"] <- (adjmat_table["0"]-6)/2 #adjust adjmat_table for only upper.tri; count "0" values
  adjmat_table["1"] <- adjmat_table["1"]/2 #adjust adjmat_table for only upper.tri; count "1" values
  adjmat_table["-1"][is.na(adjmat_table["-1"])] <- 0 #set NA values to 0
  adjmat_table["0"][is.na(adjmat_table["0"])] <- 0 #set NA values to 0
  adjmat_table["1"][is.na(adjmat_table["1"])] <- 0 #set NA values to 0
  adjmat_totaldiff <- sum(adjmat_table["-1"]*(-1), adjmat_table["0"]*(0), adjmat_table["1"]*(1), na.rm = TRUE) #compute sum across all cells
  
  
  ### compute max edge difference btw networks (from raw partial correlation matrices)
  
  partcor_x <- ppcor::pcor(x) #partial correlation matrix of data1 #returns list
  network_x_pc <- partcor_x[[1]] #partial correlation matrix of data1 #returns matrix
  
  partcor_y <- ppcor::pcor(y) #partial correlation matrix of data2 #returns list
  network_y_pc <- partcor_y[[1]] #partial correlation matrix of data2 #returns matrix
  
  diff_pc <- network_x_pc - network_y_pc #difference between two partial correlations
  maxdiff_pc <- max(abs(diff_pc)) #returns value of largest difference (absolute value)
  maxdiffedges_pc <- which(diff_pc == max(diff_pc), arr.ind = TRUE) #returns pair of nodes with largest difference
  n <- nrow(x) # note: n for data1 = n for data2
  p <- ncol(x) # note: p for data1 = p for data2
  z <- diff_pc /  sqrt((1/ (n - (p-1) - 3)) + (1/(n - (p-1) - 3))) #z score for the difference; n = sample size, p = number of variables 
  pc_pvalue <- pnorm(-abs(z), lower.tail = T) * 2
  
  
  ### print results as list
  res <- list(glstrinv.sep_x=tmp$glstrinv.sep[[1]], glstrinv.sep_y=tmp$glstrinv.sep[[2]], 
              glstrinv.real=tmp$glstrinv.real, glstrinv.pval=tmp$glstrinv.pval, 
              nwinv.real=tmp$nwinv.real, nwinv.pval=tmp$nwinv.pval, maxdiffedges_NCT=maxdiffedges_NCT[1,],
              einv.pvals=tmp$einv.pvals, einv.real=tmp$einv.real, nx=nx, ny=ny,
              diffcen.pval=tmp$diffcen.pval, diffcen.real=tmp$diffcen.real, 
              OutDegree_x=centrality_x$OutDegree, OutDegree_y=centrality_y$OutDegree, InDegree_x=centrality_x$InDegree, InDegree_y=centrality_y$InDegree,
              Closeness_x=centrality_x$Closeness, Closeness_y=centrality_y$Closeness, Betweenness_x=centrality_x$Betweenness, Betweenness_y=centrality_y$Betweenness,
              InExpectedInfluence_x=centrality_x$InExpectedInfluence, InExpectedInfluence_y=centrality_y$InExpectedInfluence,
              OutExpectedInfluence_x=centrality_x$OutExpectedInfluence, OutExpectedInfluence_y=centrality_y$OutExpectedInfluence,
              ShortestPathLengths_x=centrality_x$ShortestPathLengths, ShortestPathLengths_y=centrality_y$ShortestPathLengths,
              cor_x=cor_x, netmat_x_graph=netmat_x$graph, netmat_x_criterion=netmat_x$criterion, adjmat_x=adjmat_x,
              cor_y=cor_y, netmat_y_graph=netmat_y$graph, netmat_y_criterion=netmat_y$criterion, adjmat_y=adjmat_y,
              adjmat_x_table=adjmat_x_table, adjmat_y_table=adjmat_y_table,
              adjmat_diff=adjmat_diff, adjmat_table=adjmat_table, adjmat_totaldiff=adjmat_totaldiff,
              network_x_pc=network_x_pc, network_y_pc=network_y_pc,  
              diff_pc=diff_pc, diff_pc_pvalues=pc_pvalue, maxdiff_pc=maxdiff_pc, maxdiffedges_pc=maxdiffedges_pc[1,])
  
  return(res)
} 

## netcompare function for dependent (paired) data USING non-regularized estimation
netcompare_func_paired <- function(x, y) {
  
  ### compute correlation matrices
  
  cor_x <- stats::cor(x, method = "pearson") #returns correlation matrix (treats data as continuous)
  cor_y <- stats::cor(y, method = "pearson") #returns correlation matrix (treats data as continuous)
  
  
  ### run non-regularized estimation method (corMethod = "cor" from bootnet_ggmModSelect)
  
  x_ggmModSelect <- bootnet::estimateNetwork(x, "ggmModSelect")
  y_ggmModSelect <- bootnet::estimateNetwork(y, "ggmModSelect")
  
  
  ### run Network Comparison Test::NCT function (input complete bootnet object)
  
  tmp <- NCT(data1 = x_ggmModSelect, data2 = y_ggmModSelect, it = 1, binary.data = FALSE, abs = TRUE, paired = TRUE,
             make.positive.definite = FALSE, test.edges = TRUE, edges = "all", p.adjust.methods = "bonferroni",
             test.centrality = TRUE, centrality = c("closeness", "betweenness", "strength", "expectedInfluence"),
             verbose = TRUE)
  
  maxdiffedges_NCT <- which(tmp$einv.real == max(tmp$einv.real), arr.ind = TRUE) #returns pair of nodes with largest difference re: NCT
  
  
  ### compute unweighted adjacency matrices
  
  netmat_x <- qgraph::ggmModSelect(S = cor_x, n = dim(x)[1], start = "glasso") #estimate network #returns partial correlation matrix & criterion
  adjmat_x = ifelse(netmat_x$graph == 0, 0, 1) #returns unweighted adjacency matrix
  nx <- dim(x)[1]
  
  netmat_y <- qgraph::ggmModSelect(S = cor_y, n = dim(y)[1], start = "glasso") #estimate network #returns partial correlation matrix & criterion
  adjmat_y = ifelse(netmat_y$graph == 0, 0, 1) #returns unweighted adjacency matrix
  ny <- dim(y)[1]
  
  
  ### compute centrality indices (from ggmModSelect estimated network)
  
  centrality_x <- centrality(netmat_x$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE) 
  centrality_y <- centrality(netmat_y$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE) 
  
  
  ### tally similarities / differences btw networks (from unweighted adjacency matrices)
  
  adjmat_x_table <- table(adjmat_x) #table of data1 (x) adjmat edges
  adjmat_y_table <- table(adjmat_y) #table of data2 (y) adjmat edges
  
  adjmat_x_table["0"] <- (adjmat_x_table["0"]-6)/2 #adjust adjmat_x_table for only upper.tri; count data1 (x) "0" values
  adjmat_x_table["1"] <- adjmat_x_table["1"]/2 #adjust adjmat_x_table for only upper.tri; count data1 (x) "1" values
  adjmat_y_table["0"] <- (adjmat_y_table["0"]-6)/2 #adjust adjmat_y_table for only upper.tri; count data2 (y) "0" values
  adjmat_y_table["1"] <- adjmat_y_table["1"]/2 #adjust adjmat_y_table for only upper.tri; count data2 (y) "1" values
  
  adjmat_diff <- adjmat_x - adjmat_y #subtract data2 (y) adjacency matrix from data1 (x) adj mat (to determine where diffs exist)
  adjmat_table <- table(adjmat_diff) #table of x - y: edges absent to present (-1), edges same (0), edges present to absent (1)
  adjmat_table["-1"] <- adjmat_table["-1"]/2 #adjust adjmat_table for only upper.tri; count "-1" values
  adjmat_table["0"] <- (adjmat_table["0"]-6)/2 #adjust adjmat_table for only upper.tri; count "0" values
  adjmat_table["1"] <- adjmat_table["1"]/2 #adjust adjmat_table for only upper.tri; count "1" values
  adjmat_table["-1"][is.na(adjmat_table["-1"])] <- 0 #set NA values to 0
  adjmat_table["0"][is.na(adjmat_table["0"])] <- 0 #set NA values to 0
  adjmat_table["1"][is.na(adjmat_table["1"])] <- 0 #set NA values to 0
  adjmat_totaldiff <- sum(adjmat_table["-1"]*(-1), adjmat_table["0"]*(0), adjmat_table["1"]*(1), na.rm = TRUE) #compute sum across all cells
  
  
  ### compute max edge difference btw networks (from raw partial correlation matrices)
  
  partcor_x <- ppcor::pcor(x) #partial correlation matrix of data1 #returns list
  network_x_pc <- partcor_x[[1]] #partial correlation matrix of data1 #returns matrix
  
  partcor_y <- ppcor::pcor(y) #partial correlation matrix of data2 #returns list
  network_y_pc <- partcor_y[[1]] #partial correlation matrix of data2 #returns matrix
  
  diff_pc <- network_x_pc - network_y_pc #difference between two partial correlations
  maxdiff_pc <- max(abs(diff_pc)) #returns value of largest difference (absolute value)
  maxdiffedges_pc <- which(diff_pc == max(diff_pc), arr.ind = TRUE) #returns pair of nodes with largest difference
  n <- nrow(x) # note: n for data1 = n for data2
  p <- ncol(x) # note: p for data1 = p for data2
  z <- diff_pc /  sqrt((1/ (n - (p-1) - 3)) + (1/(n - (p-1) - 3))) #z score for the difference; n = sample size, p = number of variables 
  pc_pvalue <- pnorm(-abs(z), lower.tail = T) * 2
  
  
  ### print results as list
  res <- list(glstrinv.sep_x=tmp$glstrinv.sep[[1]], glstrinv.sep_y=tmp$glstrinv.sep[[2]], 
              glstrinv.real=tmp$glstrinv.real, glstrinv.pval=tmp$glstrinv.pval, 
              nwinv.real=tmp$nwinv.real, nwinv.pval=tmp$nwinv.pval, maxdiffedges_NCT=maxdiffedges_NCT[1,],
              einv.pvals=tmp$einv.pvals, einv.real=tmp$einv.real, nx=nx, ny=ny,
              diffcen.pval=tmp$diffcen.pval, diffcen.real=tmp$diffcen.real, 
              OutDegree_x=centrality_x$OutDegree, OutDegree_y=centrality_y$OutDegree, InDegree_x=centrality_x$InDegree, InDegree_y=centrality_y$InDegree,
              Closeness_x=centrality_x$Closeness, Closeness_y=centrality_y$Closeness, Betweenness_x=centrality_x$Betweenness, Betweenness_y=centrality_y$Betweenness,
              InExpectedInfluence_x=centrality_x$InExpectedInfluence, InExpectedInfluence_y=centrality_y$InExpectedInfluence,
              OutExpectedInfluence_x=centrality_x$OutExpectedInfluence, OutExpectedInfluence_y=centrality_y$OutExpectedInfluence,
              ShortestPathLengths_x=centrality_x$ShortestPathLengths, ShortestPathLengths_y=centrality_y$ShortestPathLengths,
              cor_x=cor_x, netmat_x_graph=netmat_x$graph, netmat_x_criterion=netmat_x$criterion, adjmat_x=adjmat_x,
              cor_y=cor_y, netmat_y_graph=netmat_y$graph, netmat_y_criterion=netmat_y$criterion, adjmat_y=adjmat_y,
              adjmat_x_table=adjmat_x_table, adjmat_y_table=adjmat_y_table,
              adjmat_diff=adjmat_diff, adjmat_table=adjmat_table, adjmat_totaldiff=adjmat_totaldiff,
              network_x_pc=network_x_pc, network_y_pc=network_y_pc,  
              diff_pc=diff_pc, diff_pc_pvalues=pc_pvalue, maxdiff_pc=maxdiff_pc, maxdiffedges_pc=maxdiffedges_pc[1,])
  
  return(res)
} 

## netcompare function for independent data USING non-regularized estimation
netcompare_func_pval <- function(x, y) {
  
  ### run non-regularized estimation method (corMethod = "cor" from bootnet_ggmModSelect)
  
  x_ggmModSelect <- bootnet::estimateNetwork(x, "ggmModSelect", stepwise = TRUE)
  y_ggmModSelect <- bootnet::estimateNetwork(y, "ggmModSelect", stepwise = TRUE)
  
  
  ### run Network Comparison Test::NCT function (input complete bootnet object)
  
  tmp <- NCT(data1 = x_ggmModSelect, data2 = y_ggmModSelect, it = 1000, binary.data = FALSE, abs = TRUE, paired = FALSE,
             make.positive.definite = FALSE, test.edges = TRUE, edges = "all", p.adjust.methods = "bonferroni",
             test.centrality = TRUE, centrality = c("closeness", "betweenness", "strength", "expectedInfluence"),
             verbose = TRUE)
  
  maxdiffedges_NCT <- which(tmp$einv.real == max(tmp$einv.real), arr.ind = TRUE) #returns pair of nodes with largest difference re: NCT
  
  nx <- dim(x)[1]
  ny <- dim(y)[1]
  
  ### print results as list
  res <- list(glstrinv.sep_x=tmp$glstrinv.sep[[1]], glstrinv.sep_y=tmp$glstrinv.sep[[2]],
              glstrinv.real=tmp$glstrinv.real, glstrinv.pval=tmp$glstrinv.pval,
              nwinv.real=tmp$nwinv.real, nwinv.pval=tmp$nwinv.pval, maxdiffedges_NCT=maxdiffedges_NCT[1,],
              einv.pvals=tmp$einv.pvals, einv.real=tmp$einv.real, nx=nx, ny=ny,
              diffcen.pval=tmp$diffcen.pval, diffcen.real=tmp$diffcen.real)
  
  return(res)
} 

## netcompare function for dependent (paired) data USING non-regularized estimation
netcompare_func_paired_pval <- function(x, y) {
  
  ### run non-regularized estimation method (corMethod = "cor" from bootnet_ggmModSelect)
  
  x_ggmModSelect <- bootnet::estimateNetwork(x, "ggmModSelect", stepwise = TRUE)
  y_ggmModSelect <- bootnet::estimateNetwork(y, "ggmModSelect", stepwise = TRUE)
  
  
  ### run Network Comparison Test::NCT function (input complete bootnet object)
  
  tmp <- NCT(data1 = x_ggmModSelect, data2 = y_ggmModSelect, it = 1000, binary.data = FALSE, abs = TRUE, paired = TRUE,
             make.positive.definite = FALSE, test.edges = TRUE, edges = "all", p.adjust.methods = "bonferroni",
             test.centrality = TRUE, centrality = c("closeness", "betweenness", "strength", "expectedInfluence"),
             verbose = TRUE)
  
  maxdiffedges_NCT <- which(tmp$einv.real == max(tmp$einv.real), arr.ind = TRUE) #returns pair of nodes with largest difference re: NCT
  
  nx <- dim(x)[1]
  ny <- dim(y)[1]
  
  ### print results as list
  res <- list(glstrinv.sep_x=tmp$glstrinv.sep[[1]], glstrinv.sep_y=tmp$glstrinv.sep[[2]],
              glstrinv.real=tmp$glstrinv.real, glstrinv.pval=tmp$glstrinv.pval,
              nwinv.real=tmp$nwinv.real, nwinv.pval=tmp$nwinv.pval, maxdiffedges_NCT=maxdiffedges_NCT[1,],
              einv.pvals=tmp$einv.pvals, einv.real=tmp$einv.real, nx=nx, ny=ny,
              diffcen.pval=tmp$diffcen.pval, diffcen.real=tmp$diffcen.real)
  
  return(res)
} 



#**********



### Analysis functions (P3)


#function to transform upper triangle of matrix to vector
to.upper<-function(mat) t(mat)[lower.tri(mat,diag=FALSE)]

edge_vector <- c("f1_f2", "f1_f3", "f1_f4", "f1_f5", "f1_f6",
                 "f2_f3", "f2_f4", "f2_f5", "f2_f6",
                 "f3_f4", "f3_f5", "f3_f6",
                 "f4_f5", "f4_f6",
                 "f5_f6") #where f represents facet



#function to extract "output1" from netcompare output: descriptives 
output1_func <- function(df) {
  
  # absolute values of pc edge diff matrix
  absdiff_pc <- abs(df$diff_pc)
  
  # absolute value of max edge diff (computed from raw pc matrices)
  absmaxdiff_pc <- max(absdiff_pc)
  
  # returns pair of nodes with largest ABSOLUTE difference
  absmaxdiffedges_pc <- which(absdiff_pc == max(absdiff_pc), arr.ind = TRUE) 
  
  # network 1: edge weight & node descriptives (NCT approach) 
  netmat_x_graph <- df$netmat_x_graph #edge weight matrix (with zeros)
  netmat_x_max <- which(netmat_x_graph == max(netmat_x_graph), arr.ind = TRUE) #identify largest edge weight
  netmat_x_graph_na <- netmat_x_graph 
  is.na(netmat_x_graph_na) <- netmat_x_graph_na==0 #edge weight matrix (with zeros set to NA)
  avg.abs_esize_x_NCT <- mean(netmat_x_graph_na[upper.tri(netmat_x_graph_na, diag = FALSE)], na.rm = TRUE) #avg edge weight for present edges
  sd.abs_esize_x_NCT <- sd(netmat_x_graph_na[upper.tri(netmat_x_graph_na, diag = FALSE)], na.rm = TRUE) #sd of edge weights for present edges
  
  # network 1: centrality ranks (expected influence)
  cent_x <- centrality(netmat_x_graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE) #note: signed = TRUE does NOT treat weights as abs values
  cent_expinfl_x <- cent_x$InExpectedInfluence #select only expected influence values
  cent_expinfl_sort_x <- head(sort(cent_expinfl_x, decreasing = TRUE),3) #order top 3 central nodes
  cent_expinfl_sort_x.df <- as.data.frame(cent_expinfl_sort_x)
  cent_expinfl_123_x <- rownames(cent_expinfl_sort_x.df)[1:3]
  cent_expinfl_123_x[cent_expinfl_123_x == "N1"] <- 1
  cent_expinfl_123_x[cent_expinfl_123_x == "N2"] <- 2
  cent_expinfl_123_x[cent_expinfl_123_x == "N3"] <- 3
  cent_expinfl_123_x[cent_expinfl_123_x == "N4"] <- 4
  cent_expinfl_123_x[cent_expinfl_123_x == "N5"] <- 5
  cent_expinfl_123_x[cent_expinfl_123_x == "N6"] <- 6
  cent_expinfl_123_x <- as.numeric(cent_expinfl_123_x) #ordered vector of top 3 central nodes
  
  
  # network 2: edge weight & node descriptives (NCT approach)
  netmat_y_graph <- df$netmat_y_graph #edge weight matrix (with zeros)
  netmat_y_max <- which(netmat_y_graph == max(netmat_y_graph), arr.ind = TRUE) #identify largest edge weight
  netmat_y_graph_na <- netmat_y_graph
  is.na(netmat_y_graph_na) <- netmat_y_graph_na==0 #edge weight matrix (with zeros set to NA)
  avg.abs_esize_y_NCT <- mean(netmat_y_graph_na[upper.tri(netmat_y_graph_na, diag = FALSE)], na.rm = TRUE) #avg edge weight for present edges
  sd.abs_esize_y_NCT <- sd(netmat_y_graph_na[upper.tri(netmat_y_graph_na, diag = FALSE)], na.rm = TRUE) #sd of edge weights for present edges
  
  # network 2: centrality ranks (expected influence)
  cent_y <- centrality(netmat_y_graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE) #note: signed = TRUE does NOT treat weights as abs values
  cent_expinfl_y <- cent_y$InExpectedInfluence #select only expected influence values
  cent_expinfl_sort_y <- head(sort(cent_expinfl_y, decreasing = TRUE),3) #order top 3 central nodes
  cent_expinfl_sort_y.df <- as.data.frame(cent_expinfl_sort_y)
  cent_expinfl_123_y <- rownames(cent_expinfl_sort_y.df)[1:3]
  cent_expinfl_123_y[cent_expinfl_123_y == "N1"] <- 1
  cent_expinfl_123_y[cent_expinfl_123_y == "N2"] <- 2
  cent_expinfl_123_y[cent_expinfl_123_y == "N3"] <- 3
  cent_expinfl_123_y[cent_expinfl_123_y == "N4"] <- 4
  cent_expinfl_123_y[cent_expinfl_123_y == "N5"] <- 5
  cent_expinfl_123_y[cent_expinfl_123_y == "N6"] <- 6
  cent_expinfl_123_y <- as.numeric(cent_expinfl_123_y) #ordered vector of top 3 central nodes
  
  tmp <- cbind(dimension=NA, condition=NA, nSamp=NA, ncol=NA, nx=df$nx, ny=df$ny,
               glstrinv.sep_x=df$glstrinv.sep_x, glstrinv.sep_y=df$glstrinv.sep_y, glstrinv.real=df$glstrinv.real, glstrinv.pval=df$glstrinv.pval, 
               nwinv.real=df$nwinv.real, nwinv.pval=df$nwinv.pval, edge_NCT_1=df$maxdiffedges_NCT[1], edge_NCT_2=df$maxdiffedges_NCT[2], 
               avg.abs_esize_x_NCT, sd.abs_esize_x_NCT, avg.abs_esize_y_NCT, sd.abs_esize_y_NCT,
               edge_x_max_1=netmat_x_max[1], edge_x_max_2=netmat_x_max[2], edge_y_max_1=netmat_y_max[1], edge_y_max_2=netmat_y_max[2],
               maxdiff_pc=df$maxdiff_pc, edge_pc_1=df$maxdiffedges_pc[1], edge_pc_2=df$maxdiffedges_pc[2], 
               adjmat_x_pres=df$adjmat_x_table["1"], adjmat_x_ab=df$adjmat_x_table["0"], adjmat_y_pres=df$adjmat_y_table["1"], adjmat_y_ab=df$adjmat_y_table["0"],
               absmaxdiff_pc=absmaxdiff_pc, edge_pc_abs_1=absmaxdiffedges_pc[1], edge_pc_abs_2=absmaxdiffedges_pc[2],
               adjmat_totaldiff=df$adjmat_totaldiff, adjmat_ab2ab=((df$adjmat_x_table["0"])-(df$adjmat_table["-1"])), adjmat_pres2pres=((df$adjmat_x_table["1"])-(df$adjmat_table["1"])),
               adjmat_ab2pres=df$adjmat_table["-1"], adjmat_same=df$adjmat_table["0"], adjmat_pres2ab=df$adjmat_table["1"],
               cent_expinfl_1_x=cent_expinfl_123_x[1], cent_expinfl_2_x=cent_expinfl_123_x[2], cent_expinfl_3_x=cent_expinfl_123_x[3],
               cent_expinfl_1_y=cent_expinfl_123_y[1], cent_expinfl_2_y=cent_expinfl_123_y[2], cent_expinfl_3_y=cent_expinfl_123_y[3])
}

#function to merge output1 
output1_merge_func <- function(df) {
  
  tmp <- lapply(df, output1_func)
  tmp <- do.call("rbind.data.frame", tmp)
}



#function to extract "output2" from netcompare output: partial correlation matrices 
output2_func <- function(df) {
  
  # absolute values of pc edge diff matrix
  absdiff_pc <- abs(df$diff_pc)
  
  tmp <- cbind.data.frame(edge=edge_vector, 
                          x_pcedges=to.upper(df$network_x_pc), y_pcedges=to.upper(df$network_y_pc),
                          pc_ediffs=to.upper(absdiff_pc),
                          x_NCTedges=to.upper(df$netmat_x_graph), y_NCTedges=to.upper(df$netmat_y_graph),
                          NCT_ediffs=to.upper(df$einv.real))
}

#function to merge output2 
output2_merge_func <- function(df) {
  tmp <- lapply(df, output2_func)
}


#function to extract "output3" from netcompare output: centrality indices (computed from ggm estimated networks) 
#specifically Expected Influence
output3_func_cent <- function(df) {
  
  ### compute centrality indices (from ggmModSelect estimated network)
  #NOTE: because networks are not directed, InExpectedInfluence = OutExpectedIInfluence
  
  tmp_x <- df$netmat_x_graph
  tmp_y <- df$netmat_y_graph
  
  cent_x <- centrality(tmp_x, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE) #note: signed = TRUE does NOT treat weights as abs values
  cent_y <- centrality(tmp_y, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE) #note: signed = TRUE does NOT treat weights as abs values
  
  res <- cbind.data.frame(cent_x, cent_y)
  res_expinfl <- data.frame(ExpectedInfluence_x=res[,5], ExpectedInfluence_y=res[,23]) #select only expected influence values
  res_expinfl$ExpInfl_diff <- res_expinfl$ExpectedInfluence_x - res_expinfl$ExpectedInfluence_y
  res_expinfl
}


#function to merge output3
output3_merge_func_cent <- function(df) {
  tmp <- lapply(df, output3_func_cent)
}



# function to analyze netcompare output [NO p-values] 
func_avg.glstr <- function(df) {
  
  nSamp <- df$nSamp[1]
  nSampValue <- df$nx[1]
  
  # global strength descriptives
  avg.glstr_x <- mean(df$glstrinv.sep_x)
  sd.glstr_x <- sd(df$glstrinv.sep_x)
  avg.glstr_y <- mean(df$glstrinv.sep_y)
  sd.glstr_y <- sd(df$glstrinv.sep_y)
  avg.glstr_diff <- mean(df$glstrinv.real)
  sd.glstr_diff <- sd(df$glstrinv.real)
  
  # average edge weight descriptives (NCT approach)
  grdmean.abs_esize_x_NCT <- mean(df$avg.abs_esize_x_NCT, na.rm = TRUE) #computed mean across the avg. edge weight values (network 1)
  sd.grdmean.abs_esize_x_NCT <- sd(df$avg.abs_esize_x_NCT, na.rm = TRUE) #variance/distribution of the avg. edge weights (network 1)
  grdmean.abs_esize_y_NCT <- mean(df$avg.abs_esize_y_NCT, na.rm = TRUE) #computed mean across the avg. edge weight values (network 2)
  sd.grdmean.abs_esize_y_NCT <- sd(df$avg.abs_esize_y_NCT, na.rm = TRUE) #variance/distribution of the avg. edge weights (network 2)
  
  # network structure differences descriptives (NCT approach)
  avg.nwinv_diff <- mean(df$nwinv.real) #max edge diff (NCT approach)
  sd.nwinv_diff <- sd(df$nwinv.real)
  
  # max edge difference descriptives (computed from raw pc matrices)
  avg.pc_diff <- mean(df$absmaxdiff_pc) 
  sd.pc_diff <- sd(df$absmaxdiff_pc)
  
  # mean number of present (i.e. non-zero) edges
  avg.present_x <- mean(df$adjmat_x_pres, na.rm = TRUE)
  sd.present_x <- sd(df$adjmat_x_pres, na.rm = TRUE)
  avg.present_y <- mean(df$adjmat_y_pres, na.rm = TRUE)
  sd.present_y <- sd(df$adjmat_y_pres, na.rm = TRUE)
  
  # mean number of absent (i.e. zero) edges
  avg.absent_x <- mean(df$adjmat_x_ab)
  sd.absent_x <- sd(df$adjmat_x_ab)
  avg.absent_y <- mean(df$adjmat_y_ab)
  sd.absent_y <- sd(df$adjmat_y_ab)
  
  # centrality frequencies (network 1)
  expinfl_1st_x_freq_N1 <- sum(df$cent_expinfl_1_x == 1)
  expinfl_1st_x_freq_N2 <- sum(df$cent_expinfl_1_x == 2)
  expinfl_1st_x_freq_N3 <- sum(df$cent_expinfl_1_x == 3)
  expinfl_1st_x_freq_N4 <- sum(df$cent_expinfl_1_x == 4)
  expinfl_1st_x_freq_N5 <- sum(df$cent_expinfl_1_x == 5)
  expinfl_1st_x_freq_N6 <- sum(df$cent_expinfl_1_x == 6)
  
  # centrality frequencies (network 2)
  expinfl_1st_y_freq_N1 <- sum(df$cent_expinfl_1_y == 1)
  expinfl_1st_y_freq_N2 <- sum(df$cent_expinfl_1_y == 2)
  expinfl_1st_y_freq_N3 <- sum(df$cent_expinfl_1_y == 3)
  expinfl_1st_y_freq_N4 <- sum(df$cent_expinfl_1_y == 4)
  expinfl_1st_y_freq_N5 <- sum(df$cent_expinfl_1_y == 5)
  expinfl_1st_y_freq_N6 <- sum(df$cent_expinfl_1_y == 6)
  
  res <- data.frame(nSamp, nSampValue,
                    avg.present_x, sd.present_x, avg.absent_x, sd.absent_x,
                    avg.present_y, sd.present_y, avg.absent_y, sd.absent_y,
                    avg.glstr_x, sd.glstr_x, avg.glstr_y, sd.glstr_y, avg.glstr_diff, sd.glstr_diff,
                    grdmean.abs_esize_x_NCT, sd.grdmean.abs_esize_x_NCT, grdmean.abs_esize_y_NCT, sd.grdmean.abs_esize_y_NCT,
                    avg.nwinv_diff, sd.nwinv_diff, avg.pc_diff, sd.pc_diff,
                    expinfl_1st_x_freq_N1, expinfl_1st_x_freq_N2, expinfl_1st_x_freq_N3,
                    expinfl_1st_x_freq_N4, expinfl_1st_x_freq_N5, expinfl_1st_x_freq_N6,
                    expinfl_1st_y_freq_N1, expinfl_1st_y_freq_N2, expinfl_1st_y_freq_N3,
                    expinfl_1st_y_freq_N4, expinfl_1st_y_freq_N5, expinfl_1st_y_freq_N6)
  return(res)
}


#function to compute average differences in adjacency matrices [p-values not relevant here]
func_avg.diff <- function(df) {
  avg.diff_same <- mean(df$adjmat_same, na.rm = TRUE)
  sd.diff_same <- sd(df$adjmat_same, na.rm = TRUE)
  avg.diff_ab2ab <- mean(df$adjmat_ab2ab, na.rm = TRUE)
  sd.diff_ab2ab <- sd(df$adjmat_ab2ab, na.rm = TRUE)
  avg.diff_pres2pres <- mean(df$adjmat_pres2pres, na.rm = TRUE)
  sd.diff_pres2pres <- sd(df$adjmat_pres2pres, na.rm = TRUE)
  avg.diff_ab2pres <- mean(df$adjmat_ab2pres, na.rm = TRUE)
  sd.diff_ab2pres <- sd(df$adjmat_ab2pres, na.rm = TRUE)
  avg.diff_pres2ab <- mean(df$adjmat_pres2ab, na.rm = TRUE)
  sd.diff_pres2ab <- sd(df$adjmat_pres2ab, na.rm = TRUE)
  avg.diff_total <- mean(df$adjmat_totaldiff, na.rm = TRUE)
  sd.diff_total <- sd(df$adjmat_totaldiff, na.rm = TRUE)
  
  res <- data.frame(avg.diff_same, sd.diff_same, avg.diff_ab2ab, sd.diff_ab2ab, avg.diff_pres2pres, sd.diff_pres2pres, 
                    avg.diff_ab2pres, sd.diff_ab2pres, avg.diff_pres2ab, sd.diff_pres2ab, avg.diff_total, sd.diff_total)
  return(res)
}


func_cor <- function(x,y){
  tmp_mat <- cor(x,y)
  tmp_diag <- diag(tmp_mat) # we care about the diagonal elements
}


func_avg.cor <- function(df){
  tmp <- list.rbind(df)
  #facetitems_cor_mean <- colMeans(tmp)
  #facetitems_cor_sd <- colSds(tmp)
  
  #tmp_df <- cbind.data.frame(facetitems_cor_mean, facetitems_cor_sd)
}


# function to tally combinations of variables
combSummarise <- function(data, variables=..., summarise=...){
  
  
  # Get all different combinations of selected variables (credit to @Michael)
  myGroups <- lapply(seq_along(variables), function(x) {
    combn(c(variables), x, simplify = FALSE)}) %>%
    unlist(recursive = FALSE)
  
  # Group by selected variables (credit to @konvas)
  df <- eval(parse(text=paste("lapply(myGroups, function(x){
               dplyr::group_by_(data, .dots=x) %>% 
               dplyr::summarize_( \"", paste(summarise, collapse="\",\""),"\")})"))) %>% 
    do.call(plyr::rbind.fill,.)
  
  groupNames <- c(myGroups[[length(myGroups)]])
  newNames <- names(df)[!(names(df) %in% groupNames)]
  
  df <- cbind(df[, groupNames], df[, newNames])
  names(df) <- c(groupNames, newNames)
  df
  
}



#**********



### [end]


### Save objects

save(
  
  ### Data-preprocessing functions (P1)
  noNA_func, 
  
  ## Resampling functions (P2)
  func_SE_0.2, func_SE_0.2_split, func_SE_0.5, func_SE_0.5_split, func_SE_0.8, func_SE_1.0,
  func_colselect_1, func_colselect_2, func_colselect_3, func_colselect_5, func_colselect_8,
  func_colselect_1same, func_colselect_2same, func_colselect_3same, func_colselect_5same, func_colselect_8same,
  
  ## Netcompare functions (P3)
  netcompare_func, netcompare_func_paired, netcompare_func_pval, netcompare_func_paired_pval,
  
  ## Analysis functions (P3)
  output1_func, output1_merge_func,
  output2_func, output2_merge_func,
  output3_func_cent, output3_merge_func_cent,
  func_avg.glstr, func_avg.diff,
  to.upper, edge_vector,
  func_cor, func_avg.cor,
  combSummarise,
  
  file = "NEO & IPIP - P0_functions.RData")





