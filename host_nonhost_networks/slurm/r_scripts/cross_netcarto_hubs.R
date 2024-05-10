library(rnetcarto)
library(igraph)


cross_net <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/downsampled_cross_hostnon_network.rds")

cross_netcarto <- lapply(cross_net, function(x) netcarto(get.adjacency(x, sparse = FALSE)))

saveRDS(cross_netcarto, "~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/cross_hostnon_netcarto_results.rds")

