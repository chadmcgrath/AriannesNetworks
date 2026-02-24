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

# Load data files
data1 <- read.csv("NEO_IPIP_1.csv")
load("NEO & IPIP - P0_functions.Rdata")



##########



### DATA PRE-PROCESSING STEPS


## STEP 1 (data pre-processing): Reverse code relevant IPIP items

# Reverse score IPIP items (Neuroticism):

{# IPIP Anxiety:
  data1$e141_R = 6 - data1$e141
  data1$e150_R = 6 - data1$e150
  data1$h1046_R = 6 - data1$h1046
  data1$h2000_R = 6 - data1$h2000
  data1$x138_R = 6 - data1$x138
  # IPIP Anger:
  data1$e120_R = 6 - data1$e120
  data1$x191_R = 6 - data1$x191
  data1$x23_R = 6 - data1$x23
  data1$x231_R = 6 - data1$x231
  data1$x265_R = 6 - data1$x265
  # IPIP Depression:
  data1$h737_R = 6 - data1$h737
  data1$x129_R = 6 - data1$x129
  data1$x156_R = 6 - data1$x156
  # IPIP Self-Consciousness:
  data1$h1197_R = 6 - data1$h1197
  data1$x197_R = 6 - data1$x197
  data1$x209_R = 6 - data1$x209
  data1$x242_R = 6 - data1$x242
  # IPIP Immoderation:
  data1$e30_R = 6 - data1$e30
  data1$x181_R = 6 - data1$x181
  data1$x216_R = 6 - data1$x216
  data1$x251_R = 6 - data1$x251
  data1$x274_R = 6 - data1$x274
  # IPIP Vulnerability:
  data1$e64_R = 6 - data1$e64
  data1$h1281_R = 6 - data1$h1281
  data1$h44_R = 6 - data1$h44
  data1$h470_R = 6 - data1$h470
  data1$x79_R = 6 - data1$x79}


# Reverse score IPIP items (Extraversion):

{# IPIP Friendliness:
  data1$h596_R = 6 - data1$h596
  data1$h648_R = 6 - data1$h648
  data1$h704_R = 6 - data1$h704
  data1$h909_R = 6 - data1$h909
  data1$x165_R = 6 - data1$x165
  # IPIP Gregariousness:
  data1$h587_R = 6 - data1$h587
  data1$h602_R = 6 - data1$h602
  data1$h650_R = 6 - data1$h650
  data1$h660_R = 6 - data1$h660
  data1$x99_R = 6 - data1$x99
  # IPIP Assertiveness:
  data1$h1039_R = 6 - data1$h1039
  data1$h154_R = 6 - data1$h154
  data1$h679_R = 6 - data1$h679
  data1$h976_R = 6 - data1$h976
  data1$x68_R = 6 - data1$x68
  # IPIP Activity Level:
  data1$e113_R = 6 - data1$e113
  data1$e84_R = 6 - data1$e84
  data1$h631_R = 6 - data1$h631
  data1$x111_R = 6 - data1$x111
  data1$x226_R = 6 - data1$x226
  # IPIP Excitement-Seeking:
  data1$x215_R = 6 - data1$x215
  data1$x250_R = 6 - data1$x250
  # IPIP Cheerfulness:
  data1$x137_R = 6 - data1$x137
  data1$x180_R = 6 - data1$x180}


# Reverse score IPIP items (Openness):

{# IPIP Imagination:
  data1$h1382_R = 6 - data1$h1382
  data1$x135_R = 6 - data1$x135
  data1$x175_R = 6 - data1$x175
  data1$x272_R = 6 - data1$x272
  # IPIP Artistic Interests:
  data1$x144_R = 6 - data1$x144
  data1$x235_R = 6 - data1$x235
  data1$x243_R = 6 - data1$x243
  data1$x45_R = 6 - data1$x45
  data1$x86_R = 6 - data1$x86
  # IPIP Emotionality:
  data1$e156_R = 6 - data1$e156
  data1$x10_R = 6 - data1$x10
  data1$x202_R = 6 - data1$x202
  data1$x267_R = 6 - data1$x267
  data1$x29_R = 6 - data1$x29
  # IPIP Adventurousness:
  data1$e36_R = 6 - data1$e36
  data1$h1063_R = 6 - data1$h1063
  data1$h1460_R = 6 - data1$h1460
  data1$h312_R = 6 - data1$h312
  data1$h910_R = 6 - data1$h910
  data1$x30_R = 6 - data1$x30
  # IPIP Intellect:
  data1$x109_R = 6 - data1$x109
  data1$x176_R = 6 - data1$x176
  data1$x228_R = 6 - data1$x228
  data1$x239_R = 6 - data1$x239
  data1$x248_R = 6 - data1$x248
  # IPIP Liberalism:
  data1$x126_R = 6 - data1$x126
  data1$x130_R = 6 - data1$x130
  data1$x157_R = 6 - data1$x157
  data1$x178_R = 6 - data1$x178
  data1$x20_R = 6 - data1$x20
  data1$x254_R = 6 - data1$x254
  data1$x35_R = 6 - data1$x35}


