#NEO & IPIP datasets

library(doParallel)
library(dplyr)
library(psych)
library(GPArotation)
library(lavaan)
library(qgraph)
library(bootnet)
library(RColorBrewer)

registerDoParallel(cores=4)

# Load data files
load("NEO & IPIP - P1_nSim50_data_N.RData")
load("NEO & IPIP - P3_nSim50_data_all_N.RData")

View(data1.rel.noNA)


### NEO dataframe pre-processing

# Select only relevant variables from NEO (without id)
{data1.rel.noNA.N_NEO <- dplyr::select(data1.rel.noNA, 
                                       I1, I31, I61, I91, I121, I151, I181, I211, # Select only NEO Neuroticism N1 facet variables
                                       I6, I36, I66, I96, I126, I156, I186, I216, # Select only NEO Neuroticism N2 facet variables
                                       I11, I41, I71, I101, I131, I161, I191, I221, # Select only NEO Neuroticism N3 facet variables
                                       I16, I46, I76, I106, I136, I166, I196, I226, # Select only NEO Neuroticism N4 facet variables
                                       I21, I51, I81, I111, I141, I171, I201, I231, # Select only NEO Neuroticism N5 facet variables
                                       I26, I56, I86, I116, I146, I176, I206, I236, # Select only NEO Neuroticism N6 facet variables
)
}

# Create copy
N_NEO.df <- data1.rel.noNA.N_NEO

#Create vector to rename item names 
namekey_NEO_N <- c(I1 = "N1.1_NEO", I31 = "N1.2_NEO", I61 = "N1.3_NEO", I91 = "N1.4_NEO", I121 = "N1.5_NEO", I151 = "N1.6_NEO", I181 = "N1.7_NEO", I211 = "N1.8_NEO", 
                   I6 = "N2.1_NEO", I36 = "N2.2_NEO", I66 = "N2.3_NEO", I96 = "N2.4_NEO", I126 = "N2.5_NEO", I156 = "N2.6_NEO", I186 = "N2.7_NEO", I216 = "N2.8_NEO", 
                   I11 = "N3.1_NEO", I41 = "N3.2_NEO", I71 = "N3.3_NEO", I101 = "N3.4_NEO", I131 = "N3.5_NEO", I161 = "N3.6_NEO", I191 = "N3.7_NEO", I221 = "N3.8_NEO",
                   I16 = "N4.1_NEO", I46 = "N4.2_NEO", I76 = "N4.3_NEO", I106 = "N4.4_NEO", I136 = "N4.5_NEO", I166 = "N4.6_NEO", I196 = "N4.7_NEO", I226 = "N4.8_NEO",
                   I21 = "N5.1_NEO", I51 = "N5.2_NEO", I81 = "N5.3_NEO", I111 = "N5.4_NEO", I141 = "N5.5_NEO", I171 = "N5.6_NEO", I201 = "N5.7_NEO", I231 = "N5.8_NEO",
                   I26 = "N6.1_NEO", I56 = "N6.2_NEO", I86 = "N6.3_NEO", I116 = "N6.4_NEO", I146 = "N6.5_NEO", I176 = "N6.6_NEO", I206 = "N6.7_NEO", I236 = "N6.8_NEO"
)

#Apply new names to dataframe
names(N_NEO.df) <- namekey_NEO_N[names(N_NEO.df)]
View(N_NEO.df)



### IPIP dataframe pre-processing

# Select only relevant variables from IPIP (without id)
{data1.rel.noNA.N_IPIP <- dplyr::select(data1.rel.noNA,
                                         e141_R, e150_R, h1046_R, h1157, h2000_R, h968, h999, x107, x120, x138_R, # Select only IPIP Neuroticism N1 facet variables
                                         e120_R, h754, h755, h761, x191_R, x23_R, x231_R, x265_R, x84, x95, # Select only IPIP Neuroticism N2 facet variables
                                         e92, h640, h646, h737_R, h947, x129_R, x15, x156_R, x205, x74, # Select only IPIP Neuroticism N3 facet variables
                                         h1197_R, h1205, h592, h655, h656, h905, h991, x197_R, x209_R, x242_R, # Select only IPIP Neuroticism N4 facet variables
                                         e24, e30_R, e57, h2029, x133, x145, x181_R, x216_R, x251_R, x274_R, # Select only IPIP Neuroticism N5 facet variables
                                         e64_R, h1281_R, h44_R, h470_R, h901, h948, h950, h954, h959, x79_R, # Select only IPIP Neuroticism N6 facet variables)
)
}

# Create copy
N_IPIP.df <- data1.rel.noNA.N_IPIP

