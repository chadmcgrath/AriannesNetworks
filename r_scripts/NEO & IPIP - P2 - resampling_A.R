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

registerDoParallel(cores=4)

# Load object Rdata file(s)
load("NEO & IPIP - P0_functions.Rdata")
load("NEO & IPIP - P1_nSim50_data_A.RData")



##########



### SIMULATION STEPS

## STEP 0 (simulation): Simulation settings

nSim <- 50 # number of resamplings
nSamp = c(0.2, 0.5, 0.8, 1.0) #proportion of sampling, i.e. vary SE 
# vary ncols <- c(1, 2, 3, 5, 8) # number of items used to measure each facet (i.e. node)


### STEP 1 (simulation): Vary sampling error (SE), i.e. proportion of cases used

sample_prop <- floor(nSamp*424) #returns numeric, i.e. 4 values of sample sizes based on sample_prop = 84 212 339 424



##########



## RESAMPLING

{#create lists for samples
  samples_A_0.2 = samples_A_0.5 = samples_A_0.8 = samples_A_1.0 <- list()}


set.seed(123123) #set the seed for reproducible results

for (i in 1:6) {
  set.seed(123123) #set seed such that for each iteration, same rows are sampled across facets
  
  #create nested lists: same sample
  samples_A_0.2[[i]] = samples_A_0.5[[i]] = samples_A_0.8[[i]] = samples_A_1.0[[i]] <- list()
  
  for (l in 1:nSim) {
    
    #sample 20% of cases nSim times
    samples_A_0.2[[i]][[l]] <- lapply(A.list[i], func_SE_0.2) 
    
    #sample 50% of cases nSim times
    samples_A_0.5[[i]][[l]] <- lapply(A.list[i], func_SE_0.5) 
    
    #sample 80% of cases nSim times
    samples_A_0.8[[i]][[l]] <- lapply(A.list[i], func_SE_0.8) 
    
    #sample 100% of cases nSim times
    samples_A_1.0[[i]][[l]] <- lapply(A.list[i], func_SE_1.0) 
  }
} 



## SPLITTING

{#create lists for samples
  samples_Asplit_0.2 = samples_Asplit_0.5 <- list()}


set.seed(123123) #set the seed for reproducible results

for (i in 1:6) {
  set.seed(123123) #set seed such that for each iteration, same rows are sampled across facets
  
  #create nested lists: same sample
  samples_Asplit_0.2[[i]] = samples_Asplit_0.5[[i]] <- list()
  
  for (l in 1:nSim) {
    
    #sample 20% of cases nSim times
    samples_Asplit_0.2[[i]][[l]] <- lapply(A.list[i], func_SE_0.2_split) 
    
    #sample 50% of cases nSim times
    samples_Asplit_0.5[[i]][[l]] <- lapply(A.list[i], func_SE_0.5_split) 
  }
} 



##########



## STEP 2 (simulation): Random sampling of items from lists


## Randomly sample n items per facet, 
# if n > 1, create sum score per facet,
# store all 6 facet scores (per dimension) as its own dataframe
# repeat resampling process nSim times, and store all nSim dataframes (per dimension) into its own list



##########



## NOTES on Resampling Conditions (& use of suffixes in the code)

# CONDITION I. Sampling Variability, i.e. ("split_SS") condition
# CONDITION II. Scale Variability, i.e. ("_DD") condition
# CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition



##########



### Sample 1 item per facet (i.e. per node)


#create lists for the nSim dataframes: per dimension, per nSamp

{#for NEO scale
  NEO_samples_A_0.2 = NEO_samples_A_0.5 = NEO_samples_A_0.8 = NEO_samples_A_1.0 <- list() 
  NEO_samples_Asplit_0.2 = NEO_samples_Asplit_0.5 <- list()}

{#for IPIP scale
  IPIP_samples_A_0.2 = IPIP_samples_A_0.5 = IPIP_samples_A_0.8 = IPIP_samples_A_1.0 <- list() 
  IPIP_samples_Asplit_0.2 = IPIP_samples_Asplit_0.5 <- list()}


#create lists for the nSim dataframes: per dimension, per nSamp, for ncol = 1

{#for NEO scale
  NEO_samples_A_0.2_1 = NEO_samples_A_0.5_1 = NEO_samples_A_0.8_1 = NEO_samples_A_1.0_1 <- list() 
  NEO_samples_Asplit_0.2_1same = NEO_samples_Asplit_0.5_1same <- list()
  NEO_samples_Asplit_0.2_1 = NEO_samples_Asplit_0.5_1 <- list()}

{#for IPIP scale
  IPIP_samples_A_0.2_1 = IPIP_samples_A_0.5_1 = IPIP_samples_A_0.8_1 = IPIP_samples_A_1.0_1 <- list()
  IPIP_samples_Asplit_0.2_1same = IPIP_samples_Asplit_0.5_1same <- list()
  IPIP_samples_Asplit_0.2_1 = IPIP_samples_Asplit_0.5_1 <- list()}



# Generate dataframes

# CONDITION II. Scale Variability, i.e. ("_DD") condition
# i.e. SAME sample + DIFF scale (ncol = 1)

set.seed(123123) #set the seed for reproducible results
for(i in 1:6){
  
  #create nested lists
  NEO_samples_A_0.2[[i]] = NEO_samples_A_0.5[[i]] = NEO_samples_A_0.8[[i]] = NEO_samples_A_1.0[[i]] <- list()
  IPIP_samples_A_0.2[[i]] = IPIP_samples_A_0.5[[i]] = IPIP_samples_A_0.8[[i]] = IPIP_samples_A_1.0[[i]] <- list()
  
  NEO_samples_A_0.2_1[[i]] = NEO_samples_A_0.5_1[[i]] = NEO_samples_A_0.8_1[[i]] = NEO_samples_A_1.0_1[[i]] <- list() 
  IPIP_samples_A_0.2_1[[i]] = IPIP_samples_A_0.5_1[[i]] = IPIP_samples_A_0.8_1[[i]] = IPIP_samples_A_1.0_1[[i]] <- list()
 
  for (l in 1:nSim){
    
    # CONDITION II. (ncol = 1)
    
    #create subsets for NEO and IPIP scales
    NEO_samples_A_0.2[[i]][[l]] <- lapply(samples_A_0.2[[i]][[l]], "[", c(1:8))
    NEO_samples_A_0.5[[i]][[l]] <- lapply(samples_A_0.5[[i]][[l]], "[", c(1:8))
    NEO_samples_A_0.8[[i]][[l]] <- lapply(samples_A_0.8[[i]][[l]], "[", c(1:8))
    NEO_samples_A_1.0[[i]][[l]] <- lapply(samples_A_1.0[[i]][[l]], "[", c(1:8))
    
    IPIP_samples_A_0.2[[i]][[l]] <- lapply(samples_A_0.2[[i]][[l]], "[", c(9:18))
    IPIP_samples_A_0.5[[i]][[l]] <- lapply(samples_A_0.5[[i]][[l]], "[", c(9:18))
    IPIP_samples_A_0.8[[i]][[l]] <- lapply(samples_A_0.8[[i]][[l]], "[", c(9:18))
    IPIP_samples_A_1.0[[i]][[l]] <- lapply(samples_A_1.0[[i]][[l]], "[", c(9:18))
    
    #apply random column selection function
    NEO_samples_A_0.2_1[[i]][[l]] <- lapply(NEO_samples_A_0.2[[i]][[l]], func_colselect_1)
    NEO_samples_A_0.5_1[[i]][[l]] <- lapply(NEO_samples_A_0.5[[i]][[l]], func_colselect_1)
    NEO_samples_A_0.8_1[[i]][[l]] <- lapply(NEO_samples_A_0.8[[i]][[l]], func_colselect_1)
    NEO_samples_A_1.0_1[[i]][[l]] <- lapply(NEO_samples_A_1.0[[i]][[l]], func_colselect_1)
    
    IPIP_samples_A_0.2_1[[i]][[l]] <- lapply(IPIP_samples_A_0.2[[i]][[l]], func_colselect_1)
    IPIP_samples_A_0.5_1[[i]][[l]] <- lapply(IPIP_samples_A_0.5[[i]][[l]], func_colselect_1)
    IPIP_samples_A_0.8_1[[i]][[l]] <- lapply(IPIP_samples_A_0.8[[i]][[l]], func_colselect_1)
    IPIP_samples_A_1.0_1[[i]][[l]] <- lapply(IPIP_samples_A_1.0[[i]][[l]], func_colselect_1)
  }
}


# Generate dataframes

# CONDITION I. Sampling Variability, i.e. ("split_SS") condition
# i.e. INDEP samples + SAME scale (ncol = 1)

# CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition
# i.e. INDEP samples + DIFF scale (ncol = 1)

set.seed(123123) #set the seed for reproducible results
for(i in 1:6){
  
  #create nested lists
  NEO_samples_Asplit_0.2[[i]] = NEO_samples_Asplit_0.5[[i]] <- list()
  IPIP_samples_Asplit_0.2[[i]] = IPIP_samples_Asplit_0.5[[i]] <- list()
  
  NEO_samples_Asplit_0.2_1same[[i]] = NEO_samples_Asplit_0.5_1same[[i]] <- list()
  IPIP_samples_Asplit_0.2_1same[[i]] = IPIP_samples_Asplit_0.5_1same[[i]] <- list()
  
  NEO_samples_Asplit_0.2_1[[i]] = NEO_samples_Asplit_0.5_1[[i]] <- list()
  IPIP_samples_Asplit_0.2_1[[i]] = IPIP_samples_Asplit_0.5_1[[i]] <- list()
  
  for (l in 1:nSim){
    
    #create further nesting
    NEO_samples_Asplit_0.2[[i]][[l]] = NEO_samples_Asplit_0.5[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2[[i]][[l]] = IPIP_samples_Asplit_0.5[[i]][[l]] <- list()
    
    NEO_samples_Asplit_0.2_1same[[i]][[l]] = NEO_samples_Asplit_0.5_1same[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_1same[[i]][[l]] = IPIP_samples_Asplit_0.5_1same[[i]][[l]] <- list()
    
    NEO_samples_Asplit_0.2_1[[i]][[l]] = NEO_samples_Asplit_0.5_1[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_1[[i]][[l]] = IPIP_samples_Asplit_0.5_1[[i]][[l]] <- list()
    
    for (h in 1:1){
      
      #create subsets for NEO and IPIP scales
      NEO_samples_Asplit_0.2[[i]][[l]][[h]] <- lapply(samples_Asplit_0.2[[i]][[l]][[h]], "[", c(1:8))
      NEO_samples_Asplit_0.5[[i]][[l]][[h]] <- lapply(samples_Asplit_0.5[[i]][[l]][[h]], "[", c(1:8))
    
      IPIP_samples_Asplit_0.2[[i]][[l]][[h]] <- lapply(samples_Asplit_0.2[[i]][[l]][[h]], "[", c(9:18))
      IPIP_samples_Asplit_0.5[[i]][[l]][[h]] <- lapply(samples_Asplit_0.5[[i]][[l]][[h]], "[", c(9:18))
      
      # CONDITION I. (ncol = 1)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_1same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_1same)
      NEO_samples_Asplit_0.5_1same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_1same)
      
      IPIP_samples_Asplit_0.2_1same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_1same)
      IPIP_samples_Asplit_0.5_1same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_1same)
      
      # CONDITION III. (ncol = 1)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_1[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_1)
      NEO_samples_Asplit_0.5_1[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_1)
      
      IPIP_samples_Asplit_0.2_1[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_1)
      IPIP_samples_Asplit_0.5_1[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_1)
    }
  }
}



#store randomly selected columns together

{# CONDITION I. (ncol = 1)
  dfsNEO_Asplit_0.2_1same_h1 = dfsNEO_Asplit_0.5_1same_h1 <- list()
  dfsNEO_Asplit_0.2_1same_h2 = dfsNEO_Asplit_0.5_1same_h2 <- list()
  
  dfsIPIP_Asplit_0.2_1same_h1 = dfsIPIP_Asplit_0.5_1same_h1 <- list()
  dfsIPIP_Asplit_0.2_1same_h2 = dfsIPIP_Asplit_0.5_1same_h2 <- list()}

{# CONDITION II. (ncol = 1)
  dfsNEO_A_0.2_1 = dfsNEO_A_0.5_1 = dfsNEO_A_0.8_1 = dfsNEO_A_1.0_1 <- list()
  dfsIPIP_A_0.2_1 = dfsIPIP_A_0.5_1 = dfsIPIP_A_0.8_1 = dfsIPIP_A_1.0_1 <- list()}

{# CONDITION III. (ncol = 1)
  dfsNEO_Asplit_0.2_1_h1 = dfsNEO_Asplit_0.5_1_h1 <- list()
  dfsNEO_Asplit_0.2_1_h2 = dfsNEO_Asplit_0.5_1_h2 <- list()
  
  dfsIPIP_Asplit_0.2_1_h1 = dfsIPIP_Asplit_0.5_1_h1 <- list()
  dfsIPIP_Asplit_0.2_1_h2 = dfsIPIP_Asplit_0.5_1_h2 <- list()}


set.seed(123123) #set the seed for reproducible results

