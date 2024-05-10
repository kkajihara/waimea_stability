library(SpiecEasi)
library(batchtools)

setwd("~/hynson_koastore/kaciekaj/waimea_current/networks/prev20/host_env/")

reg = makeRegistry(file.dir = 'batch_registry94', seed = 1)

# f_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/fully_filtered_fungal_otu_table_matched_up.rds")
# b_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/fully_filtered_bact_otu_table_matched_up.rds")

library(dplyr)
library(tibble)

f_list <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/fung_hostnon_abun_for_networks.rds")
b_list <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/bact_hostnon_abun_for_networks.rds")

# fung_otu_match <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/fung_prev20_env_abun.rds")
# bact_otu_match <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/bact_prev20_env_abun.rds")

f_abun <- f_list[["Free-living"]]
b_abun <- b_list[["Free-living"]]

identical(names(f_abun), names(b_abun))

f_abun <- t(f_abun)
b_abun <- t(b_abun)

#pargs <- list(seed=10010, thresh = 0.02, rep.num=1)
#crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='glasso', lambda.min.ratio=1e-1, pulsar.select=FALSE, scr=TRUE)

bargs <- list(conffile=".batchtools.conf.R", thresh=0.01)
crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='mb', lambda.min.ratio=1e-2, scr=TRUE,
                             pulsar.select='batch', pulsar.params=bargs)

saveRDS(crossdom_net, "~/hynson_koastore/kaciekaj/waimea_current/networks/prev20/hostnon/outputs/crossdom_nonhost_network_p20_mb_thresh01.rds")
