library(SpiecEasi)

fung_asv <- readRDS("~/cmaiki_lts/kaciekaj/waimea/networks/input_data/fung_entrance_terrestrial_plantsurface.rds")

bact_asv <- readRDS("~/cmaiki_lts/kaciekaj/waimea/networks/input_data/bact_entrance_terrestrial_plantsurface.rds")

fung_asv <- t(fung_asv)
bact_asv <- t(bact_asv)

cross_dom_net <- spiec.easi(list(fung_asv, bact_asv), method='glasso')


saveRDS(cross_dom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/outputs/cross_dom_entrance_terrestrial_plantsurface.rds")
