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
library(NetworkComparisonTest)

registerDoParallel(cores=4)

# Load object Rdata file(s)
load("NEO & IPIP - P0_functions.RData")
load("NEO & IPIP - P1_nSim50_data_A.RData")
load("NEO & IPIP - P2_nSim50_data_A.RData")



##########



### NETCOMPARE STEPS



### RUN netcompare on WHOLE-SAMPLE dataframes (with NCT it = 1000)

# Whole-sample comparisons (from ggm estimated networks; run with signed = TRUE)
netcompare_Alist_pop_DD_pval <- netcompare_func_paired_pval(df.NEO.A.pop, df.IPIP.A.pop)

# # Save whole-sample ("population") netcompare output
# save (netcompare_Alist_pop_DD_pval,
#       file = "NEO & IPIP - P3_pop_data_A.RData")



##########



### RUN netcompare on ALL conditions (with NCT it = 1)



# CONDITION I. Sampling Variability, i.e. ("split_SS") condition
# i.e. INDEP samples + SAME scale


# create lists to store results
{#create lists of network comparisons
  
  #for NEO scale
  netcompare_Alist_0.2_1split_SS_NEO = netcompare_Alist_0.2_2split_SS_NEO = netcompare_Alist_0.2_3split_SS_NEO = netcompare_Alist_0.2_5split_SS_NEO = netcompare_Alist_0.2_8split_SS_NEO <- list()
  netcompare_Alist_0.5_1split_SS_NEO = netcompare_Alist_0.5_2split_SS_NEO = netcompare_Alist_0.5_3split_SS_NEO = netcompare_Alist_0.5_5split_SS_NEO = netcompare_Alist_0.5_8split_SS_NEO <- list()
  
  #for IPIP scale
  netcompare_Alist_0.2_1split_SS_IPIP = netcompare_Alist_0.2_2split_SS_IPIP = netcompare_Alist_0.2_3split_SS_IPIP = netcompare_Alist_0.2_5split_SS_IPIP = netcompare_Alist_0.2_8split_SS_IPIP <- list()
  netcompare_Alist_0.5_1split_SS_IPIP = netcompare_Alist_0.5_2split_SS_IPIP = netcompare_Alist_0.5_3split_SS_IPIP = netcompare_Alist_0.5_5split_SS_IPIP = netcompare_Alist_0.5_8split_SS_IPIP <- list()}

set.seed(123123) #set the seed for reproducible results

# run for loop
for (l in 1:nSim){
  #Run netcompare function
  
  #at nSamp = 0.2
  netcompare_Alist_0.2_1split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_1same_h1[[l]], dfsNEO_Asplit_0.2_1same_h2[[l]])
  netcompare_Alist_0.2_2split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_2same_h1[[l]], dfsNEO_Asplit_0.2_2same_h2[[l]])
  netcompare_Alist_0.2_3split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_3same_h1[[l]], dfsNEO_Asplit_0.2_3same_h2[[l]])
  netcompare_Alist_0.2_5split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_5same_h1[[l]], dfsNEO_Asplit_0.2_5same_h2[[l]])
  netcompare_Alist_0.2_8split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_8same_h1[[l]], dfsNEO_Asplit_0.2_8same_h2[[l]])
  
  netcompare_Alist_0.2_1split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.2_1same_h1[[l]], dfsIPIP_Asplit_0.2_1same_h2[[l]])
  netcompare_Alist_0.2_2split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.2_2same_h1[[l]], dfsIPIP_Asplit_0.2_2same_h2[[l]])
  netcompare_Alist_0.2_3split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.2_3same_h1[[l]], dfsIPIP_Asplit_0.2_3same_h2[[l]])
  netcompare_Alist_0.2_5split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.2_5same_h1[[l]], dfsIPIP_Asplit_0.2_5same_h2[[l]])
  netcompare_Alist_0.2_8split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.2_8same_h1[[l]], dfsIPIP_Asplit_0.2_8same_h2[[l]])
  
  #at nSamp = 0.5
  netcompare_Alist_0.5_1split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_1same_h1[[l]], dfsNEO_Asplit_0.5_1same_h2[[l]])
  netcompare_Alist_0.5_2split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_2same_h1[[l]], dfsNEO_Asplit_0.5_2same_h2[[l]])
  netcompare_Alist_0.5_3split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_3same_h1[[l]], dfsNEO_Asplit_0.5_3same_h2[[l]])
  netcompare_Alist_0.5_5split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_5same_h1[[l]], dfsNEO_Asplit_0.5_5same_h2[[l]])
  netcompare_Alist_0.5_8split_SS_NEO[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_8same_h1[[l]], dfsNEO_Asplit_0.5_8same_h2[[l]])
  
  netcompare_Alist_0.5_1split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.5_1same_h1[[l]], dfsIPIP_Asplit_0.5_1same_h2[[l]])
  netcompare_Alist_0.5_2split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.5_2same_h1[[l]], dfsIPIP_Asplit_0.5_2same_h2[[l]])
  netcompare_Alist_0.5_3split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.5_3same_h1[[l]], dfsIPIP_Asplit_0.5_3same_h2[[l]])
  netcompare_Alist_0.5_5split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.5_5same_h1[[l]], dfsIPIP_Asplit_0.5_5same_h2[[l]])
  netcompare_Alist_0.5_8split_SS_IPIP[[l]] <- netcompare_func(dfsIPIP_Asplit_0.5_8same_h1[[l]], dfsIPIP_Asplit_0.5_8same_h2[[l]])}


# ## Save objects: CONDITION I
# 
# save(# Condition I.
#   netcompare_Alist_0.2_1split_SS_NEO, netcompare_Alist_0.2_2split_SS_NEO, netcompare_Alist_0.2_3split_SS_NEO, netcompare_Alist_0.2_5split_SS_NEO, netcompare_Alist_0.2_8split_SS_NEO,
#   netcompare_Alist_0.5_1split_SS_NEO, netcompare_Alist_0.5_2split_SS_NEO, netcompare_Alist_0.5_3split_SS_NEO, netcompare_Alist_0.5_5split_SS_NEO, netcompare_Alist_0.5_8split_SS_NEO,
# 
#   netcompare_Alist_0.2_1split_SS_IPIP, netcompare_Alist_0.2_2split_SS_IPIP, netcompare_Alist_0.2_3split_SS_IPIP, netcompare_Alist_0.2_5split_SS_IPIP, netcompare_Alist_0.2_8split_SS_IPIP,
#   netcompare_Alist_0.5_1split_SS_IPIP, netcompare_Alist_0.5_2split_SS_IPIP, netcompare_Alist_0.5_3split_SS_IPIP, netcompare_Alist_0.5_5split_SS_IPIP, netcompare_Alist_0.5_8split_SS_IPIP,
# 
#   file = "NEO & IPIP - P3_nSim50_data_split_SS_A.RData")



#*****



# CONDITION II. Scale Variability, i.e. ("_DD") condition
# SAME sample + DIFF scale


# create lists to store results
{#create lists of network comparisons
  netcompare_Alist_0.2_1_DD = netcompare_Alist_0.2_2_DD = netcompare_Alist_0.2_3_DD = netcompare_Alist_0.2_5_DD = netcompare_Alist_0.2_8_DD <- list()
  netcompare_Alist_0.5_1_DD = netcompare_Alist_0.5_2_DD = netcompare_Alist_0.5_3_DD = netcompare_Alist_0.5_5_DD = netcompare_Alist_0.5_8_DD <- list()
  netcompare_Alist_0.8_1_DD = netcompare_Alist_0.8_2_DD = netcompare_Alist_0.8_3_DD = netcompare_Alist_0.8_5_DD = netcompare_Alist_0.8_8_DD <- list()
  netcompare_Alist_1.0_1_DD = netcompare_Alist_1.0_2_DD = netcompare_Alist_1.0_3_DD = netcompare_Alist_1.0_5_DD = netcompare_Alist_1.0_8_DD <- list()}

set.seed(123123) #set the seed for reproducible results

# run for loop
for (l in 1:nSim){
  #Run netcompare function
  
  #at nSamp = 0.2
  netcompare_Alist_0.2_1_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.2_1[[l]], dfsIPIP_A_0.2_1[[l]])
  netcompare_Alist_0.2_2_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.2_2[[l]], dfsIPIP_A_0.2_2[[l]])
  netcompare_Alist_0.2_3_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.2_3[[l]], dfsIPIP_A_0.2_3[[l]])
  netcompare_Alist_0.2_5_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.2_5[[l]], dfsIPIP_A_0.2_5[[l]])
  netcompare_Alist_0.2_8_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.2_8[[l]], dfsIPIP_A_0.2_8[[l]])

  #at nSamp = 0.5
  netcompare_Alist_0.5_1_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.5_1[[l]], dfsIPIP_A_0.5_1[[l]])
  netcompare_Alist_0.5_2_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.5_2[[l]], dfsIPIP_A_0.5_2[[l]])
  netcompare_Alist_0.5_3_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.5_3[[l]], dfsIPIP_A_0.5_3[[l]])
  netcompare_Alist_0.5_5_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.5_5[[l]], dfsIPIP_A_0.5_5[[l]])
  netcompare_Alist_0.5_8_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.5_8[[l]], dfsIPIP_A_0.5_8[[l]])
  
  #at nSamp = 0.8
  netcompare_Alist_0.8_1_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.8_1[[l]], dfsIPIP_A_0.8_1[[l]])
  netcompare_Alist_0.8_2_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.8_2[[l]], dfsIPIP_A_0.8_2[[l]])
  netcompare_Alist_0.8_3_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.8_3[[l]], dfsIPIP_A_0.8_3[[l]])
  netcompare_Alist_0.8_5_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.8_5[[l]], dfsIPIP_A_0.8_5[[l]])
  netcompare_Alist_0.8_8_DD[[l]] <- netcompare_func_paired(dfsNEO_A_0.8_8[[l]], dfsIPIP_A_0.8_8[[l]])
  
  #at nSamp = 1.0
  netcompare_Alist_1.0_1_DD[[l]] <- netcompare_func_paired(dfsNEO_A_1.0_1[[l]], dfsIPIP_A_1.0_1[[l]])
  netcompare_Alist_1.0_2_DD[[l]] <- netcompare_func_paired(dfsNEO_A_1.0_2[[l]], dfsIPIP_A_1.0_2[[l]])
  netcompare_Alist_1.0_3_DD[[l]] <- netcompare_func_paired(dfsNEO_A_1.0_3[[l]], dfsIPIP_A_1.0_3[[l]])
  netcompare_Alist_1.0_5_DD[[l]] <- netcompare_func_paired(dfsNEO_A_1.0_5[[l]], dfsIPIP_A_1.0_5[[l]])
  netcompare_Alist_1.0_8_DD[[l]] <- netcompare_func_paired(dfsNEO_A_1.0_8[[l]], dfsIPIP_A_1.0_8[[l]])}


