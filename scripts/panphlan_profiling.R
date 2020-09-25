library(readr)
library(ggbiplot)
library(readxl)
library(dplyr)
library(splitstackshape)
library(tidyr)
library(gplots)
library(lattice)


source_dir = "/Users/12705859/metapigs_dry/source_data/" # git 
middle_dir = "/Users/12705859/Desktop/probioticsHunt/middle_dir/" # locale
out_dir = "/Users/12705859/Desktop/probioticsHunt/out_dir/" # locale


######################################################################

# reading in files

myfiles = list.files(middle_dir, pattern = "profile")

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
                               from = c("PosControl_D-scour", "PosControl_ColiGuard", "Neomycin+D-scour","Neomycin+ColiGuard","D-scour"), 
                               to = c("PosControl_DScour", "PosControl_ColiGuard", "NeoD","NeoC","D-Scour"))

mdat$plate_well <- paste0(mdat$DNA_plate,"_",mdat$DNA_well)

mdat <- mdat %>% dplyr::select(isolation_source,Cohort,plate_well) %>% distinct()
colnames(mdat) <- c("pig","cohort","plate_well")


######################################################################

for (file in myfiles) {
  
  # reading in
  testout <- read.delim(file.path(middle_dir,file), row.names=1)
  
  # parse mapping file 
  testout$refs <- rownames(testout)
  
  testout <- testout %>% 
    pivot_longer(cols = -refs)
  
  testout <- cSplit(indt = testout, splitCols = "name", sep = "_")
  testout <- cSplit(indt = testout, splitCols = "name_5", sep = ".")
  
  testout$plate_well <- paste0(testout$name_3,"_",testout$name_4,"_",testout$name_5_1)
  
  df <- left_join(testout,mdat)
  
  df$sample <- paste0(df$cohort,".",df$plate_well)
  
  df <- df %>% 
    dplyr::select(sample,refs,value) %>%
    pivot_wider(names_from=refs)
  
  df <- as.data.frame(df)
  
  rownames(df) <- df$sample
  df$sample <- NULL

  mymat <- as.matrix(df)
  
  pdf(paste0(out_dir,"heatmap_",file,".pdf"))
  print(heatmap.2(mymat,main = file, 
                  trace='none', #Rowv = TRUE, Colv = NULL,
                  cexRow = 0.4)) # dendrogram='none', Rowv=TRUE, Colv=TRUE
  dev.off()

}

######################################################################

