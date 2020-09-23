library(readr)
library(ggbiplot)
library(readxl)
library(dplyr)
library(splitstackshape)
library(tidyr)
library(stringr)
library(ggpubr)



source_dir = "/Users/12705859/metapigs_dry/source_data/" # git 
middle_dir = "/Users/12705859/Desktop/probioticsHunt/panphlan/middle_dir/" # locale
out_dir = "/Users/12705859/Desktop/probioticsHunt/panphlan/out/" # locale

is_this_a_dscour_probiotic_strain = "yes"

######################################################################

# reading in 

df <- read_table2(paste0(middle_dir,"Bifidobacterium_bifidum.tsv"), col_names = FALSE)
TheRef <- basename(path=tools::file_path_sans_ext(paste0(middle_dir,"Bifidobacterium_bifidum.tsv")))


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
unique(mdat$Cohort)

mdat$plate_well <- paste0(mdat$DNA_plate,"_",mdat$DNA_well)

mdat <- mdat %>% dplyr::select(isolation_source,Cohort,plate_well) %>% distinct()
colnames(mdat) <- c("pig","cohort","plate_well")

######################################################################

# parse mapping file 


NROW(df) 
# converting parsing failures rows into NA and excluding those rows 
df <- df[!is.na(as.numeric(as.character(df$X3))),]
NROW(df)

# convert to numeric
df$X3 <- as.numeric(df$X3)

df <- cSplit(indt = df, splitCols = "X2", sep = "_")

df1 <- df %>% 
  group_by(X1,X2_1) %>% 
  dplyr::summarise(avg_depth=mean(X3))


# add metadata info
df1 <- cSplit(indt = df1, splitCols = "X1", sep = ".")
df1 <- cSplit(indt = df1, splitCols = "X1_1", sep = "_")



df1$plate_well <- paste0(df1$X1_1_3,"_",df1$X1_1_4,"_",df1$X1_1_5)
df1 <- df1 %>% dplyr::select(plate_well,X2_1,avg_depth)
colnames(df1) <- c("plate_well","ref_genome","avg_depth")

head(df1)
#View(df1)
NROW(df1)

df2 <- left_join(df1,mdat)
NROW(df2)
head(df2)
unique(df2$cohort)

df2$cohort <- factor(df2$cohort, levels=c("Control",
                                            "D-Scour",
                                            "ColiGuard",
                                            "Neomycin",
                                            "NeoD",
                                            "NeoC",
                                            "Mothers",
                                        "PosControl_DScour",
                                        "PosControl_ColiGuard"))


pdf(file = paste0(out_dir,TheRef,"_all.pdf")) # width=7, height=5
ggplot(df2, 
       aes(x=ref_genome,y=avg_depth, color=cohort))+
  geom_point(alpha=0.5, size=1) +
  theme(axis.text.x=element_blank()) +
  labs(x="reference genomes",
       y="average depth",
       color="samples") +
  facet_grid(rows = vars(cohort))
ggplot(df2, 
       aes(x=ref_genome,y=avg_depth, color=cohort))+
  geom_point(alpha=0.5, size=1) +
  theme(axis.text.x=element_blank()) +
  labs(x="reference genomes",
       y="average depth",
       color="samples") +
  ylim(0,10000) +
  facet_grid(rows = vars(cohort))
dev.off()



# # PCA 
# 
# test3 <- df %>% 
#   dplyr::mutate(cohort_sample=paste0(cohort,".",plate_well)) %>% 
#   dplyr::select(cohort_sample,ref_genome,depth)
# 
# test3_wide <- test3 %>% 
#   pivot_wider(names_from = ref_genome, values_from=depth, values_fill = 0)
# 
# test3_wide <- as.data.frame(test3_wide)
# 
# rownames(test3_wide) <- test3_wide$cohort_sample
# test3_wide$cohort_sample <- NULL
# 
# test.pca <- prcomp(test3_wide, center = TRUE,scale. = TRUE)
# 
# ggbiplot(test.pca, 
#          groups=str_extract(rownames(test3_wide), "[^.]+"),
#          ellipse = TRUE, var.axes=FALSE, choice=c(1:2))



