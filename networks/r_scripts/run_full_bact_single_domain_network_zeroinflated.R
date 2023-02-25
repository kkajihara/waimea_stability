library(SpiecEasi)

abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/no_singlesampASVs_bact_asv_table.rds")
abun <- t(abun)

source("~/cmaiki_lts/kaciekaj/waimea/networks/r_scripts/zero_inflated_filter_functions.R")

# parameters for network
lambda.min.ratio = 5e-2 # ratio between min and max lambda
l_m_r <- lambda.min.ratio
n_lambda = 20

single_dom_net <- glasso.clr_filter(abun)


#pargs <- list(seed=10010)
#single_dom_net <- spiec.easi(abun, method='glasso', pulsar.params=pargs)

saveRDS(single_dom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/outputs/full_bact_network_zeroinf_filtered.rds?")
