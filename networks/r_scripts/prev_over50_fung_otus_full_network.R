library(SpiecEasi)

abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/networks/input_data/fully_filtered_fung_otu_table.rds")

abun <- t(abun)

pargs <- list(seed=10010, thresh = 0.05, rep.num=1)
single_dom_net <- spiec.easi(abun, method='glasso', pulsar.params=pargs)

saveRDS(single_dom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/outputs/fung_prev50_otus_single_rep_network.rds")
