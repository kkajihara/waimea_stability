library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/r_scripts/riverine/bact")

#fung_data <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/gradient/six_empos_fung_grad_data_ordered.rds")
bact_data <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/gradient/riverine/riverine_bact_grad_data_ordered.rds")

#reg = makeRegistry(file.dir = 'batch_registry12', seed = 1)

data <- t(bact_data[[1]])

#bargs <- list(conffile="~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/r_scripts/riverine/bact/.batchtools.conf.R")
pargs <- list(thresh=0.01, rep.num = 50)

bact_network <- spiec.easi(data,
                           method='mb', 
                           pulsar.params = pargs,
                           #nlambda=100, 
                           lambda.min.ratio=1e-5, 
                           scr=TRUE)

saveRDS(bact_network, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/outputs/riverine/bact_entrance_network_minlamtest.rds")
# 
# 
# 
# ######## cross domain
# cross_gradient_networks <- list()
# for (i in 1:length(fung_data)) {
#   f_abun <- t(fung_data[[i]])
#   b_abun <- t(bact_data[[i]])
#   
#   bargs <- list(thresh=0.01)
#   net <- multi.spiec.easi(list(f_abun, b_abun), method='mb', lambda.min.ratio=1e-2, scr=TRUE)
# 
#   cross_gradient_networks[[i]] <- net
# }
# 
# 
# saveRDS(cross_gradient_networks, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/outputs/six_empos_cross_gradient_networks.rds")





