library(eulerr)

# all_dat_bool <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/empo_bool_data_for_euler_fung.rds.rds")
# 
# samp_euler <- euler(all_dat_bool)
# 
# saveRDS(samp_euler, "~/cmaiki_lts/kaciekaj/waimea/intermediates/global/euler_data_by_empo_fung.rds.rds")



all_dat_bool <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/empo_bool_data_for_euler_bact.rds")

samp_euler <- euler(all_dat_bool)

saveRDS(samp_euler, "~/cmaiki_lts/kaciekaj/waimea/intermediates/global/euler_data_by_empo_bact.rds")