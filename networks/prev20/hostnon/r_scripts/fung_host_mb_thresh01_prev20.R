library(SpiecEasi)
library(batchtools)

setwd("~/hynson_koastore/kaciekaj/waimea_current/networks/prev20/hostnon/")

reg = makeRegistry(file.dir = 'batch_registry11', seed = 1)

f_abun <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/fung_hostnon_abun_for_networks.rds")[["Host-associated"]]


f_abun <- t(f_abun)


#pargs <- list(seed=10010, thresh = 0.02, rep.num=1)
#crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='glasso', lambda.min.ratio=1e-1, pulsar.select=FALSE, scr=TRUE)

bargs <- list(conffile=".batchtools.conf.R", thresh=0.01)
singledom_net <- spiec.easi(f_abun, method='mb', lambda.min.ratio=1e-2, scr=TRUE,
                             pulsar.select='batch', pulsar.params=bargs)

saveRDS(singledom_net, "~/hynson_koastore/kaciekaj/waimea_current/networks/prev20/hostnon/outputs/fung_host_network_p20_mb_thresh01.rds")
        
