library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/prev20/r_scripts/")

reg = makeRegistry(file.dir = 'batch_registry14', seed = 1)

b_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/fully_filtered_p20_bact_otu_table_matched_up.rds")


b_abun <- t(b_abun)


#pargs <- list(seed=10010, thresh = 0.02, rep.num=1)
#crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='glasso', lambda.min.ratio=1e-1, pulsar.select=FALSE, scr=TRUE)

bargs <- list(conffile=".batchtools.conf.R", thresh=0.01)
singledom_net <- spiec.easi(b_abun, method='mb', lambda.min.ratio=1e-2, scr=TRUE,
                            pulsar.select='batch', pulsar.params=bargs)

saveRDS(singledom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/outputs/bact_prev20_mb_thresh01_with_dummy.rds")