# Reverse score IPIP items (Conscientiousness):

{# IPIP Self-Efficacy:
  data1$h1032_R = 6 - data1$h1032
  data1$h1393_R = 6 - data1$h1393
  data1$h1395_R = 6 - data1$h1395
  data1$h1438_R = 6 - data1$h1438
  # IPIP Orderliness:
  data1$e100_R = 6 - data1$e100
  data1$e7_R = 6 - data1$e7
  data1$h822_R = 6 - data1$h822
  data1$h823_R = 6 - data1$h823
  data1$x82_R = 6 - data1$x82
  # IPIP Dutifulness:
  data1$h1018_R = 6 - data1$h1018
  data1$h1084_R = 6 - data1$h1084
  data1$h1182_R = 6 - data1$h1182
  data1$h1346_R = 6 - data1$h1346
  data1$h497_R = 6 - data1$h497
  # IPIP Achievement-Striving:
  data1$x110_R = 6 - data1$x110
  data1$x115_R = 6 - data1$x115
  data1$x167_R = 6 - data1$x167
  # IPIP Self-Discipline:
  data1$h1171_R = 6 - data1$h1171
  data1$h1180_R = 6 - data1$h1180
  data1$h1186_R = 6 - data1$h1186
  data1$h621_R = 6 - data1$h621
  data1$h969_R = 6 - data1$h969
  # IPIP Cautiousness:
  data1$e122_R = 6 - data1$e122
  data1$e46_R = 6 - data1$e46
  data1$e66_R = 6 - data1$e66
  data1$h846_R = 6 - data1$h846
  data1$h853_R = 6 - data1$h853
  data1$h862_R = 6 - data1$h862
  data1$h870_R = 6 - data1$h870}


# Reverse score IPIP items (Agreeableness): 

{# IPIP Trust:
  data1$h1001_R = 6 - data1$h1001
  data1$h1195_R = 6 - data1$h1195
  data1$h604_R = 6 - data1$h604
  data1$x80_R = 6 - data1$x80
  # IPIP Morality:
  data1$h1327_R = 6 - data1$h1327
  data1$h416_R = 6 - data1$h416
  data1$h427_R = 6 - data1$h427
  data1$h494_R = 6 - data1$h494
  data1$h774_R = 6 - data1$h774
  data1$x113_R = 6 - data1$x113
  data1$x198_R = 6 - data1$x198
  data1$x91_R = 6 - data1$x91
  # IPIP Altruism:
  data1$h1136_R = 6 - data1$h1136
  data1$h1430_R = 6 - data1$h1430
  data1$h607_R = 6 - data1$h607
  data1$h918_R = 6 - data1$h918
  data1$x203_R = 6 - data1$x203
  # IPIP Cooperation:
  data1$h1103_R = 6 - data1$h1103
  data1$h453_R = 6 - data1$h453
  data1$h699_R = 6 - data1$h699
  data1$h808_R = 6 - data1$h808
  data1$h809_R = 6 - data1$h809
  data1$h917_R = 6 - data1$h917
  data1$x217_R = 6 - data1$x217
  # IPIP Modesty:
  data1$h1267_R = 6 - data1$h1267
  data1$h2043_R = 6 - data1$h2043
  data1$h535_R = 6 - data1$h535
  data1$h736_R = 6 - data1$h736
  data1$h738_R = 6 - data1$h738
  data1$h746_R = 6 - data1$h746
  # IPIP Sympathy:
  data1$e121_R = 6 - data1$e121
  data1$e166_R = 6 - data1$e166
  data1$e78_R = 6 - data1$e78
  data1$x173_R = 6 - data1$x173
  data1$x227_R = 6 - data1$x227
  data1$x70_R = 6 - data1$x70}



##########



## STEP 2 (data pre-processing): Select variables

