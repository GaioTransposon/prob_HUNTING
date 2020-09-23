
library(readr)
library(splitstackshape)
library(dplyr)
library(data.table)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(readxl)
library(EnvStats)



source_dir = "/Users/12705859/metapigs_dry/source_data/" # git 
out_dir = "/Users/12705859/Desktop/metapigs_dry/mash/"  # local
middle_dir = "/Users/12705859/metapigs_dry/middle_dir/"  # local

# mash output was been subsetted from the original output this way: 
# $ awk '$4<1' mash_output_all.csv > mash_output_all_pvalLESSthan1.csv
# location: /shared/homes/12705859/mash_test

######################################################################

# counts data 

no_reps_all <- read.csv(paste0(middle_dir,"no_reps_all.csv"), 
                        na.strings=c("","NA"),
                        check.names = FALSE,
                        header = TRUE)


# remove .fa extension to match bins in checkm df 
no_reps_all$bin <- gsub(".fa","", no_reps_all$bin)
head(no_reps_all)
NROW(no_reps_all)


######################################################################


# load gtdbtk assignments of the bins
gtdbtk_bins <- read_csv(paste0(middle_dir,"gtdb_bins_completeTaxa"),
                        col_types = cols(node = col_character(),
                                         pig = col_character()))

gtdbtk_bins <- gtdbtk_bins %>% dplyr::select(species,pig,bin)

head(gtdbtk_bins)

######################################################################



# upload metadata for pen info

mdat <- read_excel(paste0(source_dir,"Metagenome.environmental_20190308_2.xlsx"),
                   col_types = c("text", "numeric", "numeric", "text", "text",
                                 "text", "date", "text","text", "text", "numeric",
                                 "numeric", "numeric", "numeric", "numeric", "numeric",
                                 "numeric", "text", "text","text", "text", "text", "text",
                                 "text","text", "text", "text", "text", "text","text", "text"),
                   skip = 12)

mdat$`*collection_date` <- as.character(mdat$`*collection_date`)

# cohort names edits: 
mdat$Cohort <- plyr::mapvalues(as.character(mdat$Cohort), 
                               from = c("Neomycin+D-scour","Neomycin+ColiGuard","D-scour","PosControl_D-scour","PosControl_ColiGuard"), 
                               to = c("NeoD","NeoC","D-Scour","PosControl_D-scour","PosControl_ColiGuard"))
unique(mdat$Cohort)

mdat <- mdat %>% dplyr::select(isolation_source,Cohort) %>% distinct()
colnames(mdat) <- c("pig","cohort")

mdat$cohort <- factor(mdat$cohort, levels=c("Control",
                                            "D-Scour",
                                            "ColiGuard",
                                            "Neomycin",
                                            "NeoD",
                                            "NeoC",
                                            "Mothers",
                                            "PosControl_D-scour",
                                            "PosControl_ColiGuard"))

######################################################################

# load mash data 

mash <- read_table2(paste0(out_dir,"mash_output_all_pvalLESSthan1.csv"),
                                             col_names = FALSE)

# split sample column & retain useful columns
mash <- cSplit(indt = mash, "X2", sep = "/", drop = NA)
mash <- cSplit(indt = mash, "X2_7", sep = "_", drop = NA)
mash <- cSplit(indt = mash, "X5", sep = "/", drop = NA)
mash <- mash %>% dplyr::select(X1,X2_7_1,X2_7_2,X3,X4,X5_1)


# remove .fa extension 
mash$X2_7_2 <- gsub(".fa","", mash$X2_7_2)

# remove extra text from refs
mash$X1 <- gsub("/shared/homes/12705859/mash_test/probiotic_references/","", mash$X1)
mash$X1 <- gsub(".contigs.fasta","", mash$X1)


  
# give columns sensible names
colnames(mash) <- c("reference","pig","bin","mash_distance","pvalue","matchingHashes")

# join cohort info 
mash1 <- merge(mdat,mash)

# split by reference genome
multi_mash <- split( mash1 , f = mash1$reference )


pdf(paste0(out_dir,"mash_cohorts.pdf"))
for (single_mash in multi_mash) {
  
  df1 <- single_mash %>% 
    dplyr::filter(cohort=="Control"|cohort=="D-Scour"|cohort=="ColiGuard")
  
  df2 <- single_mash %>% 
    dplyr::filter(cohort=="Neomycin"|cohort=="NeoD"|cohort=="NeoC")
  
  # plotting mains
  p1_main <- ggplot(df1, aes(x=pvalue, fill=cohort, color=cohort)) +
    geom_histogram(position="identity", alpha=0.5) +
    theme(axis.text.x=element_text(angle=90)) +
    ggtitle(as.character(unique(df1$reference)))
  
  p2_main <- ggplot(df2, aes(x=pvalue, fill=cohort, color=cohort)) +
    geom_histogram(position="identity", alpha=0.5) +
    theme(axis.text.x=element_text(angle=90)) +
    ggtitle(as.character(unique(df2$reference)))
  
  p1_sub <- df1 %>% filter(pvalue==0) %>% 
    ggplot(., aes(x=matchingHashes, fill=cohort, color=cohort)) +
    geom_histogram(position="identity", alpha=0.5) +
    theme(axis.text.x=element_text(angle=90)) +
    ggtitle(as.character(unique(df1$reference)))
  
  p2_sub <- df2 %>% filter(pvalue==0) %>% 
    ggplot(., aes(x=matchingHashes, fill=cohort, color=cohort)) +
    geom_histogram(position="identity", alpha=0.5) +
    theme(axis.text.x=element_text(angle=90)) +
    ggtitle(as.character(unique(df2$reference)))
  
  p1 <- ggarrange(p1_main,p1_sub,nrow=2)
  p2 <- ggarrange(p2_main,p2_sub,nrow=2)
  
  p <- ggarrange(p1,p2,ncol=2)
  print(p)
}
dev.off()

p
