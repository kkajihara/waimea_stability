library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/prev50_finals/r_scripts/")

reg = makeRegistry(file.dir = 'batch_registry4', seed = 1)

f_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/fully_filtered_fungal_otu_table_matched_up.rds")
b_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/fully_filtered_bact_otu_table_matched_up.rds")

#not real data, changing so can be same "sample names"
names(f_abun) = 1:ncol(f_abun)
names(b_abun) = 1:ncol(b_abun)


f_abun <- t(f_abun)
b_abun <- t(b_abun)

#pargs <- list(seed=10010, thresh = 0.02, rep.num=1)
#crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='glasso', lambda.min.ratio=1e-1, pulsar.select=FALSE, scr=TRUE)

bargs <- list(conffile=".batchtools.conf.R", thresh=0.03)
crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='mb', lambda.min.ratio=1e-2, nlambda=50, scr=TRUE,
                             pulsar.select='batch', pulsar.params=bargs)

saveRDS(crossdom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/prev50_finals/crossdom_mb_nlambda50_thresh03.rds")
