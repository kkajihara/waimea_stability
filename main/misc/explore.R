library(tidyr)
library(dplyr)
library(readr)
library(data.table)


# read in files

### Abundance

# with help from Sean's scripts
abun <- fread(file = "pipeline_outputs/abundance_table-lulu-100.shared",
             drop = c("numOtus", "label", "Group"),
             header = T)

abun_names <- fread(file = "pipeline_outputs/abundance_table-lulu-100.shared",
                   select = "Group",
                   colClasses = "character",
                   header = T)

# no idea what this does - data.table syntax?
abun[, Group := abun_names]

# move group col to front
abun <- abun %>% select(Group, everything())

# remove group col
abun <- abun[,-1]

# convert character cols to numeric
abun <- as.data.frame(sapply(abun,as.numeric))

# transpose so ASVs are rows, samples are cols
abun <- as.data.frame(t(abun))

# make sample names into col names
names(abun) <- abun[1,]

# remove OTU row with sample names (sequencing_id)
abun <- abun[-1,]


# confirm no empty samples or ASVs
min(rowSums(abun))
min(colSums(abun))


saveRDS(abun, "intermediates/asv_table.rds")


### Taxonomy

# read in taxonomy file
tax <- fread(file = "pipeline_outputs/taxonomy_100.taxonomy",
            header = T,
            sep = "\t")

# break up taxonomy info into separate columns
tax <- tax %>%
  separate(Taxonomy, 
           c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species"),
           sep = ";")

saveRDS(tax, "intermediates/taxonomy_table.rds")


### Metadata

# there are 3 separate metadata files (1 for each Hiseq run)
# Hiseq 1 has many metadata columns, 2 and 3 do not

# # import files
# hiseq1_met <- fread(file = "metadata/ITS only/hiseq01_bioblitz_mapping.csv")
# # this one has empty lines
# hiseq1_met <- hiseq1_met[hiseq1_met$run=="Hiseq01_ITS",]
# # rename id to sequencing_id to match other dfs
# names(hiseq1_met)[1] <- "sequencing_id"
# 
# hiseq2_met <- fread(file = "metadata/ITS only/hiseq2_bioblitz_mapping.csv")
# hiseq3_met <- fread(file = "metadata/ITS only/hiseq3_bioblitz_mapping.csv")
# 
# # reduce hiseq1 file to only include col names in the others
# sub_hiseq1_met <- subset(hiseq1_met, select = names(hiseq2_met))
#   
# # combine
# full_meta <- do.call(rbind, list(sub_hiseq1_met, hiseq2_met, hiseq3_met))
# 
# saveRDS(full_meta, "intermediates/full_metadata.rds")


# read in Sean's metadata file from waimea_microbial_mapping.tar.gz
all_meta <- fread("../data/raw/all_waimea_hiseq_sample_metadata.csv")
# subset ITS only
its_meta <- all_meta[all_meta$locus=="fungalITS",]
# remove samples not in abundance table
its_meta <- its_meta[its_meta$sequencing_id %in% names(abun),]

saveRDS(its_meta, "intermediates/its_metadata.rds")


s# # use metadata from hiseq1 to get some more info for 2 and 3
# sampletypes <- unique(hiseq1_met$sample_type)
# habitats <- unique(hiseq1_met$habitat)
# hosts <- unique(hiseq1_met$host)
# trophic <- unique(hiseq1_met$trophic)
# 
# a <- hiseq1_met %>% select(sample_type, habitat, host, trophic)
# 
# # can you assign habitat based on sample type?
# a$type_and_habitat <- paste(a$sample_type, a$habitat, sep=" ")
# # YES
# length(unique(a$type_and_habitat)) == length(unique(a$sample_type))
# 
# # others seemed fine too


# add data

# remove columns having to do with primers
meta <- full_meta[,1:5]

# add habitat
meta$habitat <- hiseq1_met$habitat[match(meta$sample_type, hiseq1_met$sample_type)]

# add host
meta$host <- hiseq1_met$host[match(meta$sample_type, hiseq1_met$sample_type)]

# add trophic level
meta$trophic <- hiseq1_met$trophic[match(meta$sample_type, hiseq1_met$sample_type)]

saveRDS(meta, "intermediates/new_metadata.rds")


# check that hiseq1 data is same - yes it seems to be
# hi1_check <- meta[meta$run=="Hiseq01_ITS",]
# 
# unique(hi1_check$trophic == hiseq1_met$trophic)
# 
# unique(hi1_check$host == hiseq1_met$host)
# 
# unique(hi1_check$habitat == hiseq1_met$habitat)



### checking on things

# # check that abundance and taxonomy have the same ASVs
# all(colnames(abun)[2:ncol(abun)] %in% tax$OTU)
# 
# all(tax$OTU %in% colnames(abun))
# 
# 
# b = colnames(abun)[3:ncol(abun)] # exclude Group and OTU cols
# length(b) # 52112
# length(tax$OTU) # this one is 52113 but I think it's ok because it's not as though we have an ASV with no tax info
# 
# ## continue checking using Sean's code later



