library(SpiecEasi)

abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/networks/outputs/fungal_entrance_terrestrial_network_allempos_zeroinflatedfilt.rds")

abun <- abun[[100]]
#abun <- t(abun)

source("~/cmaiki_lts/kaciekaj/waimea/networks/r_scripts/zero_inflated_filter_functions.R")

# parameters for network
# lambda.min.ratio = 0.01 # ratio between min and max lambda
# l_m_r <- lambda.min.ratio
# n_lambda = 100

pargs <- list(seed=10010)

single_dom_net <- spiec.easi(abun, method='glasso', lambda.min.ratio=0.01, nlambda=100, pulsar.params=pargs)


#pargs <- list(seed=10010)
#single_dom_net <- spiec.easi(abun, method='glasso', pulsar.params=pargs)

saveRDS(single_dom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/outputs/zeroinfl_to_spieceasi_test_fung_entr_terr.rds")
