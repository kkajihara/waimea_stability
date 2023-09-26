library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/prev20/r_scripts/")

reg = makeRegistry(file.dir = 'batch_registry9', seed = 1)

f_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/downsampled_fung_otu_table.rds")
b_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/downsampled_bact_otu_table.rds")

library(dplyr)
library(tibble)


f_abun <- t(f_abun)
b_abun <- t(b_abun)

#pargs <- list(seed=10010, thresh = 0.02, rep.num=1)
#crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='glasso', lambda.min.ratio=1e-1, pulsar.select=FALSE, scr=TRUE)

bargs <- list(conffile=".batchtools.conf.R", thresh=0.05)
crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='mb', lambda.min.ratio=1e-2, scr=TRUE,
                             pulsar.select='batch', pulsar.params=bargs)

saveRDS(crossdom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/outputs/downsampled_crossdom_prev20_mb_thresh05_with_dummy.rds")