#Create vector to rename item names 
namekey_IPIP_N <- c(e141_R = "N1.1_IPIP", e150_R = "N1.2_IPIP", h1046_R = "N1.3_IPIP", h1157 = "N1.4_IPIP", h2000_R = "N1.5_IPIP", h968 = "N1.6_IPIP", h999 = "N1.7_IPIP", x107 = "N1.8_IPIP", x120 = "N1.9_IPIP", x138_R = "N1.10_IPIP",
                    e120_R = "N2.1_IPIP", h754 = "N2.2_IPIP", h755 = "N2.3_IPIP", h761 = "N2.4_IPIP", x191_R = "N2.5_IPIP", x23_R = "N2.6_IPIP", x231_R = "N2.7_IPIP", x265_R = "N2.8_IPIP", x84 = "N2.9_IPIP", x95 = "N2.10_IPIP",
                    e92 = "N3.1_IPIP", h640 = "N3.2_IPIP", h646 = "N3.3_IPIP", h737_R = "N3.4_IPIP", h947 = "N3.5_IPIP", x129_R = "N3.6_IPIP", x15 = "N3.7_IPIP", x156_R = "N3.8_IPIP", x205 = "N3.9_IPIP", x74 = "N3.10_IPIP", 
                    h1197_R = "N4.1_IPIP", h1205 = "N4.2_IPIP", h592 = "N4.3_IPIP", h655 = "N4.4_IPIP", h656 = "N4.5_IPIP", h905 = "N4.6_IPIP", h991 = "N4.7_IPIP", x197_R = "N4.8_IPIP", x209_R = "N4.9_IPIP", x242_R = "N4.10_IPIP", 
                    e24 = "N5.1_IPIP", e30_R = "N5.2_IPIP", e57 = "N5.3_IPIP", h2029 = "N5.4_IPIP", x133 = "N5.5_IPIP", x145 = "N5.6_IPIP", x181_R = "N5.7_IPIP", x216_R = "N5.8_IPIP", x251_R = "N5.9_IPIP", x274_R = "N5.10_IPIP",
                    e64_R = "N6.1_IPIP", h1281_R = "N6.2_IPIP", h44_R = "N6.3_IPIP", h470_R = "N6.4_IPIP", h901 = "N6.5_IPIP", h948 = "N6.6_IPIP", h950 = "N6.7_IPIP", h954 = "N6.8_IPIP", h959 = "N6.9_IPIP", x79_R = "N6.10_IPIP")

#Apply new names to dataframe
names(N_IPIP.df) <- namekey_IPIP_N[names(N_IPIP.df)]
View(N_IPIP.df)



##########



### EFA

# N_NEO

# #parallel analysis
# EFA.N_NEO <- fa.parallel(N_NEO.df, n.obs = NULL, fm = "minres", fa = "fa", nfactors = 6,
#                          main = "Parallel Analysis Scree Plot", n.iter = 1000, use = "pairwise", cor = "cor", sim = TRUE,
#                          error.bars = TRUE, se.bars = TRUE, ylabel = "Eigenvalues of factors", show.legend = TRUE, plot = TRUE)
# print(EFA.N_NEO)

EFA.N_NEO.df_6_rot <- fa(r = N_NEO.df, nfactors = 6, rotate = "oblimin")
print(EFA.N_NEO.df_6_rot) #standardized loadings (pattern matrix)


### CFA

# N_NEO
model_NEO <- '
f1 =~ N1.1_NEO + N1.2_NEO + N1.3_NEO + N1.4_NEO + N1.5_NEO + N1.6_NEO + N1.7_NEO + N1.8_NEO
f2 =~ N2.1_NEO + N2.2_NEO + N2.3_NEO + N2.4_NEO + N2.5_NEO + N2.6_NEO + N2.7_NEO + N2.8_NEO
f3 =~ N3.1_NEO + N3.2_NEO + N3.3_NEO + N3.4_NEO + N3.5_NEO + N3.6_NEO + N3.7_NEO + N3.8_NEO
f4 =~ N4.1_NEO + N4.2_NEO + N4.3_NEO + N4.4_NEO + N4.5_NEO + N4.6_NEO + N4.7_NEO + N4.8_NEO
f5 =~ N5.1_NEO + N5.2_NEO + N5.3_NEO + N5.4_NEO + N5.5_NEO + N5.6_NEO + N5.7_NEO + N5.8_NEO
f6 =~ N6.1_NEO + N6.2_NEO + N6.3_NEO + N6.4_NEO + N6.5_NEO + N6.6_NEO + N6.7_NEO + N6.8_NEO
'
#items N1 = Anxiety
#items N2 = Anger
#items N3 = Depression
#items N4 = Self-Consciousness
#items N5 = Impulsiveness
#items N6 = Vulnerability

fit_NEO <- cfa(model_NEO, data = N_NEO.df)
summary(fit_NEO, fit.measures = TRUE, standardized = TRUE)



##########



### EFA

# N_IPIP

EFA.N_IPIP.df_6_rot <- fa(r = N_IPIP.df, nfactors = 6, rotate = "oblimin")
print(EFA.N_IPIP.df_6_rot) #standardized loadings (pattern matrix)


### CFA

# N_IPIP
model_IPIP <- '
f1 =~ N1.1_IPIP + N1.2_IPIP + N1.3_IPIP + N1.4_IPIP + N1.5_IPIP + N1.6_IPIP + N1.7_IPIP + N1.8_IPIP + N1.9_IPIP + N1.10_IPIP
f2 =~ N2.1_IPIP + N2.2_IPIP + N2.3_IPIP + N2.4_IPIP + N2.5_IPIP + N2.6_IPIP + N2.7_IPIP + N2.8_IPIP + N2.9_IPIP + N2.10_IPIP
f3 =~ N3.1_IPIP + N3.2_IPIP + N3.3_IPIP + N3.4_IPIP + N3.5_IPIP + N3.6_IPIP + N3.7_IPIP + N3.8_IPIP + N3.9_IPIP + N3.10_IPIP
f4 =~ N4.1_IPIP + N4.2_IPIP + N4.3_IPIP + N4.4_IPIP + N4.5_IPIP + N4.6_IPIP + N4.7_IPIP + N4.8_IPIP + N4.9_IPIP + N4.10_IPIP
f5 =~ N5.1_IPIP + N5.2_IPIP + N5.3_IPIP + N5.4_IPIP + N5.5_IPIP + N5.6_IPIP + N5.7_IPIP + N5.8_IPIP + N5.9_IPIP + N5.10_IPIP
f6 =~ N6.1_IPIP + N6.2_IPIP + N6.3_IPIP + N6.4_IPIP + N6.5_IPIP + N6.6_IPIP + N6.7_IPIP + N6.8_IPIP + N6.9_IPIP + N6.10_IPIP
'
#items N1 = Anxiety
#items N2 = Anger
#items N3 = Depression
#items N4 = Self-Consciousness
#items N5 = Impulsiveness
#items N6 = Vulnerability