# Note: Each NEO facet is made up of 8 items; each IPIP facet is made up of 10 items
# with the exception of IPIP O2 "Artistic Interests" facet: only 9 items
# data does not include item "Enjoy the beauty of nature" (ref: https://ipip.ori.org/newNEOKey.htm#Artistic-Interests)

# Select only relevant variables from NEO, IPIP, and id
{data1.rel <- dplyr::select(data1, id, 
                           I1, I31, I61, I91, I121, I151, I181, I211, # Select only NEO Neuroticism N1 facet variables
                           I6, I36, I66, I96, I126, I156, I186, I216, # Select only NEO Neuroticism N2 facet variables
                           I11, I41, I71, I101, I131, I161, I191, I221, # Select only NEO Neuroticism N3 facet variables
                           I16, I46, I76, I106, I136, I166, I196, I226, # Select only NEO Neuroticism N4 facet variables
                           I21, I51, I81, I111, I141, I171, I201, I231, # Select only NEO Neuroticism N5 facet variables
                           I26, I56, I86, I116, I146, I176, I206, I236, # Select only NEO Neuroticism N6 facet variables
                           
                           I2, I32, I62, I92, I122, I152, I182, I212, # Select only NEO Extraversion E1 facet variables
                           I7, I37, I67, I97, I127, I157, I187, I217,  # Select only NEO Extraversion E2 facet variables
                           I12, I42, I72, I102, I132, I162, I192, I222, # Select only NEO Extraversion E3 facet variables
                           I17, I47, I77, I107, I137, I167, I197, I227, # Select only NEO Extraversion E4 facet variables
                           I22, I52, I82, I112, I142, I172, I202, I232, # Select only NEO Extraversion E5 facet variables
                           I27, I57, I87, I117, I147, I177, I207, I237, # Select only NEO Extraversion E6 facet variables

                           I3, I33, I63, I93, I123, I153, I183, I213, # Select only NEO Openness O1 facet variables
                           I8, I38, I68, I98, I128, I158, I188, I218, # Select only NEO Openness O2 facet variables
                           I13, I43, I73, I103, I133, I163, I193, I223, # Select only NEO Openness O3 facet variables
                           I18, I48, I78, I108, I138, I168, I198, I228, # Select only NEO Openness O4 facet variables
                           I23, I53, I83, I113, I143, I173, I203, I233, # Select only NEO Openness O5 facet variables
                           I28, I58, I88, I118, I148, I178, I208, I238, # Select only NEO Openness O6 facet variables
                           
                           I5, I35, I65, I95, I125, I155, I185, I215, # Select only NEO Conscientiousness C1 facet variables
                           I10, I40, I70, I100, I130, I160, I190, I220, # Select only NEO Conscientiousness C2 facet variables
                           I15, I45, I75, I105, I135, I165, I195, I225, # Select only NEO Conscientiousness C3 facet variables
                           I20, I50, I80, I110, I140, I170, I200, I230, # Select only NEO Conscientiousness C4 facet variables
                           I25, I55, I85, I115, I145, I175, I205, I235, # Select only NEO Conscientiousness C5 facet variables
                           I30, I60, I90, I120, I150, I180, I210, I240, # Select only NEO Conscientiousness C6 facet variables
                           
                           I4, I34, I64, I94, I124, I154, I184, I214, # Select only NEO Agreeableness A1 facet variables
                           I9, I39, I69, I99, I129, I159, I189, I219, # Select only NEO Agreeableness A2 facet variables
                           I14, I44, I74, I104, I134, I164, I194, I224, # Select only NEO Agreeableness A3 facet variables
                           I19, I49, I79, I109, I139, I169, I199, I229, # Select only NEO Agreeableness A4 facet variables
                           I24, I54, I84, I114, I144, I174, I204, I234, # Select only NEO Agreeableness A5 facet variables
                           I29, I59, I89, I119, I149, I179, I209, I239, # Select only NEO Agreeableness A6 facet variables
                           
                           e141_R, e150_R, h1046_R, h1157, h2000_R, h968, h999, x107, x120, x138_R, # Select only IPIP Neuroticism N1 facet variables
                           e120_R, h754, h755, h761, x191_R, x23_R, x231_R, x265_R, x84, x95, # Select only IPIP Neuroticism N2 facet variables
                           e92, h640, h646, h737_R, h947, x129_R, x15, x156_R, x205, x74, # Select only IPIP Neuroticism N3 facet variables
                           h1197_R, h1205, h592, h655, h656, h905, h991, x197_R, x209_R, x242_R, # Select only IPIP Neuroticism N4 facet variables
                           e24, e30_R, e57, h2029, x133, x145, x181_R, x216_R, x251_R, x274_R, # Select only IPIP Neuroticism N5 facet variables
                           e64_R, h1281_R, h44_R, h470_R, h901, h948, h950, h954, h959, x79_R, # Select only IPIP Neuroticism N6 facet variables
                           
                           h1151, h29, h41, h52, h596_R, h648_R, h704_R, h909_R, x112, x165_R, # Select only IPIP Extraversion E1 facet variables
                           e55, h1106, h2016, h587_R, h602_R, h650_R, h660_R, h78, x83, x99_R, # Select only IPIP Extraversion E2 facet variables
                           h1039_R, h1137, h154_R, h325, h334, h524, h679_R, h773, h976_R, x68_R, # Select only IPIP Extraversion E3 facet variables
                           e113_R, e84_R, h1324, h457, h54, h58, h631_R, h79, x111_R, x226_R, # Select only IPIP Extraversion E4 facet variables
                           e35, e56, h438, h446, h67, h871, h894, x215_R, x250_R, x3, # Select only IPIP Extraversion E5 facet variables
                           h1093, h1094, h12, h23, h32, h33, h42, h66, x137_R, x180_R, # Select only IPIP Extraversion E6 facet variables
                           
                           e163, h1119, h1382_R, x114, x135_R, x14, x175_R, x238, x272_R, x71, # Select only IPIP Openness O1 facet variables
                           e105, x123, x140, x144_R, x235_R, x243_R, x45_R, x81, x86_R, # Select only IPIP Openness O2 facet variables
                           e123, e133, e136, e156_R, e174, x10_R, x202_R, x267_R, x29_R, x92, # Select only IPIP Openness O3 facet variables
                           e36_R, h1063_R, h1460_R, h2021, h312_R, h441, h910_R, x104, x204, x30_R, # Select only IPIP Openness O4 facet variables
                           e145, h1276, h1322, x109_R, x176_R, x201, x211, x228_R, x239_R, x248_R, # Select only IPIP Openness O5 facet variables
                           x126_R, x130_R, x157_R, x178_R, x184, x20_R, x218, x219, x254_R, x35_R, # Select only IPIP Openness O6 facet variables
                           
                           h1032_R, h1174, h1285, h1333, h1354, h1393_R, h1395_R, h1438_R, h2009, h352, # Select only IPIP Conscientiousness C1 facet variables
                           e100_R, e11, e7_R, h1351, h244, h309, h822_R, h823_R, x118, x82_R, # Select only IPIP Conscientiousness C2 facet variables
                           h1018_R, h1084_R, h1182_R, h1346_R, h145, h149, h153, h497_R, x127, x150, # Select only IPIP Conscientiousness C3 facet variables
                           e140, h1206, h2014, h288, h365, h402, h69, x110_R, x115_R, x167_R, # Select only IPIP Conscientiousness C4 facet variables
                           e119, h1171_R, h1180_R, h1186_R, h258, h511, h517, h621_R, h969_R, x87, # Select only IPIP Conscientiousness C5 facet variables
                           e122_R, e46_R, e66_R, h252, h367, h673, h846_R, h853_R, h862_R, h870_R, # Select only IPIP Conscientiousness C6 facet variables
                           
                           e157, h1001_R, h113, h114, h1195_R, h43, h549, h604_R, x189, x80_R, # Select only IPIP Agreeableness A1 facet variables
                           h1327_R, h294, h416_R, h427_R, h494_R, h774_R, x113_R, x136, x198_R, x91_R, # Select only IPIP Agreeableness A2 facet variables
                           e124, h1100, h1108, h1136_R, h1430_R, h22, h30, h607_R, h918_R, x203_R, # Select only IPIP Agreeableness A3 facet variables
                           e31, h1103_R, h453_R, h699_R, h808_R, h809_R, h882, h917_R, x206, x217_R, # Select only IPIP Agreeableness A4 facet variables
                           h1267_R, h2043_R, h535_R, h736_R, h738_R, h746_R, x125, x169, x212, x247, # Select only IPIP Agreeableness A5 facet variables
                           e115, e121_R, e166_R, e78_R, h988, x173_R, x227_R, x240, x259, x70_R) # Select only IPIP Agreeableness A6 facet variables
}
                           
