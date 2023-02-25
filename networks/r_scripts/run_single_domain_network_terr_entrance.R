library(SpiecEasi)

abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/networks/input_data/fung_entrance_terr_top1000_allempos_in_site_entrance.rds")

abun <- t(abun)

pargs <- list(seed=10010, thresh = 0.02, rep.num=50)
single_dom_net <- spiec.easi(abun, method='glasso', pulsar.params=pargs)

saveRDS(single_dom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/outputs/fungal_entrance_terrestrial_network_all_empos_newstars_newrep.rds")
