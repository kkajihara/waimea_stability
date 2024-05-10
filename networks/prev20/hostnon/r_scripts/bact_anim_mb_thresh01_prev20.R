library(SpiecEasi)
library(batchtools)

setwd("~/hynson_koastore/kaciekaj/waimea_current/networks/prev20/host_env/")

reg = makeRegistry(file.dir = 'batch_registry27', seed = 2)

b_list <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/bact_trophic_abun_for_networks.rds")

b_abun <- b_list[["Animal"]]


b_abun <- t(b_abun)


#pargs <- list(seed=10010, thresh = 0.02, rep.num=1)
#crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='glasso', lambda.min.ratio=1e-1, pulsar.select=FALSE, scr=TRUE)

bargs <- list(conffile=".batchtools.conf.R", thresh=0.01)
singledom_net <- spiec.easi(b_abun, method='mb', lambda.min.ratio=1e-2, scr=TRUE,
                            pulsar.select='batch', pulsar.params=bargs)

saveRDS(singledom_net, "~/hynson_koastore/kaciekaj/waimea_current/networks/prev20/host_env/outputs/bact_anim_network_p20_mb_thresh01.rds")

