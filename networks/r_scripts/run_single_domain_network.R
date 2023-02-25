library(SpiecEasi)

abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/networks/input_data/fung_entrance_terr_top1000_plantcorpus.rds")

abun <- t(abun)

pargs <- list(seed=10010)
single_dom_net <- spiec.easi(abun, method='glasso', lambda.min.ratio=1e-1, nlambda=50, pulsar.params=pargs)


saveRDS(single_dom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/outputs/fungal_entrance_terrestrial_plantcorpus.rds")
