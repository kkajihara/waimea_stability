library(picante)

input <- readRDS("~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/hostnon_inputs_for_picante_by_sample.rds")

ses.mpd.result <- ses.mpd(input[[1]], input[[2]], null.model = "taxa.labels")

saveRDS(ses.mpd.result, "~/hynson_koastore/kaciekaj/waimea_current/intermediates/hostnon/picante_by_sample_hostnon_results.rds")