View(data1.rel) # 857 x 540 (still including rows with NAs)



##########



## STEP 3 (data pre-processing): Exclude rows containing NAs

data1.rel.noNA <- noNA_func(data1.rel)

View(data1.rel.noNA) # 424 x 540 (after excluding rows with NAs)



##########



## STEP 4 (data pre-processing): Create facet-level dataframes

# NEO "Neuroticism" facet variables:
{df.NEO.N1.items <- dplyr::select(data1.rel.noNA, I1, I31, I61, I91, I121, I151, I181, I211) # Create NEO Neuroticism N1 dataframe
df.NEO.N2.items <- dplyr::select(data1.rel.noNA, I6, I36, I66, I96, I126, I156, I186, I216) # Create NEO Neuroticism N2 dataframe
df.NEO.N3.items <- dplyr::select(data1.rel.noNA, I11, I41, I71, I101, I131, I161, I191, I221) # Create NEO Neuroticism N3 dataframe
df.NEO.N4.items <- dplyr::select(data1.rel.noNA, I16, I46, I76, I106, I136, I166, I196, I226) # Create NEO Neuroticism N4 dataframe
df.NEO.N5.items <- dplyr::select(data1.rel.noNA, I21, I51, I81, I111, I141, I171, I201, I231) # Create NEO Neuroticism N5 dataframe
df.NEO.N6.items <- dplyr::select(data1.rel.noNA, I26, I56, I86, I116, I146, I176, I206, I236) # Create NEO Neuroticism N6 dataframe
}

