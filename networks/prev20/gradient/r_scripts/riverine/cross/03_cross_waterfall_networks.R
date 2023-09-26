library(SpiecEasi)

fung_data <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/gradient/six_empos_fung_grad_data_ordered.rds")
bact_data <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/gradient/six_empos_bact_grad_data_ordered.rds")

f_abun <- t(fung_data[[3]])
b_abun <- t(bact_data[[3]])

bargs <- list(thresh=0.01)
net <- multi.spiec.easi(list(f_abun, b_abun), method='mb', lambda.min.ratio=1e-5, pulsar.params=bargs, scr=TRUE)

saveRDS(net, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/outputs/cross_waterfall_network.rds")