fit_IPIP <- cfa(model_IPIP, data = N_IPIP.df)
summary(fit_IPIP, fit.measures = TRUE, standardized = TRUE)



##########



### Centrality: Strength

# Note: In 'netcompare' function, centrality metrics were computed / stored (Degree, Betweeness, Closeness, Expected Influence, Shortest Paths)
#***this list does not include Strength because the 'centrality' function computes EITHER Strength (signed = FALSE) or Expected Influence (signed = TRUE)
#***therefore rerun the Strength scores separately below (setting signed = FALSE for absolute values)



#function to extract "output1" from netcompare output: descriptives 
output1_func_cenStrength <- function(df) {
  
  # network 1: centrality ranks (expected influence)
  netmat_x_graph <- df$netmat_x_graph #edge weight matrix (with zeros)
  cent_x <- centrality(netmat_x_graph, alpha = 1, posfun = abs, weighted = TRUE, signed = FALSE) #note: signed = FALSE treats weights as abs values
  cent_expinfl_x <- cent_x$InExpectedInfluence #select only expected influence (i.e. strength) values
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
  
  # network 2: centrality ranks (expected influence)
  netmat_y_graph <- df$netmat_y_graph #edge weight matrix (with zeros)
  cent_y <- centrality(netmat_y_graph, alpha = 1, posfun = abs, weighted = TRUE, signed = FALSE) #note: signed = FALSE treats weights as abs values
  cent_expinfl_y <- cent_y$InExpectedInfluence #select only expected influence (i.e. strength) values
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
               cent_expinfl_1_x=cent_expinfl_123_x[1], cent_expinfl_2_x=cent_expinfl_123_x[2], cent_expinfl_3_x=cent_expinfl_123_x[3],
               cent_expinfl_1_y=cent_expinfl_123_y[1], cent_expinfl_2_y=cent_expinfl_123_y[2], cent_expinfl_3_y=cent_expinfl_123_y[3])
}


#function to merge output1 
output1_merge_func_cenStrength <- function(df) {
  
  tmp <- lapply(df, output1_func_cenStrength)
  tmp <- do.call("rbind.data.frame", tmp)
}



#function to extract "output3" from netcompare output: centrality indices (computed from ggm estimated networks)
#specifically Strength
output3_func_cenStrength <- function(df) {
  
  ### compute centrality indices (from ggmModSelect estimated network)
  #NOTE: because networks are not directed, InExpectedInfluence = OutExpectedIInfluence
  
  tmp_x <- df$netmat_x_graph
  tmp_y <- df$netmat_y_graph
  
  cent_x <- centrality(tmp_x, alpha = 1, posfun = abs, weighted = TRUE, signed = FALSE) #note: signed = FALSE treats weights as abs values
  cent_y <- centrality(tmp_y, alpha = 1, posfun = abs, weighted = TRUE, signed = FALSE) #note: signed = FALSE treats weights as abs values
  
  res <- cbind.data.frame(cent_x, cent_y)
  res_expinfl <- data.frame(ExpectedInfluence_x=res[,5], ExpectedInfluence_y=res[,23]) #select only expected influence values
  res_expinfl$ExpInfl_diff <- res_expinfl$ExpectedInfluence_x - res_expinfl$ExpectedInfluence_y
  res_expinfl
}


#function to merge output3
output3_merge_func_cenStrength <- function(df) {
  tmp <- lapply(df, output3_func_cenStrength)
}


# function to analyze netcompare output [NO p-values, and only relevant to centrality (Strength) indices] 
func_avg.glstr_cenStrength <- function(df) {
  
  nSamp <- df$nSamp[1]
  nSampValue <- df$nx[1]
  
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
                    expinfl_1st_x_freq_N1, expinfl_1st_x_freq_N2, expinfl_1st_x_freq_N3,
                    expinfl_1st_x_freq_N4, expinfl_1st_x_freq_N5, expinfl_1st_x_freq_N6,
                    expinfl_1st_y_freq_N1, expinfl_1st_y_freq_N2, expinfl_1st_y_freq_N3,
                    expinfl_1st_y_freq_N4, expinfl_1st_y_freq_N5, expinfl_1st_y_freq_N6)
  return(res)
}



#*****



### compute centrality indices (from ggmModSelect estimated network)


# First estimate network on full sample (using ggmModSelect)
NEO_N_popnet <- bootnet::estimateNetwork(df.NEO.N.pop, "ggmModSelect")
IPIP_N_popnet <- bootnet::estimateNetwork(df.IPIP.N.pop, "ggmModSelect")

# compute centrality scores for Strength
cenStrength_NEO_N_pop <- centrality(NEO_N_popnet, alpha = 1, posfun = abs, weighted = TRUE, signed = FALSE)
cenStrength_IPIP_N_pop <- centrality(IPIP_N_popnet, alpha = 1, posfun = abs, weighted = TRUE, signed = FALSE)

#print(cenStrength_NEO_N_pop$InExpectedInfluence)
#print(cenStrength_IPIP_N_pop$InExpectedInfluence)


### create lists for cenStrength output ("output3")


# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  output3_Nlist_split_SS_NEO_strength <- list(N_0.2_1=netcompare_Nlist_0.2_1split_SS_NEO, N_0.2_2=netcompare_Nlist_0.2_2split_SS_NEO, N_0.2_3=netcompare_Nlist_0.2_3split_SS_NEO, N_0.2_5=netcompare_Nlist_0.2_5split_SS_NEO, N_0.2_8=netcompare_Nlist_0.2_8split_SS_NEO,
                                              N_0.5_1=netcompare_Nlist_0.5_1split_SS_NEO, N_0.5_2=netcompare_Nlist_0.5_2split_SS_NEO, N_0.5_3=netcompare_Nlist_0.5_3split_SS_NEO, N_0.5_5=netcompare_Nlist_0.5_5split_SS_NEO, N_0.5_8=netcompare_Nlist_0.5_8split_SS_NEO)
  
  
  output3_Nlist_split_SS_IPIP_strength <- list(N_0.2_1=netcompare_Nlist_0.2_1split_SS_IPIP, N_0.2_2=netcompare_Nlist_0.2_2split_SS_IPIP, N_0.2_3=netcompare_Nlist_0.2_3split_SS_IPIP, N_0.2_5=netcompare_Nlist_0.2_5split_SS_IPIP, N_0.2_8=netcompare_Nlist_0.2_8split_SS_IPIP,
                                               N_0.5_1=netcompare_Nlist_0.5_1split_SS_IPIP, N_0.5_2=netcompare_Nlist_0.5_2split_SS_IPIP, N_0.5_3=netcompare_Nlist_0.5_3split_SS_IPIP, N_0.5_5=netcompare_Nlist_0.5_5split_SS_IPIP, N_0.5_8=netcompare_Nlist_0.5_8split_SS_IPIP)}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  output1_Nlist_DD_strength <- output3_Nlist_DD_strength <- list(N_0.2_1=netcompare_Nlist_0.2_1_DD, N_0.2_2=netcompare_Nlist_0.2_2_DD, N_0.2_3=netcompare_Nlist_0.2_3_DD, N_0.2_5=netcompare_Nlist_0.2_5_DD, N_0.2_8=netcompare_Nlist_0.2_8_DD,
                                                                 N_0.5_1=netcompare_Nlist_0.5_1_DD, N_0.5_2=netcompare_Nlist_0.5_2_DD, N_0.5_3=netcompare_Nlist_0.5_3_DD, N_0.5_5=netcompare_Nlist_0.5_5_DD, N_0.5_8=netcompare_Nlist_0.5_8_DD,
                                                                 N_0.8_1=netcompare_Nlist_0.8_1_DD, N_0.8_2=netcompare_Nlist_0.8_2_DD, N_0.8_3=netcompare_Nlist_0.8_3_DD, N_0.8_5=netcompare_Nlist_0.8_5_DD, N_0.8_8=netcompare_Nlist_0.8_8_DD,
                                                                 N_1.0_1=netcompare_Nlist_1.0_1_DD, N_1.0_2=netcompare_Nlist_1.0_2_DD, N_1.0_3=netcompare_Nlist_1.0_3_DD, N_1.0_5=netcompare_Nlist_1.0_5_DD, N_1.0_8=netcompare_Nlist_1.0_8_DD)}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  output3_Nlist_split_DD_strength <- list(N_0.2_1=netcompare_Nlist_0.2_1split_DD, N_0.2_2=netcompare_Nlist_0.2_2split_DD, N_0.2_3=netcompare_Nlist_0.2_3split_DD, N_0.2_5=netcompare_Nlist_0.2_5split_DD, N_0.2_8=netcompare_Nlist_0.2_8split_DD,
                                          N_0.5_1=netcompare_Nlist_0.5_1split_DD, N_0.5_2=netcompare_Nlist_0.5_2split_DD, N_0.5_3=netcompare_Nlist_0.5_3split_DD, N_0.5_5=netcompare_Nlist_0.5_5split_DD, N_0.5_8=netcompare_Nlist_0.5_8split_DD)}



### Extract and merge output from netcompare analysis


## output relevant for correlational analyses (centrality = Strength)

# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  
  # output3
  output3_N_split_SS_NEO_strength <- lapply(output3_Nlist_split_SS_NEO_strength, output3_merge_func_cenStrength)
  output3_N_split_SS_IPIP_strength <- lapply(output3_Nlist_split_SS_IPIP_strength, output3_merge_func_cenStrength)}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  
  # output1
  output1_N_DD <- lapply(output1_Nlist_DD_strength, output1_merge_func_cenStrength)
  
  # output3
  output3_N_DD_strength <- lapply(output3_Nlist_DD_strength, output3_merge_func_cenStrength)}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  
  # output3
  output3_N_split_DD_strength <- lapply(output3_Nlist_split_DD_strength, output3_merge_func_cenStrength)}


## output relevant for tallied frequencies (centrality = Strength)

### Compute avg centrality tallied frequencies across conditions


# CONDITION II. Scale Variability
{# Condition = "_DD"
  output1_N_DD_avg.glstr_strength <- lapply(output1_N_DD, func_avg.glstr_cenStrength)
  output1_N_DD_avg.glstr_strength <- do.call("rbind.data.frame", output1_N_DD_avg.glstr_strength)}


# View(output3_N_split_SS_NEO_strength)
# View(output3_N_split_SS_IPIP_strength)
# View(output3_N_DD_strength)
# View(output3_N_split_DD_strength)
# View(output1_N_DD_avg.glstr_strength)



#*****



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



#*****



