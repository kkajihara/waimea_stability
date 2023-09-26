library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/r_scripts/")

unlink("batch_registry/", recursive=TRUE)
reg = makeRegistry(file.dir = 'batch_registry', seed = 1)

abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/networks/input_data/fully_filtered_fung_otu_table.rds")

abun <- t(abun)

bargs <- list(seed=10010, conffile=".batchtools.conf.R", rep.num=20, thresh = 0.05)
single_dom_net <- spiec.easi(abun, method='glasso', pulsar.select='batch', pulsar.params=bargs)

saveRDS(single_dom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/outputs/batch_fungi_prev50.rds")
