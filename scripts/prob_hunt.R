library(data.table)
library(dplyr)
library(ggplot2)
getwd()


df <- fread("~/Downloads/tenth_14159.tsv")

df1 <- df
df2 <- df1[ , diff := V2 - shift(V2), by = V1]  
df3 <- df2[1:2000000]

tail(df3)
View(df3)
df4 <- transform(df3, Counter = ave(diff, rleid(V1, diff), FUN = seq_along))

# split df by V1
df5 <- split( df4 , f = df4$V1 )

DS_LR <- do.call(rbind,by(df5$LR_header,cumsum(c(0,diff(df5$LR_header$Counter)!=1)),
                      function(g) data.frame(imin=min(g$Counter),
                                             imax=max(g$Counter),
                                             irange=diff(range(g$Counter)),
                                             xmin=min(g$V3),
                                             xmax=max(g$V3),
                                             xmean=mean(g$V3))))

DS_LS <- do.call(rbind,by(df5$LS_header,cumsum(c(0,diff(df5$LS_header$Counter)!=1)),
                      function(g) data.frame(imin=min(g$Counter),
                                             imax=max(g$Counter),
                                             irange=diff(range(g$Counter)),
                                             xmin=min(g$V3),
                                             xmax=max(g$V3),
                                             xmean=mean(g$V3))))





df <- fread("~/Downloads/tenth_14162.tsv")

df1 <- df
df2 <- df1[ , diff := V2 - shift(V2), by = V1]  
df3 <- df2[1:2000000]

tail(df3)

df4 <- transform(df3, Counter = ave(diff, rleid(V1, diff), FUN = seq_along))

# split df by V1
df5 <- split( df4 , f = df4$V1 )

CG_LR <- do.call(rbind,by(df5$LR_header,cumsum(c(0,diff(df5$LR_header$Counter)!=1)),
                          function(g) data.frame(imin=min(g$Counter),
                                                 imax=max(g$Counter),
                                                 irange=diff(range(g$Counter)),
                                                 xmin=min(g$V3),
                                                 xmax=max(g$V3),
                                                 xmean=mean(g$V3))))

CG_LS <- do.call(rbind,by(df5$LS_header,cumsum(c(0,diff(df5$LS_header$Counter)!=1)),
                          function(g) data.frame(imin=min(g$Counter),
                                                 imax=max(g$Counter),
                                                 irange=diff(range(g$Counter)),
                                                 xmin=min(g$V3),
                                                 xmax=max(g$V3),
                                                 xmean=mean(g$V3))))

DS_LR <- DS_LR %>% dplyr::select(irange,xmean) %>% dplyr::mutate(ID="DS_LR")
DS_LS <- DS_LS %>% dplyr::select(irange,xmean) %>% dplyr::mutate(ID="DS_LS")
CG_LR <- CG_LR %>% dplyr::select(irange,xmean) %>% dplyr::mutate(ID="CG_LR")
CG_LS <- CG_LS %>% dplyr::select(irange,xmean) %>% dplyr::mutate(ID="CG_LS")

z_LR <- rbind(DS_LR,
      CG_LR)

LR <- ggplot(z_LR, aes(x=xmean,y=irange,color=ID))+
  geom_point()


z_LS <- rbind(DS_LS,
              CG_LS)

LS <- ggplot(z_LS, aes(x=xmean,y=irange,color=ID))+
  geom_point()


LR
LS


df_DS <- rbind(DS_LR,DS_LS)
ggplot(df_DS, aes(x=xmean,y=irange,color=ID))+
  geom_point()

df_CG <- rbind(CG_LR,CG_LS)
ggplot(df_CG, aes(x=xmean,y=irange,color=ID))+
  geom_point()