### SPEARMAN Correlations btw CENTRALITY scores (Strength)


## WHOLE-SAMPLE correlation

{# Run correlations on Strength scores
  pop_N_NEO_Strength <- cenStrength_NEO_N_pop$InExpectedInfluence #Strength scores for NEO whole-sample network
  pop_N_IPIP_Strength <- cenStrength_IPIP_N_pop$InExpectedInfluence #Strength scsores for IPIP whole-sample network
  pop_N_centcorr_Strength <- cor(pop_N_NEO_Strength, pop_N_IPIP_Strength) #Pearson correlation 
  pop_N_centrankcorr_Strength <- cor(pop_N_NEO_Strength, pop_N_IPIP_Strength, method="spearman") #Spearman correlation
  
  # Case-drop bootstrap
  pop_N_NEO_casedrop_Strength <- bootnet(NEO_N_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="strength")
  pop_N_IPIP_casedrop_Strength <- bootnet(IPIP_N_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="strength")
  
  # Compute CS-coefficients (centrality stability)
  pop_N_NEO_cscoeff_Strength <- corStability(pop_N_NEO_casedrop_Strength, cor=0.7) 
  pop_N_IPIP_cscoeff_Strength <- corStability(pop_N_IPIP_casedrop_Strength, cor=0.7)
}

#print pop_N_centcorr_Strength (Pearson)
# 0.8918332

#print pop_N_centrankcorr_Strength (Spearman)
# 0.8285714

#print pop_N_NEO_cscoeff_Strength (correlation stability analysis for NEO pop network)
# "expectedInfluence: 0.75 (CS-coefficient is highest level tested)"

#print pop_N_IPIP_cscoeff_Strength (correlation stability analysis for IPIP pop network)
# "expectedInfluence: 0.75 (CS-coefficient is highest level tested)"



## SAMPLE correlations

# CONDITION I. Sampling Variability
{# Conditions = "split_SS"
  
  # Create relevant lists
  output3_N_split_SS_NEO_strength_rankcorr <- output3_N_split_SS_NEO_strength_avg.rankcorr <- output3_N_split_SS_NEO_strength_sd.rankcorr <- list()
  
  # Run for-loops
  for (i in 1:10) {
    output3_N_split_SS_NEO_strength_rankcorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output3_N_split_SS_NEO_strength_rankcorr[[i]][[l]] <- cor(output3_N_split_SS_NEO_strength[[i]][[l]]$ExpectedInfluence_x, output3_N_split_SS_NEO_strength[[i]][[l]]$ExpectedInfluence_y, method="spearman")
    }
    
    output3_N_split_SS_NEO_strength_rankcorr[[i]] <- do.call("rbind.data.frame", output3_N_split_SS_NEO_strength_rankcorr[[i]])
    output3_N_split_SS_NEO_strength_rankcorr[[i]] <- setNames(output3_N_split_SS_NEO_strength_rankcorr[[i]], "strength_rankcorr_N")
    output3_N_split_SS_NEO_strength_avg.rankcorr[[i]] <- mean(output3_N_split_SS_NEO_strength_rankcorr[[i]]$strength_rankcorr_N, na.rm = TRUE)
    output3_N_split_SS_NEO_strength_sd.rankcorr[[i]] <- sd(output3_N_split_SS_NEO_strength_rankcorr[[i]]$strength_rankcorr_N, na.rm = TRUE)
  }
  
  # Merge output3 results
  output3_N_split_SS_NEO_strength_avg.rankcorr <- do.call("rbind.data.frame", output3_N_split_SS_NEO_strength_avg.rankcorr)
  output3_N_split_SS_NEO_strength_sd.rankcorr <- do.call("rbind.data.frame", output3_N_split_SS_NEO_strength_sd.rankcorr)
  output3_N_split_SS_NEO_strength_avg.rankcorr <- setNames(output3_N_split_SS_NEO_strength_avg.rankcorr, "avg.rankcorr_strength_N")
  output3_N_split_SS_NEO_strength_sd.rankcorr <- setNames(output3_N_split_SS_NEO_strength_sd.rankcorr, "sd.rankcorr_strength_N")
  output3_N_split_SS_NEO_strength_avg.rankcorr <- cbind.data.frame(condition=cond_vector_split_SS, N=nSampValue_vector_split_SS, output3_N_split_SS_NEO_strength_avg.rankcorr, output3_N_split_SS_NEO_strength_sd.rankcorr)
}

# CONDITION II. Scale Variability
{# Condition = "_DD"
  
  # Create relevant lists
  output3_N_DD_strength_rankcorr <- output3_N_DD_strength_avg.rankcorr <- output3_N_DD_strength_sd.rankcorr <- list()
  
  # Run for-loops
  for (i in 1:20) {
    output3_N_DD_strength_rankcorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output3_N_DD_strength_rankcorr[[i]][[l]] <- cor(output3_N_DD_strength[[i]][[l]]$ExpectedInfluence_x, output3_N_DD_strength[[i]][[l]]$ExpectedInfluence_y, method="spearman")
    }
    
    output3_N_DD_strength_rankcorr[[i]] <- do.call("rbind.data.frame", output3_N_DD_strength_rankcorr[[i]])
    output3_N_DD_strength_rankcorr[[i]] <- setNames(output3_N_DD_strength_rankcorr[[i]], "strength_rankcorr_N")
    output3_N_DD_strength_avg.rankcorr[[i]] <- mean(output3_N_DD_strength_rankcorr[[i]]$strength_rankcorr_N, na.rm = TRUE)
    output3_N_DD_strength_sd.rankcorr[[i]] <- sd(output3_N_DD_strength_rankcorr[[i]]$strength_rankcorr_N, na.rm = TRUE)
  }
  
  # Merge output3 results
  output3_N_DD_strength_avg.rankcorr <- do.call("rbind.data.frame", output3_N_DD_strength_avg.rankcorr)
  output3_N_DD_strength_sd.rankcorr <- do.call("rbind.data.frame", output3_N_DD_strength_sd.rankcorr)
  output3_N_DD_strength_avg.rankcorr <- setNames(output3_N_DD_strength_avg.rankcorr, "avg.rankcorr_strength_N")
  output3_N_DD_strength_sd.rankcorr <- setNames(output3_N_DD_strength_sd.rankcorr, "sd.rankcorr_strength_N")
  output3_N_DD_strength_avg.rankcorr <- cbind.data.frame(condition=cond_vector_DD, N=nSampValue_vector_DD, output3_N_DD_strength_avg.rankcorr, output3_N_DD_strength_sd.rankcorr)
}