# ### Save objects: CONDITION II
# 
# save(# Condition II.
#      netcompare_Alist_0.2_1_DD, netcompare_Alist_0.5_1_DD, netcompare_Alist_0.8_1_DD, netcompare_Alist_1.0_1_DD,
#      netcompare_Alist_0.2_2_DD, netcompare_Alist_0.5_2_DD, netcompare_Alist_0.8_2_DD, netcompare_Alist_1.0_2_DD,
#      netcompare_Alist_0.2_3_DD, netcompare_Alist_0.5_3_DD, netcompare_Alist_0.8_3_DD, netcompare_Alist_1.0_3_DD,
#      netcompare_Alist_0.2_5_DD, netcompare_Alist_0.5_5_DD, netcompare_Alist_0.8_5_DD, netcompare_Alist_1.0_5_DD,
#      netcompare_Alist_0.2_8_DD, netcompare_Alist_0.5_8_DD, netcompare_Alist_0.8_8_DD, netcompare_Alist_1.0_8_DD,
# 
#      file = "NEO & IPIP - P3_nSim50_data_DD_A.RData")



#*****



# CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition
# i.e. INDEP samples + DIFF scale


# create lists to store results
{#create lists of network comparisons
  netcompare_Alist_0.2_1split_DD = netcompare_Alist_0.2_2split_DD = netcompare_Alist_0.2_3split_DD = netcompare_Alist_0.2_5split_DD = netcompare_Alist_0.2_8split_DD <- list()
  netcompare_Alist_0.5_1split_DD = netcompare_Alist_0.5_2split_DD = netcompare_Alist_0.5_3split_DD = netcompare_Alist_0.5_5split_DD = netcompare_Alist_0.5_8split_DD <- list()}

set.seed(123123) #set the seed for reproducible results

# run for loop
for (l in 1:nSim){
  #Run netcompare function
  
  #at nSamp = 0.2
  netcompare_Alist_0.2_1split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_1_h1[[l]], dfsIPIP_Asplit_0.2_1_h2[[l]])
  netcompare_Alist_0.2_2split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_2_h1[[l]], dfsIPIP_Asplit_0.2_2_h2[[l]])
  netcompare_Alist_0.2_3split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_3_h1[[l]], dfsIPIP_Asplit_0.2_3_h2[[l]])
  netcompare_Alist_0.2_5split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_5_h1[[l]], dfsIPIP_Asplit_0.2_5_h2[[l]])
  netcompare_Alist_0.2_8split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.2_8_h1[[l]], dfsIPIP_Asplit_0.2_8_h2[[l]])

  #at nSamp = 0.5
  netcompare_Alist_0.5_1split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_1_h1[[l]], dfsIPIP_Asplit_0.5_1_h2[[l]])
  netcompare_Alist_0.5_2split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_2_h1[[l]], dfsIPIP_Asplit_0.5_2_h2[[l]])
  netcompare_Alist_0.5_3split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_3_h1[[l]], dfsIPIP_Asplit_0.5_3_h2[[l]])
  netcompare_Alist_0.5_5split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_5_h1[[l]], dfsIPIP_Asplit_0.5_5_h2[[l]])
  netcompare_Alist_0.5_8split_DD[[l]] <- netcompare_func(dfsNEO_Asplit_0.5_8_h1[[l]], dfsIPIP_Asplit_0.5_8_h2[[l]])}


# ### Save objects: CONDITION III
# 
# save(# Condition III.
#      netcompare_Alist_0.2_1split_DD, netcompare_Alist_0.2_2split_DD, netcompare_Alist_0.2_3split_DD, netcompare_Alist_0.2_5split_DD, netcompare_Alist_0.2_8split_DD,
#      netcompare_Alist_0.5_1split_DD, netcompare_Alist_0.5_2split_DD, netcompare_Alist_0.5_3split_DD, netcompare_Alist_0.5_5split_DD, netcompare_Alist_0.5_8split_DD,
# 
#      file = "NEO & IPIP - P3_nSim50_data_split_DD_A.RData")



#*****



### SAVE ALL RESULTS ABOVE TOGETHER

save (# Whole-sample data (with p-values)
      netcompare_Alist_pop_DD_pval,
      
      # CONDITION I.
      netcompare_Alist_0.2_1split_SS_NEO, netcompare_Alist_0.2_2split_SS_NEO, netcompare_Alist_0.2_3split_SS_NEO, netcompare_Alist_0.2_5split_SS_NEO, netcompare_Alist_0.2_8split_SS_NEO,
      netcompare_Alist_0.5_1split_SS_NEO, netcompare_Alist_0.5_2split_SS_NEO, netcompare_Alist_0.5_3split_SS_NEO, netcompare_Alist_0.5_5split_SS_NEO, netcompare_Alist_0.5_8split_SS_NEO,
      netcompare_Alist_0.2_1split_SS_IPIP, netcompare_Alist_0.2_2split_SS_IPIP, netcompare_Alist_0.2_3split_SS_IPIP, netcompare_Alist_0.2_5split_SS_IPIP, netcompare_Alist_0.2_8split_SS_IPIP,
      netcompare_Alist_0.5_1split_SS_IPIP, netcompare_Alist_0.5_2split_SS_IPIP, netcompare_Alist_0.5_3split_SS_IPIP, netcompare_Alist_0.5_5split_SS_IPIP, netcompare_Alist_0.5_8split_SS_IPIP,
      
      # CONDITION II. 
      netcompare_Alist_0.2_1_DD, netcompare_Alist_0.5_1_DD, netcompare_Alist_0.8_1_DD, netcompare_Alist_1.0_1_DD,
      netcompare_Alist_0.2_2_DD, netcompare_Alist_0.5_2_DD, netcompare_Alist_0.8_2_DD, netcompare_Alist_1.0_2_DD,
      netcompare_Alist_0.2_3_DD, netcompare_Alist_0.5_3_DD, netcompare_Alist_0.8_3_DD, netcompare_Alist_1.0_3_DD,
      netcompare_Alist_0.2_5_DD, netcompare_Alist_0.5_5_DD, netcompare_Alist_0.8_5_DD, netcompare_Alist_1.0_5_DD,
      netcompare_Alist_0.2_8_DD, netcompare_Alist_0.5_8_DD, netcompare_Alist_0.8_8_DD, netcompare_Alist_1.0_8_DD,
      
      # CONDITION III. 
      netcompare_Alist_0.2_1split_DD, netcompare_Alist_0.2_2split_DD, netcompare_Alist_0.2_3split_DD, netcompare_Alist_0.2_5split_DD, netcompare_Alist_0.2_8split_DD,
      netcompare_Alist_0.5_1split_DD, netcompare_Alist_0.5_2split_DD, netcompare_Alist_0.5_3split_DD, netcompare_Alist_0.5_5split_DD, netcompare_Alist_0.5_8split_DD,
      
      file = "NEO & IPIP - P3_nSim50_data_all_A.RData")



##########



load("NEO & IPIP - P3_nSim50_data_all_A.RData")


### ANALYSIS STEPS



### create lists of netcompare data ("output1", "output2" and "output3")


# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  output1_Alist_split_SS_NEO <- output2_Alist_split_SS_NEO <- output3_Alist_split_SS_NEO <- list(A_0.2_1=netcompare_Alist_0.2_1split_SS_NEO, A_0.2_2=netcompare_Alist_0.2_2split_SS_NEO, A_0.2_3=netcompare_Alist_0.2_3split_SS_NEO, A_0.2_5=netcompare_Alist_0.2_5split_SS_NEO, A_0.2_8=netcompare_Alist_0.2_8split_SS_NEO,
                                                                                                 A_0.5_1=netcompare_Alist_0.5_1split_SS_NEO, A_0.5_2=netcompare_Alist_0.5_2split_SS_NEO, A_0.5_3=netcompare_Alist_0.5_3split_SS_NEO, A_0.5_5=netcompare_Alist_0.5_5split_SS_NEO, A_0.5_8=netcompare_Alist_0.5_8split_SS_NEO)
  
  
  output1_Alist_split_SS_IPIP <- output2_Alist_split_SS_IPIP <- output3_Alist_split_SS_IPIP <- list(A_0.2_1=netcompare_Alist_0.2_1split_SS_IPIP, A_0.2_2=netcompare_Alist_0.2_2split_SS_IPIP, A_0.2_3=netcompare_Alist_0.2_3split_SS_IPIP, A_0.2_5=netcompare_Alist_0.2_5split_SS_IPIP, A_0.2_8=netcompare_Alist_0.2_8split_SS_IPIP,
                                                                                                    A_0.5_1=netcompare_Alist_0.5_1split_SS_IPIP, A_0.5_2=netcompare_Alist_0.5_2split_SS_IPIP, A_0.5_3=netcompare_Alist_0.5_3split_SS_IPIP, A_0.5_5=netcompare_Alist_0.5_5split_SS_IPIP, A_0.5_8=netcompare_Alist_0.5_8split_SS_IPIP)}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  output1_Alist_DD <- output2_Alist_DD <- output3_Alist_DD <- list(A_0.2_1=netcompare_Alist_0.2_1_DD, A_0.2_2=netcompare_Alist_0.2_2_DD, A_0.2_3=netcompare_Alist_0.2_3_DD, A_0.2_5=netcompare_Alist_0.2_5_DD, A_0.2_8=netcompare_Alist_0.2_8_DD,
                                                                   A_0.5_1=netcompare_Alist_0.5_1_DD, A_0.5_2=netcompare_Alist_0.5_2_DD, A_0.5_3=netcompare_Alist_0.5_3_DD, A_0.5_5=netcompare_Alist_0.5_5_DD, A_0.5_8=netcompare_Alist_0.5_8_DD,
                                                                   A_0.8_1=netcompare_Alist_0.8_1_DD, A_0.8_2=netcompare_Alist_0.8_2_DD, A_0.8_3=netcompare_Alist_0.8_3_DD, A_0.8_5=netcompare_Alist_0.8_5_DD, A_0.8_8=netcompare_Alist_0.8_8_DD,
                                                                   A_1.0_1=netcompare_Alist_1.0_1_DD, A_1.0_2=netcompare_Alist_1.0_2_DD, A_1.0_3=netcompare_Alist_1.0_3_DD, A_1.0_5=netcompare_Alist_1.0_5_DD, A_1.0_8=netcompare_Alist_1.0_8_DD)}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  output1_Alist_split_DD <- output2_Alist_split_DD <- output3_Alist_split_DD <- list(A_0.2_1=netcompare_Alist_0.2_1split_DD, A_0.2_2=netcompare_Alist_0.2_2split_DD, A_0.2_3=netcompare_Alist_0.2_3split_DD, A_0.2_5=netcompare_Alist_0.2_5split_DD, A_0.2_8=netcompare_Alist_0.2_8split_DD,
                                                                                     A_0.5_1=netcompare_Alist_0.5_1split_DD, A_0.5_2=netcompare_Alist_0.5_2split_DD, A_0.5_3=netcompare_Alist_0.5_3split_DD, A_0.5_5=netcompare_Alist_0.5_5split_DD, A_0.5_8=netcompare_Alist_0.5_8split_DD)}



### Extract and merge output from netcompare analysis


# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  
  # output1
  output1_A_split_SS_NEO <- lapply(output1_Alist_split_SS_NEO, output1_merge_func)
  output1_A_split_SS_IPIP <- lapply(output1_Alist_split_SS_IPIP, output1_merge_func)
  
  # output2
  output2_A_split_SS_NEO <- lapply(output2_Alist_split_SS_NEO, output2_merge_func)
  output2_A_split_SS_IPIP <- lapply(output2_Alist_split_SS_IPIP, output2_merge_func)
  
  # output3
  output3_A_split_SS_NEO_expInfl <- lapply(output3_Alist_split_SS_NEO, output3_merge_func_cent)
  output3_A_split_SS_IPIP_expInfl <- lapply(output3_Alist_split_SS_IPIP, output3_merge_func_cent)}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  
  # output1
  output1_A_DD <- lapply(output1_Alist_DD, output1_merge_func)
  
  # output2
  output2_A_DD <- lapply(output2_Alist_DD, output2_merge_func)
  
  # output3
  output3_A_DD_expInfl <- lapply(output3_Alist_DD, output3_merge_func_cent)}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  
  # output1
  output1_A_split_DD <- lapply(output1_Alist_split_DD, output1_merge_func)
  
  # output2
  output2_A_split_DD <- lapply(output2_Alist_split_DD, output2_merge_func)
  
  # output3
  output3_A_split_DD_expInfl <- lapply(output3_Alist_split_DD, output3_merge_func_cent)}



### Add condition details (i.e. dimension, nSamp, and ncol variables) to dataframes

# List of condition details
{# dimensions
  dimA <- rep("A", nSim)
  
  # conditions
  cond_DD <- rep("DD", nSim)
  cond_split_SS_NEO <- rep("split_SS_NEO", nSim)
  cond_split_SS_IPIP <- rep("split_SS_IPIP", nSim)
  cond_split_DD <- rep("split_DD", nSim)
  
  # nSamp levels
  nSamp0.2 <- rep(0.2, nSim)
  nSamp0.5 <- rep(0.5, nSim)
  nSamp0.8 <- rep(0.8, nSim)
  nSamp1.0 <- rep(1.0, nSim)
  
  # nSamp values
  nSamp0.2_84 <- rep(84, nSim)
  nSamp0.5_212 <- rep(212, nSim)
  nSamp0.8_339 <- rep(339, nSim)
  nSamp1.0_424 <- rep(424, nSim)
  
  # ncol levels
  ncol1 <- rep(1, nSim)
  ncol2 <- rep(2, nSim)
  ncol3 <- rep(3, nSim)
  ncol5 <- rep(5, nSim)
  ncol8 <- rep(8, nSim)}

# Apply to output1
{# CONDITION I. ("split_SS")
  output1_A_split_SS_NEO[[1]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.2, ncol1)
  output1_A_split_SS_NEO[[2]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.2, ncol2)
  output1_A_split_SS_NEO[[3]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.2, ncol3)
  output1_A_split_SS_NEO[[4]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.2, ncol5)
  output1_A_split_SS_NEO[[5]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.2, ncol8)
  
  output1_A_split_SS_NEO[[6]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.5, ncol1)
  output1_A_split_SS_NEO[[7]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.5, ncol2)
  output1_A_split_SS_NEO[[8]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.5, ncol3)
  output1_A_split_SS_NEO[[9]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.5, ncol5)
  output1_A_split_SS_NEO[[10]][1:nSim, 1:4] <- c(dimA, cond_split_SS_NEO, nSamp0.5, ncol8)
  
  
  output1_A_split_SS_IPIP[[1]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.2, ncol1)
  output1_A_split_SS_IPIP[[2]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.2, ncol2)
  output1_A_split_SS_IPIP[[3]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.2, ncol3)
  output1_A_split_SS_IPIP[[4]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.2, ncol5)
  output1_A_split_SS_IPIP[[5]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.2, ncol8)
  
  output1_A_split_SS_IPIP[[6]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.5, ncol1)
  output1_A_split_SS_IPIP[[7]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.5, ncol2)
  output1_A_split_SS_IPIP[[8]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.5, ncol3)
  output1_A_split_SS_IPIP[[9]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.5, ncol5)
  output1_A_split_SS_IPIP[[10]][1:nSim, 1:4] <- c(dimA, cond_split_SS_IPIP, nSamp0.5, ncol8)
  
  
  # CONDITION II. ("_DD")
  output1_A_DD[[1]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.2, ncol1)
  output1_A_DD[[2]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.2, ncol2)
  output1_A_DD[[3]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.2, ncol3)
  output1_A_DD[[4]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.2, ncol5)
  output1_A_DD[[5]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.2, ncol8)
  
  output1_A_DD[[6]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.5, ncol1)
  output1_A_DD[[7]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.5, ncol2)
  output1_A_DD[[8]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.5, ncol3)
  output1_A_DD[[9]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.5, ncol5)
  output1_A_DD[[10]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.5, ncol8)
  
  output1_A_DD[[11]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.8, ncol1)
  output1_A_DD[[12]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.8, ncol2)
  output1_A_DD[[13]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.8, ncol3)
  output1_A_DD[[14]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.8, ncol5)
  output1_A_DD[[15]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp0.8, ncol8)
  
  output1_A_DD[[16]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp1.0, ncol1)
  output1_A_DD[[17]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp1.0, ncol2)
  output1_A_DD[[18]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp1.0, ncol3)
  output1_A_DD[[19]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp1.0, ncol5)
  output1_A_DD[[20]][1:nSim, 1:4] <- c(dimA, cond_DD, nSamp1.0, ncol8)
  
  
  # CONDITION III. ("split_DD")
  output1_A_split_DD[[1]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.2, ncol1)
  output1_A_split_DD[[2]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.2, ncol2)
  output1_A_split_DD[[3]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.2, ncol3)
  output1_A_split_DD[[4]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.2, ncol5)
  output1_A_split_DD[[5]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.2, ncol8)
  
  output1_A_split_DD[[6]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.5, ncol1)
  output1_A_split_DD[[7]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.5, ncol2)
  output1_A_split_DD[[8]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.5, ncol3)
  output1_A_split_DD[[9]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.5, ncol5)
  output1_A_split_DD[[10]][1:nSim, 1:4] <- c(dimA, cond_split_DD, nSamp0.5, ncol8)}



### Compute avg edge weight, & avg global strength across conditions


# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  output1_A_split_SS_NEO_avg.glstr <- lapply(output1_A_split_SS_NEO, func_avg.glstr)
  output1_A_split_SS_IPIP_avg.glstr <- lapply(output1_A_split_SS_IPIP, func_avg.glstr)
  
  output1_A_split_SS_NEO_avg.glstr <- do.call("rbind.data.frame", output1_A_split_SS_NEO_avg.glstr)
  output1_A_split_SS_IPIP_avg.glstr <- do.call("rbind.data.frame", output1_A_split_SS_IPIP_avg.glstr)}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  output1_A_DD_avg.glstr <- lapply(output1_A_DD, func_avg.glstr)
  output1_A_DD_avg.glstr <- do.call("rbind.data.frame", output1_A_DD_avg.glstr)}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  output1_A_split_DD_avg.glstr <- lapply(output1_A_split_DD, func_avg.glstr)
  output1_A_split_DD_avg.glstr <- do.call("rbind.data.frame", output1_A_split_DD_avg.glstr)}



### Compute avg differences in adjacency matrices: edges (present/absent) across conditions


# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  output1_A_split_SS_NEO_avg.diff <- lapply(output1_A_split_SS_NEO, func_avg.diff)
  output1_A_split_SS_IPIP_avg.diff <- lapply(output1_A_split_SS_IPIP, func_avg.diff)
  
  output1_A_split_SS_NEO_avg.diff <- do.call("rbind.data.frame", output1_A_split_SS_NEO_avg.diff)
  output1_A_split_SS_IPIP_avg.diff <- do.call("rbind.data.frame", output1_A_split_SS_IPIP_avg.diff)
  
  # Add column that merges avg.diff_ab2pres and avg.diff_pres2ab columns
  output1_A_split_SS_NEO_avg.diff$avg.diff <- rowSums(output1_A_split_SS_NEO_avg.diff[,c("avg.diff_ab2pres", "avg.diff_pres2ab")])}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  output1_A_DD_avg.diff <- lapply(output1_A_DD, func_avg.diff)
  output1_A_DD_avg.diff <- do.call("rbind.data.frame", output1_A_DD_avg.diff)
  
  # Add column that merges avg.diff_ab2pres and avg.diff_pres2ab columns
  output1_A_DD_avg.diff$avg.diff <- rowSums(output1_A_DD_avg.diff[,c("avg.diff_ab2pres", "avg.diff_pres2ab")])}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  output1_A_split_DD_avg.diff <- lapply(output1_A_split_DD, func_avg.diff)
  output1_A_split_DD_avg.diff <- do.call("rbind.data.frame", output1_A_split_DD_avg.diff)
  
  # Add column that merges avg.diff_ab2pres and avg.diff_pres2ab columns
  output1_A_split_DD_avg.diff$avg.diff <- rowSums(output1_A_split_DD_avg.diff[,c("avg.diff_ab2pres", "avg.diff_pres2ab")])}



#*****



### CORRELATIONS between edge weights


## WHOLE-SAMPLE correlation

{# Run correlations on partial correlation matrices
  poppart_Alist <- list(NEO_A_part, IPIP_A_part)
  poppart_A <- cbind.data.frame(edge=edge_vector, NEO_pcedges=to.upper(poppart_Alist[[1]]), IPIP_pcedges=to.upper(poppart_Alist[[2]]))
  pop_A_edgecorr <- cor(poppart_A[,2], poppart_A[,3]) #col 2 = NEO scale; col 3 = IPIP scale
}

print(pop_A_edgecorr)
# 0.7950135



## SAMPLE correlations

## CONDITION vectors
{cond_vector_DD <- c("0.2_1", "0.2_2", "0.2_3", "0.2_5", "0.2_8",
                     "0.5_1", "0.5_2", "0.5_3", "0.5_5", "0.5_8",
                     "0.8_1", "0.8_2", "0.8_3", "0.8_5", "0.8_8",
                     "1.0_1", "1.0_2", "1.0_3", "1.0_5", "1.0_8")
  
  cond_vector_split_SS <- c("0.2_1", "0.2_2", "0.2_3", "0.2_5", "0.2_8",
                            "0.5_1", "0.5_2", "0.5_3", "0.5_5", "0.5_8")
  
  cond_vector_split_DD <- c("0.2_1", "0.2_2", "0.2_3", "0.2_5", "0.2_8",
                            "0.5_1", "0.5_2", "0.5_3", "0.5_5", "0.5_8")
  
  nSampValue_vector_DD <- c(84, 84, 84, 84, 84, 
                            212, 212, 212, 212, 212,
                            339, 339, 339, 339, 339, 
                            424, 424, 424, 424, 424)
  
  nSampValue_vector_split_SS <- c(84, 84, 84, 84, 84, 
                                  212, 212, 212, 212, 212)
  
  nSampValue_vector_split_DD <- c(84, 84, 84, 84, 84, 
                                  212, 212, 212, 212, 212)}


# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  
  # Create relevant lists
  output2_A_split_SS_NEO_edgecorr <- output2_A_split_SS_NEO_avg.edgecorr <- output2_A_split_SS_NEO_sd.edgecorr <- list()
  output2_A_split_SS_IPIP_edgecorr <- output2_A_split_SS_IPIP_avg.edgecorr <- output2_A_split_SS_IPIP_sd.edgecorr <- list()
  
  # Run for-loops
  for (i in 1:10) {
    output2_A_split_SS_NEO_edgecorr[[i]] <- output2_A_split_SS_IPIP_edgecorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output2_A_split_SS_NEO_edgecorr[[i]][[l]] <- cor(output2_A_split_SS_NEO[[i]][[l]]$x_pcedges, output2_A_split_SS_NEO[[i]][[l]]$y_pcedges)
      output2_A_split_SS_IPIP_edgecorr[[i]][[l]] <- cor(output2_A_split_SS_IPIP[[i]][[l]]$x_pcedges, output2_A_split_SS_IPIP[[i]][[l]]$y_pcedges)
    }
    
    output2_A_split_SS_NEO_edgecorr[[i]] <- do.call("rbind.data.frame", output2_A_split_SS_NEO_edgecorr[[i]])
    output2_A_split_SS_IPIP_edgecorr[[i]] <- do.call("rbind.data.frame", output2_A_split_SS_IPIP_edgecorr[[i]])
    output2_A_split_SS_NEO_edgecorr[[i]] <- setNames(output2_A_split_SS_NEO_edgecorr[[i]], "edgecorr_A")
    output2_A_split_SS_IPIP_edgecorr[[i]] <- setNames(output2_A_split_SS_IPIP_edgecorr[[i]], "edgecorr_A")
    output2_A_split_SS_NEO_avg.edgecorr[[i]] <- mean(output2_A_split_SS_NEO_edgecorr[[i]]$edgecorr_A)
    output2_A_split_SS_IPIP_avg.edgecorr[[i]] <- mean(output2_A_split_SS_IPIP_edgecorr[[i]]$edgecorr_A)
    output2_A_split_SS_NEO_sd.edgecorr[[i]] <- sd(output2_A_split_SS_NEO_edgecorr[[i]]$edgecorr_A)
    output2_A_split_SS_IPIP_sd.edgecorr[[i]] <- sd(output2_A_split_SS_IPIP_edgecorr[[i]]$edgecorr_A)
  }
  
  # Merge output2 results
  output2_A_split_SS_NEO_avg.edgecorr <- do.call("rbind.data.frame", output2_A_split_SS_NEO_avg.edgecorr)
  output2_A_split_SS_IPIP_avg.edgecorr <- do.call("rbind.data.frame", output2_A_split_SS_IPIP_avg.edgecorr)
  output2_A_split_SS_NEO_avg.edgecorr <- setNames(output2_A_split_SS_NEO_avg.edgecorr, "avg.edgecorr_A")
  output2_A_split_SS_IPIP_avg.edgecorr <- setNames(output2_A_split_SS_IPIP_avg.edgecorr, "avg.edgecorr_A")
  output2_A_split_SS_NEO_sd.edgecorr <- do.call("rbind.data.frame", output2_A_split_SS_NEO_sd.edgecorr)
  output2_A_split_SS_IPIP_sd.edgecorr <- do.call("rbind.data.frame", output2_A_split_SS_IPIP_sd.edgecorr)
  output2_A_split_SS_NEO_sd.edgecorr <- setNames(output2_A_split_SS_NEO_sd.edgecorr, "sd.edgecorr_A")
  output2_A_split_SS_IPIP_sd.edgecorr <- setNames(output2_A_split_SS_IPIP_sd.edgecorr, "sd.edgecorr_A")
  output2_A_split_SS_NEO_avg.edgecorr <- cbind.data.frame(condition=cond_vector_split_SS, A=nSampValue_vector_split_SS, output2_A_split_SS_NEO_avg.edgecorr,  output2_A_split_SS_NEO_sd.edgecorr)
  output2_A_split_SS_IPIP_avg.edgecorr <- cbind.data.frame(condition=cond_vector_split_SS, A=nSampValue_vector_split_SS, output2_A_split_SS_IPIP_avg.edgecorr, output2_A_split_SS_IPIP_sd.edgecorr)
}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  
  # Create relevant lists
  output2_A_DD_edgecorr <- output2_A_DD_avg.edgecorr <- output2_A_DD_sd.edgecorr <- list()
  
  # Run for-loops
  for (i in 1:20) {
    output2_A_DD_edgecorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output2_A_DD_edgecorr[[i]][[l]] <- cor(output2_A_DD[[i]][[l]]$x_pcedges, output2_A_DD[[i]][[l]]$y_pcedges)
    }
    
    output2_A_DD_edgecorr[[i]] <- do.call("rbind.data.frame", output2_A_DD_edgecorr[[i]])
    output2_A_DD_edgecorr[[i]] <- setNames(output2_A_DD_edgecorr[[i]], "edgecorr_A")
    output2_A_DD_avg.edgecorr[[i]] <- mean(output2_A_DD_edgecorr[[i]]$edgecorr_A)
    output2_A_DD_sd.edgecorr[[i]] <- sd(output2_A_DD_edgecorr[[i]]$edgecorr_A)
  }
  
  # Merge output2 results
  output2_A_DD_avg.edgecorr <- do.call("rbind.data.frame", output2_A_DD_avg.edgecorr)
  output2_A_DD_sd.edgecorr <- do.call("rbind.data.frame", output2_A_DD_sd.edgecorr)
  output2_A_DD_avg.edgecorr <- setNames(output2_A_DD_avg.edgecorr, "avg.edgecorr_A")
  output2_A_DD_sd.edgecorr <- setNames(output2_A_DD_sd.edgecorr, "sd.edgecorr_A")
  output2_A_DD_avg.edgecorr <- cbind.data.frame(condition=cond_vector_DD, A=nSampValue_vector_DD, output2_A_DD_avg.edgecorr, output2_A_DD_sd.edgecorr)
}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  
  # Create relevant lists
  output2_A_split_DD_edgecorr <- output2_A_split_DD_avg.edgecorr <- output2_A_split_DD_sd.edgecorr <- list()
  
  # Run for-loops
  for (i in 1:10) {
    output2_A_split_DD_edgecorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output2_A_split_DD_edgecorr[[i]][[l]] <- cor(output2_A_split_DD[[i]][[l]]$x_pcedges, output2_A_split_DD[[i]][[l]]$y_pcedges)
    }
    
    output2_A_split_DD_edgecorr[[i]] <- do.call("rbind.data.frame", output2_A_split_DD_edgecorr[[i]])
    output2_A_split_DD_edgecorr[[i]] <- setNames(output2_A_split_DD_edgecorr[[i]], "edgecorr_A")
    output2_A_split_DD_avg.edgecorr[[i]] <- mean(output2_A_split_DD_edgecorr[[i]]$edgecorr_A)
    output2_A_split_DD_sd.edgecorr[[i]] <- sd(output2_A_split_DD_edgecorr[[i]]$edgecorr_A)
  }
  
  # Merge output2 results
  output2_A_split_DD_avg.edgecorr <- do.call("rbind.data.frame", output2_A_split_DD_avg.edgecorr)
  output2_A_split_DD_avg.edgecorr <- setNames(output2_A_split_DD_avg.edgecorr, "avg.edgecorr_A")
  output2_A_split_DD_sd.edgecorr <- do.call("rbind.data.frame", output2_A_split_DD_sd.edgecorr)
  output2_A_split_DD_sd.edgecorr <- setNames(output2_A_split_DD_sd.edgecorr, "sd.edgecorr_A")
  output2_A_split_DD_avg.edgecorr <- cbind.data.frame(condition=cond_vector_split_DD, A=nSampValue_vector_split_DD, output2_A_split_DD_avg.edgecorr, output2_A_split_DD_sd.edgecorr)
}



#*****



### SPEARMAN Correlations btw CENTRALITY scores (Expected Influence)


## WHOLE-SAMPLE correlation