# IPIP "Neuroticism" facet variables:
{df.IPIP.N1.items <- dplyr::select(data1.rel.noNA, e141_R, e150_R, h1046_R, h1157, h2000_R, h968, h999, x107, x120, x138_R) # Create IPIP Neuroticism N1 dataframe
df.IPIP.N2.items <- dplyr::select(data1.rel.noNA, e120_R, h754, h755, h761, x191_R, x23_R, x231_R, x265_R, x84, x95) # Create IPIP Neuroticism N2 dataframe
df.IPIP.N3.items <- dplyr::select(data1.rel.noNA, e92, h640, h646, h737_R, h947, x129_R, x15, x156_R, x205, x74) # Create IPIP Neuroticism N3 dataframe
df.IPIP.N4.items <- dplyr::select(data1.rel.noNA, h1197_R, h1205, h592, h655, h656, h905, h991, x197_R, x209_R, x242_R) # Create IPIP Neuroticism N4 dataframe
df.IPIP.N5.items <- dplyr::select(data1.rel.noNA, e24, e30_R, e57, h2029, x133, x145, x181_R, x216_R, x251_R, x274_R) # Create IPIP Neuroticism N5 dataframe
df.IPIP.N6.items <- dplyr::select(data1.rel.noNA, e64_R, h1281_R, h44_R, h470_R, h901, h948, h950, h954, h959, x79_R) # Create IPIP Neuroticism N6 dataframe
}



##########



## STEP 5 (data pre-processing): Create dimension-level lists

# Neuroticism
{ NEO.N.list <- list(df.NEO.N1.items, df.NEO.N2.items, df.NEO.N3.items, df.NEO.N4.items, df.NEO.N5.items, df.NEO.N6.items)
  IPIP.N.list <- list(df.IPIP.N1.items, df.IPIP.N2.items, df.IPIP.N3.items, df.IPIP.N4.items, df.IPIP.N5.items, df.IPIP.N6.items)
  
  N1.items <- cbind(df.NEO.N1.items, df.IPIP.N1.items)
  N2.items <- cbind(df.NEO.N2.items, df.IPIP.N2.items)
  N3.items <- cbind(df.NEO.N3.items, df.IPIP.N3.items)
  N4.items <- cbind(df.NEO.N4.items, df.IPIP.N4.items)
  N5.items <- cbind(df.NEO.N5.items, df.IPIP.N5.items)
  N6.items <- cbind(df.NEO.N6.items, df.IPIP.N6.items)
  
  N.list <- list(N1.items, N2.items, N3.items, N4.items, N5.items, N6.items)}



##########



## STEP 5 (data pre-processing): WHOLE-SAMPLE CORRELATION matrices
# Compute correlation matrices for each dimension on the entire samples (i.e. 424 cases (or nSamp = 1.0) and the original number of columns)

# NEO whole-sample dataframes
{ df.NEO.N.pop <- cbind.data.frame(rowSums(df.NEO.N1.items[,]), rowSums(df.NEO.N2.items[,]), rowSums(df.NEO.N3.items[,]),
                                   rowSums(df.NEO.N4.items[,]), rowSums(df.NEO.N5.items[,]), rowSums(df.NEO.N6.items[,]))}

