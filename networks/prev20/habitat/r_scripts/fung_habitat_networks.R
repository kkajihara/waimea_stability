library(SpiecEasi)

fung_data <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/habitat/fung_downsampled_otu_tables_by_hab.rds")


run_se <- function(otu_table) {
  tab <- t(otu_table)
  
  bargs <- list(thresh=0.01)
  net <- spiec.easi(tab, method='mb', lambda.min.ratio=1e-5, pulsar.params=bargs, scr=TRUE)
}


fung_gradient_networks <- lapply(fung_data, run_se)
saveRDS(fung_gradient_networks, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/habitat/outputs/fung_habitat_networks.rds")


# bact_gradient_networks <- lapply(bact_data, run_se)
# saveRDS(bact_gradient_networks, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/outputs/six_empos_bact_gradient_networks.rds")
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