for (l in 1:nSim){
  
  # CONDITION I. (ncol = 1)
  dfsNEO_Asplit_0.2_1same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_1same[[1]][[l]][[1]]$half1_0.2, NEO_samples_Asplit_0.2_1same[[2]][[l]][[1]]$half1_0.2, NEO_samples_Asplit_0.2_1same[[3]][[l]][[1]]$half1_0.2,
                                                      NEO_samples_Asplit_0.2_1same[[4]][[l]][[1]]$half1_0.2, NEO_samples_Asplit_0.2_1same[[5]][[l]][[1]]$half1_0.2, NEO_samples_Asplit_0.2_1same[[6]][[l]][[1]]$half1_0.2)
  dfsNEO_Asplit_0.5_1same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_1same[[1]][[l]][[1]]$half1_0.5, NEO_samples_Asplit_0.5_1same[[2]][[l]][[1]]$half1_0.5, NEO_samples_Asplit_0.5_1same[[3]][[l]][[1]]$half1_0.5,
                                                      NEO_samples_Asplit_0.5_1same[[4]][[l]][[1]]$half1_0.5, NEO_samples_Asplit_0.5_1same[[5]][[l]][[1]]$half1_0.5, NEO_samples_Asplit_0.5_1same[[6]][[l]][[1]]$half1_0.5)
  dfsNEO_Asplit_0.2_1same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_1same[[1]][[l]][[1]]$half2_0.2, NEO_samples_Asplit_0.2_1same[[2]][[l]][[1]]$half2_0.2, NEO_samples_Asplit_0.2_1same[[3]][[l]][[1]]$half2_0.2,
                                                      NEO_samples_Asplit_0.2_1same[[4]][[l]][[1]]$half2_0.2, NEO_samples_Asplit_0.2_1same[[5]][[l]][[1]]$half2_0.2, NEO_samples_Asplit_0.2_1same[[6]][[l]][[1]]$half2_0.2)
  dfsNEO_Asplit_0.5_1same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_1same[[1]][[l]][[1]]$half2_0.5, NEO_samples_Asplit_0.5_1same[[2]][[l]][[1]]$half2_0.5, NEO_samples_Asplit_0.5_1same[[3]][[l]][[1]]$half2_0.5,
                                                      NEO_samples_Asplit_0.5_1same[[4]][[l]][[1]]$half2_0.5, NEO_samples_Asplit_0.5_1same[[5]][[l]][[1]]$half2_0.5, NEO_samples_Asplit_0.5_1same[[6]][[l]][[1]]$half2_0.5)
  
  dfsIPIP_Asplit_0.2_1same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_1same[[1]][[l]][[1]]$half1_0.2, IPIP_samples_Asplit_0.2_1same[[2]][[l]][[1]]$half1_0.2, IPIP_samples_Asplit_0.2_1same[[3]][[l]][[1]]$half1_0.2,
                                                       IPIP_samples_Asplit_0.2_1same[[4]][[l]][[1]]$half1_0.2, IPIP_samples_Asplit_0.2_1same[[5]][[l]][[1]]$half1_0.2, IPIP_samples_Asplit_0.2_1same[[6]][[l]][[1]]$half1_0.2)
  dfsIPIP_Asplit_0.5_1same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_1same[[1]][[l]][[1]]$half1_0.5, IPIP_samples_Asplit_0.5_1same[[2]][[l]][[1]]$half1_0.5, IPIP_samples_Asplit_0.5_1same[[3]][[l]][[1]]$half1_0.5,
                                                       IPIP_samples_Asplit_0.5_1same[[4]][[l]][[1]]$half1_0.5, IPIP_samples_Asplit_0.5_1same[[5]][[l]][[1]]$half1_0.5, IPIP_samples_Asplit_0.5_1same[[6]][[l]][[1]]$half1_0.5)
  dfsIPIP_Asplit_0.2_1same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_1same[[1]][[l]][[1]]$half2_0.2, IPIP_samples_Asplit_0.2_1same[[2]][[l]][[1]]$half2_0.2, IPIP_samples_Asplit_0.2_1same[[3]][[l]][[1]]$half2_0.2,
                                                       IPIP_samples_Asplit_0.2_1same[[4]][[l]][[1]]$half2_0.2, IPIP_samples_Asplit_0.2_1same[[5]][[l]][[1]]$half2_0.2, IPIP_samples_Asplit_0.2_1same[[6]][[l]][[1]]$half2_0.2)
  dfsIPIP_Asplit_0.5_1same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_1same[[1]][[l]][[1]]$half2_0.5, IPIP_samples_Asplit_0.5_1same[[2]][[l]][[1]]$half2_0.5, IPIP_samples_Asplit_0.5_1same[[3]][[l]][[1]]$half2_0.5,
                                                       IPIP_samples_Asplit_0.5_1same[[4]][[l]][[1]]$half2_0.5, IPIP_samples_Asplit_0.5_1same[[5]][[l]][[1]]$half2_0.5, IPIP_samples_Asplit_0.5_1same[[6]][[l]][[1]]$half2_0.5)
  
  # CONDITION II. (ncol = 1)
  dfsNEO_A_0.2_1[[l]] <- cbind.data.frame(NEO_samples_A_0.2_1[[1]][[l]][[1]], NEO_samples_A_0.2_1[[2]][[l]][[1]], NEO_samples_A_0.2_1[[3]][[l]][[1]],
                                          NEO_samples_A_0.2_1[[4]][[l]][[1]], NEO_samples_A_0.2_1[[5]][[l]][[1]], NEO_samples_A_0.2_1[[6]][[l]][[1]])
  dfsNEO_A_0.5_1[[l]] <- cbind.data.frame(NEO_samples_A_0.5_1[[1]][[l]][[1]], NEO_samples_A_0.5_1[[2]][[l]][[1]], NEO_samples_A_0.5_1[[3]][[l]][[1]],
                                          NEO_samples_A_0.5_1[[4]][[l]][[1]], NEO_samples_A_0.5_1[[5]][[l]][[1]], NEO_samples_A_0.5_1[[6]][[l]][[1]])
  dfsNEO_A_0.8_1[[l]] <- cbind.data.frame(NEO_samples_A_0.8_1[[1]][[l]][[1]], NEO_samples_A_0.8_1[[2]][[l]][[1]], NEO_samples_A_0.8_1[[3]][[l]][[1]],
                                          NEO_samples_A_0.8_1[[4]][[l]][[1]], NEO_samples_A_0.8_1[[5]][[l]][[1]], NEO_samples_A_0.8_1[[6]][[l]][[1]])
  dfsNEO_A_1.0_1[[l]] <- cbind.data.frame(NEO_samples_A_1.0_1[[1]][[l]][[1]], NEO_samples_A_1.0_1[[2]][[l]][[1]], NEO_samples_A_1.0_1[[3]][[l]][[1]],
                                          NEO_samples_A_1.0_1[[4]][[l]][[1]], NEO_samples_A_1.0_1[[5]][[l]][[1]], NEO_samples_A_1.0_1[[6]][[l]][[1]])
 
  dfsIPIP_A_0.2_1[[l]] <- cbind.data.frame(IPIP_samples_A_0.2_1[[1]][[l]][[1]], IPIP_samples_A_0.2_1[[2]][[l]][[1]], IPIP_samples_A_0.2_1[[3]][[l]][[1]],
                                           IPIP_samples_A_0.2_1[[4]][[l]][[1]], IPIP_samples_A_0.2_1[[5]][[l]][[1]], IPIP_samples_A_0.2_1[[6]][[l]][[1]])
  dfsIPIP_A_0.5_1[[l]] <- cbind.data.frame(IPIP_samples_A_0.5_1[[1]][[l]][[1]], IPIP_samples_A_0.5_1[[2]][[l]][[1]], IPIP_samples_A_0.5_1[[3]][[l]][[1]],
                                           IPIP_samples_A_0.5_1[[4]][[l]][[1]], IPIP_samples_A_0.5_1[[5]][[l]][[1]], IPIP_samples_A_0.5_1[[6]][[l]][[1]])
  dfsIPIP_A_0.8_1[[l]] <- cbind.data.frame(IPIP_samples_A_0.8_1[[1]][[l]][[1]], IPIP_samples_A_0.8_1[[2]][[l]][[1]], IPIP_samples_A_0.8_1[[3]][[l]][[1]],
                                           IPIP_samples_A_0.8_1[[4]][[l]][[1]], IPIP_samples_A_0.8_1[[5]][[l]][[1]], IPIP_samples_A_0.8_1[[6]][[l]][[1]])
  dfsIPIP_A_1.0_1[[l]] <- cbind.data.frame(IPIP_samples_A_1.0_1[[1]][[l]][[1]], IPIP_samples_A_1.0_1[[2]][[l]][[1]], IPIP_samples_A_1.0_1[[3]][[l]][[1]],
                                           IPIP_samples_A_1.0_1[[4]][[l]][[1]], IPIP_samples_A_1.0_1[[5]][[l]][[1]], IPIP_samples_A_1.0_1[[6]][[l]][[1]])
  
  # CONDITION III. (ncol = 1)
  dfsNEO_Asplit_0.2_1_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_1[[1]][[l]][[1]]$half1_0.2, NEO_samples_Asplit_0.2_1[[2]][[l]][[1]]$half1_0.2, NEO_samples_Asplit_0.2_1[[3]][[l]][[1]]$half1_0.2,
                                                  NEO_samples_Asplit_0.2_1[[4]][[l]][[1]]$half1_0.2, NEO_samples_Asplit_0.2_1[[5]][[l]][[1]]$half1_0.2, NEO_samples_Asplit_0.2_1[[6]][[l]][[1]]$half1_0.2)
  dfsNEO_Asplit_0.5_1_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_1[[1]][[l]][[1]]$half1_0.5, NEO_samples_Asplit_0.5_1[[2]][[l]][[1]]$half1_0.5, NEO_samples_Asplit_0.5_1[[3]][[l]][[1]]$half1_0.5,
                                                  NEO_samples_Asplit_0.5_1[[4]][[l]][[1]]$half1_0.5, NEO_samples_Asplit_0.5_1[[5]][[l]][[1]]$half1_0.5, NEO_samples_Asplit_0.5_1[[6]][[l]][[1]]$half1_0.5)
  dfsNEO_Asplit_0.2_1_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_1[[1]][[l]][[1]]$half2_0.2, NEO_samples_Asplit_0.2_1[[2]][[l]][[1]]$half2_0.2, NEO_samples_Asplit_0.2_1[[3]][[l]][[1]]$half2_0.2,
                                                  NEO_samples_Asplit_0.2_1[[4]][[l]][[1]]$half2_0.2, NEO_samples_Asplit_0.2_1[[5]][[l]][[1]]$half2_0.2, NEO_samples_Asplit_0.2_1[[6]][[l]][[1]]$half2_0.2)
  dfsNEO_Asplit_0.5_1_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_1[[1]][[l]][[1]]$half2_0.5, NEO_samples_Asplit_0.5_1[[2]][[l]][[1]]$half2_0.5, NEO_samples_Asplit_0.5_1[[3]][[l]][[1]]$half2_0.5,
                                                  NEO_samples_Asplit_0.5_1[[4]][[l]][[1]]$half2_0.5, NEO_samples_Asplit_0.5_1[[5]][[l]][[1]]$half2_0.5, NEO_samples_Asplit_0.5_1[[6]][[l]][[1]]$half2_0.5)
  
  dfsIPIP_Asplit_0.2_1_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_1[[1]][[l]][[1]]$half1_0.2, IPIP_samples_Asplit_0.2_1[[2]][[l]][[1]]$half1_0.2, IPIP_samples_Asplit_0.2_1[[3]][[l]][[1]]$half1_0.2,
                                                   IPIP_samples_Asplit_0.2_1[[4]][[l]][[1]]$half1_0.2, IPIP_samples_Asplit_0.2_1[[5]][[l]][[1]]$half1_0.2, IPIP_samples_Asplit_0.2_1[[6]][[l]][[1]]$half1_0.2)
  dfsIPIP_Asplit_0.5_1_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_1[[1]][[l]][[1]]$half1_0.5, IPIP_samples_Asplit_0.5_1[[2]][[l]][[1]]$half1_0.5, IPIP_samples_Asplit_0.5_1[[3]][[l]][[1]]$half1_0.5,
                                                   IPIP_samples_Asplit_0.5_1[[4]][[l]][[1]]$half1_0.5, IPIP_samples_Asplit_0.5_1[[5]][[l]][[1]]$half1_0.5, IPIP_samples_Asplit_0.5_1[[6]][[l]][[1]]$half1_0.5)
  dfsIPIP_Asplit_0.2_1_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_1[[1]][[l]][[1]]$half2_0.2, IPIP_samples_Asplit_0.2_1[[2]][[l]][[1]]$half2_0.2, IPIP_samples_Asplit_0.2_1[[3]][[l]][[1]]$half2_0.2,
                                                   IPIP_samples_Asplit_0.2_1[[4]][[l]][[1]]$half2_0.2, IPIP_samples_Asplit_0.2_1[[5]][[l]][[1]]$half2_0.2, IPIP_samples_Asplit_0.2_1[[6]][[l]][[1]]$half2_0.2)
  dfsIPIP_Asplit_0.5_1_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_1[[1]][[l]][[1]]$half2_0.5, IPIP_samples_Asplit_0.5_1[[2]][[l]][[1]]$half2_0.5, IPIP_samples_Asplit_0.5_1[[3]][[l]][[1]]$half2_0.5,
                                                   IPIP_samples_Asplit_0.5_1[[4]][[l]][[1]]$half2_0.5, IPIP_samples_Asplit_0.5_1[[5]][[l]][[1]]$half2_0.5, IPIP_samples_Asplit_0.5_1[[6]][[l]][[1]]$half2_0.5)
} #returns lists of nSim dataframes



#rename dataframe columns such that NEO and IPIP have matching names for netcompare step

colnames_N <- c("N1", "N2", "N3", "N4", "N5", "N6") #Note: deliberately left as N1 to N6 (representing nodes); will cohere with code below
  