# CONDITION III. Sampling & Scale Variability
{# Condition = "split_DD"
  
  # Create relevant lists
  output3_N_split_DD_strength_rankcorr <- output3_N_split_DD_strength_avg.rankcorr <- output3_N_split_DD_strength_sd.rankcorr <- list()
  
  # Run for-loops
  for (i in 1:10) {
    output3_N_split_DD_strength_rankcorr[[i]] <- list()
    
    for (l in 1:nSim) {
      output3_N_split_DD_strength_rankcorr[[i]][[l]] <- cor(output3_N_split_DD_strength[[i]][[l]]$ExpectedInfluence_x, output3_N_split_DD_strength[[i]][[l]]$ExpectedInfluence_y, method="spearman")
    }
    
    output3_N_split_DD_strength_rankcorr[[i]] <- do.call("rbind.data.frame", output3_N_split_DD_strength_rankcorr[[i]])
    output3_N_split_DD_strength_rankcorr[[i]] <- setNames(output3_N_split_DD_strength_rankcorr[[i]], "strength_rankcorr_N")
    output3_N_split_DD_strength_avg.rankcorr[[i]] <- mean(output3_N_split_DD_strength_rankcorr[[i]]$strength_rankcorr_N, na.rm = TRUE)
    output3_N_split_DD_strength_sd.rankcorr[[i]] <- sd(output3_N_split_DD_strength_rankcorr[[i]]$strength_rankcorr_N, na.rm = TRUE)
  }
  
  #Merge output2 results
  output3_N_split_DD_strength_avg.rankcorr <- do.call("rbind.data.frame", output3_N_split_DD_strength_avg.rankcorr)
  output3_N_split_DD_strength_sd.rankcorr <- do.call("rbind.data.frame", output3_N_split_DD_strength_sd.rankcorr)
  output3_N_split_DD_strength_avg.rankcorr <- setNames(output3_N_split_DD_strength_avg.rankcorr, "avg.rankcorr_strength_N")
  output3_N_split_DD_strength_sd.rankcorr <- setNames(output3_N_split_DD_strength_sd.rankcorr, "sd.rankcorr_strength_N")
  output3_N_split_DD_strength_avg.rankcorr <- cbind.data.frame(condition=cond_vector_split_DD, N=nSampValue_vector_split_DD, output3_N_split_DD_strength_avg.rankcorr, output3_N_split_DD_strength_sd.rankcorr)
}



#*****



### SAVE RESULTS

save(### Factor analysis data:
  # FINISH
  
  ### Centrality (strength) data:
  
  # extracted data ("output1")
  output1_N_DD_avg.glstr_strength,
  
  # extracted data ("output3")
  output3_N_split_SS_NEO_strength, output3_N_split_SS_IPIP_strength, output3_N_DD_strength, output3_N_split_DD_strength, 
  
  # "output 3" : centrality correlations
  output3_N_split_SS_NEO_strength_avg.rankcorr, output3_N_DD_strength_avg.rankcorr, output3_N_split_DD_strength_avg.rankcorr, 
  
  # whole-sample data
  pop_N_NEO_Strength, pop_N_IPIP_Strength, 
  pop_N_centcorr_Strength, pop_N_centrankcorr_Strength,
  pop_N_NEO_casedrop_Strength, pop_N_IPIP_casedrop_Strength,
  pop_N_NEO_cscoeff_Strength, pop_N_IPIP_cscoeff_Strength, 
  pop_N_NEO_edgeacc_Strength, pop_N_IPIP_edgeacc_Strength,
  
  file = "NEO & IPIP - P3_nSim50_results_extra_N.RData")



#*****



### VISUALIZE RESULTS

# Simple Bar Plots
barplot_colours5 <- brewer.pal(5, "Set2")
barplot_colours4 <- brewer.pal(4, "Pastel1")
barplot_colours3 <- brewer.pal(3, "Pastel1")



### FIGURE S1
# "Correlations Between Centrality Scores (Strength)"