# library(phyloseq)

# phy_tax <- tax


# there are two entries for asv_1
# but actually the "size" col doesn't matter for phyloseq purposes
# n_occur <- data.frame(table(tax$OTU))
# 
# phy_tax <- phy_tax %>% select(-Size)
# # remove first row (asv_1, duplicate)
# phy_tax <- phy_tax[-1,]
# rownames(phy_tax) <- phy_tax$OTU
# 
# phy_tax <- phy_tax %>% select(-OTU)
# phy_tax <- phy_tax[order(rownames(phy_tax)),]
# 
# # filter metadata to only include samples in abundance table
# phy_met <- meta[meta$sequencing_id %in% names(abun),]
# 
# 
# # physeq object
# asv = otu_table(abun, taxa_are_rows = TRUE)
# taxo = tax_table(phy_tax)
# 
# its_physeq <- phyloseq(asv, taxo)



### goal: bar plot showing how many sequences map to fungi across our 3 habitats

library(ggplot2)


# new abundance table - remove ASVs where Kingdom == "NA" (all other levels are NA as well)
t = tax[tax$Kingdom=="NA",] 
non_fungal = t$OTU
abun_fungi <- abun[!rownames(abun) %in% non_fungal,]

# gonna do this a not so good way first

# figure out which samples belong to which habitat
marine <- meta[meta$habitat=="Marine",]
marine_samps <- marine$sequencing_id
marine_samps <- as.character(marine_samps)

terr <- meta[meta$habitat=="Terrestrial",]
terr_samps <- terr$sequencing_id
terr_samps <- as.character(terr_samps)

stream <- meta[meta$habitat=="Riverine",]
stream_samps <- stream$sequencing_id
stream_samps <- as.character(stream_samps)


# subset abundance table by habitat using vectors of sample ids
# looks like not all sample ids are in the dataset

# 440 samples in metadata, 412 in abundance
marine_abun <- abun_fungi[,colnames(abun_fungi) %in% marine_samps]

# 782 samples in meta, 774 in abun
terr_abun <- abun_fungi[,colnames(abun_fungi) %in% terr_samps]

# 204 samples in meta, 202 in abun
stream_abun <- abun_fungi[,colnames(abun_fungi) %in% stream_samps]


# remove empty samples and ASVs, also remove non-fungal ASVs
rm_empty <- function(hab_df, non_fungal) {
  hab_df <- hab_df[rowSums(hab_df) > 0, colSums(hab_df) > 0]
  hab_df <- hab_df[!rownames(hab_df) %in% non_fungal,]
  return(hab_df)
}

# apply function
marine_abun <- rm_empty(marine_abun, non_fungal)
terr_abun <- rm_empty(terr_abun, non_fungal)
stream_abun <- rm_empty(stream_abun, non_fungal)


# how many ASVs in each habitat?
mar_asv <- length(rownames(marine_abun))
ter_asv <- length(rownames(terr_abun))
str_asv <- length(rownames(stream_abun))

# how many sequences in each habitat?
mar_seq <- sum(colSums(marine_abun))
ter_seq <- sum(colSums(terr_abun))
str_seq <- sum(colSums(stream_abun))


plot_df <- data.frame(Habitat = c("Marine", "Terrestrial", "Stream"),
                      ASV_count = c(mar_asv, ter_asv, str_asv),
                      Sequences = c(mar_seq, ter_seq, str_seq))


asv_plot <- ggplot(data = plot_df, aes(x=Habitat, y = ASV_count)) +
  geom_bar(stat="identity", fill = "#56B4E9") +
  theme(
    panel.grid.major=element_blank(), 
    panel.grid.minor=element_blank(), 
    panel.background=element_blank(), 
    axis.line = element_line(colour="black"),
    axis.title.x = element_text(size=12),
    axis.title.y = element_text(size=12)) +
  geom_text(aes(label = ASV_count), nudge_y = 1000) +
  ggtitle("Fungal ASVs per Habitat")

seq_plot <- ggplot(data = plot_df, aes(x=Habitat, y = Sequences)) +
  geom_bar(stat="identity", fill = "#56B4E9") +
  theme(
    panel.grid.major=element_blank(), 
    panel.grid.minor=element_blank(), 
    panel.background=element_blank(), 
    axis.line = element_line(colour="black"),
    axis.title.x = element_text(size=12),
    axis.title.y = element_text(size=12)) +
  geom_text(aes(label = Sequences), nudge_y = 3000000) +
  ggtitle("Fungal Sequences per Habitat")


library(ggpubr)

ggarrange(asv_plot, seq_plot, ncol = 2)

ggsave("figures/ASVs_and_reads_by_habitat.png", width = 13, height = 7)