# IPIP whole-sample dataframes
{ df.IPIP.N.pop <- cbind.data.frame(rowSums(df.IPIP.N1.items[,]), rowSums(df.IPIP.N2.items[,]), rowSums(df.IPIP.N3.items[,]),
                                    rowSums(df.IPIP.N4.items[,]), rowSums(df.IPIP.N5.items[,]), rowSums(df.IPIP.N6.items[,]))}

# Rename whole-sample dataframe columns
{colnames_Npop <- c("N1sum", "N2sum", "N3sum", "N4sum", "N5sum", "N6sum")
  
  df.NEO.N.pop <- setNames(df.NEO.N.pop, colnames_Npop)
  df.IPIP.N.pop <- setNames(df.IPIP.N.pop, colnames_Npop)}

# Run whole-sample correlation matrices
{NEO_N_cor <- cor(df.NEO.N.pop)
  IPIP_N_cor <- cor(df.IPIP.N.pop)}

# Run whole-sample partial correlation matrices
{NEO_N_part <- ppcor::pcor(df.NEO.N.pop)$estimate
  IPIP_N_part <- ppcor::pcor(df.IPIP.N.pop)$estimate}



##########



## STEP 6 (data pre-processing): Reliabilities and correlations btw subscales 

## NEUROTICISM

# NEO subscale reliabilities
{NEO_N1_pop_alpha <- alpha(df.NEO.N1.items) # 0.84 (tau-equivalence rejected)
  NEO_N1_pop_omega <- omega(df.NEO.N1.items) # 0.84 (homogeneity rejected)
  
  NEO_N2_pop_alpha <- alpha(df.NEO.N2.items) # 0.81 (tau-equivalence rejected)
  NEO_N2_pop_omega <- omega(df.NEO.N2.items) # 0.81 (homogeneity rejected)
  
  NEO_N3_pop_alpha <- alpha(df.NEO.N3.items) # 0.86 (tau-equivalence rejected)
  NEO_N3_pop_omega <- omega(df.NEO.N3.items) # 0.87 (homogeneity rejected)
  
  NEO_N4_pop_alpha <- alpha(df.NEO.N4.items) # 0.76 (tau-equivalence rejected)
  NEO_N4_pop_omega <- omega(df.NEO.N4.items) # 0.77 (homogeneity rejected)
  
  NEO_N5_pop_alpha <- alpha(df.NEO.N5.items) # 0.74 (tau-equivalence rejected)
  NEO_N5_pop_omega <- omega(df.NEO.N5.items) # 0.74 (homogeneity rejected)
  
  NEO_N6_pop_alpha <- alpha(df.NEO.N6.items) # 0.78 (tau-equivalence rejected)
  NEO_N6_pop_omega <- omega(df.NEO.N6.items) # 0.78 (homogeneity rejected)
}

# IPIP subscale reliabilities
{IPIP_N1_pop_alpha <- alpha(df.IPIP.N1.items) # 0.85 (tau-equivalence rejected)
  IPIP_N1_pop_omega <- omega(df.IPIP.N1.items) # 0.85 (homogeneity rejected)
  
  IPIP_N2_pop_alpha <- alpha(df.IPIP.N2.items) # 0.89 (tau-equivalence rejected)
  IPIP_N2_pop_omega <- omega(df.IPIP.N2.items) # 0.90 (homogeneity rejected)
  
  IPIP_N3_pop_alpha <- alpha(df.IPIP.N3.items) # 0.90 (tau-equivalence rejected)
  IPIP_N3_pop_omega <- omega(df.IPIP.N3.items) # 0.90 (homogeneity rejected)
  
  IPIP_N4_pop_alpha <- alpha(df.IPIP.N4.items) # 0.81 (tau-equivalence rejected)
  IPIP_N4_pop_omega <- omega(df.IPIP.N4.items) # 0.82 (homogeneity rejected)
  
  IPIP_N5_pop_alpha <- alpha(df.IPIP.N5.items) # 0.79 (tau-equivalence rejected)
  IPIP_N5_pop_omega <- omega(df.IPIP.N5.items) # 0.79 (homogeneity rejected)
  
  IPIP_N6_pop_alpha <- alpha(df.IPIP.N6.items) # 0.83 (tau-equivalence rejected)
  IPIP_N6_pop_omega <- omega(df.IPIP.N6.items) # 0.83 (homogeneity rejected)
}