{# NEO ncol=1 dataframes
  dfsNEO_A_0.2_1 <- lapply(dfsNEO_A_0.2_1, setNames, nm = colnames_N)
  dfsNEO_A_0.5_1 <- lapply(dfsNEO_A_0.5_1, setNames, nm = colnames_N)
  dfsNEO_A_0.8_1 <- lapply(dfsNEO_A_0.8_1, setNames, nm = colnames_N)
  dfsNEO_A_1.0_1 <- lapply(dfsNEO_A_1.0_1, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_1same_h1 <- lapply(dfsNEO_Asplit_0.2_1same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_1same_h1 <- lapply(dfsNEO_Asplit_0.5_1same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_1same_h2 <- lapply(dfsNEO_Asplit_0.2_1same_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_1same_h2 <- lapply(dfsNEO_Asplit_0.5_1same_h2, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_1_h1 <- lapply(dfsNEO_Asplit_0.2_1_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_1_h1 <- lapply(dfsNEO_Asplit_0.5_1_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_1_h2 <- lapply(dfsNEO_Asplit_0.2_1_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_1_h2 <- lapply(dfsNEO_Asplit_0.5_1_h2, setNames, nm = colnames_N)}

{# IPIP ncol=1 dataframes
  dfsIPIP_A_0.2_1 <- lapply(dfsIPIP_A_0.2_1, setNames, nm = colnames_N)
  dfsIPIP_A_0.5_1 <- lapply(dfsIPIP_A_0.5_1, setNames, nm = colnames_N)
  dfsIPIP_A_0.8_1 <- lapply(dfsIPIP_A_0.8_1, setNames, nm = colnames_N)
  dfsIPIP_A_1.0_1 <- lapply(dfsIPIP_A_1.0_1, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_1same_h1 <- lapply(dfsIPIP_Asplit_0.2_1same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_1same_h1 <- lapply(dfsIPIP_Asplit_0.5_1same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_1same_h2 <- lapply(dfsIPIP_Asplit_0.2_1same_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_1same_h2 <- lapply(dfsIPIP_Asplit_0.5_1same_h2, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_1_h1 <- lapply(dfsIPIP_Asplit_0.2_1_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_1_h1 <- lapply(dfsIPIP_Asplit_0.5_1_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_1_h2 <- lapply(dfsIPIP_Asplit_0.2_1_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_1_h2 <- lapply(dfsIPIP_Asplit_0.5_1_h2, setNames, nm = colnames_N)}



##########



### Sample 2 items per facet (i.e. per node)


#create lists for the nSim dataframes: per dimension, per nSamp, for ncol = 2

{#for NEO scale
  NEO_samples_A_0.2_2 = NEO_samples_A_0.5_2 = NEO_samples_A_0.8_2 = NEO_samples_A_1.0_2 <- list() 
  NEO_samples_Asplit_0.2_2 = NEO_samples_Asplit_0.5_2 <- list()
  NEO_samples_Asplit_0.2_2same = NEO_samples_Asplit_0.5_2same <- list()}

{#for IPIP scale
  IPIP_samples_A_0.2_2 = IPIP_samples_A_0.5_2 = IPIP_samples_A_0.8_2 = IPIP_samples_A_1.0_2 <- list()
  IPIP_samples_Asplit_0.2_2 = IPIP_samples_Asplit_0.5_2 <- list()
  IPIP_samples_Asplit_0.2_2same = IPIP_samples_Asplit_0.5_2same <- list()}



# Generate dataframes

# CONDITION II. Scale Variability, i.e. ("_DD") condition
# i.e. SAME sample + DIFF scale (ncol = 2)

set.seed(123123) #set the seed for reproducible results
for(i in 1:6){
  
  #create nested lists
  NEO_samples_A_0.2_2[[i]] = NEO_samples_A_0.5_2[[i]] = NEO_samples_A_0.8_2[[i]] = NEO_samples_A_1.0_2[[i]] <- list() 
  IPIP_samples_A_0.2_2[[i]] = IPIP_samples_A_0.5_2[[i]] = IPIP_samples_A_0.8_2[[i]] = IPIP_samples_A_1.0_2[[i]] <- list()
  
  for (l in 1:nSim){
    
    # CONDITION II. (ncol = 2)
    
    #apply random column selection function
    NEO_samples_A_0.2_2[[i]][[l]] <- lapply(NEO_samples_A_0.2[[i]][[l]], func_colselect_2)
    NEO_samples_A_0.5_2[[i]][[l]] <- lapply(NEO_samples_A_0.5[[i]][[l]], func_colselect_2)
    NEO_samples_A_0.8_2[[i]][[l]] <- lapply(NEO_samples_A_0.8[[i]][[l]], func_colselect_2)
    NEO_samples_A_1.0_2[[i]][[l]] <- lapply(NEO_samples_A_1.0[[i]][[l]], func_colselect_2)
    
    IPIP_samples_A_0.2_2[[i]][[l]] <- lapply(IPIP_samples_A_0.2[[i]][[l]], func_colselect_2)
    IPIP_samples_A_0.5_2[[i]][[l]] <- lapply(IPIP_samples_A_0.5[[i]][[l]], func_colselect_2)
    IPIP_samples_A_0.8_2[[i]][[l]] <- lapply(IPIP_samples_A_0.8[[i]][[l]], func_colselect_2)
    IPIP_samples_A_1.0_2[[i]][[l]] <- lapply(IPIP_samples_A_1.0[[i]][[l]], func_colselect_2)
    
    #create sum score
    NEO_samples_A_0.2_2[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.2_2[[i]][[l]][[1]][,1] + NEO_samples_A_0.2_2[[i]][[l]][[1]][,2])
    NEO_samples_A_0.5_2[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.5_2[[i]][[l]][[1]][,1] + NEO_samples_A_0.5_2[[i]][[l]][[1]][,2])
    NEO_samples_A_0.8_2[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.8_2[[i]][[l]][[1]][,1] + NEO_samples_A_0.8_2[[i]][[l]][[1]][,2])
    NEO_samples_A_1.0_2[[i]][[l]][[1]]$sum <- (NEO_samples_A_1.0_2[[i]][[l]][[1]][,1] + NEO_samples_A_1.0_2[[i]][[l]][[1]][,2])
    
    IPIP_samples_A_0.2_2[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.2_2[[i]][[l]][[1]][,1] + IPIP_samples_A_0.2_2[[i]][[l]][[1]][,2])
    IPIP_samples_A_0.5_2[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.5_2[[i]][[l]][[1]][,1] + IPIP_samples_A_0.5_2[[i]][[l]][[1]][,2])
    IPIP_samples_A_0.8_2[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.8_2[[i]][[l]][[1]][,1] + IPIP_samples_A_0.8_2[[i]][[l]][[1]][,2])
    IPIP_samples_A_1.0_2[[i]][[l]][[1]]$sum <- (IPIP_samples_A_1.0_2[[i]][[l]][[1]][,1] + IPIP_samples_A_1.0_2[[i]][[l]][[1]][,2])
  }
}


# Generate dataframes

# CONDITION I. Sampling Variability, i.e. ("split_SS") condition
# i.e. INDEP samples + SAME scale (ncol = 2)

# CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition
# i.e. INDEP samples + DIFF scale (ncol = 2)

set.seed(123123) #set the seed for reproducible results
for (i in 1:6){
  
  #create nested lists
  NEO_samples_Asplit_0.2_2same[[i]] = NEO_samples_Asplit_0.5_2same[[i]] <- list()
  IPIP_samples_Asplit_0.2_2same[[i]] = IPIP_samples_Asplit_0.5_2same[[i]] <- list()
  
  NEO_samples_Asplit_0.2_2[[i]] = NEO_samples_Asplit_0.5_2[[i]] <- list()
  IPIP_samples_Asplit_0.2_2[[i]] = IPIP_samples_Asplit_0.5_2[[i]] <- list()
  
  for (l in 1:nSim){
    
    #create further nesting
    NEO_samples_Asplit_0.2_2same[[i]][[l]] = NEO_samples_Asplit_0.5_2same[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_2same[[i]][[l]] = IPIP_samples_Asplit_0.5_2same[[i]][[l]] <- list()
    
    NEO_samples_Asplit_0.2_2[[i]][[l]] = NEO_samples_Asplit_0.5_2[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_2[[i]][[l]] = IPIP_samples_Asplit_0.5_2[[i]][[l]] <- list()
    
    for (h in 1:1){ 
      
      # CONDITION I. (ncol = 2)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_2same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_2same)
      NEO_samples_Asplit_0.5_2same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_2same)
      
      IPIP_samples_Asplit_0.2_2same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_2same)
      IPIP_samples_Asplit_0.5_2same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_2same)
      
      # CONDITION III. (ncol = 2)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_2[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_2)
      NEO_samples_Asplit_0.5_2[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_2)
      
      IPIP_samples_Asplit_0.2_2[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_2)
      IPIP_samples_Asplit_0.5_2[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_2)
    }
  }
}


for (i in 1:6){
  for (l in 1:nSim){
    for (h in 1:2) {
      #create sum score
      NEO_samples_Asplit_0.2_2same[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.2_2same[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.2_2same[[i]][[l]][[1]][[h]][,2])
      NEO_samples_Asplit_0.5_2same[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.5_2same[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.5_2same[[i]][[l]][[1]][[h]][,2])
      
      IPIP_samples_Asplit_0.2_2same[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.2_2same[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.2_2same[[i]][[l]][[1]][[h]][,2])
      IPIP_samples_Asplit_0.5_2same[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.5_2same[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.5_2same[[i]][[l]][[1]][[h]][,2])
      
      #create sum score
      NEO_samples_Asplit_0.2_2[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.2_2[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.2_2[[i]][[l]][[1]][[h]][,2])
      NEO_samples_Asplit_0.5_2[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.5_2[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.5_2[[i]][[l]][[1]][[h]][,2])
      
      IPIP_samples_Asplit_0.2_2[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.2_2[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.2_2[[i]][[l]][[1]][[h]][,2])
      IPIP_samples_Asplit_0.5_2[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.5_2[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.5_2[[i]][[l]][[1]][[h]][,2])
    }
  }
}



#store randomly selected columns together

{# CONDITION I. (ncol = 2)
  dfsNEO_Asplit_0.2_2same_h1 = dfsNEO_Asplit_0.5_2same_h1 <- list() 
  dfsNEO_Asplit_0.2_2same_h2 = dfsNEO_Asplit_0.5_2same_h2 <- list() 
  
  dfsIPIP_Asplit_0.2_2same_h1 = dfsIPIP_Asplit_0.5_2same_h1 <- list() 
  dfsIPIP_Asplit_0.2_2same_h2 = dfsIPIP_Asplit_0.5_2same_h2 <- list()} 

{# CONDITION II. (ncol = 2)
  dfsNEO_A_0.2_2 = dfsNEO_A_0.5_2 = dfsNEO_A_0.8_2 = dfsNEO_A_1.0_2 <- list()
  dfsIPIP_A_0.2_2 = dfsIPIP_A_0.5_2 = dfsIPIP_A_0.8_2 = dfsIPIP_A_1.0_2 <- list()}

{# CONDITION III. (ncol = 2)
  dfsNEO_Asplit_0.2_2_h1 = dfsNEO_Asplit_0.5_2_h1 <- list() 
  dfsNEO_Asplit_0.2_2_h2 = dfsNEO_Asplit_0.5_2_h2 <- list() 
  
  dfsIPIP_Asplit_0.2_2_h1 = dfsIPIP_Asplit_0.5_2_h1 <- list() 
  dfsIPIP_Asplit_0.2_2_h2 = dfsIPIP_Asplit_0.5_2_h2 <- list()} 



set.seed(123123) #set the seed for reproducible results

for (l in 1:nSim){

  # CONDITION I. (ncol = 2)
  dfsNEO_Asplit_0.2_2same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_2same[[1]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_2same[[2]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_2same[[3]][[l]][[1]]$half1_0.2$sum,
                                                      NEO_samples_Asplit_0.2_2same[[4]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_2same[[5]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_2same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsNEO_Asplit_0.2_2same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_2same[[1]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_2same[[2]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_2same[[3]][[l]][[1]]$half2_0.2$sum,
                                                      NEO_samples_Asplit_0.2_2same[[4]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_2same[[5]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_2same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsNEO_Asplit_0.5_2same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_2same[[1]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_2same[[2]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_2same[[3]][[l]][[1]]$half1_0.5$sum,
                                                      NEO_samples_Asplit_0.5_2same[[4]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_2same[[5]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_2same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsNEO_Asplit_0.5_2same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_2same[[1]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_2same[[2]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_2same[[3]][[l]][[1]]$half2_0.5$sum,
                                                      NEO_samples_Asplit_0.5_2same[[4]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_2same[[5]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_2same[[6]][[l]][[1]]$half2_0.5$sum)
  
  dfsIPIP_Asplit_0.2_2same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_2same[[1]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_2same[[2]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_2same[[3]][[l]][[1]]$half1_0.2$sum,
                                                       IPIP_samples_Asplit_0.2_2same[[4]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_2same[[5]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_2same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsIPIP_Asplit_0.2_2same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_2same[[1]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_2same[[2]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_2same[[3]][[l]][[1]]$half2_0.2$sum,
                                                       IPIP_samples_Asplit_0.2_2same[[4]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_2same[[5]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_2same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsIPIP_Asplit_0.5_2same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_2same[[1]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_2same[[2]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_2same[[3]][[l]][[1]]$half1_0.5$sum,
                                                       IPIP_samples_Asplit_0.5_2same[[4]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_2same[[5]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_2same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsIPIP_Asplit_0.5_2same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_2same[[1]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_2same[[2]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_2same[[3]][[l]][[1]]$half2_0.5$sum,
                                                       IPIP_samples_Asplit_0.5_2same[[4]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_2same[[5]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_2same[[6]][[l]][[1]]$half2_0.5$sum)
  
  # CONDITION II. (ncol = 2)
  dfsNEO_A_0.2_2[[l]] <- cbind.data.frame(NEO_samples_A_0.2_2[[1]][[l]][[1]]$sum, NEO_samples_A_0.2_2[[2]][[l]][[1]]$sum, NEO_samples_A_0.2_2[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.2_2[[4]][[l]][[1]]$sum, NEO_samples_A_0.2_2[[5]][[l]][[1]]$sum, NEO_samples_A_0.2_2[[6]][[l]][[1]]$sum)
  dfsNEO_A_0.5_2[[l]] <- cbind.data.frame(NEO_samples_A_0.5_2[[1]][[l]][[1]]$sum, NEO_samples_A_0.5_2[[2]][[l]][[1]]$sum, NEO_samples_A_0.5_2[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.5_2[[4]][[l]][[1]]$sum, NEO_samples_A_0.5_2[[5]][[l]][[1]]$sum, NEO_samples_A_0.5_2[[6]][[l]][[1]]$sum)
  dfsNEO_A_0.8_2[[l]] <- cbind.data.frame(NEO_samples_A_0.8_2[[1]][[l]][[1]]$sum, NEO_samples_A_0.8_2[[2]][[l]][[1]]$sum, NEO_samples_A_0.8_2[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.8_2[[4]][[l]][[1]]$sum, NEO_samples_A_0.8_2[[5]][[l]][[1]]$sum, NEO_samples_A_0.8_2[[6]][[l]][[1]]$sum)
  dfsNEO_A_1.0_2[[l]] <- cbind.data.frame(NEO_samples_A_1.0_2[[1]][[l]][[1]]$sum, NEO_samples_A_1.0_2[[2]][[l]][[1]]$sum, NEO_samples_A_1.0_2[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_1.0_2[[4]][[l]][[1]]$sum, NEO_samples_A_1.0_2[[5]][[l]][[1]]$sum, NEO_samples_A_1.0_2[[6]][[l]][[1]]$sum)
  
  dfsIPIP_A_0.2_2[[l]] <- cbind.data.frame(IPIP_samples_A_0.2_2[[1]][[l]][[1]]$sum, IPIP_samples_A_0.2_2[[2]][[l]][[1]]$sum, IPIP_samples_A_0.2_2[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.2_2[[4]][[l]][[1]]$sum, IPIP_samples_A_0.2_2[[5]][[l]][[1]]$sum, IPIP_samples_A_0.2_2[[6]][[l]][[1]]$sum)
  dfsIPIP_A_0.5_2[[l]] <- cbind.data.frame(IPIP_samples_A_0.5_2[[1]][[l]][[1]]$sum, IPIP_samples_A_0.5_2[[2]][[l]][[1]]$sum, IPIP_samples_A_0.5_2[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.5_2[[4]][[l]][[1]]$sum, IPIP_samples_A_0.5_2[[5]][[l]][[1]]$sum, IPIP_samples_A_0.5_2[[6]][[l]][[1]]$sum)
  dfsIPIP_A_0.8_2[[l]] <- cbind.data.frame(IPIP_samples_A_0.8_2[[1]][[l]][[1]]$sum, IPIP_samples_A_0.8_2[[2]][[l]][[1]]$sum, IPIP_samples_A_0.8_2[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.8_2[[4]][[l]][[1]]$sum, IPIP_samples_A_0.8_2[[5]][[l]][[1]]$sum, IPIP_samples_A_0.8_2[[6]][[l]][[1]]$sum)
  dfsIPIP_A_1.0_2[[l]] <- cbind.data.frame(IPIP_samples_A_1.0_2[[1]][[l]][[1]]$sum, IPIP_samples_A_1.0_2[[2]][[l]][[1]]$sum, IPIP_samples_A_1.0_2[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_1.0_2[[4]][[l]][[1]]$sum, IPIP_samples_A_1.0_2[[5]][[l]][[1]]$sum, IPIP_samples_A_1.0_2[[6]][[l]][[1]]$sum)
  
  # CONDITION III. (ncol = 2)
  dfsNEO_Asplit_0.2_2_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_2same[[1]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_2same[[2]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_2same[[3]][[l]][[1]]$half1_0.2$sum,
                                                  NEO_samples_Asplit_0.2_2same[[4]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_2same[[5]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_2same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsNEO_Asplit_0.2_2_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_2same[[1]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_2same[[2]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_2same[[3]][[l]][[1]]$half2_0.2$sum,
                                                  NEO_samples_Asplit_0.2_2same[[4]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_2same[[5]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_2same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsNEO_Asplit_0.5_2_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_2same[[1]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_2same[[2]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_2same[[3]][[l]][[1]]$half1_0.5$sum,
                                                  NEO_samples_Asplit_0.5_2same[[4]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_2same[[5]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_2same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsNEO_Asplit_0.5_2_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_2same[[1]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_2same[[2]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_2same[[3]][[l]][[1]]$half2_0.5$sum,
                                                  NEO_samples_Asplit_0.5_2same[[4]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_2same[[5]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_2same[[6]][[l]][[1]]$half2_0.5$sum)
  
  dfsIPIP_Asplit_0.2_2_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_2same[[1]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_2same[[2]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_2same[[3]][[l]][[1]]$half1_0.2$sum,
                                                   IPIP_samples_Asplit_0.2_2same[[4]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_2same[[5]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_2same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsIPIP_Asplit_0.2_2_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_2same[[1]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_2same[[2]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_2same[[3]][[l]][[1]]$half2_0.2$sum,
                                                   IPIP_samples_Asplit_0.2_2same[[4]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_2same[[5]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_2same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsIPIP_Asplit_0.5_2_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_2same[[1]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_2same[[2]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_2same[[3]][[l]][[1]]$half1_0.5$sum,
                                                   IPIP_samples_Asplit_0.5_2same[[4]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_2same[[5]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_2same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsIPIP_Asplit_0.5_2_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_2same[[1]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_2same[[2]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_2same[[3]][[l]][[1]]$half2_0.5$sum,
                                                   IPIP_samples_Asplit_0.5_2same[[4]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_2same[[5]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_2same[[6]][[l]][[1]]$half2_0.5$sum)
} #returns lists of nSim dataframes



#rename dataframe columns such that NEO and IPIP have matching names for netcompare step

colnames_N <- c("N1", "N2", "N3", "N4", "N5", "N6")

{# NEO ncol=2 dataframes    
  dfsNEO_A_0.2_2 <- lapply(dfsNEO_A_0.2_2, setNames, nm = colnames_N)
  dfsNEO_A_0.5_2 <- lapply(dfsNEO_A_0.5_2, setNames, nm = colnames_N)
  dfsNEO_A_0.8_2 <- lapply(dfsNEO_A_0.8_2, setNames, nm = colnames_N)
  dfsNEO_A_1.0_2 <- lapply(dfsNEO_A_1.0_2, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_2same_h1 <- lapply(dfsNEO_Asplit_0.2_2same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_2same_h1 <- lapply(dfsNEO_Asplit_0.5_2same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_2same_h2 <- lapply(dfsNEO_Asplit_0.2_2same_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_2same_h2 <- lapply(dfsNEO_Asplit_0.5_2same_h2, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_2_h1 <- lapply(dfsNEO_Asplit_0.2_2_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_2_h1 <- lapply(dfsNEO_Asplit_0.5_2_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_2_h2 <- lapply(dfsNEO_Asplit_0.2_2_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_2_h2 <- lapply(dfsNEO_Asplit_0.5_2_h2, setNames, nm = colnames_N)}

{# IPIP ncol=2 dataframes
  dfsIPIP_A_0.2_2 <- lapply(dfsIPIP_A_0.2_2, setNames, nm = colnames_N)
  dfsIPIP_A_0.5_2 <- lapply(dfsIPIP_A_0.5_2, setNames, nm = colnames_N)
  dfsIPIP_A_0.8_2 <- lapply(dfsIPIP_A_0.8_2, setNames, nm = colnames_N)
  dfsIPIP_A_1.0_2 <- lapply(dfsIPIP_A_1.0_2, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_2same_h1 <- lapply(dfsIPIP_Asplit_0.2_2same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_2same_h1 <- lapply(dfsIPIP_Asplit_0.5_2same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_2same_h2 <- lapply(dfsIPIP_Asplit_0.2_2same_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_2same_h2 <- lapply(dfsIPIP_Asplit_0.5_2same_h2, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_2_h1 <- lapply(dfsIPIP_Asplit_0.2_2_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_2_h1 <- lapply(dfsIPIP_Asplit_0.5_2_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_2_h2 <- lapply(dfsIPIP_Asplit_0.2_2_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_2_h2 <- lapply(dfsIPIP_Asplit_0.5_2_h2, setNames, nm = colnames_N)}



##########



### Sample 3 items per facet (i.e. per node)


#create lists for the nSim dataframes: per dimension, per nSamp, for ncol = 3

{#for NEO scale
  NEO_samples_A_0.2_3 = NEO_samples_A_0.5_3 = NEO_samples_A_0.8_3 = NEO_samples_A_1.0_3 <- list()
  NEO_samples_Asplit_0.2_3same = NEO_samples_Asplit_0.5_3same <- list()
  NEO_samples_Asplit_0.2_3 = NEO_samples_Asplit_0.5_3 <- list()} 

{#for IPIP scale
  IPIP_samples_A_0.2_3 = IPIP_samples_A_0.5_3 = IPIP_samples_A_0.8_3 = IPIP_samples_A_1.0_3 <- list()
  IPIP_samples_Asplit_0.2_3same = IPIP_samples_Asplit_0.5_3same <- list()
  IPIP_samples_Asplit_0.2_3 = IPIP_samples_Asplit_0.5_3 <- list()}



# Generate dataframes

# CONDITION II. Scale Variability, i.e. ("_DD") condition
# SAME sample + DIFF scale (ncol = 3)

set.seed(123123) #set the seed for reproducible results
for(i in 1:6){
  
  #create nested lists
  NEO_samples_A_0.2_3[[i]] = NEO_samples_A_0.5_3[[i]] = NEO_samples_A_0.8_3[[i]] = NEO_samples_A_1.0_3[[i]] <- list() 
  IPIP_samples_A_0.2_3[[i]] = IPIP_samples_A_0.5_3[[i]] = IPIP_samples_A_0.8_3[[i]] = IPIP_samples_A_1.0_3[[i]] <- list()
  
  for (l in 1:nSim){
    
    # CONDITION II. (ncol = 3)
    
    #apply random column selection function
    NEO_samples_A_0.2_3[[i]][[l]] <- lapply(NEO_samples_A_0.2[[i]][[l]], func_colselect_3)
    NEO_samples_A_0.5_3[[i]][[l]] <- lapply(NEO_samples_A_0.5[[i]][[l]], func_colselect_3)
    NEO_samples_A_0.8_3[[i]][[l]] <- lapply(NEO_samples_A_0.8[[i]][[l]], func_colselect_3)
    NEO_samples_A_1.0_3[[i]][[l]] <- lapply(NEO_samples_A_1.0[[i]][[l]], func_colselect_3)
    
    IPIP_samples_A_0.2_3[[i]][[l]] <- lapply(IPIP_samples_A_0.2[[i]][[l]], func_colselect_3)
    IPIP_samples_A_0.5_3[[i]][[l]] <- lapply(IPIP_samples_A_0.5[[i]][[l]], func_colselect_3)
    IPIP_samples_A_0.8_3[[i]][[l]] <- lapply(IPIP_samples_A_0.8[[i]][[l]], func_colselect_3)
    IPIP_samples_A_1.0_3[[i]][[l]] <- lapply(IPIP_samples_A_1.0[[i]][[l]], func_colselect_3)
    
    #create sum score
    NEO_samples_A_0.2_3[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.2_3[[i]][[l]][[1]][,1] + NEO_samples_A_0.2_3[[i]][[l]][[1]][,2] + NEO_samples_A_0.2_3[[i]][[l]][[1]][,3])
    NEO_samples_A_0.5_3[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.5_3[[i]][[l]][[1]][,1] + NEO_samples_A_0.5_3[[i]][[l]][[1]][,2] + NEO_samples_A_0.5_3[[i]][[l]][[1]][,3])
    NEO_samples_A_0.8_3[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.8_3[[i]][[l]][[1]][,1] + NEO_samples_A_0.8_3[[i]][[l]][[1]][,2] + NEO_samples_A_0.8_3[[i]][[l]][[1]][,3])
    NEO_samples_A_1.0_3[[i]][[l]][[1]]$sum <- (NEO_samples_A_1.0_3[[i]][[l]][[1]][,1] + NEO_samples_A_1.0_3[[i]][[l]][[1]][,2] + NEO_samples_A_1.0_3[[i]][[l]][[1]][,3])
    
    IPIP_samples_A_0.2_3[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.2_3[[i]][[l]][[1]][,1] + IPIP_samples_A_0.2_3[[i]][[l]][[1]][,2] + IPIP_samples_A_0.2_3[[i]][[l]][[1]][,3])
    IPIP_samples_A_0.5_3[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.5_3[[i]][[l]][[1]][,1] + IPIP_samples_A_0.5_3[[i]][[l]][[1]][,2] + IPIP_samples_A_0.5_3[[i]][[l]][[1]][,3])
    IPIP_samples_A_0.8_3[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.8_3[[i]][[l]][[1]][,1] + IPIP_samples_A_0.8_3[[i]][[l]][[1]][,2] + IPIP_samples_A_0.8_3[[i]][[l]][[1]][,3])
    IPIP_samples_A_1.0_3[[i]][[l]][[1]]$sum <- (IPIP_samples_A_1.0_3[[i]][[l]][[1]][,1] + IPIP_samples_A_1.0_3[[i]][[l]][[1]][,2] + IPIP_samples_A_1.0_3[[i]][[l]][[1]][,3])
  }
}


# Generate dataframes

# CONDITION I. Sampling Variability, i.e. ("split_SS") condition
# i.e. INDEP samples + SAME scale (ncol = 3)

# CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition
# i.e. INDEP samples + DIFF scale (ncol = 3)

set.seed(123123) #set the seed for reproducible results
for (i in 1:6){
  
  #create nested lists
  NEO_samples_Asplit_0.2_3same[[i]] = NEO_samples_Asplit_0.5_3same[[i]] <- list()
  IPIP_samples_Asplit_0.2_3same[[i]] = IPIP_samples_Asplit_0.5_3same[[i]] <- list()
  
  NEO_samples_Asplit_0.2_3[[i]] = NEO_samples_Asplit_0.5_3[[i]] <- list()
  IPIP_samples_Asplit_0.2_3[[i]] = IPIP_samples_Asplit_0.5_3[[i]] <- list()
  
  for (l in 1:nSim){
    
    #create further nesting
    NEO_samples_Asplit_0.2_3same[[i]][[l]] = NEO_samples_Asplit_0.5_3same[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_3same[[i]][[l]] = IPIP_samples_Asplit_0.5_3same[[i]][[l]] <- list()
    
    NEO_samples_Asplit_0.2_3[[i]][[l]] = NEO_samples_Asplit_0.5_3[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_3[[i]][[l]] = IPIP_samples_Asplit_0.5_3[[i]][[l]] <- list()
    
    for (h in 1:1){ 
      
      # CONDITION I. (ncol = 3)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_3same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_3same)
      NEO_samples_Asplit_0.5_3same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_3same)
      
      IPIP_samples_Asplit_0.2_3same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_3same)
      IPIP_samples_Asplit_0.5_3same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_3same)
      
      # CONDITION III. (ncol = 3)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_3[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_3)
      NEO_samples_Asplit_0.5_3[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_3)
      
      IPIP_samples_Asplit_0.2_3[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_3)
      IPIP_samples_Asplit_0.5_3[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_3)
    }
  }
}


for (i in 1:6){
  for (l in 1:nSim){
    for (h in 1:2) {
      
      #create sum score
      NEO_samples_Asplit_0.2_3same[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.2_3same[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.2_3same[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.2_3same[[i]][[l]][[1]][[h]][,3])
      NEO_samples_Asplit_0.5_3same[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.5_3same[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.5_3same[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.5_3same[[i]][[l]][[1]][[h]][,3])
      
      IPIP_samples_Asplit_0.2_3same[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.2_3same[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.2_3same[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.2_3same[[i]][[l]][[1]][[h]][,3])
      IPIP_samples_Asplit_0.5_3same[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.5_3same[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.5_3same[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.5_3same[[i]][[l]][[1]][[h]][,3])
      
      #create sum score
      NEO_samples_Asplit_0.2_3[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.2_3[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.2_3[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.2_3[[i]][[l]][[1]][[h]][,3])
      NEO_samples_Asplit_0.5_3[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.5_3[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.5_3[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.5_3[[i]][[l]][[1]][[h]][,3])
      
      IPIP_samples_Asplit_0.2_3[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.2_3[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.2_3[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.2_3[[i]][[l]][[1]][[h]][,3])
      IPIP_samples_Asplit_0.5_3[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.5_3[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.5_3[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.5_3[[i]][[l]][[1]][[h]][,3])
    }
  }
}



#store randomly selected columns together

{# CONDITION I. (ncol = 3)
  dfsNEO_Asplit_0.2_3same_h1 = dfsNEO_Asplit_0.5_3same_h1 <- list() 
  dfsNEO_Asplit_0.2_3same_h2 = dfsNEO_Asplit_0.5_3same_h2 <- list() 
  
  dfsIPIP_Asplit_0.2_3same_h1 = dfsIPIP_Asplit_0.5_3same_h1 <- list() 
  dfsIPIP_Asplit_0.2_3same_h2 = dfsIPIP_Asplit_0.5_3same_h2 <- list()}

{# CONDITION II. (ncol = 3)
  dfsNEO_A_0.2_3 = dfsNEO_A_0.5_3 = dfsNEO_A_0.8_3 = dfsNEO_A_1.0_3 <- list()
  dfsIPIP_A_0.2_3 = dfsIPIP_A_0.5_3 = dfsIPIP_A_0.8_3 = dfsIPIP_A_1.0_3 <- list()}

{# CONDITION III. (ncol = 3)
  dfsNEO_Asplit_0.2_3_h1 = dfsNEO_Asplit_0.5_3_h1 <- list() 
  dfsNEO_Asplit_0.2_3_h2 = dfsNEO_Asplit_0.5_3_h2 <- list() 
  
  dfsIPIP_Asplit_0.2_3_h1 = dfsIPIP_Asplit_0.5_3_h1 <- list() 
  dfsIPIP_Asplit_0.2_3_h2 = dfsIPIP_Asplit_0.5_3_h2 <- list()}



set.seed(123123) #set the seed for reproducible results

for (l in 1:nSim){
  
  # CONDITION I. (ncol = 3)
  dfsNEO_Asplit_0.2_3same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_3same[[1]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_3same[[2]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_3same[[3]][[l]][[1]]$half1_0.2$sum,
                                                      NEO_samples_Asplit_0.2_3same[[4]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_3same[[5]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_3same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsNEO_Asplit_0.2_3same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_3same[[1]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_3same[[2]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_3same[[3]][[l]][[1]]$half2_0.2$sum,
                                                      NEO_samples_Asplit_0.2_3same[[4]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_3same[[5]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_3same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsNEO_Asplit_0.5_3same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_3same[[1]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_3same[[2]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_3same[[3]][[l]][[1]]$half1_0.5$sum,
                                                      NEO_samples_Asplit_0.5_3same[[4]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_3same[[5]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_3same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsNEO_Asplit_0.5_3same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_3same[[1]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_3same[[2]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_3same[[3]][[l]][[1]]$half2_0.5$sum,
                                                      NEO_samples_Asplit_0.5_3same[[4]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_3same[[5]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_3same[[6]][[l]][[1]]$half2_0.5$sum)
  
  dfsIPIP_Asplit_0.2_3same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_3same[[1]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_3same[[2]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_3same[[3]][[l]][[1]]$half1_0.2$sum,
                                                       IPIP_samples_Asplit_0.2_3same[[4]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_3same[[5]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_3same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsIPIP_Asplit_0.2_3same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_3same[[1]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_3same[[2]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_3same[[3]][[l]][[1]]$half2_0.2$sum,
                                                       IPIP_samples_Asplit_0.2_3same[[4]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_3same[[5]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_3same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsIPIP_Asplit_0.5_3same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_3same[[1]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_3same[[2]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_3same[[3]][[l]][[1]]$half1_0.5$sum,
                                                       IPIP_samples_Asplit_0.5_3same[[4]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_3same[[5]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_3same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsIPIP_Asplit_0.5_3same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_3same[[1]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_3same[[2]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_3same[[3]][[l]][[1]]$half2_0.5$sum,
                                                       IPIP_samples_Asplit_0.5_3same[[4]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_3same[[5]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_3same[[6]][[l]][[1]]$half2_0.5$sum)
  
  # CONDITION II. (ncol = 3)
  dfsNEO_A_0.2_3[[l]] <- cbind.data.frame(NEO_samples_A_0.2_3[[1]][[l]][[1]]$sum, NEO_samples_A_0.2_3[[2]][[l]][[1]]$sum, NEO_samples_A_0.2_3[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.2_3[[4]][[l]][[1]]$sum, NEO_samples_A_0.2_3[[5]][[l]][[1]]$sum, NEO_samples_A_0.2_3[[6]][[l]][[1]]$sum)
  dfsNEO_A_0.5_3[[l]] <- cbind.data.frame(NEO_samples_A_0.5_3[[1]][[l]][[1]]$sum, NEO_samples_A_0.5_3[[2]][[l]][[1]]$sum, NEO_samples_A_0.5_3[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.5_3[[4]][[l]][[1]]$sum, NEO_samples_A_0.5_3[[5]][[l]][[1]]$sum, NEO_samples_A_0.5_3[[6]][[l]][[1]]$sum)
  dfsNEO_A_0.8_3[[l]] <- cbind.data.frame(NEO_samples_A_0.8_3[[1]][[l]][[1]]$sum, NEO_samples_A_0.8_3[[2]][[l]][[1]]$sum, NEO_samples_A_0.8_3[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.8_3[[4]][[l]][[1]]$sum, NEO_samples_A_0.8_3[[5]][[l]][[1]]$sum, NEO_samples_A_0.8_3[[6]][[l]][[1]]$sum)
  dfsNEO_A_1.0_3[[l]] <- cbind.data.frame(NEO_samples_A_1.0_3[[1]][[l]][[1]]$sum, NEO_samples_A_1.0_3[[2]][[l]][[1]]$sum, NEO_samples_A_1.0_3[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_1.0_3[[4]][[l]][[1]]$sum, NEO_samples_A_1.0_3[[5]][[l]][[1]]$sum, NEO_samples_A_1.0_3[[6]][[l]][[1]]$sum)
  
  dfsIPIP_A_0.2_3[[l]] <- cbind.data.frame(IPIP_samples_A_0.2_3[[1]][[l]][[1]]$sum, IPIP_samples_A_0.2_3[[2]][[l]][[1]]$sum, IPIP_samples_A_0.2_3[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.2_3[[4]][[l]][[1]]$sum, IPIP_samples_A_0.2_3[[5]][[l]][[1]]$sum, IPIP_samples_A_0.2_3[[6]][[l]][[1]]$sum)
  dfsIPIP_A_0.5_3[[l]] <- cbind.data.frame(IPIP_samples_A_0.5_3[[1]][[l]][[1]]$sum, IPIP_samples_A_0.5_3[[2]][[l]][[1]]$sum, IPIP_samples_A_0.5_3[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.5_3[[4]][[l]][[1]]$sum, IPIP_samples_A_0.5_3[[5]][[l]][[1]]$sum, IPIP_samples_A_0.5_3[[6]][[l]][[1]]$sum)
  dfsIPIP_A_0.8_3[[l]] <- cbind.data.frame(IPIP_samples_A_0.8_3[[1]][[l]][[1]]$sum, IPIP_samples_A_0.8_3[[2]][[l]][[1]]$sum, IPIP_samples_A_0.8_3[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.8_3[[4]][[l]][[1]]$sum, IPIP_samples_A_0.8_3[[5]][[l]][[1]]$sum, IPIP_samples_A_0.8_3[[6]][[l]][[1]]$sum)
  dfsIPIP_A_1.0_3[[l]] <- cbind.data.frame(IPIP_samples_A_1.0_3[[1]][[l]][[1]]$sum, IPIP_samples_A_1.0_3[[2]][[l]][[1]]$sum, IPIP_samples_A_1.0_3[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_1.0_3[[4]][[l]][[1]]$sum, IPIP_samples_A_1.0_3[[5]][[l]][[1]]$sum, IPIP_samples_A_1.0_3[[6]][[l]][[1]]$sum)
  
  # CONDITION III. (ncol = 3)
  dfsNEO_Asplit_0.2_3_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_3[[1]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_3[[2]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_3[[3]][[l]][[1]]$half1_0.2$sum,
                                                  NEO_samples_Asplit_0.2_3[[4]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_3[[5]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_3[[6]][[l]][[1]]$half1_0.2$sum)
  dfsNEO_Asplit_0.2_3_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_3[[1]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_3[[2]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_3[[3]][[l]][[1]]$half2_0.2$sum,
                                                  NEO_samples_Asplit_0.2_3[[4]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_3[[5]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_3[[6]][[l]][[1]]$half2_0.2$sum)
  dfsNEO_Asplit_0.5_3_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_3[[1]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_3[[2]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_3[[3]][[l]][[1]]$half1_0.5$sum,
                                                  NEO_samples_Asplit_0.5_3[[4]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_3[[5]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_3[[6]][[l]][[1]]$half1_0.5$sum)
  dfsNEO_Asplit_0.5_3_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_3[[1]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_3[[2]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_3[[3]][[l]][[1]]$half2_0.5$sum,
                                                  NEO_samples_Asplit_0.5_3[[4]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_3[[5]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_3[[6]][[l]][[1]]$half2_0.5$sum)
  
  dfsIPIP_Asplit_0.2_3_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_3[[1]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_3[[2]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_3[[3]][[l]][[1]]$half1_0.2$sum,
                                                   IPIP_samples_Asplit_0.2_3[[4]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_3[[5]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_3[[6]][[l]][[1]]$half1_0.2$sum)
  dfsIPIP_Asplit_0.2_3_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_3[[1]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_3[[2]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_3[[3]][[l]][[1]]$half2_0.2$sum,
                                                   IPIP_samples_Asplit_0.2_3[[4]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_3[[5]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_3[[6]][[l]][[1]]$half2_0.2$sum)
  dfsIPIP_Asplit_0.5_3_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_3[[1]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_3[[2]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_3[[3]][[l]][[1]]$half1_0.5$sum,
                                                   IPIP_samples_Asplit_0.5_3[[4]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_3[[5]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_3[[6]][[l]][[1]]$half1_0.5$sum)
  dfsIPIP_Asplit_0.5_3_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_3[[1]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_3[[2]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_3[[3]][[l]][[1]]$half2_0.5$sum,
                                                   IPIP_samples_Asplit_0.5_3[[4]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_3[[5]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_3[[6]][[l]][[1]]$half2_0.5$sum)
} #returns lists of nSim dataframes



#rename dataframe columns such that NEO and IPIP have matching names for netcompare step

colnames_N <- c("N1", "N2", "N3", "N4", "N5", "N6")

{# NEO ncol=3 dataframes
  dfsNEO_A_0.2_3 <- lapply(dfsNEO_A_0.2_3, setNames, nm = colnames_N)
  dfsNEO_A_0.5_3 <- lapply(dfsNEO_A_0.5_3, setNames, nm = colnames_N)
  dfsNEO_A_0.8_3 <- lapply(dfsNEO_A_0.8_3, setNames, nm = colnames_N)
  dfsNEO_A_1.0_3 <- lapply(dfsNEO_A_1.0_3, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_3same_h1 <- lapply(dfsNEO_Asplit_0.2_3same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_3same_h1 <- lapply(dfsNEO_Asplit_0.5_3same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_3same_h2 <- lapply(dfsNEO_Asplit_0.2_3same_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_3same_h2 <- lapply(dfsNEO_Asplit_0.5_3same_h2, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_3_h1 <- lapply(dfsNEO_Asplit_0.2_3_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_3_h1 <- lapply(dfsNEO_Asplit_0.5_3_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_3_h2 <- lapply(dfsNEO_Asplit_0.2_3_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_3_h2 <- lapply(dfsNEO_Asplit_0.5_3_h2, setNames, nm = colnames_N)}

{# IPIP ncol=3 dataframes
  dfsIPIP_A_0.2_3 <- lapply(dfsIPIP_A_0.2_3, setNames, nm = colnames_N)
  dfsIPIP_A_0.5_3 <- lapply(dfsIPIP_A_0.5_3, setNames, nm = colnames_N)
  dfsIPIP_A_0.8_3 <- lapply(dfsIPIP_A_0.8_3, setNames, nm = colnames_N)
  dfsIPIP_A_1.0_3 <- lapply(dfsIPIP_A_1.0_3, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_3same_h1 <- lapply(dfsIPIP_Asplit_0.2_3same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_3same_h1 <- lapply(dfsIPIP_Asplit_0.5_3same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_3same_h2 <- lapply(dfsIPIP_Asplit_0.2_3same_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_3same_h2 <- lapply(dfsIPIP_Asplit_0.5_3same_h2, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_3_h1 <- lapply(dfsIPIP_Asplit_0.2_3_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_3_h1 <- lapply(dfsIPIP_Asplit_0.5_3_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_3_h2 <- lapply(dfsIPIP_Asplit_0.2_3_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_3_h2 <- lapply(dfsIPIP_Asplit_0.5_3_h2, setNames, nm = colnames_N)}



##########



### Sample 5 items per facet (i.e. per node)


#create lists for the nSim dataframes: per dimension, per nSamp, for ncol = 5

{#for NEO scale
  NEO_samples_A_0.2_5 = NEO_samples_A_0.5_5 = NEO_samples_A_0.8_5 = NEO_samples_A_1.0_5 <- list() 
  NEO_samples_Asplit_0.2_5same = NEO_samples_Asplit_0.5_5same <- list()
  NEO_samples_Asplit_0.2_5 = NEO_samples_Asplit_0.5_5 <- list()}

{#for IPIP scale
  IPIP_samples_A_0.2_5 = IPIP_samples_A_0.5_5 = IPIP_samples_A_0.8_5 = IPIP_samples_A_1.0_5 <- list()
  IPIP_samples_Asplit_0.2_5same = IPIP_samples_Asplit_0.5_5same <- list()
  IPIP_samples_Asplit_0.2_5 = IPIP_samples_Asplit_0.5_5 <- list()}



# Generate dataframes

# CONDITION II. Scale Variability, i.e. ("_DD") condition
# i.e. SAME sample + DIFF scale (ncol = 5)

set.seed(123123) #set the seed for reproducible results
for(i in 1:6){
  
  #create nested lists
  NEO_samples_A_0.2_5[[i]] = NEO_samples_A_0.5_5[[i]] = NEO_samples_A_0.8_5[[i]] = NEO_samples_A_1.0_5[[i]] <- list() 
  IPIP_samples_A_0.2_5[[i]] = IPIP_samples_A_0.5_5[[i]] = IPIP_samples_A_0.8_5[[i]] = IPIP_samples_A_1.0_5[[i]] <- list()
  
  for (l in 1:nSim){
    
    # CONDITION II. (ncol = 5)
    
    #apply random column selection function
    NEO_samples_A_0.2_5[[i]][[l]] <- lapply(NEO_samples_A_0.2[[i]][[l]], func_colselect_5)
    NEO_samples_A_0.5_5[[i]][[l]] <- lapply(NEO_samples_A_0.5[[i]][[l]], func_colselect_5)
    NEO_samples_A_0.8_5[[i]][[l]] <- lapply(NEO_samples_A_0.8[[i]][[l]], func_colselect_5)
    NEO_samples_A_1.0_5[[i]][[l]] <- lapply(NEO_samples_A_1.0[[i]][[l]], func_colselect_5)
    
    IPIP_samples_A_0.2_5[[i]][[l]] <- lapply(IPIP_samples_A_0.2[[i]][[l]], func_colselect_5)
    IPIP_samples_A_0.5_5[[i]][[l]] <- lapply(IPIP_samples_A_0.5[[i]][[l]], func_colselect_5)
    IPIP_samples_A_0.8_5[[i]][[l]] <- lapply(IPIP_samples_A_0.8[[i]][[l]], func_colselect_5)
    IPIP_samples_A_1.0_5[[i]][[l]] <- lapply(IPIP_samples_A_1.0[[i]][[l]], func_colselect_5)
    
    #create sum score
    NEO_samples_A_0.2_5[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.2_5[[i]][[l]][[1]][,1] + NEO_samples_A_0.2_5[[i]][[l]][[1]][,2] + NEO_samples_A_0.2_5[[i]][[l]][[1]][,3] + NEO_samples_A_0.2_5[[i]][[l]][[1]][,4] + NEO_samples_A_0.2_5[[i]][[l]][[1]][,5])
    NEO_samples_A_0.5_5[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.5_5[[i]][[l]][[1]][,1] + NEO_samples_A_0.5_5[[i]][[l]][[1]][,2] + NEO_samples_A_0.5_5[[i]][[l]][[1]][,3] + NEO_samples_A_0.5_5[[i]][[l]][[1]][,4] + NEO_samples_A_0.5_5[[i]][[l]][[1]][,5])
    NEO_samples_A_0.8_5[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.8_5[[i]][[l]][[1]][,1] + NEO_samples_A_0.8_5[[i]][[l]][[1]][,2] + NEO_samples_A_0.8_5[[i]][[l]][[1]][,3] + NEO_samples_A_0.8_5[[i]][[l]][[1]][,4] + NEO_samples_A_0.8_5[[i]][[l]][[1]][,5])
    NEO_samples_A_1.0_5[[i]][[l]][[1]]$sum <- (NEO_samples_A_1.0_5[[i]][[l]][[1]][,1] + NEO_samples_A_1.0_5[[i]][[l]][[1]][,2] + NEO_samples_A_1.0_5[[i]][[l]][[1]][,3] + NEO_samples_A_1.0_5[[i]][[l]][[1]][,4] + NEO_samples_A_1.0_5[[i]][[l]][[1]][,5])
    
    IPIP_samples_A_0.2_5[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.2_5[[i]][[l]][[1]][,1] + IPIP_samples_A_0.2_5[[i]][[l]][[1]][,2] + IPIP_samples_A_0.2_5[[i]][[l]][[1]][,3] + IPIP_samples_A_0.2_5[[i]][[l]][[1]][,4] + IPIP_samples_A_0.2_5[[i]][[l]][[1]][,5])
    IPIP_samples_A_0.5_5[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.5_5[[i]][[l]][[1]][,1] + IPIP_samples_A_0.5_5[[i]][[l]][[1]][,2] + IPIP_samples_A_0.5_5[[i]][[l]][[1]][,3] + IPIP_samples_A_0.5_5[[i]][[l]][[1]][,4] + IPIP_samples_A_0.5_5[[i]][[l]][[1]][,5])
    IPIP_samples_A_0.8_5[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.8_5[[i]][[l]][[1]][,1] + IPIP_samples_A_0.8_5[[i]][[l]][[1]][,2] + IPIP_samples_A_0.8_5[[i]][[l]][[1]][,3] + IPIP_samples_A_0.8_5[[i]][[l]][[1]][,4] + IPIP_samples_A_0.8_5[[i]][[l]][[1]][,5])
    IPIP_samples_A_1.0_5[[i]][[l]][[1]]$sum <- (IPIP_samples_A_1.0_5[[i]][[l]][[1]][,1] + IPIP_samples_A_1.0_5[[i]][[l]][[1]][,2] + IPIP_samples_A_1.0_5[[i]][[l]][[1]][,3] + IPIP_samples_A_1.0_5[[i]][[l]][[1]][,4] + IPIP_samples_A_1.0_5[[i]][[l]][[1]][,5])
  }
}


# Generate dataframes

# CONDITION I. Sampling Variability, i.e. ("split_SS") condition
# i.e. INDEP samples + SAME scale (ncol = 5)

# CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition
# i.e. INDEP samples + DIFF scale (ncol = 5)

set.seed(123123) #set the seed for reproducible results
for (i in 1:6){
  
  #create nested lists
  NEO_samples_Asplit_0.2_5same[[i]] = NEO_samples_Asplit_0.5_5same[[i]] <- list()
  IPIP_samples_Asplit_0.2_5same[[i]] = IPIP_samples_Asplit_0.5_5same[[i]] <- list()
  
  NEO_samples_Asplit_0.2_5[[i]] = NEO_samples_Asplit_0.5_5[[i]] <- list()
  IPIP_samples_Asplit_0.2_5[[i]] = IPIP_samples_Asplit_0.5_5[[i]] <- list()
  
  for (l in 1:nSim){
    
    #create further nesting
    NEO_samples_Asplit_0.2_5same[[i]][[l]] = NEO_samples_Asplit_0.5_5same[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_5same[[i]][[l]] = IPIP_samples_Asplit_0.5_5same[[i]][[l]] <- list()
    
    NEO_samples_Asplit_0.2_5[[i]][[l]] = NEO_samples_Asplit_0.5_5[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_5[[i]][[l]] = IPIP_samples_Asplit_0.5_5[[i]][[l]] <- list()
    
    for (h in 1:1){ 
      
      # CONDITION I. (ncol = 5)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_5same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_5same)
      NEO_samples_Asplit_0.5_5same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_5same)
      
      IPIP_samples_Asplit_0.2_5same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_5same)
      IPIP_samples_Asplit_0.5_5same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_5same)
      
      # CONDITION III. (ncol = 5)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_5[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_5)
      NEO_samples_Asplit_0.5_5[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_5)
      
      IPIP_samples_Asplit_0.2_5[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_5)
      IPIP_samples_Asplit_0.5_5[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_5)
    }
  }
}


for (i in 1:6){
  for (l in 1:nSim){
    for (h in 1:2) {
      
      #create sum score
      NEO_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,3] + NEO_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,4] + NEO_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,5])
      NEO_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,3] + NEO_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,4] + NEO_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,5])
      
      IPIP_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,3] + IPIP_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,4] + IPIP_samples_Asplit_0.2_5same[[i]][[l]][[1]][[h]][,5])
      IPIP_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,3] + IPIP_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,4] + IPIP_samples_Asplit_0.5_5same[[i]][[l]][[1]][[h]][,5])
      
      #create sum score
      NEO_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,3] + NEO_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,4] + NEO_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,5])
      NEO_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,3] + NEO_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,4] + NEO_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,5])
      
      IPIP_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,3] + IPIP_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,4] + IPIP_samples_Asplit_0.2_5[[i]][[l]][[1]][[h]][,5])
      IPIP_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,3] + IPIP_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,4] + IPIP_samples_Asplit_0.5_5[[i]][[l]][[1]][[h]][,5])
    }
  }
}



#store randomly selected columns together

{# CONDITION I. (ncol = 5)
  dfsNEO_Asplit_0.2_5same_h1 = dfsNEO_Asplit_0.5_5same_h1 <- list() 
  dfsNEO_Asplit_0.2_5same_h2 = dfsNEO_Asplit_0.5_5same_h2 <- list() 
  
  dfsIPIP_Asplit_0.2_5same_h1 = dfsIPIP_Asplit_0.5_5same_h1 <- list() 
  dfsIPIP_Asplit_0.2_5same_h2 = dfsIPIP_Asplit_0.5_5same_h2 <- list()}

{# CONDITION II. (ncol = 5)
  dfsNEO_A_0.2_5 = dfsNEO_A_0.5_5 = dfsNEO_A_0.8_5 = dfsNEO_A_1.0_5 <- list()
  dfsIPIP_A_0.2_5 = dfsIPIP_A_0.5_5 = dfsIPIP_A_0.8_5 = dfsIPIP_A_1.0_5 <- list()}

{# CONDITION III. (ncol = 5)
  dfsNEO_Asplit_0.2_5_h1 = dfsNEO_Asplit_0.5_5_h1 <- list() 
  dfsNEO_Asplit_0.2_5_h2 = dfsNEO_Asplit_0.5_5_h2 <- list() 
  
  dfsIPIP_Asplit_0.2_5_h1 = dfsIPIP_Asplit_0.5_5_h1 <- list() 
  dfsIPIP_Asplit_0.2_5_h2 = dfsIPIP_Asplit_0.5_5_h2 <- list()}



set.seed(123123) #set the seed for reproducible results

for (l in 1:nSim){
  
  # CONDITION I. (ncol = 5)
  dfsNEO_Asplit_0.2_5same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_5same[[1]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_5same[[2]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_5same[[3]][[l]][[1]]$half1_0.2$sum,
                                                      NEO_samples_Asplit_0.2_5same[[4]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_5same[[5]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_5same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsNEO_Asplit_0.2_5same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_5same[[1]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_5same[[2]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_5same[[3]][[l]][[1]]$half2_0.2$sum,
                                                      NEO_samples_Asplit_0.2_5same[[4]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_5same[[5]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_5same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsNEO_Asplit_0.5_5same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_5same[[1]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_5same[[2]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_5same[[3]][[l]][[1]]$half1_0.5$sum,
                                                      NEO_samples_Asplit_0.5_5same[[4]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_5same[[5]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_5same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsNEO_Asplit_0.5_5same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_5same[[1]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_5same[[2]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_5same[[3]][[l]][[1]]$half2_0.5$sum,
                                                      NEO_samples_Asplit_0.5_5same[[4]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_5same[[5]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_5same[[6]][[l]][[1]]$half2_0.5$sum)
  
  dfsIPIP_Asplit_0.2_5same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_5same[[1]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_5same[[2]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_5same[[3]][[l]][[1]]$half1_0.2$sum,
                                                       IPIP_samples_Asplit_0.2_5same[[4]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_5same[[5]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_5same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsIPIP_Asplit_0.2_5same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_5same[[1]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_5same[[2]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_5same[[3]][[l]][[1]]$half2_0.2$sum,
                                                       IPIP_samples_Asplit_0.2_5same[[4]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_5same[[5]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_5same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsIPIP_Asplit_0.5_5same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_5same[[1]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_5same[[2]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_5same[[3]][[l]][[1]]$half1_0.5$sum,
                                                       IPIP_samples_Asplit_0.5_5same[[4]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_5same[[5]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_5same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsIPIP_Asplit_0.5_5same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_5same[[1]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_5same[[2]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_5same[[3]][[l]][[1]]$half2_0.5$sum,
                                                       IPIP_samples_Asplit_0.5_5same[[4]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_5same[[5]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_5same[[6]][[l]][[1]]$half2_0.5$sum)
  
  # CONDITION II. (ncol = 5)
  dfsNEO_A_0.2_5[[l]] <- cbind.data.frame(NEO_samples_A_0.2_5[[1]][[l]][[1]]$sum, NEO_samples_A_0.2_5[[2]][[l]][[1]]$sum, NEO_samples_A_0.2_5[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.2_5[[4]][[l]][[1]]$sum, NEO_samples_A_0.2_5[[5]][[l]][[1]]$sum, NEO_samples_A_0.2_5[[6]][[l]][[1]]$sum)
  dfsNEO_A_0.5_5[[l]] <- cbind.data.frame(NEO_samples_A_0.5_5[[1]][[l]][[1]]$sum, NEO_samples_A_0.5_5[[2]][[l]][[1]]$sum, NEO_samples_A_0.5_5[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.5_5[[4]][[l]][[1]]$sum, NEO_samples_A_0.5_5[[5]][[l]][[1]]$sum, NEO_samples_A_0.5_5[[6]][[l]][[1]]$sum)
  dfsNEO_A_0.8_5[[l]] <- cbind.data.frame(NEO_samples_A_0.8_5[[1]][[l]][[1]]$sum, NEO_samples_A_0.8_5[[2]][[l]][[1]]$sum, NEO_samples_A_0.8_5[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.8_5[[4]][[l]][[1]]$sum, NEO_samples_A_0.8_5[[5]][[l]][[1]]$sum, NEO_samples_A_0.8_5[[6]][[l]][[1]]$sum)
  dfsNEO_A_1.0_5[[l]] <- cbind.data.frame(NEO_samples_A_1.0_5[[1]][[l]][[1]]$sum, NEO_samples_A_1.0_5[[2]][[l]][[1]]$sum, NEO_samples_A_1.0_5[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_1.0_5[[4]][[l]][[1]]$sum, NEO_samples_A_1.0_5[[5]][[l]][[1]]$sum, NEO_samples_A_1.0_5[[6]][[l]][[1]]$sum)
  
  dfsIPIP_A_0.2_5[[l]] <- cbind.data.frame(IPIP_samples_A_0.2_5[[1]][[l]][[1]]$sum, IPIP_samples_A_0.2_5[[2]][[l]][[1]]$sum, IPIP_samples_A_0.2_5[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.2_5[[4]][[l]][[1]]$sum, IPIP_samples_A_0.2_5[[5]][[l]][[1]]$sum, IPIP_samples_A_0.2_5[[6]][[l]][[1]]$sum)
  dfsIPIP_A_0.5_5[[l]] <- cbind.data.frame(IPIP_samples_A_0.5_5[[1]][[l]][[1]]$sum, IPIP_samples_A_0.5_5[[2]][[l]][[1]]$sum, IPIP_samples_A_0.5_5[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.5_5[[4]][[l]][[1]]$sum, IPIP_samples_A_0.5_5[[5]][[l]][[1]]$sum, IPIP_samples_A_0.5_5[[6]][[l]][[1]]$sum)
  dfsIPIP_A_0.8_5[[l]] <- cbind.data.frame(IPIP_samples_A_0.8_5[[1]][[l]][[1]]$sum, IPIP_samples_A_0.8_5[[2]][[l]][[1]]$sum, IPIP_samples_A_0.8_5[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.8_5[[4]][[l]][[1]]$sum, IPIP_samples_A_0.8_5[[5]][[l]][[1]]$sum, IPIP_samples_A_0.8_5[[6]][[l]][[1]]$sum)
  dfsIPIP_A_1.0_5[[l]] <- cbind.data.frame(IPIP_samples_A_1.0_5[[1]][[l]][[1]]$sum, IPIP_samples_A_1.0_5[[2]][[l]][[1]]$sum, IPIP_samples_A_1.0_5[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_1.0_5[[4]][[l]][[1]]$sum, IPIP_samples_A_1.0_5[[5]][[l]][[1]]$sum, IPIP_samples_A_1.0_5[[6]][[l]][[1]]$sum)
  
  # CONDITION III. (ncol = 5)
  dfsNEO_Asplit_0.2_5_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_5[[1]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_5[[2]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_5[[3]][[l]][[1]]$half1_0.2$sum,
                                                  NEO_samples_Asplit_0.2_5[[4]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_5[[5]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_5[[6]][[l]][[1]]$half1_0.2$sum)
  dfsNEO_Asplit_0.2_5_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_5[[1]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_5[[2]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_5[[3]][[l]][[1]]$half2_0.2$sum,
                                                  NEO_samples_Asplit_0.2_5[[4]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_5[[5]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_5[[6]][[l]][[1]]$half2_0.2$sum)
  dfsNEO_Asplit_0.5_5_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_5[[1]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_5[[2]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_5[[3]][[l]][[1]]$half1_0.5$sum,
                                                  NEO_samples_Asplit_0.5_5[[4]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_5[[5]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_5[[6]][[l]][[1]]$half1_0.5$sum)
  dfsNEO_Asplit_0.5_5_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_5[[1]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_5[[2]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_5[[3]][[l]][[1]]$half2_0.5$sum,
                                                  NEO_samples_Asplit_0.5_5[[4]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_5[[5]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_5[[6]][[l]][[1]]$half2_0.5$sum)
  
  dfsIPIP_Asplit_0.2_5_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_5[[1]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_5[[2]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_5[[3]][[l]][[1]]$half1_0.2$sum,
                                                   IPIP_samples_Asplit_0.2_5[[4]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_5[[5]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_5[[6]][[l]][[1]]$half1_0.2$sum)
  dfsIPIP_Asplit_0.2_5_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_5[[1]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_5[[2]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_5[[3]][[l]][[1]]$half2_0.2$sum,
                                                   IPIP_samples_Asplit_0.2_5[[4]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_5[[5]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_5[[6]][[l]][[1]]$half2_0.2$sum)
  dfsIPIP_Asplit_0.5_5_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_5[[1]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_5[[2]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_5[[3]][[l]][[1]]$half1_0.5$sum,
                                                   IPIP_samples_Asplit_0.5_5[[4]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_5[[5]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_5[[6]][[l]][[1]]$half1_0.5$sum)
  dfsIPIP_Asplit_0.5_5_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_5[[1]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_5[[2]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_5[[3]][[l]][[1]]$half2_0.5$sum,
                                                   IPIP_samples_Asplit_0.5_5[[4]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_5[[5]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_5[[6]][[l]][[1]]$half2_0.5$sum)
} #returns lists of nSim dataframes



#rename dataframe columns such that NEO and IPIP have matching names for netcompare step

colnames_N <- c("N1", "N2", "N3", "N4", "N5", "N6")

{# NEO ncol=5 dataframes
  dfsNEO_A_0.2_5 <- lapply(dfsNEO_A_0.2_5, setNames, nm = colnames_N)
  dfsNEO_A_0.5_5 <- lapply(dfsNEO_A_0.5_5, setNames, nm = colnames_N)
  dfsNEO_A_0.8_5 <- lapply(dfsNEO_A_0.8_5, setNames, nm = colnames_N)
  dfsNEO_A_1.0_5 <- lapply(dfsNEO_A_1.0_5, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_5same_h1 <- lapply(dfsNEO_Asplit_0.2_5same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_5same_h1 <- lapply(dfsNEO_Asplit_0.5_5same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_5same_h2 <- lapply(dfsNEO_Asplit_0.2_5same_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_5same_h2 <- lapply(dfsNEO_Asplit_0.5_5same_h2, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_5_h1 <- lapply(dfsNEO_Asplit_0.2_5_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_5_h1 <- lapply(dfsNEO_Asplit_0.5_5_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_5_h2 <- lapply(dfsNEO_Asplit_0.2_5_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_5_h2 <- lapply(dfsNEO_Asplit_0.5_5_h2, setNames, nm = colnames_N)}

{# IPIP ncol=5 dataframes
  dfsIPIP_A_0.2_5 <- lapply(dfsIPIP_A_0.2_5, setNames, nm = colnames_N)
  dfsIPIP_A_0.5_5 <- lapply(dfsIPIP_A_0.5_5, setNames, nm = colnames_N)
  dfsIPIP_A_0.8_5 <- lapply(dfsIPIP_A_0.8_5, setNames, nm = colnames_N)
  dfsIPIP_A_1.0_5 <- lapply(dfsIPIP_A_1.0_5, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_5same_h1 <- lapply(dfsIPIP_Asplit_0.2_5same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_5same_h1 <- lapply(dfsIPIP_Asplit_0.5_5same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_5same_h2 <- lapply(dfsIPIP_Asplit_0.2_5same_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_5same_h2 <- lapply(dfsIPIP_Asplit_0.5_5same_h2, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_5_h1 <- lapply(dfsIPIP_Asplit_0.2_5_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_5_h1 <- lapply(dfsIPIP_Asplit_0.5_5_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_5_h2 <- lapply(dfsIPIP_Asplit_0.2_5_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_5_h2 <- lapply(dfsIPIP_Asplit_0.5_5_h2, setNames, nm = colnames_N)}



##########



### Sample 8 items per facet (i.e. per node)


#create lists for the nSim dataframes: per dimension, per nSamp, for ncol = 8

{#for NEO scale
  NEO_samples_A_0.2_8 = NEO_samples_A_0.5_8 = NEO_samples_A_0.8_8 = NEO_samples_A_1.0_8 <- list() 
  NEO_samples_Asplit_0.2_8same = NEO_samples_Asplit_0.5_8same <- list()
  NEO_samples_Asplit_0.2_8 = NEO_samples_Asplit_0.5_8 <- list()}

{#for IPIP scale
  IPIP_samples_A_0.2_8 = IPIP_samples_A_0.5_8 = IPIP_samples_A_0.8_8 = IPIP_samples_A_1.0_8 <- list()
  IPIP_samples_Asplit_0.2_8same = IPIP_samples_Asplit_0.5_8same <- list()
  IPIP_samples_Asplit_0.2_8 = IPIP_samples_Asplit_0.5_8 <- list()}



# Generate dataframes

# CONDITION II. Scale Variability, i.e. ("_DD") condition
# SAME sample + DIFF scale (ncol = 8)

set.seed(123123) #set the seed for reproducible results
for(i in 1:6){
  
  #create nested lists
  NEO_samples_A_0.2_8[[i]] = NEO_samples_A_0.5_8[[i]] = NEO_samples_A_0.8_8[[i]] = NEO_samples_A_1.0_8[[i]] <- list() 
  IPIP_samples_A_0.2_8[[i]] = IPIP_samples_A_0.5_8[[i]] = IPIP_samples_A_0.8_8[[i]] = IPIP_samples_A_1.0_8[[i]] <- list()
  
  for (l in 1:nSim){
    
    # CONDITION II. (ncol = 8)
    
    #apply random column selection function
    NEO_samples_A_0.2_8[[i]][[l]] <- lapply(NEO_samples_A_0.2[[i]][[l]], func_colselect_8)
    NEO_samples_A_0.5_8[[i]][[l]] <- lapply(NEO_samples_A_0.5[[i]][[l]], func_colselect_8)
    NEO_samples_A_0.8_8[[i]][[l]] <- lapply(NEO_samples_A_0.8[[i]][[l]], func_colselect_8)
    NEO_samples_A_1.0_8[[i]][[l]] <- lapply(NEO_samples_A_1.0[[i]][[l]], func_colselect_8)
    
    IPIP_samples_A_0.2_8[[i]][[l]] <- lapply(IPIP_samples_A_0.2[[i]][[l]], func_colselect_8)
    IPIP_samples_A_0.5_8[[i]][[l]] <- lapply(IPIP_samples_A_0.5[[i]][[l]], func_colselect_8)
    IPIP_samples_A_0.8_8[[i]][[l]] <- lapply(IPIP_samples_A_0.8[[i]][[l]], func_colselect_8)
    IPIP_samples_A_1.0_8[[i]][[l]] <- lapply(IPIP_samples_A_1.0[[i]][[l]], func_colselect_8)
    
    #create sum score
    NEO_samples_A_0.2_8[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.2_8[[i]][[l]][[1]][,1] + NEO_samples_A_0.2_8[[i]][[l]][[1]][,2] + NEO_samples_A_0.2_8[[i]][[l]][[1]][,3] + NEO_samples_A_0.2_8[[i]][[l]][[1]][,4]
                                               + NEO_samples_A_0.2_8[[i]][[l]][[1]][,5] + NEO_samples_A_0.2_8[[i]][[l]][[1]][,6] + NEO_samples_A_0.2_8[[i]][[l]][[1]][,7] + NEO_samples_A_0.2_8[[i]][[l]][[1]][,8])
    NEO_samples_A_0.5_8[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.5_8[[i]][[l]][[1]][,1] + NEO_samples_A_0.5_8[[i]][[l]][[1]][,2] + NEO_samples_A_0.5_8[[i]][[l]][[1]][,3] + NEO_samples_A_0.5_8[[i]][[l]][[1]][,4]
                                               + NEO_samples_A_0.5_8[[i]][[l]][[1]][,5] + NEO_samples_A_0.5_8[[i]][[l]][[1]][,6] + NEO_samples_A_0.5_8[[i]][[l]][[1]][,7] + NEO_samples_A_0.5_8[[i]][[l]][[1]][,8])
    NEO_samples_A_0.8_8[[i]][[l]][[1]]$sum <- (NEO_samples_A_0.8_8[[i]][[l]][[1]][,1] + NEO_samples_A_0.8_8[[i]][[l]][[1]][,2] + NEO_samples_A_0.8_8[[i]][[l]][[1]][,3] + NEO_samples_A_0.8_8[[i]][[l]][[1]][,4]
                                               + NEO_samples_A_0.8_8[[i]][[l]][[1]][,5] + NEO_samples_A_0.8_8[[i]][[l]][[1]][,6] + NEO_samples_A_0.8_8[[i]][[l]][[1]][,7] + NEO_samples_A_0.8_8[[i]][[l]][[1]][,8])
    NEO_samples_A_1.0_8[[i]][[l]][[1]]$sum <- (NEO_samples_A_1.0_8[[i]][[l]][[1]][,1] + NEO_samples_A_1.0_8[[i]][[l]][[1]][,2] + NEO_samples_A_1.0_8[[i]][[l]][[1]][,3] + NEO_samples_A_1.0_8[[i]][[l]][[1]][,4]
                                               + NEO_samples_A_1.0_8[[i]][[l]][[1]][,5] + NEO_samples_A_1.0_8[[i]][[l]][[1]][,6] + NEO_samples_A_1.0_8[[i]][[l]][[1]][,7] + NEO_samples_A_1.0_8[[i]][[l]][[1]][,8])
    
    IPIP_samples_A_0.2_8[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.2_8[[i]][[l]][[1]][,1] + IPIP_samples_A_0.2_8[[i]][[l]][[1]][,2] + IPIP_samples_A_0.2_8[[i]][[l]][[1]][,3] + IPIP_samples_A_0.2_8[[i]][[l]][[1]][,4]
                                                + IPIP_samples_A_0.2_8[[i]][[l]][[1]][,5] + IPIP_samples_A_0.2_8[[i]][[l]][[1]][,6] + IPIP_samples_A_0.2_8[[i]][[l]][[1]][,7] + IPIP_samples_A_0.2_8[[i]][[l]][[1]][,8])
    IPIP_samples_A_0.5_8[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.5_8[[i]][[l]][[1]][,1] + IPIP_samples_A_0.5_8[[i]][[l]][[1]][,2] + IPIP_samples_A_0.5_8[[i]][[l]][[1]][,3] + IPIP_samples_A_0.5_8[[i]][[l]][[1]][,4]
                                                + IPIP_samples_A_0.5_8[[i]][[l]][[1]][,5] + IPIP_samples_A_0.5_8[[i]][[l]][[1]][,6] + IPIP_samples_A_0.5_8[[i]][[l]][[1]][,7] + IPIP_samples_A_0.5_8[[i]][[l]][[1]][,8])
    IPIP_samples_A_0.8_8[[i]][[l]][[1]]$sum <- (IPIP_samples_A_0.8_8[[i]][[l]][[1]][,1] + IPIP_samples_A_0.8_8[[i]][[l]][[1]][,2] + IPIP_samples_A_0.8_8[[i]][[l]][[1]][,3] + IPIP_samples_A_0.8_8[[i]][[l]][[1]][,4]
                                                + IPIP_samples_A_0.8_8[[i]][[l]][[1]][,5] + IPIP_samples_A_0.8_8[[i]][[l]][[1]][,6] + IPIP_samples_A_0.8_8[[i]][[l]][[1]][,7] + IPIP_samples_A_0.8_8[[i]][[l]][[1]][,8])
    IPIP_samples_A_1.0_8[[i]][[l]][[1]]$sum <- (IPIP_samples_A_1.0_8[[i]][[l]][[1]][,1] + IPIP_samples_A_1.0_8[[i]][[l]][[1]][,2] + IPIP_samples_A_1.0_8[[i]][[l]][[1]][,3] + IPIP_samples_A_1.0_8[[i]][[l]][[1]][,4]
                                                + IPIP_samples_A_1.0_8[[i]][[l]][[1]][,5] + IPIP_samples_A_1.0_8[[i]][[l]][[1]][,6] + IPIP_samples_A_1.0_8[[i]][[l]][[1]][,7] + IPIP_samples_A_1.0_8[[i]][[l]][[1]][,8])
  }
}


# Generate dataframes

# CONDITION I. Sampling Variability, i.e. ("split_SS") condition
# i.e. INDEP samples + SAME scale (ncol = 8)

# CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition
# i.e. INDEP samples + DIFF scale (ncol = 8)

set.seed(123123) #set the seed for reproducible results
for (i in 1:6){
  
  #create nested lists
  NEO_samples_Asplit_0.2_8same[[i]] = NEO_samples_Asplit_0.5_8same[[i]] <- list()
  IPIP_samples_Asplit_0.2_8same[[i]] = IPIP_samples_Asplit_0.5_8same[[i]] <- list()
  
  NEO_samples_Asplit_0.2_8[[i]] = NEO_samples_Asplit_0.5_8[[i]] <- list()
  IPIP_samples_Asplit_0.2_8[[i]] = IPIP_samples_Asplit_0.5_8[[i]] <- list()
  
  for (l in 1:nSim){
    
    #create further nesting
    NEO_samples_Asplit_0.2_8same[[i]][[l]] = NEO_samples_Asplit_0.5_8same[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_8same[[i]][[l]] = IPIP_samples_Asplit_0.5_8same[[i]][[l]] <- list()
    
    NEO_samples_Asplit_0.2_8[[i]][[l]] = NEO_samples_Asplit_0.5_8[[i]][[l]] <- list()
    IPIP_samples_Asplit_0.2_8[[i]][[l]] = IPIP_samples_Asplit_0.5_8[[i]][[l]] <- list()
    
    for (h in 1:1){ 
      
      # CONDITION I. (ncol = 8)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_8same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_8same)
      NEO_samples_Asplit_0.5_8same[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_8same)
      
      IPIP_samples_Asplit_0.2_8same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_8same)
      IPIP_samples_Asplit_0.5_8same[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_8same)
      
      # CONDITION III. (ncol = 8)
      
      #apply random column selection function
      NEO_samples_Asplit_0.2_8[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_8)
      NEO_samples_Asplit_0.5_8[[i]][[l]][[h]] <- lapply(NEO_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_8)
      
      IPIP_samples_Asplit_0.2_8[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.2[[i]][[l]][[h]], func_colselect_8)
      IPIP_samples_Asplit_0.5_8[[i]][[l]][[h]] <- lapply(IPIP_samples_Asplit_0.5[[i]][[l]][[h]], func_colselect_8)
    }
  }
}


for (i in 1:6){
  for (l in 1:nSim){
    for (h in 1:2) {
      
      #create sum score
      NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,3] + NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,4]
                                                               + NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,5] + NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,6] + NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,7] + NEO_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,8])
      NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,3] + NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,4]
                                                               + NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,5] + NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,6] + NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,7] + NEO_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,8])
      
      IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,3] + IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,4]
                                                                + IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,5] + IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,6] + IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,7] + IPIP_samples_Asplit_0.2_8same[[i]][[l]][[1]][[h]][,8])
      IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,3] + IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,4]
                                                                + IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,5] + IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,6] + IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,7] + IPIP_samples_Asplit_0.5_8same[[i]][[l]][[1]][[h]][,8])
      
      #create sum score
      NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,3] + NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,4]
                                                           + NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,5] + NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,6] + NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,7] + NEO_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,8])
      NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]]$sum <- (NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,1] + NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,2] + NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,3] + NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,4]
                                                           + NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,5] + NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,6] + NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,7] + NEO_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,8])
      
      IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,3] + IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,4]
                                                            + IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,5] + IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,6] + IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,7] + IPIP_samples_Asplit_0.2_8[[i]][[l]][[1]][[h]][,8])
      IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]]$sum <- (IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,1] + IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,2] + IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,3] + IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,4]
                                                            + IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,5] + IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,6] + IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,7] + IPIP_samples_Asplit_0.5_8[[i]][[l]][[1]][[h]][,8])
    }
  }
}



#store randomly selected columns together

{# CONDITION I. (ncol = 8)
  dfsNEO_Asplit_0.2_8same_h1 = dfsNEO_Asplit_0.5_8same_h1 <- list() 
  dfsNEO_Asplit_0.2_8same_h2 = dfsNEO_Asplit_0.5_8same_h2 <- list() 
  
  dfsIPIP_Asplit_0.2_8same_h1 = dfsIPIP_Asplit_0.5_8same_h1 <- list() 
  dfsIPIP_Asplit_0.2_8same_h2 = dfsIPIP_Asplit_0.5_8same_h2 <- list()}

{# CONDITION II. (ncol = 8)
  dfsNEO_A_0.2_8 = dfsNEO_A_0.5_8 = dfsNEO_A_0.8_8 = dfsNEO_A_1.0_8 <- list()
  dfsIPIP_A_0.2_8 = dfsIPIP_A_0.5_8 = dfsIPIP_A_0.8_8 = dfsIPIP_A_1.0_8 <- list()}

{# CONDITION III. (ncol = 8)
  dfsNEO_Asplit_0.2_8_h1 = dfsNEO_Asplit_0.5_8_h1 <- list() 
  dfsNEO_Asplit_0.2_8_h2 = dfsNEO_Asplit_0.5_8_h2 <- list() 
  
  dfsIPIP_Asplit_0.2_8_h1 = dfsIPIP_Asplit_0.5_8_h1 <- list() 
  dfsIPIP_Asplit_0.2_8_h2 = dfsIPIP_Asplit_0.5_8_h2 <- list()}



set.seed(123123) #set the seed for reproducible results

for (l in 1:nSim){
  
  # CONDITION I. (ncol = 8)
  dfsNEO_Asplit_0.2_8same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_8same[[1]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_8same[[2]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_8same[[3]][[l]][[1]]$half1_0.2$sum,
                                                      NEO_samples_Asplit_0.2_8same[[4]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_8same[[5]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_8same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsNEO_Asplit_0.2_8same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_8same[[1]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_8same[[2]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_8same[[3]][[l]][[1]]$half2_0.2$sum,
                                                      NEO_samples_Asplit_0.2_8same[[4]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_8same[[5]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_8same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsNEO_Asplit_0.5_8same_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_8same[[1]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_8same[[2]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_8same[[3]][[l]][[1]]$half1_0.5$sum,
                                                      NEO_samples_Asplit_0.5_8same[[4]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_8same[[5]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_8same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsNEO_Asplit_0.5_8same_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_8same[[1]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_8same[[2]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_8same[[3]][[l]][[1]]$half2_0.5$sum,
                                                      NEO_samples_Asplit_0.5_8same[[4]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_8same[[5]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_8same[[6]][[l]][[1]]$half2_0.5$sum)
  
  dfsIPIP_Asplit_0.2_8same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_8same[[1]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_8same[[2]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_8same[[3]][[l]][[1]]$half1_0.2$sum,
                                                       IPIP_samples_Asplit_0.2_8same[[4]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_8same[[5]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_8same[[6]][[l]][[1]]$half1_0.2$sum)
  dfsIPIP_Asplit_0.2_8same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_8same[[1]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_8same[[2]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_8same[[3]][[l]][[1]]$half2_0.2$sum,
                                                       IPIP_samples_Asplit_0.2_8same[[4]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_8same[[5]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_8same[[6]][[l]][[1]]$half2_0.2$sum)
  dfsIPIP_Asplit_0.5_8same_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_8same[[1]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_8same[[2]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_8same[[3]][[l]][[1]]$half1_0.5$sum,
                                                       IPIP_samples_Asplit_0.5_8same[[4]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_8same[[5]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_8same[[6]][[l]][[1]]$half1_0.5$sum)
  dfsIPIP_Asplit_0.5_8same_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_8same[[1]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_8same[[2]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_8same[[3]][[l]][[1]]$half2_0.5$sum,
                                                       IPIP_samples_Asplit_0.5_8same[[4]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_8same[[5]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_8same[[6]][[l]][[1]]$half2_0.5$sum)
  
  # CONDITION II. (ncol = 8)
  dfsNEO_A_0.2_8[[l]] <- cbind.data.frame(NEO_samples_A_0.2_8[[1]][[l]][[1]]$sum, NEO_samples_A_0.2_8[[2]][[l]][[1]]$sum, NEO_samples_A_0.2_8[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.2_8[[4]][[l]][[1]]$sum, NEO_samples_A_0.2_8[[5]][[l]][[1]]$sum, NEO_samples_A_0.2_8[[6]][[l]][[1]]$sum)
  dfsNEO_A_0.5_8[[l]] <- cbind.data.frame(NEO_samples_A_0.5_8[[1]][[l]][[1]]$sum, NEO_samples_A_0.5_8[[2]][[l]][[1]]$sum, NEO_samples_A_0.5_8[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.5_8[[4]][[l]][[1]]$sum, NEO_samples_A_0.5_8[[5]][[l]][[1]]$sum, NEO_samples_A_0.5_8[[6]][[l]][[1]]$sum)
  dfsNEO_A_0.8_8[[l]] <- cbind.data.frame(NEO_samples_A_0.8_8[[1]][[l]][[1]]$sum, NEO_samples_A_0.8_8[[2]][[l]][[1]]$sum, NEO_samples_A_0.8_8[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_0.8_8[[4]][[l]][[1]]$sum, NEO_samples_A_0.8_8[[5]][[l]][[1]]$sum, NEO_samples_A_0.8_8[[6]][[l]][[1]]$sum)
  dfsNEO_A_1.0_8[[l]] <- cbind.data.frame(NEO_samples_A_1.0_8[[1]][[l]][[1]]$sum, NEO_samples_A_1.0_8[[2]][[l]][[1]]$sum, NEO_samples_A_1.0_8[[3]][[l]][[1]]$sum,
                                          NEO_samples_A_1.0_8[[4]][[l]][[1]]$sum, NEO_samples_A_1.0_8[[5]][[l]][[1]]$sum, NEO_samples_A_1.0_8[[6]][[l]][[1]]$sum)
  
  dfsIPIP_A_0.2_8[[l]] <- cbind.data.frame(IPIP_samples_A_0.2_8[[1]][[l]][[1]]$sum, IPIP_samples_A_0.2_8[[2]][[l]][[1]]$sum, IPIP_samples_A_0.2_8[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.2_8[[4]][[l]][[1]]$sum, IPIP_samples_A_0.2_8[[5]][[l]][[1]]$sum, IPIP_samples_A_0.2_8[[6]][[l]][[1]]$sum)
  dfsIPIP_A_0.5_8[[l]] <- cbind.data.frame(IPIP_samples_A_0.5_8[[1]][[l]][[1]]$sum, IPIP_samples_A_0.5_8[[2]][[l]][[1]]$sum, IPIP_samples_A_0.5_8[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.5_8[[4]][[l]][[1]]$sum, IPIP_samples_A_0.5_8[[5]][[l]][[1]]$sum, IPIP_samples_A_0.5_8[[6]][[l]][[1]]$sum)
  dfsIPIP_A_0.8_8[[l]] <- cbind.data.frame(IPIP_samples_A_0.8_8[[1]][[l]][[1]]$sum, IPIP_samples_A_0.8_8[[2]][[l]][[1]]$sum, IPIP_samples_A_0.8_8[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_0.8_8[[4]][[l]][[1]]$sum, IPIP_samples_A_0.8_8[[5]][[l]][[1]]$sum, IPIP_samples_A_0.8_8[[6]][[l]][[1]]$sum)
  dfsIPIP_A_1.0_8[[l]] <- cbind.data.frame(IPIP_samples_A_1.0_8[[1]][[l]][[1]]$sum, IPIP_samples_A_1.0_8[[2]][[l]][[1]]$sum, IPIP_samples_A_1.0_8[[3]][[l]][[1]]$sum,
                                           IPIP_samples_A_1.0_8[[4]][[l]][[1]]$sum, IPIP_samples_A_1.0_8[[5]][[l]][[1]]$sum, IPIP_samples_A_1.0_8[[6]][[l]][[1]]$sum)
  
  # CONDITION III. (ncol = 8)
  dfsNEO_Asplit_0.2_8_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_8[[1]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_8[[2]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_8[[3]][[l]][[1]]$half1_0.2$sum,
                                                  NEO_samples_Asplit_0.2_8[[4]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_8[[5]][[l]][[1]]$half1_0.2$sum, NEO_samples_Asplit_0.2_8[[6]][[l]][[1]]$half1_0.2$sum)
  dfsNEO_Asplit_0.2_8_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.2_8[[1]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_8[[2]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_8[[3]][[l]][[1]]$half2_0.2$sum,
                                                  NEO_samples_Asplit_0.2_8[[4]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_8[[5]][[l]][[1]]$half2_0.2$sum, NEO_samples_Asplit_0.2_8[[6]][[l]][[1]]$half2_0.2$sum)
  dfsNEO_Asplit_0.5_8_h1[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_8[[1]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_8[[2]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_8[[3]][[l]][[1]]$half1_0.5$sum,
                                                  NEO_samples_Asplit_0.5_8[[4]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_8[[5]][[l]][[1]]$half1_0.5$sum, NEO_samples_Asplit_0.5_8[[6]][[l]][[1]]$half1_0.5$sum)
  dfsNEO_Asplit_0.5_8_h2[[l]] <- cbind.data.frame(NEO_samples_Asplit_0.5_8[[1]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_8[[2]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_8[[3]][[l]][[1]]$half2_0.5$sum,
                                                  NEO_samples_Asplit_0.5_8[[4]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_8[[5]][[l]][[1]]$half2_0.5$sum, NEO_samples_Asplit_0.5_8[[6]][[l]][[1]]$half2_0.5$sum)
  
  dfsIPIP_Asplit_0.2_8_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_8[[1]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_8[[2]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_8[[3]][[l]][[1]]$half1_0.2$sum,
                                                   IPIP_samples_Asplit_0.2_8[[4]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_8[[5]][[l]][[1]]$half1_0.2$sum, IPIP_samples_Asplit_0.2_8[[6]][[l]][[1]]$half1_0.2$sum)
  dfsIPIP_Asplit_0.2_8_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.2_8[[1]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_8[[2]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_8[[3]][[l]][[1]]$half2_0.2$sum,
                                                   IPIP_samples_Asplit_0.2_8[[4]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_8[[5]][[l]][[1]]$half2_0.2$sum, IPIP_samples_Asplit_0.2_8[[6]][[l]][[1]]$half2_0.2$sum)
  dfsIPIP_Asplit_0.5_8_h1[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_8[[1]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_8[[2]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_8[[3]][[l]][[1]]$half1_0.5$sum,
                                                   IPIP_samples_Asplit_0.5_8[[4]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_8[[5]][[l]][[1]]$half1_0.5$sum, IPIP_samples_Asplit_0.5_8[[6]][[l]][[1]]$half1_0.5$sum)
  dfsIPIP_Asplit_0.5_8_h2[[l]] <- cbind.data.frame(IPIP_samples_Asplit_0.5_8[[1]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_8[[2]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_8[[3]][[l]][[1]]$half2_0.5$sum,
                                                   IPIP_samples_Asplit_0.5_8[[4]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_8[[5]][[l]][[1]]$half2_0.5$sum, IPIP_samples_Asplit_0.5_8[[6]][[l]][[1]]$half2_0.5$sum)
} #returns lists of nSim dataframes



#rename dataframe columns such that NEO and IPIP have matching names for netcompare step

colnames_N <- c("N1", "N2", "N3", "N4", "N5", "N6")

{# NEO ncol=8 dataframes
  dfsNEO_A_0.2_8 <- lapply(dfsNEO_A_0.2_8, setNames, nm = colnames_N)
  dfsNEO_A_0.5_8 <- lapply(dfsNEO_A_0.5_8, setNames, nm = colnames_N)
  dfsNEO_A_0.8_8 <- lapply(dfsNEO_A_0.8_8, setNames, nm = colnames_N)
  dfsNEO_A_1.0_8 <- lapply(dfsNEO_A_1.0_8, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_8same_h1 <- lapply(dfsNEO_Asplit_0.2_8same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_8same_h1 <- lapply(dfsNEO_Asplit_0.5_8same_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_8same_h2 <- lapply(dfsNEO_Asplit_0.2_8same_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_8same_h2 <- lapply(dfsNEO_Asplit_0.5_8same_h2, setNames, nm = colnames_N)
  
  dfsNEO_Asplit_0.2_8_h1 <- lapply(dfsNEO_Asplit_0.2_8_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_8_h1 <- lapply(dfsNEO_Asplit_0.5_8_h1, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.2_8_h2 <- lapply(dfsNEO_Asplit_0.2_8_h2, setNames, nm = colnames_N)
  dfsNEO_Asplit_0.5_8_h2 <- lapply(dfsNEO_Asplit_0.5_8_h2, setNames, nm = colnames_N)}

{# IPIP ncol=8 dataframes
  dfsIPIP_A_0.2_8 <- lapply(dfsIPIP_A_0.2_8, setNames, nm = colnames_N)
  dfsIPIP_A_0.5_8 <- lapply(dfsIPIP_A_0.5_8, setNames, nm = colnames_N)
  dfsIPIP_A_0.8_8 <- lapply(dfsIPIP_A_0.8_8, setNames, nm = colnames_N)
  dfsIPIP_A_1.0_8 <- lapply(dfsIPIP_A_1.0_8, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_8same_h1 <- lapply(dfsIPIP_Asplit_0.2_8same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_8same_h1 <- lapply(dfsIPIP_Asplit_0.5_8same_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_8same_h2 <- lapply(dfsIPIP_Asplit_0.2_8same_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_8same_h2 <- lapply(dfsIPIP_Asplit_0.5_8same_h2, setNames, nm = colnames_N)
  
  dfsIPIP_Asplit_0.2_8_h1 <- lapply(dfsIPIP_Asplit_0.2_8_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_8_h1 <- lapply(dfsIPIP_Asplit_0.5_8_h1, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.2_8_h2 <- lapply(dfsIPIP_Asplit_0.2_8_h2, setNames, nm = colnames_N)
  dfsIPIP_Asplit_0.5_8_h2 <- lapply(dfsIPIP_Asplit_0.5_8_h2, setNames, nm = colnames_N)}



### [end]


### Save objects

save(random.seeds, nSamp, sample_prop, colnames_N,
     
     NEO_samples_A_0.2, NEO_samples_A_0.5, NEO_samples_A_0.8, NEO_samples_A_1.0,
     NEO_samples_Asplit_0.2, NEO_samples_Asplit_0.5,
     IPIP_samples_A_0.2, IPIP_samples_A_0.5, IPIP_samples_A_0.8, IPIP_samples_A_1.0,
     IPIP_samples_Asplit_0.2, IPIP_samples_Asplit_0.5,
     
     dfsNEO_A_0.2_1, dfsNEO_A_0.5_1, dfsNEO_A_0.8_1, dfsNEO_A_1.0_1, 
     dfsNEO_Asplit_0.2_1same_h1, dfsNEO_Asplit_0.5_1same_h1, dfsNEO_Asplit_0.2_1same_h2, dfsNEO_Asplit_0.5_1same_h2, 
     dfsNEO_Asplit_0.2_1_h1, dfsNEO_Asplit_0.5_1_h1, dfsNEO_Asplit_0.2_1_h2, dfsNEO_Asplit_0.5_1_h2,
     
     dfsIPIP_A_0.2_1, dfsIPIP_A_0.5_1, dfsIPIP_A_0.8_1, dfsIPIP_A_1.0_1, 
     dfsIPIP_Asplit_0.2_1same_h1, dfsIPIP_Asplit_0.5_1same_h1, dfsIPIP_Asplit_0.2_1same_h2, dfsIPIP_Asplit_0.5_1same_h2, 
     dfsIPIP_Asplit_0.2_1_h1, dfsIPIP_Asplit_0.5_1_h1, dfsIPIP_Asplit_0.2_1_h2, dfsIPIP_Asplit_0.5_1_h2, 
     
     dfsNEO_A_0.2_2,dfsNEO_A_0.5_2, dfsNEO_A_0.8_2, dfsNEO_A_1.0_2, 
     dfsNEO_Asplit_0.2_2same_h1, dfsNEO_Asplit_0.5_2same_h1, dfsNEO_Asplit_0.2_2same_h2, dfsNEO_Asplit_0.5_2same_h2, 
     dfsNEO_Asplit_0.2_2_h1, dfsNEO_Asplit_0.5_2_h1, dfsNEO_Asplit_0.2_2_h2, dfsNEO_Asplit_0.5_2_h2, 
     
     dfsIPIP_A_0.2_2, dfsIPIP_A_0.5_2, dfsIPIP_A_0.8_2, dfsIPIP_A_1.0_2, 
     dfsIPIP_Asplit_0.2_2same_h1, dfsIPIP_Asplit_0.5_2same_h1, dfsIPIP_Asplit_0.2_2same_h2, dfsIPIP_Asplit_0.5_2same_h2, 
     dfsIPIP_Asplit_0.2_2_h1, dfsIPIP_Asplit_0.5_2_h1, dfsIPIP_Asplit_0.2_2_h2, dfsIPIP_Asplit_0.5_2_h2, 
     
     dfsNEO_A_0.2_3, dfsNEO_A_0.5_3, dfsNEO_A_0.8_3, dfsNEO_A_1.0_3, 
     dfsNEO_Asplit_0.2_3same_h1, dfsNEO_Asplit_0.5_3same_h1, dfsNEO_Asplit_0.2_3same_h2, dfsNEO_Asplit_0.5_3same_h2, 
     dfsNEO_Asplit_0.2_3_h1, dfsNEO_Asplit_0.5_3_h1, dfsNEO_Asplit_0.2_3_h2, dfsNEO_Asplit_0.5_3_h2,
     
     dfsIPIP_A_0.2_3, dfsIPIP_A_0.5_3, dfsIPIP_A_0.8_3, dfsIPIP_A_1.0_3, 
     dfsIPIP_Asplit_0.2_3same_h1, dfsIPIP_Asplit_0.5_3same_h1, dfsIPIP_Asplit_0.2_3same_h2, dfsIPIP_Asplit_0.5_3same_h2, 
     dfsIPIP_Asplit_0.2_3_h1, dfsIPIP_Asplit_0.5_3_h1, dfsIPIP_Asplit_0.2_3_h2, dfsIPIP_Asplit_0.5_3_h2,
     
     dfsNEO_A_0.2_5, dfsNEO_A_0.5_5, dfsNEO_A_0.8_5, dfsNEO_A_1.0_5, 
     dfsNEO_Asplit_0.2_5same_h1, dfsNEO_Asplit_0.5_5same_h1, dfsNEO_Asplit_0.2_5same_h2, dfsNEO_Asplit_0.5_5same_h2, 
     dfsNEO_Asplit_0.2_5_h1, dfsNEO_Asplit_0.5_5_h1, dfsNEO_Asplit_0.2_5_h2, dfsNEO_Asplit_0.5_5_h2,
     
     dfsIPIP_A_0.2_5, dfsIPIP_A_0.5_5, dfsIPIP_A_0.8_5, dfsIPIP_A_1.0_5, 
     dfsIPIP_Asplit_0.2_5same_h1, dfsIPIP_Asplit_0.5_5same_h1, dfsIPIP_Asplit_0.2_5same_h2, dfsIPIP_Asplit_0.5_5same_h2, 
     dfsIPIP_Asplit_0.2_5_h1, dfsIPIP_Asplit_0.5_5_h1, dfsIPIP_Asplit_0.2_5_h2, dfsIPIP_Asplit_0.5_5_h2,
     
     dfsNEO_A_0.2_8, dfsNEO_A_0.5_8, dfsNEO_A_0.8_8, dfsNEO_A_1.0_8, 
     dfsNEO_Asplit_0.2_8same_h1, dfsNEO_Asplit_0.5_8same_h1, dfsNEO_Asplit_0.2_8same_h2, dfsNEO_Asplit_0.5_8same_h2, 
     dfsNEO_Asplit_0.2_8_h1, dfsNEO_Asplit_0.5_8_h1, dfsNEO_Asplit_0.2_8_h2, dfsNEO_Asplit_0.5_8_h2,
     
     dfsIPIP_A_0.2_8, dfsIPIP_A_0.5_8, dfsIPIP_A_0.8_8, dfsIPIP_A_1.0_8, 
     dfsIPIP_Asplit_0.2_8same_h1, dfsIPIP_Asplit_0.5_8same_h1, dfsIPIP_Asplit_0.2_8same_h2, dfsIPIP_Asplit_0.5_8same_h2, 
     dfsIPIP_Asplit_0.2_8_h1, dfsIPIP_Asplit_0.5_8_h1, dfsIPIP_Asplit_0.2_8_h2, dfsIPIP_Asplit_0.5_8_h2,
     
     file = "NEO & IPIP - P2_nSim50_data_A.RData")







 















