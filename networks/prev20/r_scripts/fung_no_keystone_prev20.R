library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/prev20/r_scripts/")

reg = makeRegistry(file.dir = 'batch_registry5', seed = 1)

f_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/fully_filtered_p20_fungal_otu_table_matched_up.rds")

f_abun <- f_abun[rownames(f_abun)!="fung_otu17170",]

f_abun <- t(f_abun)


#pargs <- list(seed=10010, thresh = 0.02, rep.num=1)
#crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='glasso', lambda.min.ratio=1e-1, pulsar.select=FALSE, scr=TRUE)

bargs <- list(conffile=".batchtools.conf.R", thresh=0.01)
singledom_net <- spiec.easi(f_abun, method='mb', lambda.min.ratio=1e-2, scr=TRUE,
                             pulsar.select='batch', pulsar.params=bargs)

saveRDS(singledom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/outputs/fung_no_keystone_with_dummy.rds")