{# Run correlations on Expected Influence scores
  pop_A_NEO_ExpInfl <- centrality_NEO_A_pop_ggm$InExpectedInfluence #Expected Influence scores for NEO whole-sample network
  pop_A_IPIP_ExpInfl <- centrality_IPIP_A_pop_ggm$InExpectedInfluence #Expected Influence scsores for IPIP whole-sample network
  pop_A_centcorr <- cor(pop_A_NEO_ExpInfl, pop_A_IPIP_ExpInfl) #Pearson correlation 
  pop_A_centrankcorr <- cor(pop_A_NEO_ExpInfl, pop_A_IPIP_ExpInfl, method="spearman") #Spearman correlation
  
  # Case-drop bootstrap
  pop_A_NEO_casedrop <- bootnet(NEO_A_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  pop_A_IPIP_casedrop <- bootnet(IPIP_A_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  
  # Compute CS-coefficients (centrality stability)
  pop_A_NEO_cscoeff <- corStability(pop_A_NEO_casedrop, cor=0.7) 
  pop_A_IPIP_cscoeff <- corStability(pop_A_IPIP_casedrop, cor=0.7)
  
  # Edge-weight accuracy
  pop_A_NEO_edgeacc <- bootnet(NEO_A_pop_bootnet, nBoots=1000, nCores=4)
  pop_A_IPIP_edgeacc <- bootnet(IPIP_A_pop_bootnet, nBoots=1000, nCores=4)
}

#print(pop_A_centcorr) #(Pearson)
# 0.9684594

#print(pop_A_centrankcorr) #(Spearman)
# 0.9428571

#print(pop_A_NEO_cscoeff) #(correlation stability analysis for NEO pop network)
# "expectedInfluence: 0.52 (CS-coefficient is highest level tested)"

#print(pop_A_IPIP_cscoeff) #(correlation stability analysis for IPIP pop network)
# "expectedInfluence: 0.75 (CS-coefficient is highest level tested)"



## SAMPLE correlations

# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  
  # Create relevant lists
  output3_A_split_SS_NEO_expInfl_rankcorr <- output3_A_split_SS_NEO_expInfl_avg.rankcorr <- output3_A_split_SS_NEO_expInfl_sd.rankcorr <- list()
  
  # Run for-loops
  for (i in 1:10) {
    output3_A_split_SS_NEO_expInfl_rankcorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output3_A_split_SS_NEO_expInfl_rankcorr[[i]][[l]] <- cor(output3_A_split_SS_NEO_expInfl[[i]][[l]]$ExpectedInfluence_x, output3_A_split_SS_NEO_expInfl[[i]][[l]]$ExpectedInfluence_y, method="spearman")
    }
    
    output3_A_split_SS_NEO_expInfl_rankcorr[[i]] <- do.call("rbind.data.frame", output3_A_split_SS_NEO_expInfl_rankcorr[[i]])
    output3_A_split_SS_NEO_expInfl_rankcorr[[i]] <- setNames(output3_A_split_SS_NEO_expInfl_rankcorr[[i]], "expInfl_rankcorr_A")
    output3_A_split_SS_NEO_expInfl_avg.rankcorr[[i]] <- mean(output3_A_split_SS_NEO_expInfl_rankcorr[[i]]$expInfl_rankcorr_A)
    output3_A_split_SS_NEO_expInfl_sd.rankcorr[[i]] <- sd(output3_A_split_SS_NEO_expInfl_rankcorr[[i]]$expInfl_rankcorr_A)
  }
  
  # Merge output3 results
  output3_A_split_SS_NEO_expInfl_avg.rankcorr <- do.call("rbind.data.frame", output3_A_split_SS_NEO_expInfl_avg.rankcorr)
  output3_A_split_SS_NEO_expInfl_sd.rankcorr <- do.call("rbind.data.frame", output3_A_split_SS_NEO_expInfl_sd.rankcorr)
  output3_A_split_SS_NEO_expInfl_avg.rankcorr <- setNames(output3_A_split_SS_NEO_expInfl_avg.rankcorr, "avg.rankcorr_expInfl_A")
  output3_A_split_SS_NEO_expInfl_sd.rankcorr <- setNames(output3_A_split_SS_NEO_expInfl_sd.rankcorr, "sd.rankcorr_expInfl_A")
  output3_A_split_SS_NEO_expInfl_avg.rankcorr <- cbind.data.frame(condition=cond_vector_split_SS, A=nSampValue_vector_split_SS, output3_A_split_SS_NEO_expInfl_avg.rankcorr, output3_A_split_SS_NEO_expInfl_sd.rankcorr)
}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  
  # Create relevant lists
  output3_A_DD_expInfl_rankcorr <- output3_A_DD_expInfl_avg.rankcorr <- output3_A_DD_expInfl_sd.rankcorr <- list()
  
  # Run for-loops
  for (i in 1:20) {
    output3_A_DD_expInfl_rankcorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output3_A_DD_expInfl_rankcorr[[i]][[l]] <- cor(output3_A_DD_expInfl[[i]][[l]]$ExpectedInfluence_x, output3_A_DD_expInfl[[i]][[l]]$ExpectedInfluence_y, method="spearman")
    }
    
    output3_A_DD_expInfl_rankcorr[[i]] <- do.call("rbind.data.frame", output3_A_DD_expInfl_rankcorr[[i]])
    output3_A_DD_expInfl_rankcorr[[i]] <- setNames(output3_A_DD_expInfl_rankcorr[[i]], "expInfl_rankcorr_A")
    output3_A_DD_expInfl_avg.rankcorr[[i]] <- mean(output3_A_DD_expInfl_rankcorr[[i]]$expInfl_rankcorr_A,na.rm = TRUE)
    output3_A_DD_expInfl_sd.rankcorr[[i]] <- sd(output3_A_DD_expInfl_rankcorr[[i]]$expInfl_rankcorr_A,na.rm = TRUE)
  }
  
  # Merge output2 results
  output3_A_DD_expInfl_avg.rankcorr <- do.call("rbind.data.frame", output3_A_DD_expInfl_avg.rankcorr)
  output3_A_DD_expInfl_sd.rankcorr <- do.call("rbind.data.frame", output3_A_DD_expInfl_sd.rankcorr)
  output3_A_DD_expInfl_avg.rankcorr <- setNames(output3_A_DD_expInfl_avg.rankcorr, "avg.rankcorr_expInfl_A")
  output3_A_DD_expInfl_sd.rankcorr <- setNames(output3_A_DD_expInfl_sd.rankcorr, "sd.rankcorr_expInfl_A")
  output3_A_DD_expInfl_avg.rankcorr <- cbind.data.frame(condition=cond_vector_DD, A=nSampValue_vector_DD, output3_A_DD_expInfl_avg.rankcorr, output3_A_DD_expInfl_sd.rankcorr)
}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  
  # Create relevant lists
  output3_A_split_DD_expInfl_rankcorr <- output3_A_split_DD_expInfl_avg.rankcorr <- output3_A_split_DD_expInfl_sd.rankcorr <- list()
  
  # Run for-loops
  for (i in 1:10) {
    output3_A_split_DD_expInfl_rankcorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output3_A_split_DD_expInfl_rankcorr[[i]][[l]] <- cor(output3_A_split_DD_expInfl[[i]][[l]]$ExpectedInfluence_x, output3_A_split_DD_expInfl[[i]][[l]]$ExpectedInfluence_y, method="spearman")
    }
    
    output3_A_split_DD_expInfl_rankcorr[[i]] <- do.call("rbind.data.frame", output3_A_split_DD_expInfl_rankcorr[[i]])
    output3_A_split_DD_expInfl_rankcorr[[i]] <- setNames(output3_A_split_DD_expInfl_rankcorr[[i]], "expInfl_rankcorr_A")
    output3_A_split_DD_expInfl_avg.rankcorr[[i]] <- mean(output3_A_split_DD_expInfl_rankcorr[[i]]$expInfl_rankcorr_A,na.rm = TRUE)
    output3_A_split_DD_expInfl_sd.rankcorr[[i]] <- sd(output3_A_split_DD_expInfl_rankcorr[[i]]$expInfl_rankcorr_A,na.rm = TRUE)
  }
  
  #Merge output2 results
  output3_A_split_DD_expInfl_avg.rankcorr <- do.call("rbind.data.frame", output3_A_split_DD_expInfl_avg.rankcorr)
  output3_A_split_DD_expInfl_sd.rankcorr <- do.call("rbind.data.frame", output3_A_split_DD_expInfl_sd.rankcorr)
  output3_A_split_DD_expInfl_avg.rankcorr <- setNames(output3_A_split_DD_expInfl_avg.rankcorr, "avg.rankcorr_expInfl_A")
  output3_A_split_DD_expInfl_sd.rankcorr <- setNames(output3_A_split_DD_expInfl_sd.rankcorr, "sd.rankcorr_expInfl_A")
  output3_A_split_DD_expInfl_avg.rankcorr <- cbind.data.frame(condition=cond_vector_split_DD, A=nSampValue_vector_split_DD, output3_A_split_DD_expInfl_avg.rankcorr, output3_A_split_DD_expInfl_sd.rankcorr)
}



#*****



### SAVE RESULTS

save(# extracted data ("output1", "output2", and "output3")
     output1_A_split_SS_NEO, output1_A_split_SS_IPIP, output1_A_DD, output1_A_split_DD, 
     output2_A_split_SS_NEO, output2_A_split_SS_IPIP, output2_A_DD, output2_A_split_DD, 
     output3_A_split_SS_NEO_expInfl, output3_A_split_SS_IPIP_expInfl, output3_A_DD_expInfl, output3_A_split_DD_expInfl, 
     
     # "output 1" : descriptives
     output1_A_split_SS_NEO_avg.glstr, output1_A_split_SS_NEO_avg.diff, 
     output1_A_split_SS_IPIP_avg.glstr, output1_A_split_SS_IPIP_avg.diff, 
     output1_A_DD_avg.glstr, output1_A_DD_avg.diff, 
     output1_A_split_DD_avg.glstr, output1_A_split_DD_avg.diff, 
     
     # "output 2" : edge correlations
     output2_A_split_SS_NEO_avg.edgecorr, output2_A_split_SS_IPIP_avg.edgecorr, output2_A_DD_avg.edgecorr, output2_A_split_DD_avg.edgecorr, 
     
     # "output 3" : centrality correlations
     output3_A_split_SS_NEO_expInfl_avg.rankcorr, output3_A_DD_expInfl_avg.rankcorr, output3_A_split_DD_expInfl_avg.rankcorr, 
     
     # whole-sample data
     poppart_Alist, poppart_A, pop_A_edgecorr,
     pop_A_NEO_ExpInfl, pop_A_IPIP_ExpInfl, 
     pop_A_centcorr, pop_A_centrankcorr,
     pop_A_NEO_casedrop, pop_A_IPIP_casedrop,
     pop_A_NEO_cscoeff, pop_A_IPIP_cscoeff, 
     pop_A_NEO_edgeacc, pop_A_IPIP_edgeacc,
     
     file = "NEO & IPIP - P3_nSim50_results_all_A.RData")



##########



### VISUALIZE RESULTS

# Simple Bar Plots
barplot_colours5 <- brewer.pal(5, "Set2")
barplot_colours4 <- brewer.pal(4, "Pastel1")
barplot_colours3 <- brewer.pal(3, "Pastel1")



### FIGURE A1
# "Differences in Adjacency Matrices: Edges Estimated as Present versus Absent"

{par(mfrow = c(1,3), oma = c(5, 2, 3, 2))
  
  # I. CONDITION 1. Sampling Variability, i.e. ("split_SS_NEO") condition
  
  df.avg.diff_A_split_SS_NEO <- dplyr::select(output1_A_split_SS_NEO_avg.diff, avg.diff_ab2ab, avg.diff_pres2pres, avg.diff) 
  data.avg.diff_A_split_SS_NEO <- as.matrix(df.avg.diff_A_split_SS_NEO)
  data.avg.diff_A_split_SS_NEO <- t(data.avg.diff_A_split_SS_NEO)
  barplot_colours4 <- brewer.pal(4, "Pastel1")
  barplot(data.avg.diff_A_split_SS_NEO, beside = FALSE, col = barplot_colours3, border = "white",
          ylim = c(0, 19), ylab="Number of edges (avg. count)", main="Sampling Variability", las = 1,
          names.arg = c("1", "2", "3", "5", "8", "1", "2", "3", "5", "8"),
          xlab="Node aggregation",
          cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 2, cex.sub = 1.5, font = 1,
          space = c(0.2, 0.1, 0.1, 0.1, 0.1, 0.5, 0.1, 0.1, 0.1, 0.1))
  legend("top", ncol=1, cex=1.5, legend = c("Absent in both", "Present in both" , "Different in each"), fill = barplot_colours3, bty = "n") #can add title to legend square here with ".., title = "title")
  
  left_84 = "N = 84"
  left_212 = "N = 212"
  mtext(side=3, line=-7.5, at=2, adj=0, cex=1, left_84)
  mtext(side=3, line=-7.5, at=8, adj=0, cex=1, left_212)
  
  
  # CONDITION II. Scale Variability, i.e. ("_DD") condition
  
  df.avg.diff_A_DD <- dplyr::select(output1_A_DD_avg.diff, avg.diff_ab2ab, avg.diff_pres2pres, avg.diff)
  data.avg.diff_A_DD <- as.matrix(df.avg.diff_A_DD[1:10,])  
  data.avg.diff_A_DD <- t(data.avg.diff_A_DD)
  barplot_colours4 <- brewer.pal(4, "Pastel1")
  barplot(data.avg.diff_A_DD, beside = FALSE, col = barplot_colours3, border = "white",
          ylim = c(0, 19), ylab="Number of edges (avg. count)", main="Scale Variability", las = 1,
          names.arg = c("1", "2", "3", "5", "8", "1", "2", "3", "5", "8"),
          xlab="Node aggregation",
          cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 2, cex.sub = 1.5, font = 1,
          space = c(0.2, 0.1, 0.1, 0.1, 0.1, 0.5, 0.1, 0.1, 0.1, 0.1))
  legend("top", ncol=1, cex=1.5, legend = c("Absent in both", "Present in both" , "Different in each"), fill = barplot_colours3, bty = "n")
  
  mid_84 = "N = 84"
  mid_212 = "N = 212"
  mtext(side=3, line=-7.5, at=2, adj=0, cex=1, mid_84)
  mtext(side=3, line=-7.5, at=8, adj=0, cex=1, mid_212)
  
  
  # CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition
  
  df.avg.diff_A_split_DD <- dplyr::select(output1_A_split_DD_avg.diff, avg.diff_ab2ab, avg.diff_pres2pres, avg.diff) 
  data.avg.diff_A_split_DD <- as.matrix(df.avg.diff_A_split_DD) 
  data.avg.diff_A_split_DD <- t(data.avg.diff_A_split_DD)
  barplot_colours4 <- brewer.pal(4, "Pastel1")
  barplot(data.avg.diff_A_split_DD, beside = FALSE, col = barplot_colours3, border = "white",
          ylim = c(0, 19), ylab="Number of edges (avg. count)", main="Sampling & Scale Variability", las = 1,
          names.arg = c("1", "2", "3", "5", "8", "1", "2", "3", "5", "8"),
          xlab="Node aggregation", 
          cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 2, cex.sub = 1.5, font = 1,
          space = c(0.2, 0.1, 0.1, 0.1, 0.1, 0.5, 0.1, 0.1, 0.1, 0.1))
  legend("top", ncol=1, cex=1.5, legend = c("Absent in both", "Present in both" , "Different in each"), fill = barplot_colours3, bty = "n")
  
  right_84 = "N = 84"
  right_212 = "N = 212"
  mtext(side=3, line=-7.5, at=2, adj=0, cex=1, right_84)
  mtext(side=3, line=-7.5, at=8, adj=0, cex=1, right_212)
  
  
  # ADD main title
  mtext("Differences in Adjacency Matrices (Agreeableness)", outer=TRUE,  cex=1.5, font=1, line=-0.15)}



