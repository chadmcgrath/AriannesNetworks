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

# Load data file
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

# NEO "Extraversion" facet variables:
{df.NEO.E1.items <- dplyr::select(data1.rel.noNA, I2, I32, I62, I92, I122, I152, I182, I212) # Create NEO Extraversion E1 dataframe
df.NEO.E2.items <- dplyr::select(data1.rel.noNA, I7, I37, I67, I97, I127, I157, I187, I217) # Create NEO Extraversion E2 dataframe
df.NEO.E3.items <- dplyr::select(data1.rel.noNA, I12, I42, I72, I102, I132, I162, I192, I222) # Create NEO Extraversion E3 dataframe
df.NEO.E4.items <- dplyr::select(data1.rel.noNA, I17, I47, I77, I107, I137, I167, I197, I227) # Create NEO Extraversion E4 dataframe
df.NEO.E5.items <- dplyr::select(data1.rel.noNA, I22, I52, I82, I112, I142, I172, I202, I232) # Create NEO Extraversion E5 dataframe
df.NEO.E6.items <- dplyr::select(data1.rel.noNA, I27, I57, I87, I117, I147, I177, I207, I237) # Create NEO Extraversion E6 dataframe
}

# NEO "Openness" facet variables:
{df.NEO.O1.items <- dplyr::select(data1.rel.noNA, I3, I33, I63, I93, I123, I153, I183, I213) # Create NEO Openness O1 dataframe
df.NEO.O2.items <- dplyr::select(data1.rel.noNA, I8, I38, I68, I98, I128, I158, I188, I218) # Create NEO Openness O2 dataframe
df.NEO.O3.items <- dplyr::select(data1.rel.noNA, I13, I43, I73, I103, I133, I163, I193, I223) # Create NEO Openness O3 dataframe
df.NEO.O4.items <- dplyr::select(data1.rel.noNA, I18, I48, I78, I108, I138, I168, I198, I228) # Create NEO Openness O4 dataframe
df.NEO.O5.items <- dplyr::select(data1.rel.noNA, I23, I53, I83, I113, I143, I173, I203, I233) # Create NEO Openness O5 dataframe
df.NEO.O6.items <- dplyr::select(data1.rel.noNA, I28, I58, I88, I118, I148, I178, I208, I238) # Create NEO Openness O6 dataframe
}

# NEO "Conscientiousness" facet variables:
{df.NEO.C1.items <- dplyr::select(data1.rel.noNA, I5, I35, I65, I95, I125, I155, I185, I215) # Create NEO Conscientiousness C1 dataframe
df.NEO.C2.items <- dplyr::select(data1.rel.noNA, I10, I40, I70, I100, I130, I160, I190, I220) # Create NEO Conscientiousness C2 dataframe
df.NEO.C3.items <- dplyr::select(data1.rel.noNA, I15, I45, I75, I105, I135, I165, I195, I225) # Create NEO Conscientiousness C3 dataframe
df.NEO.C4.items <- dplyr::select(data1.rel.noNA, I20, I50, I80, I110, I140, I170, I200, I230) # Create NEO Conscientiousness C4 dataframe
df.NEO.C5.items <- dplyr::select(data1.rel.noNA, I25, I55, I85, I115, I145, I175, I205, I235) # Create NEO Conscientiousness C5 dataframe
df.NEO.C6.items <- dplyr::select(data1.rel.noNA, I30, I60, I90, I120, I150, I180, I210, I240) # Create NEO Conscientiousness C6 dataframe
}

# NEO "Agreeableness" facet variables:
{df.NEO.A1.items <- dplyr::select(data1.rel.noNA, I4, I34, I64, I94, I124, I154, I184, I214) # Create NEO Agreeableness A1 dataframe
df.NEO.A2.items <- dplyr::select(data1.rel.noNA, I9, I39, I69, I99, I129, I159, I189, I219) # Create NEO Agreeableness A2 dataframe
df.NEO.A3.items <- dplyr::select(data1.rel.noNA, I14, I44, I74, I104, I134, I164, I194, I224) # Create NEO Agreeableness A3 dataframe
df.NEO.A4.items <- dplyr::select(data1.rel.noNA, I19, I49, I79, I109, I139, I169, I199, I229) # Create NEO Agreeableness A4 dataframe
df.NEO.A5.items <- dplyr::select(data1.rel.noNA, I24, I54, I84, I114, I144, I174, I204, I234) # Create NEO Agreeableness A5 dataframe
df.NEO.A6.items <- dplyr::select(data1.rel.noNA, I29, I59, I89, I119, I149, I179, I209, I239) # Create NEO Agreeableness A6 dataframe
}

# IPIP "Neuroticism" facet variables:
{df.IPIP.N1.items <- dplyr::select(data1.rel.noNA, e141_R, e150_R, h1046_R, h1157, h2000_R, h968, h999, x107, x120, x138_R) # Create IPIP Neuroticism N1 dataframe
df.IPIP.N2.items <- dplyr::select(data1.rel.noNA, e120_R, h754, h755, h761, x191_R, x23_R, x231_R, x265_R, x84, x95) # Create IPIP Neuroticism N2 dataframe
df.IPIP.N3.items <- dplyr::select(data1.rel.noNA, e92, h640, h646, h737_R, h947, x129_R, x15, x156_R, x205, x74) # Create IPIP Neuroticism N3 dataframe
df.IPIP.N4.items <- dplyr::select(data1.rel.noNA, h1197_R, h1205, h592, h655, h656, h905, h991, x197_R, x209_R, x242_R) # Create IPIP Neuroticism N4 dataframe
df.IPIP.N5.items <- dplyr::select(data1.rel.noNA, e24, e30_R, e57, h2029, x133, x145, x181_R, x216_R, x251_R, x274_R) # Create IPIP Neuroticism N5 dataframe
df.IPIP.N6.items <- dplyr::select(data1.rel.noNA, e64_R, h1281_R, h44_R, h470_R, h901, h948, h950, h954, h959, x79_R) # Create IPIP Neuroticism N6 dataframe
}

# IPIP "Extraversion" facet variables:
{df.IPIP.E1.items <- dplyr::select(data1.rel.noNA, h1151, h29, h41, h52, h596_R, h648_R, h704_R, h909_R, x112, x165_R) # Create IPIP Extraversion E1 dataframe
df.IPIP.E2.items <- dplyr::select(data1.rel.noNA, e55, h1106, h2016, h587_R, h602_R, h650_R, h660_R, h78, x83, x99_R) # Create IPIP Extraversion E2 dataframe
df.IPIP.E3.items <- dplyr::select(data1.rel.noNA, h1039_R, h1137, h154_R, h325, h334, h524, h679_R, h773, h976_R, x68_R) # Create IPIP Extraversion E3 dataframe
df.IPIP.E4.items <- dplyr::select(data1.rel.noNA, e113_R, e84_R, h1324, h457, h54, h58, h631_R, h79, x111_R, x226_R) # Create IPIP Extraversion E4 dataframe
df.IPIP.E5.items <- dplyr::select(data1.rel.noNA, e35, e56, h438, h446, h67, h871, h894, x215_R, x250_R, x3) # Create IPIP Extraversion E5 dataframe
df.IPIP.E6.items <- dplyr::select(data1.rel.noNA, h1093, h1094, h12, h23, h32, h33, h42, h66, x137_R, x180_R) # Create IPIP Extraversion E6 dataframe
}

# IPIP "Openness" facet variables:
{df.IPIP.O1.items <- dplyr::select(data1.rel.noNA, e163, h1119, h1382_R, x114, x135_R, x14, x175_R, x238, x272_R, x71) # Create IPIP Openness O1 dataframe
df.IPIP.O2.items <- dplyr::select(data1.rel.noNA, e105, x123, x140, x144_R, x235_R, x243_R, x45_R, x81, x86_R) # Create IPIP Openness O2 dataframe
df.IPIP.O3.items <- dplyr::select(data1.rel.noNA, e123, e133, e136, e156_R, e174, x10_R, x202_R, x267_R, x29_R, x92) # Create IPIP Openness O3 dataframe
df.IPIP.O4.items <- dplyr::select(data1.rel.noNA, e36_R, h1063_R, h1460_R, h2021, h312_R, h441, h910_R, x104, x204, x30_R) # Create IPIP Openness O4 dataframes
df.IPIP.O5.items <- dplyr::select(data1.rel.noNA, e145, h1276, h1322, x109_R, x176_R, x201, x211, x228_R, x239_R, x248_R) # Create IPIP Openness O5 dataframe
df.IPIP.O6.items <- dplyr::select(data1.rel.noNA, x126_R, x130_R, x157_R, x178_R, x184, x20_R, x218, x219, x254_R, x35_R) # Create IPIP Openness O6 dataframe
}

