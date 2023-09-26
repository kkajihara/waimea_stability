library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/prev20/r_scripts/")

reg = makeRegistry(file.dir = 'batch_registry13', seed = 1)

# f_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/fully_filtered_fungal_otu_table_matched_up.rds")
# b_abun <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/fully_filtered_bact_otu_table_matched_up.rds")

library(dplyr)
library(tibble)

fung_otu_match <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/fully_filtered_p20_fungal_otu_table_matched_up.rds")
fung_meta_match <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/fully_filtered_p20_fungal_otu_metadata_matched_up.rds")
bact_otu_match <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/fully_filtered_p20_bact_otu_table_matched_up.rds")
bact_meta_match <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/global/fully_filtered_p20_bact_otu_metadata_matched_up.rds")

bact_df <- data.frame(seq_id <- bact_meta_match$sequencing_id,
                      x_seq_id <- bact_meta_match$x_seq_id,
                      sample <- bact_meta_match$sample_id)
names(bact_df) <- c("seq_id", "x_seq_id", "sample")

fung_df <- data.frame(seq_id <- fung_meta_match$sequencing_id,
                      x_seq_id <- fung_meta_match$x_seq_id,
                      sample <- fung_meta_match$sample_id)
names(fung_df) <- c("seq_id", "x_seq_id", "sample")


f_abun_test <- fung_otu_match
names(f_abun_test) <- as.character(fung_df$sample[match(names(f_abun_test), fung_df$x_seq_id)])
f_abun_test <- f_abun_test[, order(names(f_abun_test))]

b_abun_test <- bact_otu_match
names(b_abun_test) <- as.character(bact_df$sample[match(names(b_abun_test), bact_df$x_seq_id)])
b_abun_test <- b_abun_test[, order(names(b_abun_test))]

f_abun <- f_abun_test
b_abun <- b_abun_test

f_abun <- t(f_abun)
b_abun <- t(b_abun)

#pargs <- list(seed=10010, thresh = 0.02, rep.num=1)
#crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='glasso', lambda.min.ratio=1e-1, pulsar.select=FALSE, scr=TRUE)

bargs <- list(conffile=".batchtools.conf.R", thresh=0.01)
crossdom_net <- multi.spiec.easi(list(f_abun, b_abun), method='mb', lambda.min.ratio=1e-2, scr=TRUE,
                             pulsar.select='batch', pulsar.params=bargs)

saveRDS(crossdom_net, "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/outputs/crossdom_prev20_mb_thresh01_with_dummy.rds")
