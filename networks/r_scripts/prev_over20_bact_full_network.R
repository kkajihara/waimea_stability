library(SpiecEasi)

abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/networks/input_data/prev20_and_mean_rarefied_bact_data.rds")

abun <- t(abun)

pargs <- list(seed=10010, thresh = 0.02)
single_dom_net <- spiec.easi(abun, method='glasso', pulsar.params=pargs)

saveRDS(single_dom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/outputs/bact_prev_over20_and_rarefied_full_network.rds")