# IPIP "Conscientiousness" facet variables:
{df.IPIP.C1.items <- dplyr::select(data1.rel.noNA, h1032_R, h1174, h1285, h1333, h1354, h1393_R, h1395_R, h1438_R, h2009, h352) # Create IPIP Conscientiousness C1 dataframe
df.IPIP.C2.items <- dplyr::select(data1.rel.noNA, e100_R, e11, e7_R, h1351, h244, h309, h822_R, h823_R, x118, x82_R) # Create IPIP Conscientiousness C2 dataframe
df.IPIP.C3.items <- dplyr::select(data1.rel.noNA, h1018_R, h1084_R, h1182_R, h1346_R, h145, h149, h153, h497_R, x127, x150) # Create IPIP Conscientiousness C3 dataframe
df.IPIP.C4.items <- dplyr::select(data1.rel.noNA, e140, h1206, h2014, h288, h365, h402, h69, x110_R, x115_R, x167_R) # Create IPIP Conscientiousness C4 dataframe
df.IPIP.C5.items <- dplyr::select(data1.rel.noNA, e119, h1171_R, h1180_R, h1186_R, h258, h511, h517, h621_R, h969_R, x87) # Create IPIP Conscientiousness C5 dataframe
df.IPIP.C6.items <- dplyr::select(data1.rel.noNA, e122_R, e46_R, e66_R, h252, h367, h673, h846_R, h853_R, h862_R, h870_R) # Create IPIP Conscientiousness C6 dataframe
}