if (is_this_a_dscour_probiotic_strain == "yes") {
  
  DSc <- df2 %>% 
    dplyr::filter(cohort=="PosControl_DScour") %>%
    arrange(desc(avg_depth)) %>% 
    dplyr::select(ref_genome) %>% 
    unique()
  
  CG <- df2 %>% dplyr::filter(cohort=="PosControl_ColiGuard") 
  
  mylist <- anti_join(DSc,CG, by = "ref_genome") %>% dplyr::select(ref_genome)
  
  p1 <- ggplot(subset(df2, ref_genome %in% mylist$ref_genome), 
         aes(x=ref_genome,y=avg_depth, color=cohort))+
    geom_point(alpha=0.5, size=1) +
    theme(axis.text.x=element_blank(),
          legend.position="none") +
    labs(x="reference genomes",
         y="average depth",
         color="samples") +
    facet_grid(rows = vars(cohort))
  p2 <- ggplot(subset(df2, ref_genome %in% mylist$ref_genome), 
         aes(x=ref_genome,y=avg_depth, color=cohort))+
    geom_point(alpha=0.5, size=1) +
    theme(axis.text.x=element_blank(),
          legend.position="none") +
    labs(x="reference genomes",
         y="average depth",
         color="samples") +
    ylim(0,max(subset(df2, ref_genome %in% mylist$ref_genome)$avg_depth)/4) +
    facet_grid(rows = vars(cohort))
  
  p3 <- ggarrange(p1,p2,ncol=2)
  
} else {
  
  CG <- df2 %>% 
    dplyr::filter(cohort=="PosControl_ColiGuard") %>%
    arrange(desc(avg_depth)) %>% 
    dplyr::select(ref_genome) %>% 
    unique()
  
  Dsc <- df2 %>% dplyr::filter(cohort=="PosControl_DScour") 
  
  mylist <- anti_join(CG,DSc, by = "ref_genome") %>% dplyr::select(ref_genome)
  
  p1 <- ggplot(subset(df2, ref_genome %in% mylist$ref_genome), 
               aes(x=ref_genome,y=avg_depth, color=cohort))+
    geom_point(alpha=0.5, size=1) +
    theme(axis.text.x=element_blank(),
          legend.position="none") +
    labs(x="reference genomes",
         y="average depth",
         color="samples") +
    facet_grid(rows = vars(cohort))
  p2 <- ggplot(subset(df2, ref_genome %in% mylist$ref_genome), 
               aes(x=ref_genome,y=avg_depth, color=cohort))+
    geom_point(alpha=0.5, size=1) +
    theme(axis.text.x=element_blank(),
          legend.position="none") +
    labs(x="reference genomes",
         y="average depth",
         color="samples") +
    ylim(0,max(subset(df2, ref_genome %in% mylist$ref_genome)$avg_depth)/4) +
    facet_grid(rows = vars(cohort))
  
  p3 <- ggarrange(p1,p2,ncol=2)

}

pdf(file = paste0(out_dir,TheRef,"_filtered.pdf"))
p3
dev.off()


DSc <- df2 %>% 
  dplyr::filter(cohort=="PosControl_DScour") %>%
  arrange(desc(avg_depth)) %>% 
  slice(1:100) %>%
  dplyr::select(ref_genome) %>% 
  unique()

mylist <- anti_join(DSc,CG, by = "ref_genome") %>% dplyr::select(ref_genome)

pdf(file = paste0(out_dir,TheRef,"_filtered2.pdf"))
ggplot(subset(df2, ref_genome %in% mylist$ref_genome), 
       aes(x=ref_genome,y=avg_depth, color=cohort))+
  geom_point(alpha=0.5, size=1) +
  theme(axis.text.x=element_blank(),
        legend.position="none") +
  labs(x="reference genomes",
       y="average depth",
       color="samples") +
  ylim(0,5000) +
  facet_grid(cols = vars(cohort))
ggplot(subset(df2, ref_genome %in% mylist$ref_genome), 
       aes(x=ref_genome,y=avg_depth, color=cohort))+
  geom_point(alpha=0.5, size=1) +
  theme(axis.text.x=element_blank(),
        legend.position="none") +
  labs(x="reference genomes",
       y="average depth",
       color="samples") +
  ylim(0,5000) +
  facet_grid(rows = vars(cohort))
dev.off()


mylist


x <- subset(df2, ref_genome %in% mylist$ref_genome)
View(x)

x %>% dplyr::filter(cohort=="D-Scour") %>%
  ggplot(., 
       aes(x=ref_genome,y=avg_depth, color=cohort))+
  geom_point(alpha=0.5, size=1) +
  theme(axis.text.x=element_blank(),
        legend.position="none") +
  labs(x="reference genomes",
       y="average depth",
       color="samples") +
  ylim(0,5000) +
  facet_grid(cols = vars(plate_well))