#*****



### FIGURE A2
# "Average Global Strength"

# CONDITION II. Scale Variability, i.e. ("_DD") condition
{par(mfrow = c(1,2), oma = c(0, 0, 2, 0))
  
  means_x <- as.vector(output1_A_DD_avg.glstr$avg.glstr_x)
  means_y <- as.vector(output1_A_DD_avg.glstr$avg.glstr_y)
  
  sds_x <- as.vector(output1_A_DD_avg.glstr$sd.glstr_x)
  sds_y <- as.vector(output1_A_DD_avg.glstr$sd.glstr_y)
  
  ses_x <- sds_x/sqrt(as.vector(output1_A_DD_avg.glstr$nSampValue))
  ses_y <- sds_y/sqrt(as.vector(output1_A_DD_avg.glstr$nSampValue))
  
  CI_x <- 1.96*ses_x
  CI_y <- 1.96*ses_y
  
  # Average global strength: Neuroticism (NEO)
  barCenters_x <- barplot(means_x, ylim = c(0, 3.5), ylab = "Average global strength", las = 1,
                          names.arg = c("", "84", "84", "", "", "", "212", "212", "", "", "", "339", "339", "", "", "", "424", "424", "", ""), xlab="Sample size",
                          main="NEO scale", col = barplot_colours5,
                          cex.names = 1.5, cex.axis = 1.5, cex.lab=1.5, cex.main = 1.5, cex.sub = 1.5, font = 1,
                          space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_x, means_x - CI_x, barCenters_x, means_x + CI_x, lwd = 1.5, angle = 90, code = 3, length = 0.05)        
  legend("top", ncol=2, cex=1.25, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  # Average global strength: Neuroticism (IPIP)
  barCenters_y <- barplot(means_y, ylim = c(0, 3.5), ylab = "Average global strength", las = 1,
                          names.arg = c("", "84", "84", "", "", "", "212", "212", "", "", "", "339", "339", "", "", "", "424", "424", "", ""), xlab="Sample size",
                          main="IPIP scale", col = barplot_colours5,
                          cex.names = 1.5, cex.axis = 1.5, cex.lab=1.5, cex.main = 1.5, cex.sub = 1.5, font = 1,
                          space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_y, means_y - CI_y, barCenters_y, means_y + CI_y, lwd = 1.5, angle = 90, code = 3, length = 0.05)        
  legend("top", ncol=2, cex=1.25, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  # ADD main title
  mtext("Average Global Strength (Agreeableness)", outer=TRUE,  cex=2, font=1, line=-0.5)}



#*****



### FIGURE A3
# "Difference in Average Global Strength"

{par(mfrow = c(1,3), oma = c(2, 2, 3, 2))
  
  # I. CONDITION 1. Sampling Variability, i.e. ("split_SS_NEO") condition
  
  means_split_SS_x <- as.vector(output1_A_split_SS_NEO_avg.glstr$avg.glstr_diff)
  sds_split_SS_x <- as.vector(output1_A_split_SS_NEO_avg.glstr$sd.glstr_diff)
  ses_split_SS_x <- sds_split_SS_x/sqrt(as.vector(output1_A_split_SS_NEO_avg.glstr$nSampValue))
  CI_split_SS_x <- 1.96*ses_split_SS_x
  
  barCenters_split_SS_x <- barplot(means_split_SS_x, ylim = c(0, 0.6), ylab = "Difference in average global strength", las = 1,
                                   names.arg = c("",  "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                   main="Sampling Variability", col = barplot_colours5,
                                   cex.names = 1.5, cex.axis = 1.5, cex.lab=1.75, cex.main = 1.5, font = 1,
                                   space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_split_SS_x, means_split_SS_x - CI_split_SS_x, barCenters_split_SS_x, means_split_SS_x + CI_split_SS_x, lwd = 1.5, angle = 90, code = 3, length = 0.05)          
  legend("top", cex=1.5, ncol=2, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  
  # CONDITION II. Scale Variability, i.e. ("_DD") condition
  
  means_DD <- as.vector(output1_A_DD_avg.glstr$avg.glstr_diff[1:10])
  sds_DD <- as.vector(output1_A_DD_avg.glstr$sd.glstr_diff[1:10])
  ses_DD <- sds_DD/sqrt(as.vector(output1_A_DD_avg.glstr$nSampValue[1:10]))
  CI_DD <- 1.96*ses_DD
  
  barCenters_DD <- barplot(means_DD, ylim = c(0, 0.6), ylab = "Difference in average global strength", las = 1,
                           names.arg = c("",  "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                           main="Scale Variability", col = barplot_colours5,
                           cex.names = 1.5, cex.axis = 1.5, cex.lab=1.75, cex.main = 1.5, font = 1,
                           space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_DD, means_DD - CI_DD, barCenters_DD, means_DD + CI_DD, lwd = 1.5, angle = 90, code = 3, length = 0.05)          
  legend("top", cex=1.5, ncol=2, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  
  # CONDITION III. Sampling & Scale Variability, i.e. ("split_DD") condition
  
  means_split_DD <- as.vector(output1_A_split_DD_avg.glstr$avg.glstr_diff)
  sds_split_DD <- as.vector(output1_A_split_DD_avg.glstr$sd.glstr_diff)
  ses_split_DD <- sds_split_DD/sqrt(as.vector(output1_A_split_DD_avg.glstr$nSampValue))
  CI_split_DD <- 1.96*ses_split_DD
  
  barCenters_split_DD <- barplot(means_split_DD, ylim = c(0, 0.6), ylab = "Difference in average global strength", las = 1,
                                 names.arg = c("",  "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                 main="Sampling & Scale Variability", col = barplot_colours5,
                                 cex.names = 1.5, cex.axis = 1.5, cex.lab=1.75, cex.main = 1.5, font = 1,
                                 space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_split_DD, means_split_DD - CI_split_DD, barCenters_split_DD, means_split_DD + CI_split_DD, lwd = 1.5, angle = 90, code = 3, length = 0.05)          
  legend("top", cex=1.5, ncol=2, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  # ADD main title
  mtext("Difference in Average Global Strength (Agreeableness)", outer=TRUE,  cex=1.5, font=1, line=-0.5)}



#*****



### FIGURE A4
# "Correlations Between Edge Weights"

{par(mfrow = c(1,3), oma = c(2, 2, 3, 2))
  
  # I. Sampling Variability, i.e. ("split_SS") condition
  
  means_split_SS_x <- as.vector(output2_A_split_SS_NEO_avg.edgecorr$avg.edgecorr_A)
  means_split_SS_y <- as.vector(output2_A_split_SS_IPIP_avg.edgecorr$avg.edgecorr_A)
  
  sds_split_SS_x <- as.vector(output2_A_split_SS_NEO_avg.edgecorr$sd.edgecorr_A)
  sds_split_SS_y <- as.vector(output2_A_split_SS_IPIP_avg.edgecorr$sd.edgecorr_A)
  
  barCenters_split_SS_x <- barplot(means_split_SS_x, ylim = c(0, 1.0), ylab = "Correlation", las = 1,
                                   names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                   main="Sampling Variability", col = barplot_colours5,
                                   cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, cex.sub = 1, font = 1,
                                   space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_split_SS_x, means_split_SS_x - CI_split_SS_x, barCenters_split_SS_x, means_split_SS_x + CI_split_SS_x, lwd = 1.5, angle = 90, code = 3, length = 0.05)         
  legend("top", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  
  # II. Scale Variability, i.e. ("_DD") condition
  
  means_DD <- as.vector(output2_A_DD_avg.edgecorr$avg.edgecorr_A[c(1:10)])
  sds_DD <- as.vector(output2_A_DD_avg.edgecorr$sd.edgecorr_A[c(1:10)])
  ses_DD <- sds_DD/sqrt(as.vector(output2_A_DD_avg.edgecorr$A[c(1:10)]))
  CI_DD <- 1.96*ses_DD
  
  barCenters_DD <- barplot(means_DD, ylim = c(0, 1.0), ylab = "Correlation", las = 1,
                           names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                           main="Scale Variability", col = barplot_colours5,
                           cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, cex.sub = 1, font = 1,
                           space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_DD, means_DD - CI_DD, barCenters_DD, means_DD + CI_DD, lwd = 1.5, angle = 90, code = 3, length = 0.05)
  legend("top", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  
  # III. Sampling & Scale Variability, i.e. ("split_DD") condition
  
  means_split_DD <- as.vector(output2_A_split_DD_avg.edgecorr$avg.edgecorr_A)
  sds_split_DD <- as.vector(output2_A_split_DD_avg.edgecorr$sd.edgecorr_A)
  ses_split_DD <- sds_split_DD/sqrt(as.vector(output2_A_split_DD_avg.edgecorr$A))
  CI_split_DD <- 1.96*ses_split_DD
  
  barCenters_split_DD <- barplot(means_split_DD, ylim = c(0, 1.0), ylab = "Correlation", las = 1,
                                 names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                 main="Sampling & Scale Variability", col = barplot_colours5,
                                 cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, cex.sub = 1, font = 1,
                                 space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_split_DD, means_split_DD - CI_split_DD, barCenters_split_DD, means_split_DD + CI_split_DD, lwd = 1.5, angle = 90, code = 3, length = 0.05)        
  legend("top", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  # ADD main title
  mtext("Correlations Between Edge Weights (Agreeableness)", outer=TRUE,  cex=1.5, font=1, line=-0.15)}



#*****



### FIGURE A5
# "Correlations Between Centrality Scores (Expected Influence)"

{par(mfrow = c(1,3), oma = c(2, 2, 3, 2))
  
  # I. Sampling Variability, i.e. ("split_SS") condition
  
  means_expInfl_split_SS_x <- as.vector(output3_A_split_SS_NEO_expInfl_avg.rankcorr$avg.rankcorr_expInfl_A)
  sds_expInfl_split_SS_x <- as.vector(output3_A_split_SS_NEO_expInfl_avg.rankcorr$sd.rankcorr_expInfl_A)
  ses_expInfl_split_SS_x <- sds_expInfl_split_SS_x/sqrt(as.vector(output3_A_split_SS_NEO_expInfl_avg.rankcorr$A))
  CI_expInfl_split_SS_x <- 1.96*ses_expInfl_split_SS_x
  
  barCenters_expInfl_split_SS_x <- barplot(means_expInfl_split_SS_x, ylim = c(0, 1.0), ylab = "Correlation", las = 1,
                                           names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                           cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, font = 1,
                                           main="Sampling Variability", col = barplot_colours5,
                                           space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_expInfl_split_SS_x, means_expInfl_split_SS_x - CI_expInfl_split_SS_x, barCenters_expInfl_split_SS_x, means_expInfl_split_SS_x + CI_expInfl_split_SS_x, lwd = 1.5, angle = 90, code = 3, length = 0.05)         
  legend("top", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  
  # II. Scale Variability, i.e. ("_DD") condition
  
  means_expInfl_DD <- as.vector(output3_A_DD_expInfl_avg.rankcorr$avg.rankcorr_expInfl_A[c(1:10)])
  sds_expInfl_DD <- as.vector(output3_A_DD_expInfl_avg.rankcorr$sd.rankcorr_expInfl_A[c(1:10)])
  ses_expInfl_DD <- sds_expInfl_DD/sqrt(as.vector(output3_A_DD_expInfl_avg.rankcorr$A[c(1:10)]))
  CI_expInfl_DD <- 1.96*ses_expInfl_DD
  
  barCenters_expInfl_DD <- barplot(means_expInfl_DD, ylim = c(0, 1.0), ylab = "Correlation", las = 1,
                                   names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                   cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, font = 1,
                                   main="Scale Variability", col = barplot_colours5,
                                   space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_expInfl_DD, means_expInfl_DD - CI_expInfl_DD, barCenters_expInfl_DD, means_expInfl_DD + CI_expInfl_DD, lwd = 1.5, angle = 90, code = 3, length = 0.05)
  legend("top", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  
  # III. Sampling & Scale Variability, i.e. ("split_DD") condition
  
  means_expInfl_split_DD <- as.vector(output3_A_split_DD_expInfl_avg.rankcorr$avg.rankcorr_expInfl_A)
  sds_expInfl_split_DD <- as.vector(output3_A_split_DD_expInfl_avg.rankcorr$sd.rankcorr_expInfl_A)
  ses_expInfl_split_DD <- sds_expInfl_split_DD/sqrt(as.vector(output3_A_split_DD_expInfl_avg.rankcorr$A))
  CI_expInfl_split_DD <- 1.96*ses_expInfl_split_DD
  
  barCenters_expInfl_split_DD <- barplot(means_expInfl_split_DD, ylim = c(0, 1.0), ylab = "Correlation", las = 1,
                                         names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                         cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, font = 1,
                                         main="Sampling & Scale Variability", col = barplot_colours5,
                                         space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_expInfl_split_DD, means_expInfl_split_DD - CI_expInfl_split_DD, barCenters_expInfl_split_DD, means_expInfl_split_DD + CI_expInfl_split_DD, lwd = 1.5, angle = 90, code = 3, length = 0.05)        
  legend("top", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node aggregation", bty = "n")
  
  # ADD main title
  mtext("Correlations Between Centrality Scores (Agreeableness)", outer=TRUE,  cex=1.5, font=1, line=-0.15)}



#*****



### FIGURE A6
# "Whole-Sample Networks (Agreeableness)"

# Agreeableness
{# First estimate network on full sample (using ggmModSelect)
  NEO_A_popnet <- bootnet::estimateNetwork(df.NEO.A.pop, "ggmModSelect")
  IPIP_A_popnet <- bootnet::estimateNetwork(df.IPIP.A.pop, "ggmModSelect")
  
  # Graph from estimated network
  graph_A_NEO_V2 <- qgraph(NEO_A_popnet$graph, layout = "spring", labels = itemlabels_A_NEO, title = "Whole-Sample Network (NEO)")
  graph_A_IPIP_V2 <- qgraph(IPIP_A_popnet$graph, layout = "spring", labels = itemlabels_A_IPIP, title = "Whole-Sample Network (IPIP)")
  
  # In this case, do not use average layout of both graphs (because it yields overlapping edges; use IPIP layout)
  Layout_A_V1 <- averageLayout(graph_A_IPIP_V1, graph_A_IPIP_V1)
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  par(mfrow = c(1,2))
  graph_A_NEO_V2 <- qgraph(NEO_A_popnet$graph, layout = Layout_A_V1, labels = itemlabels_A_NEO, GLratio = 2.25, title = "Whole-Sample Network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_A_NEO, negDashed = TRUE, maximum = 0.45)
  graph_A_IPIP_V2 <- qgraph(IPIP_A_popnet$graph, layout =  Layout_A_V1, labels = itemlabels_A_IPIP, GLratio = 2.25, title = "Whole-Sample Network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_A_IPIP, negDashed = TRUE, maximum = 0.45)}


#*****



### FIGURE A7
# "Whole-Sample Networks (Agreeableness): Accuracy of Edge Weight Estimates"

plot(pop_A_NEO_edgeacc, labels = TRUE, order = "sample")
plot(pop_A_IPIP_edgeacc, labels = TRUE, order = "sample")

## 2-panel plot (ordered by "sample")
{require(gridExtra)
  # TOP PLOT
  NEO_pop_edgeacc_plot <- plot(pop_A_NEO_edgeacc, labels = TRUE, order = "sample")
  
  # BOTTOM PLOT
  IPIP_pop_edgeacc_plot <- plot(pop_A_IPIP_edgeacc, labels = TRUE, order = "sample")
  
  grid.arrange(NEO_pop_edgeacc_plot, IPIP_pop_edgeacc_plot, ncol=1)}



#*****



### FIGURE A8
# "Whole-Sample Networks (Agreeableness): Correspondence in Expected Influence Scores"

# Centrality scores (expected influence): 1-panel plot
A_ExpInf_plot <- centralityPlot(list(NEO = NEO_A_pop_bootnet, IPIP = IPIP_A_pop_bootnet), include = c("ExpectedInfluence"), scale = "raw", orderBy = "ExpectedInfluence")



#*****



### FIGURE A9
# "Whole-Sample Networks (Agreeableness): Centrality Stability (Expected Influence)"

# CS-coefficients (centrality stability): 2-panel plot
{require(gridExtra)
  # TOP PLOT
  NEO_pop_casedrop_plot_A <- plot(pop_A_NEO_casedrop, statistics = "expectedInfluence")
  # BOTTOM PLOT
  IPIP_pop_casedrop_plot_A <- plot(pop_A_IPIP_casedrop, statistics = "expectedInfluence")
  grid.arrange(NEO_pop_casedrop_plot_A, IPIP_pop_casedrop_plot_A, ncol=1)}



##########



### TABLE (& text) DESCRIPTIVES



### Table A1 (corresponding to FIGURE 1)
# "Differences in Adjacency Matrices: Descriptives"

{# Condition I "sampling variability"
  output1_A_split_SS_NEO_avg.diff %>% dplyr::select(avg.diff_ab2ab, avg.diff_pres2pres, avg.diff) 
  
  # Condition II "scale variability"
  output1_A_DD_avg.diff %>% dplyr::select(avg.diff_ab2ab, avg.diff_pres2pres, avg.diff) 
  
  # Condition III "sampling & scale variability"
  output1_A_split_DD_avg.diff %>% dplyr::select(avg.diff_ab2ab, avg.diff_pres2pres, avg.diff)}



#*****



### Table A2 (corresponding to FIGURE 2)
# "Average Global Strength: Descriptives"

{# NEO scale
  output1_A_DD_avg.glstr %>% dplyr::select(nSamp, nSampValue, avg.glstr_x, sd.glstr_x)
  
  # IPIP scale
  output1_A_DD_avg.glstr %>% dplyr::select(nSamp, nSampValue, avg.glstr_y, sd.glstr_y)}



#*****



### Table A3 (corresponding to FIGURE 3)
# "Differences in Average Global Strength: Descriptives"

{# Condition I "sampling variability"
  output1_A_split_SS_NEO_avg.glstr %>% dplyr::select(nSamp, nSampValue, avg.glstr_diff, sd.glstr_diff)
  
  # Condition II "scale variability"
  output1_A_DD_avg.glstr %>% dplyr::select(nSamp, nSampValue, avg.glstr_diff, sd.glstr_diff)
  
  # Condition III "sampling & scale variability"
  output1_A_split_DD_avg.glstr %>% dplyr::select(nSamp, nSampValue, avg.glstr_diff, sd.glstr_diff)}



#*****



### Table A4 (corresponding to FIGURE 4)
# "Correlations Between Edge Weights: Descriptives"

{# Condition I "sampling variability"
  # note: 8-item indicator (n=212) -> r = 0.7069658
  output2_A_split_SS_NEO_avg.edgecorr
  
  # Condition II "scale variability"
  # note: 8-item indicator (n=212) -> r = 0.6587063
  output2_A_DD_avg.edgecorr
  
  # Condition III "sampling & scale variability"
  # note: 8-item indicator (n=212) -> r = 0.6054491
  output2_A_split_DD_avg.edgecorr}



#*****



### Table A5 (corresponding to FIGURE 5)
# "Correlations Between Centrality Scores: Descriptives"

{# Condition I "sampling variability"
  # note: 8-item indicator (n=212) -> r = 0.8548571 
  output3_A_split_SS_NEO_expInfl_avg.rankcorr
  
  
  # Condition II "scale variability"
  # note: 8-item indicator (n=212) -> r = 0.8891429
  output3_A_DD_expInfl_avg.rankcorr
  
  
  # Condition III "sampling & scale variability"
  # note: 8-item indicator (n=212) -> r = 0.8605714
  output3_A_split_DD_expInfl_avg.rankcorr}



#*****



## TABLE A6: WHOLE-SAMPLE NETWORK CHARACTERISTICS (estimated from ggm networks)

# Global strength
netcompare_Alist_pop_DD_pval$glstrinv.sep_x #NEO network global strength
netcompare_Alist_pop_DD_pval$glstrinv.sep_y #IPIP network global strength
netcompare_Alist_pop_DD_pval$glstrinv.real #NCT comparison (global strength invariance): difference value
netcompare_Alist_pop_DD_pval$glstrinv.pval #NCT comparison (global strength invariance): accompanying p-value

# Average edge strength (i.e. absolute edge weights, averaged across only non-zero edges)
{#compute for NEO pop network
  NEO_A_pop_ggm_graph <- NEO_A_pop_bootnet$graph
  NEO_A_pop_ggm_graph_na <- NEO_A_pop_ggm_graph
  is.na(NEO_A_pop_ggm_graph_na) <- NEO_A_pop_ggm_graph_na==0 #edge weight matrix (with zeros set to NA) for NEO pop network
  avg.abs_esize_NEO_A_pop <- mean(NEO_A_pop_ggm_graph_na[upper.tri(NEO_A_pop_ggm_graph_na, diag = FALSE)], na.rm = TRUE) #avg edge weight for NEO present edges
  sd.abs_esize_NEO_A_pop <- sd(NEO_A_pop_ggm_graph_na[upper.tri(NEO_A_pop_ggm_graph_na, diag = FALSE)], na.rm = TRUE) #sd of edge weights for NEO present edges
  #compute for IPIP pop network
  IPIP_A_pop_ggm_graph <- IPIP_A_pop_bootnet$graph
  IPIP_A_pop_ggm_graph_na <- IPIP_A_pop_ggm_graph
  is.na(IPIP_A_pop_ggm_graph_na) <- IPIP_A_pop_ggm_graph_na==0 #edge weight matrix (with zeros set to NA) for IPIP pop network
  avg.abs_esize_IPIP_A_pop <- mean(IPIP_A_pop_ggm_graph_na[upper.tri(IPIP_A_pop_ggm_graph_na, diag = FALSE)], na.rm = TRUE) #avg edge weight for NEO present edges
  sd.abs_esize_IPIP_A_pop <- sd(IPIP_A_pop_ggm_graph_na[upper.tri(IPIP_A_pop_ggm_graph_na, diag = FALSE)], na.rm = TRUE) #sd of edge weights for NEO present edges
}
#print results
avg.abs_esize_NEO_A_pop #  0.1891396
sd.abs_esize_NEO_A_pop # 0.1393977
avg.abs_esize_IPIP_A_pop # 0.2048505
sd.abs_esize_IPIP_A_pop # 0.185275

# CS-coefficients
pop_A_NEO_cscoeff # 0.5165094
pop_A_IPIP_cscoeff # 0.75

# Centrality scores
centrality_NEO_A_pop_ggm$InExpectedInfluence #NEO scale
centrality_IPIP_A_pop_ggm$InExpectedInfluence #IPIP scale
# netcompare_Nlist_pop_DD_pval$diffcen.real #NCT comparison
# netcompare_Nlist_pop_DD_pval$diffcen.pval #NCT comparison

# Individual edges
netcompare_Alist_pop_DD_pval$einv.real #NCT comparison (edge strength invariance): difference values
netcompare_Alist_pop_DD_pval$einv.pvals #NCT comparison (edge strength invariance): accompanying p-values



#*****



### TABLE A7: OVERVIEW OF NETWORK CHARACTERISTICS

## Descriptives @nSamp = 0.5 (i.e. n=212)
## Resampling Condition = Scale Variability ("DD" conditions)

# Average global strength
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"),c("avg.glstr_x", "sd.glstr_x")] #NEO scale 
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"),c("avg.glstr_y", "sd.glstr_y")] #IPIP scale 

# Average edge strength (i.e. absolute edge weights across non-zero edges)
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"),c("grdmean.abs_esize_x_NCT", "sd.grdmean.abs_esize_x_NCT")] #NEO scale 
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"),c("grdmean.abs_esize_y_NCT", "sd.grdmean.abs_esize_y_NCT")] #IPIP scale 

# Mean number of present (i.e.non-zero) edges
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"), c("avg.present_x", "sd.present_x")] #NEO scale
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"), c("avg.present_y", "sd.present_y")] #IPIP scale

# Mean number of absent (i.e. zero) edges
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"), c("avg.absent_x", "sd.absent_x")] #NEO scale
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"), c("avg.absent_y", "sd.absent_y")] #IPIP scale

# Average correlation btw edge weights
output2_A_DD_avg.edgecorr[c(6,8,10), c("condition", "avg.edgecorr_A", "sd.edgecorr_A")]

# Average correlation btw centrality scores
output3_A_DD_expInfl_avg.rankcorr[c(6,8,10), c("condition", "avg.rankcorr_expInfl_A", "sd.rankcorr_expInfl_A")]

# Centrality frequencies (re: most central nodes)
output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"), c("expinfl_1st_x_freq_N1", "expinfl_1st_x_freq_N2", "expinfl_1st_x_freq_N3",
                                                             "expinfl_1st_x_freq_N4", "expinfl_1st_x_freq_N5", "expinfl_1st_x_freq_N6")] #NEO scale

output1_A_DD_avg.glstr[c("A_0.5_1", "A_0.5_3", "A_0.5_8"), c("expinfl_1st_y_freq_N1", "expinfl_1st_y_freq_N2", "expinfl_1st_y_freq_N3",
                                                             "expinfl_1st_y_freq_N4", "expinfl_1st_y_freq_N5", "expinfl_1st_y_freq_N6")] #IPIP scale


# Largest edges (frequencies)
# largest edge frequencies (network 1: NEO)
{# condition: 1-item indicator (n=212)
  output1_A_DD_maxedge_0.5_1_x_comb <- combSummarise(output1_A_DD$A_0.5_1, var=c("edge_x_max_1", "edge_x_max_2"), summarise=c("length(edge_x_max_1)"))
  output1_A_DD_maxedge_0.5_1_x_nona <- na.omit(output1_A_DD_maxedge_0.5_1_x_comb) # select relevant rows
  output1_A_DD_maxedge_0.5_1_x_order <- output1_A_DD_maxedge_0.5_1_x_nona[order(output1_A_DD_maxedge_0.5_1_x_nona$'length(edge_x_max_1)'),] # order by frequency
  
  # condition: 3-item indicator (n=212)
  output1_A_DD_maxedge_0.5_3_x_comb <- combSummarise(output1_A_DD$A_0.5_3, var=c("edge_x_max_1", "edge_x_max_2"), summarise=c("length(edge_x_max_1)"))
  output1_A_DD_maxedge_0.5_3_x_nona <- na.omit(output1_A_DD_maxedge_0.5_3_x_comb) # select relevant rows
  output1_A_DD_maxedge_0.5_3_x_order <- output1_A_DD_maxedge_0.5_3_x_nona[order(output1_A_DD_maxedge_0.5_3_x_nona$'length(edge_x_max_1)'),] # order by frequency
  
  # condition: 8-item indicator (n=212)
  output1_A_DD_maxedge_0.5_8_x_comb <- combSummarise(output1_A_DD$A_0.5_8, var=c("edge_x_max_1", "edge_x_max_2"), summarise=c("length(edge_x_max_1)"))
  output1_A_DD_maxedge_0.5_8_x_nona <- na.omit(output1_A_DD_maxedge_0.5_8_x_comb) # select relevant rows
  output1_A_DD_maxedge_0.5_8_x_order <- output1_A_DD_maxedge_0.5_8_x_nona[order(output1_A_DD_maxedge_0.5_8_x_nona$'length(edge_x_max_1)'),] # order by frequency
}
# largest edge frequencies (network 2: IPIP)
{# condition: 1-item indicator (n=212)
  output1_A_DD_maxedge_0.5_1_y_comb <- combSummarise(output1_A_DD$A_0.5_1, var=c("edge_y_max_1", "edge_y_max_2"), summarise=c("length(edge_y_max_1)"))
  output1_A_DD_maxedge_0.5_1_y_nona <- na.omit(output1_A_DD_maxedge_0.5_1_y_comb) # select relevant rows
  output1_A_DD_maxedge_0.5_1_y_order <- output1_A_DD_maxedge_0.5_1_y_nona[order(output1_A_DD_maxedge_0.5_1_y_nona$'length(edge_y_max_1)'),] # order by frequency
  
  # condition: 3-item indicator (n=212)
  output1_A_DD_maxedge_0.5_3_y_comb <- combSummarise(output1_A_DD$A_0.5_3, var=c("edge_y_max_1", "edge_y_max_2"), summarise=c("length(edge_y_max_1)"))
  output1_A_DD_maxedge_0.5_3_y_nona <- na.omit(output1_A_DD_maxedge_0.5_3_y_comb) # select relevant rows
  output1_A_DD_maxedge_0.5_3_y_order <- output1_A_DD_maxedge_0.5_3_y_nona[order(output1_A_DD_maxedge_0.5_3_y_nona$'length(edge_y_max_1)'),] # order by frequency
  
  # condition: 8-item indicator (n=212)
  output1_A_DD_maxedge_0.5_8_y_comb <- combSummarise(output1_A_DD$A_0.5_8, var=c("edge_y_max_1", "edge_y_max_2"), summarise=c("length(edge_y_max_1)"))
  output1_A_DD_maxedge_0.5_8_y_nona <- na.omit(output1_A_DD_maxedge_0.5_8_y_comb) # select relevant rows
  output1_A_DD_maxedge_0.5_8_y_order <- output1_A_DD_maxedge_0.5_8_y_nona[order(output1_A_DD_maxedge_0.5_8_y_nona$'length(edge_y_max_1)'),] # order by frequency
}
#print frequencies [recall: N1=ANX, N2=ANG, N3=DEP, N4=SELF, N5=IMP, N6=VUL]
{print(output1_A_DD_maxedge_0.5_1_x_order) # 1-item (n=212) NEO scale
  print(output1_A_DD_maxedge_0.5_1_y_order) # 1-item (n=212) IPIP scale
  print(output1_A_DD_maxedge_0.5_3_x_order) # 3-item (n=212) NEO scale
  print(output1_A_DD_maxedge_0.5_3_y_order) # 3-item (n=212) IPIP scale
  print(output1_A_DD_maxedge_0.5_8_x_order) # 8-item (n=212) NEO scale
  print(output1_A_DD_maxedge_0.5_8_y_order) # 8-item (n=212) IPIP scale
}


# Max. edge differences (frequencies)
# condition: 1-item indicator (n=212)
{output1_A_DD_maxdiff_0.5_1_comb <- combSummarise(output1_A_DD$A_0.5_1, var=c("edge_NCT_1", "edge_NCT_2"), summarise=c("length(edge_NCT_1)"))
  output1_A_DD_maxdiff_0.5_1_nona <- na.omit(output1_A_DD_maxdiff_0.5_1_comb) # select relevant rows
  output1_A_DD_maxdiff_0.5_1_order <- output1_A_DD_maxdiff_0.5_1_nona[order(output1_A_DD_maxdiff_0.5_1_nona$'length(edge_NCT_1)'),] # order by frequency
}
# condition: 3-item indicator (n=212)
{output1_A_DD_maxdiff_0.5_3_comb <- combSummarise(output1_A_DD$A_0.5_3, var=c("edge_NCT_1", "edge_NCT_2"), summarise=c("length(edge_NCT_1)"))
  output1_A_DD_maxdiff_0.5_3_nona <- na.omit(output1_A_DD_maxdiff_0.5_3_comb) # select relevant rows
  output1_A_DD_maxdiff_0.5_3_order <- output1_A_DD_maxdiff_0.5_3_nona[order(output1_A_DD_maxdiff_0.5_3_nona$'length(edge_NCT_1)'),] # order by frequency
}
# condition: 8-item indicator (n=212)
{output1_A_DD_maxdiff_0.5_8_comb <- combSummarise(output1_A_DD$A_0.5_8, var=c("edge_NCT_1", "edge_NCT_2"), summarise=c("length(edge_NCT_1)"))
  output1_A_DD_maxdiff_0.5_8_nona <- na.omit(output1_A_DD_maxdiff_0.5_8_comb) # select relevant rows
  output1_A_DD_maxdiff_0.5_8_order <- output1_A_DD_maxdiff_0.5_8_nona[order(output1_A_DD_maxdiff_0.5_8_nona$'length(edge_NCT_1)'),] # order by frequency
}
#print frequencies [recall: A1=TRUST, A2=STR, A3=ALT, A4=COMPL, A5=MOD, A6=TENDER]
{print(output1_A_DD_maxdiff_0.5_1_order)
  print(output1_A_DD_maxdiff_0.5_3_order)
  print(output1_A_DD_maxdiff_0.5_8_order)}
 


### [end]



