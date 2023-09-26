library(SpiecEasi)

#fung_data <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/gradient/six_empos_fung_grad_data_ordered.rds")
bact_data <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/gradient/six_empos_bact_grad_data_ordered.rds")

data <- t(bact_data[[3]])

bargs <- list(thresh=0.01)

bact_network <- spiec.easi(data, method='mb', lambda.min.ratio=1e-5,  pulsar.params=bargs, scr=TRUE)

saveRDS(bact_network, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/outputs/bact_waterfall_network_defaultnl.rds")
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





