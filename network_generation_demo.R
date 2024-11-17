# demonstration of network generation software SpiecEasi

library(SpiecEasi)

setwd("demo/")

df <- readRDS("../intermediates/global/fully_filtered_p20_fungal_otu_table_matched_up.rds")

# subsample to achieve suitable runtime
df <- df[sample(nrow(df), 100), sample(ncol(df), 20)]

df <- t(df)


bargs <- list(thresh=0.01)
net <- spiec.easi(df, method='mb', lambda.min.ratio=1e-2, scr=TRUE, pulsar.params=bargs) 