{par(mfrow = c(1,3), oma = c(2, 2, 3, 2))
  
  # I. Sampling Variability, i.e. ("split_SS") condition
  
  means_strength_split_SS_x <- as.vector(output3_N_split_SS_NEO_strength_avg.rankcorr$avg.rankcorr_strength_N)
  sds_strength_split_SS_x <- as.vector(output3_N_split_SS_NEO_strength_avg.rankcorr$sd.rankcorr_strength_N)
  ses_strength_split_SS_x <- sds_strength_split_SS_x/sqrt(as.vector(output3_N_split_SS_NEO_strength_avg.rankcorr$N))
  CI_strength_split_SS_x <- 1.96*ses_strength_split_SS_x
  
  barCenters_strength_split_SS_x <- barplot(means_strength_split_SS_x, ylim = c(0, 1.0), ylab = "Correlation",
                                           names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                           cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, font = 1,
                                           main="Sampling Variability", col = barplot_colours5,
                                           space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_strength_split_SS_x, means_strength_split_SS_x - CI_strength_split_SS_x, barCenters_strength_split_SS_x, means_strength_split_SS_x + CI_strength_split_SS_x, lwd = 1.5, angle = 90, code = 3, length = 0.05)         
  legend("topleft", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node reliability")
  
  
  # II. Scale Variability, i.e. ("_DD") condition
  
  means_strength_DD <- as.vector(output3_N_DD_strength_avg.rankcorr$avg.rankcorr_strength_N[c(1:10)])
  sds_strength_DD <- as.vector(output3_N_DD_strength_avg.rankcorr$sd.rankcorr_strength_N[c(1:10)])
  ses_strength_DD <- sds_strength_DD/sqrt(as.vector(output3_N_DD_strength_avg.rankcorr$N[c(1:10)]))
  CI_strength_DD <- 1.96*ses_strength_DD
  
  barCenters_strength_DD <- barplot(means_strength_DD, ylim = c(0, 1.0), ylab = "Correlation",
                                   names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                   cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, font = 1,
                                   main="Scale Variability", col = barplot_colours5,
                                   space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_strength_DD, means_strength_DD - CI_strength_DD, barCenters_strength_DD, means_strength_DD + CI_strength_DD, lwd = 1.5, angle = 90, code = 3, length = 0.05)
  legend("topleft", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node reliability")
  
  
  # III. Sampling & Scale Variability, i.e. ("split_DD") condition
  
  means_strength_split_DD <- as.vector(output3_N_split_DD_strength_avg.rankcorr$avg.rankcorr_strength_N)
  sds_strength_split_DD <- as.vector(output3_N_split_DD_strength_avg.rankcorr$sd.rankcorr_strength_N)
  ses_strength_split_DD <- sds_strength_split_DD/sqrt(as.vector(output3_N_split_DD_strength_avg.rankcorr$N))
  CI_strength_split_DD <- 1.96*ses_strength_split_DD
  
  barCenters_strength_split_DD <- barplot(means_strength_split_DD, ylim = c(0, 1.0), ylab = "Correlation",
                                         names.arg = c("", "", "84", "", "", "", "", "212", "", ""), xlab="Sample size",
                                         cex.names = 2, cex.axis = 2, cex.lab=1.75, cex.main = 1.5, font = 1,
                                         main="Sampling & Scale Variability", col = barplot_colours5,
                                         space = c(0.2, 0, 0, 0, 0, 0.5, 0, 0, 0, 0))
  arrows(barCenters_strength_split_DD, means_strength_split_DD - CI_strength_split_DD, barCenters_strength_split_DD, means_strength_split_DD + CI_strength_split_DD, lwd = 1.5, angle = 90, code = 3, length = 0.05)        
  legend("topleft", ncol=3, cex=1.5, legend = c("1 item", "2 items", "3 items", "5 items", "8 items"), fill = barplot_colours5, title = "Node reliability")
  
  # ADD main title
  mtext("Correlations Between Centrality Scores (Neuroticism)", outer=TRUE,  cex=1.5, font=1, line=-0.15)}



#*****



### FIGURE S2
# "Whole-Sample Networks: Centrality Stability (Strength)"

# CS-coefficients (centrality stability): 2-panel plot
{require(gridExtra)
  # TOP PLOT
  NEO_pop_casedrop_plot_N_Strength <- plot(pop_N_NEO_casedrop_Strength, statistics = "strength")
  # BOTTOM PLOT
  IPIP_pop_casedrop_plot_N_Strength <- plot(pop_N_IPIP_casedrop_Strength, statistics = "strength")
  grid.arrange(NEO_pop_casedrop_plot_N_Strength, IPIP_pop_casedrop_plot_N_Strength, ncol=1)}



#*****



### Response Letter Figures



### FIGURE R1 
# "Small-Sample Networks: Accuracy of Edge Weight Estimates"
# Note:  (resampling condition = scale variability; n = 84; node aggregation = 1-item indicators, first replication in list)

# Estimate networks
NEO_N_rep1_bootnet <- bootnet::estimateNetwork(dfsNEO_N_0.2_1[1][[1]], "ggmModSelect") #estimate network on first NEO replication in list (n=84, 1-item indicators)
IPIP_N_rep1_bootnet <- bootnet::estimateNetwork(dfsIPIP_N_0.2_1[1][[1]], "ggmModSelect") #estimate network on first IPIP replication in list (n=84, 1-item indicators)

# Edge-weight accuracy
rep1_N_NEO_edgeacc <- bootnet(NEO_N_rep1_bootnet, nBoots=1000, nCores=4)
rep1_N_IPIP_edgeacc <- bootnet(IPIP_N_rep1_bootnet, nBoots=1000, nCores=4)

plot(rep1_N_NEO_edgeacc, labels = TRUE, order = "sample")
plot(rep1_N_IPIP_edgeacc, labels = TRUE, order = "sample")

## 2-panel plot (ordered by "sample")
{require(gridExtra)
  # TOP PLOT
  NEO_rep1_edgeacc_plot <- plot(rep1_N_NEO_edgeacc, labels = TRUE, order = "sample")
  
  # BOTTOM PLOT
  IPIP_rep1_edgeacc_plot <- plot(rep1_N_IPIP_edgeacc, labels = TRUE, order = "sample")
  
  grid.arrange(NEO_rep1_edgeacc_plot, IPIP_rep1_edgeacc_plot, ncol=1)}



#*****



### FIGURE R2
# "Small-Sample Networks: Correspondence in Expected Influence Scores"
# Note:  (resampling condition = scale variability; n = 84; node aggregation = 1-item indicators, first replication in list)

# Centrality scores (expected influence): 1-panel plot
N_ExpInf_plot_rep1 <- centralityPlot(list(NEO = NEO_N_rep1_bootnet, IPIP = IPIP_N_rep1_bootnet), include = c("ExpectedInfluence"), scale = "raw", orderBy = "ExpectedInfluence")



#*****



### FIGURE R3
# "Small-Sample Networks: Centrality Stability (Expected Influence)"
# Note:  (resampling condition = scale variability; n = 84; node aggregation = 1-item indicators, first replication in list)

# Case-drop bootstrap
rep1_N_NEO_casedrop <- bootnet(NEO_N_rep1_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
rep1_N_IPIP_casedrop <- bootnet(IPIP_N_rep1_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")

# CS-coefficients (centrality stability): 2-panel plot
{require(gridExtra)
  # TOP PLOT
  NEO_rep1_casedrop_plot_N <- plot(rep1_N_NEO_casedrop, statistics = "expectedInfluence")
  # BOTTOM PLOT
  IPIP_rep1_casedrop_plot_N <- plot(rep1_N_IPIP_casedrop, statistics = "expectedInfluence")
  grid.arrange(NEO_rep1_casedrop_plot_N, IPIP_rep1_casedrop_plot_N, ncol=1)}



##########



### TABLE (& text) DESCRIPTIVES



### Table S6 (corresponding to FIGURE S1)
# "Correlations Between Centrality Scores (Strength): Descriptives"

{# Condition I "sampling variability"
  # note: 8-item indicator (n=212) -> r = 0.8548571 
  output3_N_split_SS_NEO_strength_avg.rankcorr
  
  
  # Condition II "scale variability"
  # note: 8-item indicator (n=212) -> r = 0.880000
  output3_N_DD_strength_avg.rankcorr
  
  
  # Condition III "sampling & scale variability"
  # note: 8-item indicator (n=212) -> r = 0.8605714
  output3_N_split_DD_strength_avg.rankcorr}



#*****



## TABLE S7: WHOLE-SAMPLE NETWORK CHARACTERISTICS (estimated from ggm networks)
#(only values relevant to centrality Strength scores)

# CS-coefficients
pop_N_NEO_cscoeff_Strength # 0.75
pop_N_IPIP_cscoeff_Strength # 0.75

# Centrality scores
pop_N_NEO_Strength #NEO scale
pop_N_IPIP_Strength #IPIP scale



#*****



### TABLE S8: OVERVIEW OF NETWORK CHARACTERISTICS
#(only values relevant to centrality Strength scores)

## Descriptives @nSamp = 0.5 (i.e. n=212)
## Resampling Condition = Scale Variability ("DD" conditions)

# Average correlation btw centrality scores
output3_N_DD_strength_avg.rankcorr[c(6,8,10), c("condition", "avg.rankcorr_strength_N", "sd.rankcorr_strength_N")]

# Centrality frequencies (re: most central nodes)
# [recall: N1=ANX, N2=ANG, N3=DEP, N4=SELF, N5=IMP, N6=VUL]
output1_N_DD_avg.glstr_strength[c("N_0.5_1", "N_0.5_3", "N_0.5_8"), c("expinfl_1st_x_freq_N1", "expinfl_1st_x_freq_N2", "expinfl_1st_x_freq_N3",
                                                                      "expinfl_1st_x_freq_N4", "expinfl_1st_x_freq_N5", "expinfl_1st_x_freq_N6")] #NEO scale

output1_N_DD_avg.glstr_strength[c("N_0.5_1", "N_0.5_3", "N_0.5_8"), c("expinfl_1st_y_freq_N1", "expinfl_1st_y_freq_N2", "expinfl_1st_y_freq_N3",
                                                                      "expinfl_1st_y_freq_N4", "expinfl_1st_y_freq_N5", "expinfl_1st_y_freq_N6")] #IPIP scale



#*****



### ASIDE:

### Quick function check

# Making sure that when signed=TRUE, "InExpectedInfluence" represents Expected Influence
# Making sure that when signed=FALSE, "InExpectedInfluence" represents Strength

#test matrix (with pos and neg values)
matrix_test <- netcompare_Nlist_0.2_1_DD[[1]]$netmat_x_graph
matrix_test[1,3] <- -0.5046022
matrix_test[3,1] <- -0.5046022
matrix_test

#compute centralities (Strength vs. Expected Influence)
centrality_test_signedTRUE <- centrality(matrix_test, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE) #Expected Influence
centrality_test_signedFALSE <- centrality(matrix_test, alpha = 1, posfun = abs, weighted = TRUE, signed = FALSE) #Strength

print(centrality_test_signedTRUE$InExpectedInfluence) # for N3, -0.21155521
print(centrality_test_signedFALSE$InExpectedInfluence) # for N3, 0.7976492

#manually compute to compare / check (e.g., node N3)
score_signedTRUE <- matrix_test[1,3] + matrix_test[6,3]
score_signedFALSE <- abs(matrix_test[1,3]) + abs(matrix_test[6,3])

print(score_signedTRUE) # -0.2115552
print(score_signedFALSE) # 0.7976492



#*****