# Pearson correlations btw subscales
{cor_pop_N1 <- cor(df.NEO.N.pop$N1sum, df.IPIP.N.pop$N1sum)
  cor_pop_N2 <- cor(df.NEO.N.pop$N2sum, df.IPIP.N.pop$N2sum)
  cor_pop_N3 <- cor(df.NEO.N.pop$N3sum, df.IPIP.N.pop$N3sum)
  cor_pop_N4 <- cor(df.NEO.N.pop$N4sum, df.IPIP.N.pop$N4sum)
  cor_pop_N5 <- cor(df.NEO.N.pop$N5sum, df.IPIP.N.pop$N5sum)
  cor_pop_N6 <- cor(df.NEO.N.pop$N6sum, df.IPIP.N.pop$N6sum)
  cor_pop_N_vector <- c(cor_pop_N1, cor_pop_N2, cor_pop_N3, cor_pop_N4, cor_pop_N5, cor_pop_N6)
  meancor_pop_Nfacets <- mean(cor_pop_N_vector)
}

#print correlations
{print(cor_pop_N1) # 0.76
  print(cor_pop_N2) # 0.78
  print(cor_pop_N3) # 0.81
  print(cor_pop_N4) # 0.74
  print(cor_pop_N5) # 0.74
  print(cor_pop_N6) # 0.80
  print(meancor_pop_Nfacets) # 0.77
}



##########



### Plot population network graphs


## NOTE: VERSION 1 = plots network using raw partial correlations
## NOTE: VERSION 2 = plots network after using ggmModSelect (i.e. some edges set to zero)



## NEUROTICISM

