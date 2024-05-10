library(rnetcarto)
library(igraph)

fung_net <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/downsampled_fung_hostnon_network.rds")

fung_netcarto <- lapply(fung_net, function(x) netcarto(get.adjacency(x, sparse = FALSE)))

saveRDS(fung_netcarto, "~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/fung_hostnon_netcarto_results.rds")


bact_net <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/downsampled_bact_hostnon_network.rds")

bact_netcarto <- lapply(bact_net, function(x) netcarto(get.adjacency(x, sparse = FALSE)))

saveRDS(bact_netcarto, "~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/bact_hostnon_netcarto_results.rds")