# IPIP "Agreeableness" facet variables:
{df.IPIP.A1.items <- dplyr::select(data1.rel.noNA, e157, h1001_R, h113, h114, h1195_R, h43, h549, h604_R, x189, x80_R) # Create IPIP Agreeableness A1 dataframe
df.IPIP.A2.items <- dplyr::select(data1.rel.noNA, h1327_R, h294, h416_R, h427_R, h494_R, h774_R, x113_R, x136, x198_R, x91_R) # Create IPIP Agreeableness A2 dataframe
df.IPIP.A3.items <- dplyr::select(data1.rel.noNA, e124, h1100, h1108, h1136_R, h1430_R, h22, h30, h607_R, h918_R, x203_R) # Create IPIP Agreeableness A3 dataframe
df.IPIP.A4.items <- dplyr::select(data1.rel.noNA, e31, h1103_R, h453_R, h699_R, h808_R, h809_R, h882, h917_R, x206, x217_R) # Create IPIP Agreeableness A4 dataframe
df.IPIP.A5.items <- dplyr::select(data1.rel.noNA, h1267_R, h2043_R, h535_R, h736_R, h738_R, h746_R, x125, x169, x212, x247) # Create IPIP Agreeableness A5 dataframe
df.IPIP.A6.items <- dplyr::select(data1.rel.noNA, e115, e121_R, e166_R, e78_R, h988, x173_R, x227_R, x240, x259, x70_R) # Select only IPIP Agreeableness A6 facet variables
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

# Extraversion
{ NEO.E.list <- list(df.NEO.E1.items, df.NEO.E2.items, df.NEO.E3.items, df.NEO.E4.items, df.NEO.E5.items, df.NEO.E6.items)
  IPIP.E.list <- list(df.IPIP.E1.items, df.IPIP.E2.items, df.IPIP.E3.items, df.IPIP.E4.items, df.IPIP.E5.items, df.IPIP.E6.items)
  
  E1.items <- cbind(df.NEO.E1.items, df.IPIP.E1.items)
  E2.items <- cbind(df.NEO.E2.items, df.IPIP.E2.items)
  E3.items <- cbind(df.NEO.E3.items, df.IPIP.E3.items)
  E4.items <- cbind(df.NEO.E4.items, df.IPIP.E4.items)
  E5.items <- cbind(df.NEO.E5.items, df.IPIP.E5.items)
  E6.items <- cbind(df.NEO.E6.items, df.IPIP.E6.items)
  
  E.list <- list(E1.items, E2.items, E3.items, E4.items, E5.items, E6.items)}

# Openness
{ NEO.O.list <- list(df.NEO.O1.items, df.NEO.O2.items, df.NEO.O3.items, df.NEO.O4.items, df.NEO.O5.items, df.NEO.O6.items)
  IPIP.O.list <- list(df.IPIP.O1.items, df.IPIP.O2.items, df.IPIP.O3.items, df.IPIP.O4.items, df.IPIP.O5.items, df.IPIP.O6.items)
  
  O1.items <- cbind(df.NEO.O1.items, df.IPIP.O1.items)
  O2.items <- cbind(df.NEO.O2.items, df.IPIP.O2.items)
  O3.items <- cbind(df.NEO.O3.items, df.IPIP.O3.items)
  O4.items <- cbind(df.NEO.O4.items, df.IPIP.O4.items)
  O5.items <- cbind(df.NEO.O5.items, df.IPIP.O5.items)
  O6.items <- cbind(df.NEO.O6.items, df.IPIP.O6.items)
  
  O.list <- list(O1.items, O2.items, O3.items, O4.items, O5.items, O6.items)}

# Conscientiousness
{ NEO.C.list <- list(df.NEO.C1.items, df.NEO.C2.items, df.NEO.C3.items, df.NEO.C4.items, df.NEO.C5.items, df.NEO.C6.items)
  IPIP.C.list <- list(df.IPIP.C1.items, df.IPIP.C2.items, df.IPIP.C3.items, df.IPIP.C4.items, df.IPIP.C5.items, df.IPIP.C6.items)
  
  C1.items <- cbind(df.NEO.C1.items, df.IPIP.C1.items)
  C2.items <- cbind(df.NEO.C2.items, df.IPIP.C2.items)
  C3.items <- cbind(df.NEO.C3.items, df.IPIP.C3.items)
  C4.items <- cbind(df.NEO.C4.items, df.IPIP.C4.items)
  C5.items <- cbind(df.NEO.C5.items, df.IPIP.C5.items)
  C6.items <- cbind(df.NEO.C6.items, df.IPIP.C6.items)
  
  C.list <- list(C1.items, C2.items, C3.items, C4.items, C5.items, C6.items)}

# Agreeableness
{ NEO.A.list <- list(df.NEO.A1.items, df.NEO.A2.items, df.NEO.A3.items, df.NEO.A4.items, df.NEO.A5.items, df.NEO.A6.items)
  IPIP.A.list <- list(df.IPIP.A1.items, df.IPIP.A2.items, df.IPIP.A3.items, df.IPIP.A4.items, df.IPIP.A5.items, df.IPIP.A6.items)
  
  A1.items <- cbind(df.NEO.A1.items, df.IPIP.A1.items)
  A2.items <- cbind(df.NEO.A2.items, df.IPIP.A2.items)
  A3.items <- cbind(df.NEO.A3.items, df.IPIP.A3.items)
  A4.items <- cbind(df.NEO.A4.items, df.IPIP.A4.items)
  A5.items <- cbind(df.NEO.A5.items, df.IPIP.A5.items)
  A6.items <- cbind(df.NEO.A6.items, df.IPIP.A6.items)
  
  A.list <- list(A1.items, A2.items, A3.items, A4.items, A5.items, A6.items)}



##########



## STEP 5 (data pre-processing): WHOLE-SAMPLE CORRELATION matrices
# Run correlation matrices for each dimension on the entire samples (i.e. 424 cases (or nSamp = 1.0) and the original number of columns)

# NEO whole-sample dataframes
{ df.NEO.N.pop <- cbind.data.frame(rowSums(df.NEO.N1.items[,]), rowSums(df.NEO.N2.items[,]), rowSums(df.NEO.N3.items[,]),
                                   rowSums(df.NEO.N4.items[,]), rowSums(df.NEO.N5.items[,]), rowSums(df.NEO.N6.items[,]))
  
  df.NEO.E.pop <- cbind.data.frame(rowSums(df.NEO.E1.items[,]), rowSums(df.NEO.E2.items[,]), rowSums(df.NEO.E3.items[,]),
                                   rowSums(df.NEO.E4.items[,]), rowSums(df.NEO.E5.items[,]), rowSums(df.NEO.E6.items[,]))
  
  df.NEO.O.pop <- cbind.data.frame(rowSums(df.NEO.O1.items[,]), rowSums(df.NEO.O2.items[,]), rowSums(df.NEO.O3.items[,]),
                                   rowSums(df.NEO.O4.items[,]), rowSums(df.NEO.O5.items[,]), rowSums(df.NEO.O6.items[,]))
  
  df.NEO.C.pop <- cbind.data.frame(rowSums(df.NEO.C1.items[,]), rowSums(df.NEO.C2.items[,]), rowSums(df.NEO.C3.items[,]),
                                   rowSums(df.NEO.C4.items[,]), rowSums(df.NEO.C5.items[,]), rowSums(df.NEO.C6.items[,]))
  
  df.NEO.A.pop <- cbind.data.frame(rowSums(df.NEO.A1.items[,]), rowSums(df.NEO.A2.items[,]), rowSums(df.NEO.A3.items[,]),
                                   rowSums(df.NEO.A4.items[,]), rowSums(df.NEO.A5.items[,]), rowSums(df.NEO.A6.items[,]))}

# IPIP whole-sample dataframes
{ df.IPIP.N.pop <- cbind.data.frame(rowSums(df.IPIP.N1.items[,]), rowSums(df.IPIP.N2.items[,]), rowSums(df.IPIP.N3.items[,]),
                                    rowSums(df.IPIP.N4.items[,]), rowSums(df.IPIP.N5.items[,]), rowSums(df.IPIP.N6.items[,]))
  
  df.IPIP.E.pop <- cbind.data.frame(rowSums(df.IPIP.E1.items[,]), rowSums(df.IPIP.E2.items[,]), rowSums(df.IPIP.E3.items[,]),
                                    rowSums(df.IPIP.E4.items[,]), rowSums(df.IPIP.E5.items[,]), rowSums(df.IPIP.E6.items[,]))
  
  df.IPIP.O.pop <- cbind.data.frame(rowSums(df.IPIP.O1.items[,]), rowSums(df.IPIP.O2.items[,]), rowSums(df.IPIP.O3.items[,]),
                                    rowSums(df.IPIP.O4.items[,]), rowSums(df.IPIP.O5.items[,]), rowSums(df.IPIP.O6.items[,]))
  
  df.IPIP.C.pop <- cbind.data.frame(rowSums(df.IPIP.C1.items[,]), rowSums(df.IPIP.C2.items[,]), rowSums(df.IPIP.C3.items[,]),
                                    rowSums(df.IPIP.C4.items[,]), rowSums(df.IPIP.C5.items[,]), rowSums(df.IPIP.C6.items[,]))
  
  df.IPIP.A.pop <- cbind.data.frame(rowSums(df.IPIP.A1.items[,]), rowSums(df.IPIP.A2.items[,]), rowSums(df.IPIP.A3.items[,]),
                                    rowSums(df.IPIP.A4.items[,]), rowSums(df.IPIP.A5.items[,]), rowSums(df.IPIP.A6.items[,]))}

# Rename whole-sample dataframe columns
{colnames_Npop <- c("N1sum", "N2sum", "N3sum", "N4sum", "N5sum", "N6sum")
  colnames_Epop <- c("E1sum", "E2sum", "E3sum", "E4sum", "E5sum", "E6sum")
  colnames_Opop <- c("O1sum", "O2sum", "O3sum", "O4sum", "O5sum", "O6sum")
  colnames_Cpop <- c("C1sum", "C2sum", "C3sum", "C4sum", "C5sum", "C6sum")
  colnames_Apop <- c("A1sum", "A2sum", "A3sum", "A4sum", "A5sum", "A6sum")

  df.NEO.N.pop <- setNames(df.NEO.N.pop, colnames_Npop)
  df.NEO.E.pop <- setNames(df.NEO.E.pop, colnames_Epop)
  df.NEO.O.pop <- setNames(df.NEO.O.pop, colnames_Opop)
  df.NEO.C.pop <- setNames(df.NEO.C.pop, colnames_Cpop)
  df.NEO.A.pop <- setNames(df.NEO.A.pop, colnames_Apop)

  df.IPIP.N.pop <- setNames(df.IPIP.N.pop, colnames_Npop)
  df.IPIP.E.pop <- setNames(df.IPIP.E.pop, colnames_Epop)
  df.IPIP.O.pop <- setNames(df.IPIP.O.pop, colnames_Opop)
  df.IPIP.C.pop <- setNames(df.IPIP.C.pop, colnames_Cpop)
  df.IPIP.A.pop <- setNames(df.IPIP.A.pop, colnames_Apop)}

# Run whole-sample correlation matrices
{NEO_N_cor <- cor(df.NEO.N.pop)
  NEO_E_cor <- cor(df.NEO.E.pop)
  NEO_O_cor <- cor(df.NEO.O.pop)
  NEO_C_cor <- cor(df.NEO.C.pop)
  NEO_A_cor <- cor(df.NEO.A.pop)
  
  IPIP_N_cor <- cor(df.IPIP.N.pop)
  IPIP_E_cor <- cor(df.IPIP.E.pop)
  IPIP_O_cor <- cor(df.IPIP.O.pop)
  IPIP_C_cor <- cor(df.IPIP.C.pop)
  IPIP_A_cor <- cor(df.IPIP.A.pop)}

# Run whole-sample partial correlation matrices
{NEO_N_part <- ppcor::pcor(df.NEO.N.pop)$estimate
  NEO_E_part <- ppcor::pcor(df.NEO.E.pop)$estimate
  NEO_O_part <- ppcor::pcor(df.NEO.O.pop)$estimate
  NEO_C_part <- ppcor::pcor(df.NEO.C.pop)$estimate
  NEO_A_part <- ppcor::pcor(df.NEO.A.pop)$estimate
  
  IPIP_N_part <- ppcor::pcor(df.IPIP.N.pop)$estimate
  IPIP_E_part <- ppcor::pcor(df.IPIP.E.pop)$estimate
  IPIP_O_part <- ppcor::pcor(df.IPIP.O.pop)$estimate
  IPIP_C_part <- ppcor::pcor(df.IPIP.C.pop)$estimate
  IPIP_A_part <- ppcor::pcor(df.IPIP.A.pop)$estimate}



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



## EXTRAVERSION

# NEO subscale reliabilities
{NEO_E1_pop_alpha <- alpha(df.NEO.E1.items) # 0.81 (tau-equivalence rejected)
  NEO_E1_pop_omega <- omega(df.NEO.E1.items) # 0.81 (homogeneity rejected)
  
  NEO_E2_pop_alpha <- alpha(df.NEO.E2.items) # 0.81 (tau-equivalence rejected)
  NEO_E2_pop_omega <- omega(df.NEO.E2.items) # 0.82 (homogeneity rejected)
  
  NEO_E3_pop_alpha <- alpha(df.NEO.E3.items) # 0.81 (tau-equivalence rejected)
  NEO_E3_pop_omega <- omega(df.NEO.E3.items) # 0.82 (homogeneity rejected)
  
  NEO_E4_pop_alpha <- alpha(df.NEO.E4.items) # 0.74 (tau-equivalence rejected)
  NEO_E4_pop_omega <- omega(df.NEO.E4.items) # 0.74 (homogeneity rejected)
  
  NEO_E5_pop_alpha <- alpha(df.NEO.E5.items) # 0.65 (tau-equivalence rejected)
  NEO_E5_pop_omega <- omega(df.NEO.E5.items) # 0.65 (homogeneity rejected)
  
  NEO_E6_pop_alpha <- alpha(df.NEO.E6.items) # 0.84 (tau-equivalence rejected)
  NEO_E6_pop_omega <- omega(df.NEO.E6.items) # 0.84 (homogeneity rejected)
}

# IPIP subscale reliabilities
{IPIP_E1_pop_alpha <- alpha(df.IPIP.E1.items) # 0.88 (tau-equivalence rejected)
  IPIP_E1_pop_omega <- omega(df.IPIP.E1.items) # 0.89 (homogeneity rejected)
  
  IPIP_E2_pop_alpha <- alpha(df.IPIP.E2.items) # 0.81 (tau-equivalence rejected)
  IPIP_E2_pop_omega <- omega(df.IPIP.E2.items) # 0.92 (homogeneity rejected)
  
  IPIP_E3_pop_alpha <- alpha(df.IPIP.E3.items) # 0.86 (tau-equivalence rejected)
  IPIP_E3_pop_omega <- omega(df.IPIP.E3.items) # 0.86 (homogeneity rejected)
  
  IPIP_E4_pop_alpha <- alpha(df.IPIP.E4.items) # 0.73 (tau-equivalence rejected)
  IPIP_E4_pop_omega <- omega(df.IPIP.E4.items) # 0.73 (homogeneity rejected)
  
  IPIP_E5_pop_alpha <- alpha(df.IPIP.E5.items) # 0.79 (tau-equivalence rejected)
  IPIP_E5_pop_omega <- omega(df.IPIP.E5.items) # 0.79 (homogeneity rejected)
  
  IPIP_E6_pop_alpha <- alpha(df.IPIP.E6.items) # 0.81 (tau-equivalence rejected)
  IPIP_E6_pop_omega <- omega(df.IPIP.E6.items) # 0.82 (homogeneity rejected)
}

# Pearson correlations btw subscales
{cor_pop_E1 <- cor(df.NEO.E.pop$E1sum, df.IPIP.E.pop$E1sum)
  cor_pop_E2 <- cor(df.NEO.E.pop$E2sum, df.IPIP.E.pop$E2sum)
  cor_pop_E3 <- cor(df.NEO.E.pop$E3sum, df.IPIP.E.pop$E3sum)
  cor_pop_E4 <- cor(df.NEO.E.pop$E4sum, df.IPIP.E.pop$E4sum)
  cor_pop_E5 <- cor(df.NEO.E.pop$E5sum, df.IPIP.E.pop$E5sum)
  cor_pop_E6 <- cor(df.NEO.E.pop$E6sum, df.IPIP.E.pop$E6sum)
  cor_pop_E_vector <- c(cor_pop_E1, cor_pop_E2, cor_pop_E3, cor_pop_E4, cor_pop_E5, cor_pop_E6)
  meancor_pop_Efacets <- mean(cor_pop_E_vector)
}

#print correlations
{print(cor_pop_E1) # 0.75
  print(cor_pop_E2) # 0.80
  print(cor_pop_E3) # 0.82
  print(cor_pop_E4) # 0.70
  print(cor_pop_E5) # 0.67
  print(cor_pop_E6) # 0.76
  print(meancor_pop_Efacets) # 0.75
}



## OPENNESS

# NEO subscale reliabilities
{NEO_O1_pop_alpha <- alpha(df.NEO.O1.items) # 0.83 (tau-equivalence rejected)
  NEO_O1_pop_omega <- omega(df.NEO.O1.items) # 0.83 (homogeneity rejected)
  
  NEO_O2_pop_alpha <- alpha(df.NEO.O2.items) # 0.85 (tau-equivalence rejected)
  NEO_O2_pop_omega <- omega(df.NEO.O2.items) # 0.85 (homogeneity rejected)
  
  NEO_O3_pop_alpha <- alpha(df.NEO.O3.items) # 0.77 (tau-equivalence rejected)
  NEO_O3_pop_omega <- omega(df.NEO.O3.items) # 0.78 (homogeneity rejected)
  
  NEO_O4_pop_alpha <- alpha(df.NEO.O4.items) # 0.65 (tau-equivalence rejected)
  NEO_O4_pop_omega <- omega(df.NEO.O4.items) # 0.66 (homogeneity rejected)
  
  NEO_O5_pop_alpha <- alpha(df.NEO.O5.items) # 0.83 (tau-equivalence rejected)
  NEO_O5_pop_omega <- omega(df.NEO.O5.items) # 0.83 (homogeneity rejected)
  
  NEO_O6_pop_alpha <- alpha(df.NEO.O6.items) # 0.80 (tau-equivalence rejected)
  NEO_O6_pop_omega <- omega(df.NEO.O6.items) # 0.81 (homogeneity rejected)
}

# IPIP subscale reliabilities
{IPIP_O1_pop_alpha <- alpha(df.IPIP.O1.items) # 0.83 (tau-equivalence rejected)
  IPIP_O1_pop_omega <- omega(df.IPIP.O1.items) # 0.83 (homogeneity rejected)
  
  IPIP_O2_pop_alpha <- alpha(df.IPIP.O2.items) # 0.83 (tau-equivalence rejected)
  IPIP_O2_pop_omega <- omega(df.IPIP.O2.items) # 0.84 (homogeneity rejected)
  
  IPIP_O3_pop_alpha <- alpha(df.IPIP.O3.items) # 0.81 (tau-equivalence rejected)
  IPIP_O3_pop_omega <- omega(df.IPIP.O3.items) # 0.81 (homogeneity rejected)
  
  IPIP_O4_pop_alpha <- alpha(df.IPIP.O4.items) # 0.78 (tau-equivalence rejected)
  IPIP_O4_pop_omega <- omega(df.IPIP.O4.items) # 0.79 (homogeneity rejected)
  
  IPIP_O5_pop_alpha <- alpha(df.IPIP.O5.items) # 0.88 (tau-equivalence rejected)
  IPIP_O5_pop_omega <- omega(df.IPIP.O5.items) # 0.88 (homogeneity rejected)
  
  IPIP_O6_pop_alpha <- alpha(df.IPIP.O6.items) # 0.87 (tau-equivalence rejected)
  IPIP_O6_pop_omega <- omega(df.IPIP.O6.items) # 0.87 (homogeneity rejected)
}

# Pearson correlations btw subscales
{cor_pop_O1 <- cor(df.NEO.O.pop$O1sum, df.IPIP.O.pop$O1sum)
  cor_pop_O2 <- cor(df.NEO.O.pop$O2sum, df.IPIP.O.pop$O2sum)
  cor_pop_O3 <- cor(df.NEO.O.pop$O3sum, df.IPIP.O.pop$O3sum)
  cor_pop_O4 <- cor(df.NEO.O.pop$O4sum, df.IPIP.O.pop$O4sum)
  cor_pop_O5 <- cor(df.NEO.O.pop$O5sum, df.IPIP.O.pop$O5sum)
  cor_pop_O6 <- cor(df.NEO.O.pop$O6sum, df.IPIP.O.pop$O6sum)
  cor_pop_O_vector <- c(cor_pop_O1, cor_pop_O2, cor_pop_O3, cor_pop_O4, cor_pop_O5, cor_pop_O6)
  meancor_pop_Ofacets <- mean(cor_pop_O_vector)
}

#print correlations
{print(cor_pop_O1) # 0.75
  print(cor_pop_O2) # 0.80
  print(cor_pop_O3) # 0.72
  print(cor_pop_O4) # 0.73
  print(cor_pop_O5) # 0.81
  print(cor_pop_O6) # 0.72
  print(meancor_pop_Ofacets) # 0.75
}



## CONSCIENTIOUSNESS

# NEO subscale reliabilities
{NEO_C1_pop_alpha <- alpha(df.NEO.C1.items) # 0.71 (tau-equivalence rejected)
  NEO_C1_pop_omega <- omega(df.NEO.C1.items) # 0.72 (homogeneity rejected)
  
  NEO_C2_pop_alpha <- alpha(df.NEO.C2.items) # 0.75 (tau-equivalence rejected)
  NEO_C2_pop_omega <- omega(df.NEO.C2.items) # 0.76 (homogeneity rejected)
  
  NEO_C3_pop_alpha <- alpha(df.NEO.C3.items) # 0.67 (tau-equivalence rejected)
  NEO_C3_pop_omega <- omega(df.NEO.C3.items) # 0.67 (homogeneity rejected)
  
  NEO_C4_pop_alpha <- alpha(df.NEO.C4.items) # 0.75 (tau-equivalence rejected)
  NEO_C4_pop_omega <- omega(df.NEO.C4.items) # 0.76 (homogeneity rejected)
  
  NEO_C5_pop_alpha <- alpha(df.NEO.C5.items) # 0.80 (tau-equivalence rejected)
  NEO_C5_pop_omega <- omega(df.NEO.C5.items) # 0.80 (homogeneity rejected)
  
  NEO_C6_pop_alpha <- alpha(df.NEO.C6.items) # 0.70 (tau-equivalence rejected)
  NEO_C6_pop_omega <- omega(df.NEO.C6.items) # 0.71 (homogeneity rejected)
}

# IPIP subscale reliabilities
{IPIP_C1_pop_alpha <- alpha(df.IPIP.C1.items) # 0.82 (tau-equivalence rejected)
  IPIP_C1_pop_omega <- omega(df.IPIP.C1.items) # 0.82 (homogeneity rejected)
  
  IPIP_C2_pop_alpha <- alpha(df.IPIP.C2.items) # 0.83 (tau-equivalence rejected)
  IPIP_C2_pop_omega <- omega(df.IPIP.C2.items) # 0.84 (homogeneity rejected)
  
  IPIP_C3_pop_alpha <- alpha(df.IPIP.C3.items) # 0.74 (tau-equivalence rejected)
  IPIP_C3_pop_omega <- omega(df.IPIP.C3.items) # 0.74 (homogeneity rejected)
  
  IPIP_C4_pop_alpha <- alpha(df.IPIP.C4.items) # 0.80 (tau-equivalence rejected)
  IPIP_C4_pop_omega <- omega(df.IPIP.C4.items) # 0.80 (homogeneity rejected)
  
  IPIP_C5_pop_alpha <- alpha(df.IPIP.C5.items) # 0.87 (tau-equivalence rejected)
  IPIP_C5_pop_omega <- omega(df.IPIP.C5.items) # 0.88 (homogeneity rejected)
  
  IPIP_C6_pop_alpha <- alpha(df.IPIP.C6.items) # 0.78 (tau-equivalence rejected)
  IPIP_C6_pop_omega <- omega(df.IPIP.C6.items) # 0.79 (homogeneity rejected)
}

# Pearson correlations btw subscales
{cor_pop_C1 <- cor(df.NEO.C.pop$C1sum, df.IPIP.C.pop$C1sum)
  cor_pop_C2 <- cor(df.NEO.C.pop$C2sum, df.IPIP.C.pop$C2sum)
  cor_pop_C3 <- cor(df.NEO.C.pop$C3sum, df.IPIP.C.pop$C3sum)
  cor_pop_C4 <- cor(df.NEO.C.pop$C4sum, df.IPIP.C.pop$C4sum)
  cor_pop_C5 <- cor(df.NEO.C.pop$C5sum, df.IPIP.C.pop$C5sum)
  cor_pop_C6 <- cor(df.NEO.C.pop$C6sum, df.IPIP.C.pop$C6sum)
  cor_pop_C_vector <- c(cor_pop_C1, cor_pop_C2, cor_pop_C3, cor_pop_C4, cor_pop_C5, cor_pop_C6)
  meancor_pop_Cfacets <- mean(cor_pop_C_vector)
}

#print correlations
{print(cor_pop_C1) # 0.69
  print(cor_pop_C2) # 0.76
  print(cor_pop_C3) # 0.62
  print(cor_pop_C4) # 0.72
  print(cor_pop_C5) # 0.78
  print(cor_pop_C6) # 0.72
  print(meancor_pop_Cfacets) # 0.71
}



## AGREEABLENESS

# NEO subscale reliabilities
{NEO_A1_pop_alpha <- alpha(df.NEO.A1.items) # 0.84 (tau-equivalence rejected)
  NEO_A1_pop_omega <- omega(df.NEO.A1.items) # 0.84 (homogeneity rejected)
  
  NEO_A2_pop_alpha <- alpha(df.NEO.A2.items) # 0.76 (tau-equivalence rejected)
  NEO_A2_pop_omega <- omega(df.NEO.A2.items) # 0.78 (homogeneity rejected)
  
  NEO_A3_pop_alpha <- alpha(df.NEO.A3.items) # 0.73 (tau-equivalence rejected)
  NEO_A3_pop_omega <- omega(df.NEO.A3.items) # 0.74 (homogeneity rejected)
  
  NEO_A4_pop_alpha <- alpha(df.NEO.A4.items) # 0.73 (tau-equivalence rejected)
  NEO_A4_pop_omega <- omega(df.NEO.A4.items) # 0.73 (homogeneity rejected)
  
  NEO_A5_pop_alpha <- alpha(df.NEO.A5.items) # 0.76 (tau-equivalence rejected)
  NEO_A5_pop_omega <- omega(df.NEO.A5.items) # 0.76 (homogeneity rejected)
  
  NEO_A6_pop_alpha <- alpha(df.NEO.A6.items) # 0.61 (tau-equivalence rejected)
  NEO_A6_pop_omega <- omega(df.NEO.A6.items) # 0.61 (homogeneity rejected)
}

# IPIP subscale reliabilities
{IPIP_A1_pop_alpha <- alpha(df.IPIP.A1.items) # 0.84 (tau-equivalence rejected)
  IPIP_A1_pop_omega <- omega(df.IPIP.A1.items) # 0.84 (homogeneity rejected)
  
  IPIP_A2_pop_alpha <- alpha(df.IPIP.A2.items) # 0.73 (tau-equivalence rejected)
  IPIP_A2_pop_omega <- omega(df.IPIP.A2.items) # 0.73 (homogeneity rejected)
  
  IPIP_A3_pop_alpha <- alpha(df.IPIP.A3.items) # 0.81 (tau-equivalence rejected)
  IPIP_A3_pop_omega <- omega(df.IPIP.A3.items) # 0.81 (homogeneity rejected)
  
  IPIP_A4_pop_alpha <- alpha(df.IPIP.A4.items) # 0.71 (tau-equivalence rejected)
  IPIP_A4_pop_omega <- omega(df.IPIP.A4.items) # 0.72 (homogeneity rejected)
  
  IPIP_A5_pop_alpha <- alpha(df.IPIP.A5.items) # 0.77 (tau-equivalence rejected)
  IPIP_A5_pop_omega <- omega(df.IPIP.A5.items) # 0.77 (homogeneity rejected)
  
  IPIP_A6_pop_alpha <- alpha(df.IPIP.A6.items) # 0.76 (tau-equivalence rejected)
  IPIP_A6_pop_omega <- omega(df.IPIP.A6.items) # 0.77 (homogeneity rejected)
}

# Pearson correlations btw subscales
{cor_pop_A1 <- cor(df.NEO.A.pop$A1sum, df.IPIP.A.pop$A1sum)
  cor_pop_A2 <- cor(df.NEO.A.pop$A2sum, df.IPIP.A.pop$A2sum)
  cor_pop_A3 <- cor(df.NEO.A.pop$A3sum, df.IPIP.A.pop$A3sum)
  cor_pop_A4 <- cor(df.NEO.A.pop$A4sum, df.IPIP.A.pop$A4sum)
  cor_pop_A5 <- cor(df.NEO.A.pop$A5sum, df.IPIP.A.pop$A5sum)
  cor_pop_A6 <- cor(df.NEO.A.pop$A6sum, df.IPIP.A.pop$A6sum)
  cor_pop_A_vector <- c(cor_pop_A1, cor_pop_A2, cor_pop_A3, cor_pop_A4, cor_pop_A5, cor_pop_A6)
  meancor_pop_Afacets <- mean(cor_pop_A_vector)
}

#print correlations
{print(cor_pop_A1) # 0.79
  print(cor_pop_A2) # 0.66
  print(cor_pop_A3) # 0.68
  print(cor_pop_A4) # 0.72
  print(cor_pop_A5) # 0.71
  print(cor_pop_A6) # 0.60
  print(meancor_pop_Afacets) # 0.69
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
  


## EXTRAVERSION

# Extraversion [VERSION 1]
{itemlabels_E_NEO <- c("War", "Gre", "Ass", "Act", "Exc", "Pos")
  itemlabels_E_IPIP <- c("Fri", "Gre", "Ass", "Act", "Exc", "Che")
  
  nodenames_E_NEO <- c("Warmth", "Gregariousness", "Assertiveness", "Activity", "Excitement-Seeking", "Pos. Emotions")
  nodenames_E_IPIP <- c("Friendliness", "Gregariousness", "Assertiveness", "Activity Level", "Excitement-Seeking", "Cheerfulness")
  
  # Graph from partial correlation matrix
  graph_E_NEO_V1 <- qgraph(NEO_E_part, layout = "spring", labels = itemlabels_E_NEO, title = "Whole-sample 'E' network (NEO)")
  graph_E_IPIP_V1 <- qgraph(IPIP_E_part, layout = "spring", labels = itemlabels_E_IPIP, title = "Whole-sample 'E' network (IPIP)")
  
  # Create average layout of both graphs for use of plotting together below
  Layout_E_V1 <- averageLayout(graph_E_NEO_V1, graph_E_IPIP_V1)
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 1]
  par(mfrow = c(1,2))
  graph_E_NEO_V1 <- qgraph(NEO_E_part, layout = Layout_E_V1, labels = itemlabels_E_NEO, GLratio = 2.25, title = "Whole-sample 'E' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_E_NEO, negDashed = TRUE, maximum = 0.45)
  graph_E_IPIP_V1 <- qgraph(IPIP_E_part, layout = Layout_E_V1, labels = itemlabels_E_IPIP, GLratio = 2.25, title = "Whole-sample 'E' network (NEO)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_E_IPIP, negDashed = TRUE, maximum = 0.45)}

# Extraversion [VERSION 2]
{# First estimate network on full sample (using ggmModSelect)
  NEO_E_popnet <- bootnet::estimateNetwork(df.NEO.E.pop, "ggmModSelect")
  IPIP_E_popnet <- bootnet::estimateNetwork(df.IPIP.E.pop, "ggmModSelect")
  
  # Graph from estimated network
  graph_E_NEO_V2 <- qgraph(NEO_E_popnet$graph, layout = "spring", labels = itemlabels_E_NEO, title = "Whole-sample 'E' network (NEO)")
  graph_E_IPIP_V2 <- qgraph(IPIP_E_popnet$graph, layout = "spring", labels = itemlabels_E_IPIP, title = "Whole-sample 'E' network (IPIP)")
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 2]
  par(mfrow = c(1,2))
  graph_E_NEO_V2 <- qgraph(NEO_E_popnet$graph, layout = Layout_E_V1, labels = itemlabels_E_NEO, GLratio = 2.25, title = "Whole-sample 'E' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_E_NEO, negDashed = TRUE, maximum = 0.45)
  graph_E_IPIP_V2 <- qgraph(IPIP_E_popnet$graph, layout = Layout_E_V1, labels = itemlabels_E_IPIP, GLratio = 2.25, title = "Whole-sample 'E' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_E_IPIP, negDashed = TRUE, maximum = 0.45)}



## OPENNESS

# Openness [VERSION 1]
{itemlabels_O_NEO <- c("Fan", "Aes", "Feel", "Action", "Idea", "Val")
  itemlabels_O_IPIP <- c("Ima", "Art", "Emo", "Adv", "Int", "Lib")
  
  nodenames_O_NEO <- c("Fantasy", "Aesthetics", "Feelings", "Actions", "Ideas", "Values")
  nodenames_O_IPIP <- c("Imagination", "Artistic Interests", "Emotionality", "Adventurousness", "Intellect", "Liberalism")
  
  # Graph from partial correlation matrix
  graph_O_NEO_V1 <- qgraph(NEO_O_part, layout = "spring", labels = itemlabels_O_NEO, title = "Whole-sample 'O' network (NEO)")
  graph_O_IPIP_V1 <- qgraph(IPIP_O_part, layout = "spring", labels = itemlabels_O_IPIP, title = "Whole-sample 'O' network (IPIP)")
  
  # Create average layout of both graphs for use of plotting together below
  Layout_O_V1 <- averageLayout(graph_O_NEO_V1, graph_O_IPIP_V1)
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 1]
  par(mfrow = c(1,2))
  graph_O_NEO_V1 <- qgraph(NEO_O_part, layout = Layout_O_V1, labels = itemlabels_O_NEO, GLratio = 2.25, title = "Whole-sample 'O' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_O_NEO, negDashed = TRUE, maximum = 0.45)
  graph_O_IPIP_V1 <- qgraph(IPIP_O_part, layout = Layout_O_V1, labels = itemlabels_O_IPIP, GLratio = 2.25, title = "Whole-sample 'O' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_O_IPIP, negDashed = TRUE, maximum = 0.45)}

# Openness [VERSION 2]
{# First estimate network on full sample (using ggmModSelect)
  NEO_O_popnet <- bootnet::estimateNetwork(df.NEO.O.pop, "ggmModSelect")
  IPIP_O_popnet <- bootnet::estimateNetwork(df.IPIP.O.pop, "ggmModSelect")
  
  # Graph from estimated network
  graph_O_NEO_V2 <- qgraph(NEO_O_popnet$graph, layout = "spring", labels = itemlabels_O_NEO, title = "Whole-sample 'O' network (NEO)")
  graph_O_IPIP_V2 <- qgraph(IPIP_O_popnet$graph, layout = "spring", labels = itemlabels_O_IPIP, title = "Whole-sample 'O' network (IPIP)")
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 2]
  par(mfrow = c(1,2))
  graph_O_NEO_V2 <- qgraph(NEO_O_popnet$graph, layout = Layout_O_V1, labels = itemlabels_O_NEO, GLratio = 2.25, title = "Whole-sample 'O' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_O_NEO, negDashed = TRUE, maximum = 0.45)
  graph_O_IPIP_V2 <- qgraph(IPIP_O_popnet$graph, layout = Layout_O_V1, labels = itemlabels_O_IPIP, GLratio = 2.25, title = "Whole-sample 'O' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_O_IPIP, negDashed = TRUE, maximum = 0.45)}



## CONSCIENTIOUSNESS

# Conscientiousness [VERSION 1]
{itemlabels_C_NEO <- c("Comp", "Order", "Dut", "Ach", "SelfD", "Delib")
  itemlabels_C_IPIP <- c("SelfE", "Order", "Dut", "Ach", "SelfD", "Caut")
  
  nodenames_C_NEO <- c("Competence", "Order", "Dutifulness", "Achievement Striving", "Self-Discipline", "Deliberation")
  nodenames_C_IPIP <- c("Self-Efficacy", "Orderliness", "Dutifulness", "Achievement Striving", "Self-Discipline", "Cautiousness")
  
  # Graph from partial correlation matrix
  graph_C_NEO_V1 <- qgraph(NEO_C_part, layout = "spring", labels = itemlabels_C_NEO, title = "Whole-sample 'C' network (NEO)")
  graph_C_IPIP_V1 <- qgraph(IPIP_C_part, layout = "spring", labels = itemlabels_C_IPIP, title = "Whole-sample 'C' network (IPIP)")
  
  # Create average layout of both graphs for use of plotting together below
  Layout_C_V1 <- averageLayout(graph_C_NEO_V1, graph_C_IPIP_V1)
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 1]
  par(mfrow = c(1,2))
  graph_C_NEO_V1 <- qgraph(NEO_C_part, layout = Layout_C_V1, labels = itemlabels_C_NEO, GLratio = 2.25, title = "Whole-sample 'C' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_C_NEO, negDashed = TRUE, maximum = 0.45)
  graph_C_IPIP_V1 <- qgraph(IPIP_C_part, layout = Layout_C_V1, labels = itemlabels_C_IPIP, GLratio = 2.25, title = "Whole-sample 'C' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_C_IPIP, negDashed = TRUE, maximum = 0.45)}

# Conscientiousness [VERSION 2]
{# First estimate network on full sample (using ggmModSelect)
  NEO_C_popnet <- bootnet::estimateNetwork(df.NEO.C.pop, "ggmModSelect")
  IPIP_C_popnet <- bootnet::estimateNetwork(df.IPIP.C.pop, "ggmModSelect")
  
  # Graph from estimated network
  graph_C_NEO_V2 <- qgraph(NEO_C_popnet$graph, layout = "spring", labels = itemlabels_C_NEO, title = "Whole-sample 'C' network (NEO)")
  graph_C_IPIP_V2 <- qgraph(IPIP_C_popnet$graph, layout = "spring", labels = itemlabels_C_IPIP, title = "Whole-sample 'C' network (IPIP)")
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 2]
  par(mfrow = c(1,2))
  graph_C_NEO_V2 <- qgraph(NEO_C_popnet$graph, layout = Layout_C_V1, labels = itemlabels_C_NEO, GLratio = 2.25, title = "Whole-sample 'C' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_C_NEO, negDashed = TRUE, maximum = 0.45)
  graph_C_IPIP_V2 <- qgraph(IPIP_C_popnet$graph, layout = Layout_C_V1, labels = itemlabels_C_IPIP, GLratio = 2.25, title = "Whole-sample 'C' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_C_IPIP, negDashed = TRUE, maximum = 0.45)}



## AGREEABLENESS

# Agreeableness [VERSION 1]
{itemlabels_A_NEO <- c("Trust", "Str", "Alt", "Compl", "Mod", "Tender")
  itemlabels_A_IPIP <- c("Trust", "Mor", "Alt", "Coop", "Mod", "Sym")
  
  nodenames_A_NEO <- c("Trust", "Straightforwardness", "Altruism", "Compliance", "Modesty", "Tender-Mindedness")
  nodenames_A_IPIP <- c("Trust", "Morality", "Altruism", "Cooperation", "Modesty", "Sympathy")
  
  # Graph from partial correlation matrix
  graph_A_NEO_V1 <- qgraph(NEO_A_part, layout = "spring", labels = itemlabels_A_NEO, title = "Whole-sample 'A' network (NEO)")
  graph_A_IPIP_V1 <- qgraph(IPIP_A_part, layout = "spring", labels = itemlabels_A_IPIP, title = "Whole-sample 'A' network (IPIP)")
  
  # Create average layout of both graphs for use of plotting together below
  Layout_A_V1 <- averageLayout(graph_A_NEO_V1, graph_A_IPIP_V1)
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 1]
  par(mfrow = c(1,2))
  graph_A_NEO_V1 <- qgraph(NEO_A_part, layout = Layout_A_V1, labels = itemlabels_A_NEO, GLratio = 2.25, title = "Whole-sample 'A' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_A_NEO, negDashed = TRUE, maximum = 0.45)
  graph_A_IPIP_V1 <- qgraph(IPIP_A_part, layout = Layout_A_V1, labels = itemlabels_A_IPIP, GLratio = 2.25, title = "Whole-sample 'A' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_A_IPIP, negDashed = TRUE, maximum = 0.45)}

# Agreeableness [VERSION 2]
{# First estimate network on full sample (using ggmModSelect)
  NEO_A_popnet <- bootnet::estimateNetwork(df.NEO.A.pop, "ggmModSelect")
  IPIP_A_popnet <- bootnet::estimateNetwork(df.IPIP.A.pop, "ggmModSelect")
  
  # Graph from estimated network
  graph_A_NEO_V2 <- qgraph(NEO_A_popnet$graph, layout = "spring", labels = itemlabels_A_NEO, title = "Whole-sample 'A' network (NEO)")
  graph_A_IPIP_V2 <- qgraph(IPIP_A_popnet$graph, layout = "spring", labels = itemlabels_A_IPIP, title = "Whole-sample 'A' network (IPIP)")
  
  # Plot NEO & IPIP networks alongside one another with the same layout 
  # [VERSION 2]
  par(mfrow = c(1,2))
  graph_A_NEO_V2 <- qgraph(NEO_A_popnet$graph, layout = Layout_A_V1, labels = itemlabels_A_NEO, GLratio = 2.25, title = "Whole-sample 'A' network (NEO)",
                           legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_A_NEO, negDashed = TRUE, maximum = 0.45)
  graph_A_IPIP_V2 <- qgraph(IPIP_A_popnet$graph, layout = Layout_A_V1, labels = itemlabels_A_IPIP, GLratio = 2.25, title = "Whole-sample 'A' network (IPIP)",
                            legend = TRUE, legend.cex = 0.5, nodeNames = nodenames_A_IPIP, negDashed = TRUE, maximum = 0.45)}



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
  
  #Centrality scores (estimated from ggmModSelect)
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


# EXTRAVERSION

# Whole-sample network statistics
{ df.NEO.E.pop_tmp <- df.NEO.E.pop
  df.IPIP.E.pop_tmp <- df.IPIP.E.pop
  
  colnames(df.NEO.E.pop_tmp) <- c("WAR", "GRE", "ASS", "ACT", "EXC", "POS") 
  colnames(df.IPIP.E.pop_tmp) <- c("WAR", "GRE", "ASS", "ACT", "EXC", "POS")
  
  NEO_E_pop_bootnet <- bootnet::estimateNetwork(df.NEO.E.pop_tmp, "ggmModSelect")
  IPIP_E_pop_bootnet <- bootnet::estimateNetwork(df.IPIP.E.pop_tmp, "ggmModSelect")
  
  #Centrality scores (estimated from ggmModSelect)
  centrality_NEO_E_pop_ggm <- centrality(NEO_E_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  centrality_IPIP_E_pop_ggm <- centrality(IPIP_E_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  
  # Case-drop bootstrap
  pop_E_NEO_casedrop <- bootnet(NEO_E_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  pop_E_IPIP_casedrop <- bootnet(IPIP_E_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  
  # Compute CS-coefficients (centrality stability)
  pop_E_NEO_cscoeff <- corStability(pop_E_NEO_casedrop, cor=0.7) 
  pop_E_IPIP_cscoeff <- corStability(pop_E_IPIP_casedrop, cor=0.7)
}

# Print centrality statistics #(Table 1 descriptives)
{print(centrality_NEO_E_pop_ggm$InExpectedInfluence) 
  print(centrality_IPIP_E_pop_ggm$InExpectedInfluence)
  print(pop_E_NEO_cscoeff)
  print(pop_E_IPIP_cscoeff)}


# OPENNESS

# Whole-sample network statistics
{ df.NEO.O.pop_tmp <- df.NEO.O.pop
  df.IPIP.O.pop_tmp <- df.IPIP.O.pop
  
  colnames(df.NEO.O.pop_tmp) <- c("FAN", "AES", "FEEL", "ACTION", "IDEA", "VAL")
  colnames(df.IPIP.O.pop_tmp) <- c("FAN", "AES", "FEEL", "ACTION", "IDEA", "VAL")
  
  NEO_O_pop_bootnet <- bootnet::estimateNetwork(df.NEO.O.pop_tmp, "ggmModSelect")
  IPIP_O_pop_bootnet <- bootnet::estimateNetwork(df.IPIP.O.pop_tmp, "ggmModSelect")
  
  #Centrality scores (estimated from ggmModSelect)
  centrality_NEO_O_pop_ggm <- centrality(NEO_O_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  centrality_IPIP_O_pop_ggm <- centrality(IPIP_O_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  
  # Case-drop bootstrap
  pop_O_NEO_casedrop <- bootnet(NEO_O_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  pop_O_IPIP_casedrop <- bootnet(IPIP_O_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  
  # Compute CS-coefficients (centrality stability)
  pop_O_NEO_cscoeff <- corStability(pop_O_NEO_casedrop, cor=0.7) 
  pop_O_IPIP_cscoeff <- corStability(pop_O_IPIP_casedrop, cor=0.7)
}

# Print centrality statistics #(Table 1 descriptives)
{print(centrality_NEO_O_pop_ggm$InExpectedInfluence) 
  print(centrality_IPIP_O_pop_ggm$InExpectedInfluence)
  print(pop_O_NEO_cscoeff)
  print(pop_O_IPIP_cscoeff)}


# CONSCIENTIOUSNESS

# Whole-sample network statistics
{ df.NEO.C.pop_tmp <- df.NEO.C.pop
  df.IPIP.C.pop_tmp <- df.IPIP.C.pop
  
  colnames(df.NEO.C.pop_tmp) <- c("COMP", "ORDER", "DUT", "ACH", "SELFD", "DELIB")
  colnames(df.IPIP.C.pop_tmp) <- c("COMP", "ORDER", "DUT", "ACH", "SELFD", "DELIB")
  
  NEO_C_pop_bootnet <- bootnet::estimateNetwork(df.NEO.C.pop_tmp, "ggmModSelect")
  IPIP_C_pop_bootnet <- bootnet::estimateNetwork(df.IPIP.C.pop_tmp, "ggmModSelect")
  
  #Centrality scores (estimated from ggmModSelect)
  centrality_NEO_C_pop_ggm <- centrality(NEO_C_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  centrality_IPIP_C_pop_ggm <- centrality(IPIP_C_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  
  # Case-drop bootstrap
  pop_C_NEO_casedrop <- bootnet(NEO_C_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  pop_C_IPIP_casedrop <- bootnet(IPIP_C_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  
  # Compute CS-coefficients (centrality stability)
  pop_C_NEO_cscoeff <- corStability(pop_C_NEO_casedrop, cor=0.7) 
  pop_C_IPIP_cscoeff <- corStability(pop_C_IPIP_casedrop, cor=0.7)
}

# Print centrality statistics #(Table 1 descriptives)
{print(centrality_NEO_C_pop_ggm$InExpectedInfluence) 
  print(centrality_IPIP_C_pop_ggm$InExpectedInfluence)
  print(pop_C_NEO_cscoeff)
  print(pop_C_IPIP_cscoeff)}


# AGREEABLENESS

# Whole-sample network statistics
{ df.NEO.A.pop_tmp <- df.NEO.A.pop
  df.IPIP.A.pop_tmp <- df.IPIP.A.pop
  
  colnames(df.NEO.A.pop_tmp) <- c("TRUST", "STR", "ALT", "COMPL", "MOD", "TENDER")
  colnames(df.IPIP.A.pop_tmp) <- c("TRUST", "STR", "ALT", "COMPL", "MOD", "TENDER")
  
  NEO_A_pop_bootnet <- bootnet::estimateNetwork(df.NEO.A.pop_tmp, "ggmModSelect")
  IPIP_A_pop_bootnet <- bootnet::estimateNetwork(df.IPIP.A.pop_tmp, "ggmModSelect")
  
  #Centrality scores (estimated from ggmModSelect)
  centrality_NEO_A_pop_ggm <- centrality(NEO_A_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  centrality_IPIP_A_pop_ggm <- centrality(IPIP_A_pop_bootnet$graph, alpha = 1, posfun = abs, weighted = TRUE, signed = TRUE)
  
  # Case-drop bootstrap
  pop_A_NEO_casedrop <- bootnet(NEO_A_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  pop_A_IPIP_casedrop <- bootnet(IPIP_A_pop_bootnet, nBoots=1000, nCores=4, type="case", statistics="expectedInfluence")
  
  # Compute CS-coefficients (centrality stability)
  pop_A_NEO_cscoeff <- corStability(pop_A_NEO_casedrop, cor=0.7) 
  pop_A_IPIP_cscoeff <- corStability(pop_A_IPIP_casedrop, cor=0.7)
}

# Print centrality statistics #(Table 1 descriptives)
{print(centrality_NEO_A_pop_ggm$InExpectedInfluence) 
  print(centrality_IPIP_A_pop_ggm$InExpectedInfluence)
  print(pop_A_NEO_cscoeff)
  print(pop_A_IPIP_cscoeff)}



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


## EXTRAVERSION

# Centrality scores (expected influence): 1-panel plot
E_ExpInf_plot <- centralityPlot(list(NEO = NEO_E_pop_bootnet, IPIP = IPIP_E_pop_bootnet), include = c("ExpectedInfluence"), scale = "raw", orderBy = "ExpectedInfluence")

# CS-coefficients (centrality stability): 2-panel plot
{require(gridExtra)
  # TOP PLOT
  NEO_pop_casedrop_plot_E <- plot(pop_E_NEO_casedrop, statistics = "expectedInfluence")
  # BOTTOM PLOT
  IPIP_pop_casedrop_plot_E <- plot(pop_E_IPIP_casedrop, statistics = "expectedInfluence")
  grid.arrange(NEO_pop_casedrop_plot_E, IPIP_pop_casedrop_plot_E, ncol=1)}


## OPENNESS

# Centrality scores (expected influence): 1-panel plot
O_ExpInf_plot <- centralityPlot(list(NEO = NEO_O_pop_bootnet, IPIP = IPIP_O_pop_bootnet), include = c("ExpectedInfluence"), scale = "raw", orderBy = "ExpectedInfluence")

# CS-coefficients (centrality stability): 2-panel plot
{require(gridExtra)
  # TOP PLOT
  NEO_pop_casedrop_plot_O <- plot(pop_O_NEO_casedrop, statistics = "expectedInfluence")
  # BOTTOM PLOT
  IPIP_pop_casedrop_plot_O <- plot(pop_O_IPIP_casedrop, statistics = "expectedInfluence")
  grid.arrange(NEO_pop_casedrop_plot_O, IPIP_pop_casedrop_plot_O, ncol=1)}


## CONSCIENTIOUSNESS

# Centrality scores (expected influence): 1-panel plot
C_ExpInf_plot <- centralityPlot(list(NEO = NEO_C_pop_bootnet, IPIP = IPIP_C_pop_bootnet), include = c("ExpectedInfluence"), scale = "raw", orderBy = "ExpectedInfluence")

# CS-coefficients (centrality stability): 2-panel plot
{require(gridExtra)
  # TOP PLOT
  NEO_pop_casedrop_plot_C <- plot(pop_C_NEO_casedrop, statistics = "expectedInfluence")
  # BOTTOM PLOT
  IPIP_pop_casedrop_plot_C <- plot(pop_C_IPIP_casedrop, statistics = "expectedInfluence")
  grid.arrange(NEO_pop_casedrop_plot_C, IPIP_pop_casedrop_plot_C, ncol=1)}


## AGREEABLENESS

# Centrality scores (expected influence): 1-panel plot
A_ExpInf_plot <- centralityPlot(list(NEO = NEO_A_pop_bootnet, IPIP = IPIP_A_pop_bootnet), include = c("ExpectedInfluence"), scale = "raw", orderBy = "ExpectedInfluence")

# CS-coefficients (centrality stability): 2-panel plot
{require(gridExtra)
  # TOP PLOT
  NEO_pop_casedrop_plot_A <- plot(pop_A_NEO_casedrop, statistics = "expectedInfluence")
  # BOTTOM PLOT
  IPIP_pop_casedrop_plot_A <- plot(pop_A_IPIP_casedrop, statistics = "expectedInfluence")
  grid.arrange(NEO_pop_casedrop_plot_A, IPIP_pop_casedrop_plot_A, ncol=1)}
  


### [end]


### Save objects

save(data1.rel, data1.rel.noNA, noNA_func,
     df.NEO.N1.items, df.NEO.N2.items, df.NEO.N3.items, df.NEO.N4.items, df.NEO.N5.items, df.NEO.N6.items,
     df.NEO.E1.items, df.NEO.E2.items, df.NEO.E3.items, df.NEO.E4.items, df.NEO.E5.items, df.NEO.E6.items,
     df.NEO.O1.items, df.NEO.O2.items, df.NEO.O3.items, df.NEO.O4.items, df.NEO.O5.items, df.NEO.O6.items,
     df.NEO.C1.items, df.NEO.C2.items, df.NEO.C3.items, df.NEO.C4.items, df.NEO.C5.items, df.NEO.C6.items,
     df.NEO.A1.items, df.NEO.A2.items, df.NEO.A3.items, df.NEO.A4.items, df.NEO.A5.items, df.NEO.A6.items,
     df.IPIP.N1.items, df.IPIP.N2.items, df.IPIP.N3.items, df.IPIP.N4.items, df.IPIP.N5.items, df.IPIP.N6.items,
     df.IPIP.E1.items, df.IPIP.E2.items, df.IPIP.E3.items, df.IPIP.E4.items, df.IPIP.E5.items, df.IPIP.E6.items,
     df.IPIP.O1.items, df.IPIP.O2.items, df.IPIP.O3.items, df.IPIP.O4.items, df.IPIP.O5.items, df.IPIP.O6.items,
     df.IPIP.C1.items, df.IPIP.C2.items, df.IPIP.C3.items, df.IPIP.C4.items, df.IPIP.C5.items, df.IPIP.C6.items,
     df.IPIP.A1.items, df.IPIP.A2.items, df.IPIP.A3.items, df.IPIP.A4.items, df.IPIP.A5.items, df.IPIP.A6.items,
     NEO.N.list, NEO.E.list, NEO.O.list, NEO.C.list, NEO.A.list,
     IPIP.N.list, IPIP.E.list, IPIP.O.list, IPIP.C.list, IPIP.A.list,
     N1.items, N2.items, N3.items, N4.items, N5.items, N6.items,
     E1.items, E2.items, E3.items, E4.items, E5.items, E6.items,
     O1.items, O2.items, O3.items, O4.items, O5.items, O6.items,
     C1.items, C2.items, C3.items, C4.items, C5.items, C6.items,
     A1.items, A2.items, A3.items, A4.items, A5.items, A6.items,
     N.list, E.list, O.list, C.list, A.list,
     df.NEO.N.pop, df.NEO.E.pop, df.NEO.O.pop, df.NEO.C.pop, df.NEO.A.pop,
     df.IPIP.N.pop, df.IPIP.E.pop, df.IPIP.O.pop, df.IPIP.C.pop, df.IPIP.A.pop,
     colnames_Npop, colnames_Epop, colnames_Opop, colnames_Cpop, colnames_Apop,
     NEO_N_cor, NEO_E_cor, NEO_O_cor, NEO_C_cor, NEO_A_cor,
     IPIP_N_cor, IPIP_E_cor, IPIP_O_cor, IPIP_C_cor, IPIP_A_cor,
     NEO_N_part, NEO_E_part, NEO_O_part, NEO_C_part, NEO_A_part,
     IPIP_N_part, IPIP_E_part, IPIP_O_part, IPIP_C_part, IPIP_A_part,
     itemlabels_N_NEO, itemlabels_N_IPIP, nodenames_N_NEO, nodenames_N_IPIP, 
     itemlabels_E_NEO, itemlabels_E_IPIP, nodenames_E_NEO, nodenames_E_IPIP, 
     itemlabels_O_NEO, itemlabels_O_IPIP, nodenames_O_NEO, nodenames_O_IPIP, 
     itemlabels_C_NEO, itemlabels_C_IPIP, nodenames_C_NEO, nodenames_C_IPIP, 
     itemlabels_A_NEO, itemlabels_A_IPIP, nodenames_A_NEO, nodenames_A_IPIP, 
     graph_N_NEO_V1, graph_N_IPIP_V1, Layout_N_V1, graph_N_NEO_V2, graph_N_IPIP_V2,
     graph_E_NEO_V1, graph_E_IPIP_V1, Layout_E_V1, graph_E_NEO_V2, graph_E_IPIP_V2,
     graph_O_NEO_V1, graph_O_IPIP_V1, Layout_O_V1, graph_O_NEO_V2, graph_O_IPIP_V2,
     graph_C_NEO_V1, graph_C_IPIP_V1, Layout_C_V1, graph_C_NEO_V2, graph_C_IPIP_V2,
     graph_A_NEO_V1, graph_A_IPIP_V1, Layout_A_V1, graph_A_NEO_V2, graph_A_IPIP_V2,
     NEO_N_pop_bootnet, NEO_E_pop_bootnet, NEO_O_pop_bootnet, NEO_C_pop_bootnet, NEO_A_pop_bootnet, 
     IPIP_N_pop_bootnet, IPIP_E_pop_bootnet, IPIP_O_pop_bootnet, IPIP_C_pop_bootnet, IPIP_A_pop_bootnet, 
     centrality_NEO_N_pop_ggm, centrality_NEO_E_pop_ggm, centrality_NEO_O_pop_ggm, centrality_NEO_C_pop_ggm, centrality_NEO_A_pop_ggm, 
     centrality_IPIP_N_pop_ggm, centrality_IPIP_E_pop_ggm, centrality_IPIP_O_pop_ggm, centrality_IPIP_C_pop_ggm, centrality_IPIP_A_pop_ggm,
     pop_N_NEO_casedrop, pop_E_NEO_casedrop, pop_O_NEO_casedrop, pop_C_NEO_casedrop, pop_A_NEO_casedrop, 
     pop_N_IPIP_casedrop, pop_E_IPIP_casedrop, pop_O_IPIP_casedrop, pop_C_IPIP_casedrop, pop_A_IPIP_casedrop,
     NEO_pop_casedrop_plot_N, NEO_pop_casedrop_plot_E, NEO_pop_casedrop_plot_O, NEO_pop_casedrop_plot_C, NEO_pop_casedrop_plot_A,
     IPIP_pop_casedrop_plot_N, IPIP_pop_casedrop_plot_E, IPIP_pop_casedrop_plot_O, IPIP_pop_casedrop_plot_C, IPIP_pop_casedrop_plot_A,
     pop_N_NEO_cscoeff, pop_E_NEO_cscoeff, pop_O_NEO_cscoeff, pop_C_NEO_cscoeff, pop_A_NEO_cscoeff, 
     pop_N_IPIP_cscoeff, pop_E_IPIP_cscoeff, pop_O_IPIP_cscoeff, pop_C_IPIP_cscoeff, pop_A_IPIP_cscoeff,
     file = "NEO & IPIP - P1_nSim50_data_NEOCA.RData")

  

