# Neuroticism [VERSION 1]
{itemlabels_N_NEO <- c("Anx", "Ang", "Dep", "Self", "Imp", "Vul")
  itemlabels_N_IPIP <- c("Anx", "Ang", "Dep", "Self", "Imm", "Vul")
  
  nodenames_N_NEO <- c("Anxiety", "Angry Hostility", "Depression", "Self-Consc.", "Impulsiveness", "Vulnerability")
  nodenames_N_IPIP <- c("Anxiety", "Anger", "Depression", "Self-Consc.", "Immoderation", "Vulnerability")
  
  # Graph from partial correlation matrix
  graph_N_NEO_V1 <- qgraph(NEO_N_part, layout = "spring", labels = itemlabels_N_NEO, title = "Whole-sample 'N' network (NEO)")
  graph_N_IPIP_V1 <- qgraph(IPIP_N_part, layout = "spring", labels = itemlabels_N_IPIP, title = "Whole-sample 'N' network (IPIP)")
  
  # Create average layout of both graphs for use of plotting together below
  Layout_N_V1 <- averageLayout(graph_N_NEO_V1, graph_N_IPIP_V1)
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 1]
  par(mfrow = c(1,2))
  graph_N_NEO_V1 <- qgraph(NEO_N_part, layout = Layout_N_V1, labels = itemlabels_N_NEO, GLratio = 2.25, title = "Whole-sample 'N' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_N_NEO, negDashed = TRUE, maximum = 0.45)
  graph_N_IPIP_V1 <- qgraph(IPIP_N_part, layout = Layout_N_V1, labels = itemlabels_N_IPIP, GLratio = 2.25, title = "Whole-sample 'N' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_N_IPIP, negDashed = TRUE, maximum = 0.45)}

# Neuroticism [VERSION 2]
{# First estimate network on full sample (using ggmModSelect)
  NEO_N_popnet <- bootnet::estimateNetwork(df.NEO.N.pop, "ggmModSelect")
  IPIP_N_popnet <- bootnet::estimateNetwork(df.IPIP.N.pop, "ggmModSelect")
  
  # Graph from estimated network
  graph_N_NEO_V2 <- qgraph(NEO_N_popnet$graph, layout = "spring", labels = itemlabels_N_NEO, title = "Whole-sample 'N' network (NEO)")
  graph_N_IPIP_V2 <- qgraph(IPIP_N_popnet$graph, layout = "spring", labels = itemlabels_N_IPIP, title = "Whole-sample 'N' network (IPIP)")
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 2]
  par(mfrow = c(1,2))
  graph_N_NEO_V2 <- qgraph(NEO_N_popnet$graph, layout = Layout_N_V1, labels = itemlabels_N_NEO, GLratio = 2.25, title = "Whole-sample 'N' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_N_NEO, negDashed = TRUE, maximum = 0.45)
  graph_N_IPIP_V2 <- qgraph(IPIP_N_popnet$graph, layout = Layout_N_V1, labels = itemlabels_N_IPIP, GLratio = 2.25, title = "Whole-sample 'N' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_N_IPIP, negDashed = TRUE, maximum = 0.45)}
  


##########



## Centrality statistics

# NEUROTICISM

# Whole-sample network statistics
{ df.NEO.N.pop_tmp <- df.NEO.N.pop
  df.IPIP.N.pop_tmp <- df.IPIP.N.pop

  colnames(df.NEO.N.pop_tmp) <- c("ANX", "ANG", "DEP", "SELF", "IMP", "VUL")
  colnames(df.IPIP.N.pop_tmp) <- c("ANX", "ANG", "DEP", "SELF", "IMP", "VUL")
  
  NEO_N_pop_bootnet <- bootnet::estimateNetwork(df.NEO.N.pop_tmp, "ggmModSelect")
  IPIP_N_pop_bootnet <- bootnet::estimateNetwork(df.IPIP.N.pop_tmp, "ggmModSelect")
  
  # Centrality scores (estimated from ggmModSelect)
  centrality_NEO_N_pop_ggm <- centrality(NEO_N_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  centrality_IPIP_N_pop_ggm <- centrality(IPIP_N_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  
  # Case-drop bootstrap
  pop_N_NEO_casedrop <- bootnet(NEO_N_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  pop_N_IPIP_casedrop <- bootnet(IPIP_N_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  
  # Compute CS-coefficients (centrality stability)
  pop_N_NEO_cscoeff <- corStability(pop_N_NEO_casedrop, cor=0.7) 
  pop_N_IPIP_cscoeff <- corStability(pop_N_IPIP_casedrop, cor=0.7)
}

# Print centrality statistics #(Table 1 descriptives)
{print(centrality_NEO_N_pop_ggm$InExpectedInfluence) 
  print(centrality_IPIP_N_pop_ggm$InExpectedInfluence)
  print(pop_N_NEO_cscoeff)
  print(pop_N_IPIP_cscoeff)}



## Centrality plots 


## NEUROTICISM

# Centrality scores (expected influence): 1-panel plot
N_ExpInf_plot <- centralityPlot(list(NEO = NEO_N_pop_bootnet, IPIP = IPIP_N_pop_bootnet), include = c("ExpectedInfluence"), scale = "raw", orderBy = "ExpectedInfluence")

# CS-coefficients (centrality stability): 2-panel plot
{require(gridExtra)
  # TOP PLOT
  NEO_pop_casedrop_plot_N <- plot(pop_N_NEO_casedrop, statistics = "expectedInfluence")
  # BOTTOM PLOT
  IPIP_pop_casedrop_plot_N <- plot(pop_N_IPIP_casedrop, statistics = "expectedInfluence")
  grid.arrange(NEO_pop_casedrop_plot_N, IPIP_pop_casedrop_plot_N, ncol=1)}



### [end]


### Save objects

save(data1.rel, data1.rel.noNA, noNA_func,
     df.NEO.N1.items, df.NEO.N2.items, df.NEO.N3.items, df.NEO.N4.items, df.NEO.N5.items, df.NEO.N6.items,
     df.IPIP.N1.items, df.IPIP.N2.items, df.IPIP.N3.items, df.IPIP.N4.items, df.IPIP.N5.items, df.IPIP.N6.items,
     NEO.N.list, IPIP.N.list, 
     N1.items, N2.items, N3.items, N4.items, N5.items, N6.items,
     N.list, df.NEO.N.pop, df.IPIP.N.pop, 
     colnames_Npop, NEO_N_cor, IPIP_N_cor, NEO_N_part, IPIP_N_part, 
     itemlabels_N_NEO, itemlabels_N_IPIP, nodenames_N_NEO, nodenames_N_IPIP, 
     graph_N_NEO_V1, graph_N_IPIP_V1, Layout_N_V1, graph_N_NEO_V2, graph_N_IPIP_V2,
     NEO_N_pop_bootnet, IPIP_N_pop_bootnet, 
     centrality_NEO_N_pop_ggm, centrality_IPIP_N_pop_ggm, 
     pop_N_NEO_casedrop, pop_N_IPIP_casedrop, 
     NEO_pop_casedrop_plot_N, IPIP_pop_casedrop_plot_N,
     pop_N_NEO_cscoeff, pop_N_IPIP_cscoeff, 
     file = "NEO & IPIP - P1_nSim50_data_N.RData")

  

















