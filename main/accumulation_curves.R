### accumulation curves



# newer version does not work with abrown435's example
# library(devtools)
# install_version("iNEXT", version = "2.0.19")
library(iNEXT)
library(job)
library(ggplot2)


setwd("~/cmaiki_lts/kaciekaj/waimea")

# read in rds files of ASV sums

# habitat: terrestrial

# read in data
culled_abun <- readRDS("../intermediates/culled_asv_table.rds")
#culled_tax <- readRDS("stuff_to_scp/culled_tax_table.rds")
culled_meta <- readRDS("../intermediates/culled_metadata.rds")

culled_meta <- data.frame(culled_meta)

# to run in parallel following abrown435's example
# data must be converted so each sample is a matrix and then each sample is a member of a list
# then run the function in pbmclapply and do whatever downstream processes in iNEXT you need to do

# I think my data is already in this format

# library(parallel)
# library(pbmcapply)
# 
# Max_CPU_Cores = detectCores()
# Upper_Limit_CPU_Cores = 2*round((Max_CPU_Cores*0.9)/2)
# # Parallel Rarefaction Function
# # This is a working parallelized function of iNEXT. 5x faster than previously
# parallel_rarefaction <- function(data){
#   out_df <- iNEXT(data, q=0, datatype="abundance")
#   #df <- fortify.iNEXT(out_df, type=1)
#   return(out_df)
# }



## SMALLER TEST
# tiny_plant <- sample(plant_terr_sums, 100)
# tiny_animal <- sample(animal_terr_sums, 100)
# tiny_list <- list(tiny_plant, tiny_animal)
# names(tiny_list) <- c("Primary Producer", "Animal")
# 
# 
# result <- pbmclapply(tiny_list, parallel_rarefaction, mc.cores = Upper_Limit_CPU_Cores)
# ggiNEXT(result$`Primary Producer`)
# 
# 
# 
# b <- iNEXT(tiny_list)

## MEDIUM TEST
# med_plant <- sample(plant_terr_sums, 2000)
# med_animal <- sample(animal_terr_sums, 2000)
# med_list <- list(med_plant, med_animal)
# names(med_list) <- c("Primary Producer", "Animal")
# 
# 
# time_nonpar <- proc.time()
# 
# nonpar <- iNEXT(med_list)
# 
# time_nonpar - proc.time() # 131 seconds? 
# 
# 
# time_par <- proc.time()
# 
# par <- pbmclapply(med_list, parallel_rarefaction, mc.cores = Upper_Limit_CPU_Cores) # 74 seconds
# 
# time_par - proc.time() 




# function for subsetting data and getting ASV sums

subset_for_curves <- function(metadata, asv_table, comm, habitat) {
  
  if (comm=="plant") {
    
    sub_df <- metadata[metadata$trophic=="PrimaryProducer" & metadata$habitat==habitat,][["sequencing_id"]]
    
    asvs <- asv_table[,names(asv_table) %in% sub_df]
    # remove empty ASVs
    asvs <- asvs[rowSums(asvs)>0,]
    # get row sums
    asv_sums <- rowSums(asvs)
    
    return(asv_sums)
    
  }
  
  else if (comm=="animal") {
    
    sub_df <- metadata[metadata$host=="Animal" & metadata$habitat==habitat,][["sequencing_id"]]
    
    asvs <- asv_table[,names(asv_table) %in% sub_df]
    # remove empty ASVs
    asvs <- asvs[rowSums(asvs)>0,]
    # get row sums
    asv_sums <- rowSums(asvs)
    
    return(asv_sums)
    
  } 
  
  else {
    
    sub_df <- metadata[metadata$trophic=="Environmental" & metadata$habitat==habitat,][["sequencing_id"]]
    
    asvs <- asv_table[,names(asv_table) %in% sub_df]
    # remove empty ASVs
    asvs <- asvs[rowSums(asvs)>0,]
    # get row sums
    asv_sums <- rowSums(asvs)
    
    return(asv_sums)
    
  }
  
}




### the real thing!

## stream

plant_terr_sums <- subset_for_curves(metadata = culled_meta,
                                       asv_table = culled_abun,
                                       comm = "plant",
                                       habitat = "Terrestrial")

anim_terr_sums <- subset_for_curves(metadata = culled_meta,
                                      asv_table = culled_abun,
                                      comm = "animal",
                                      habitat = "Terrestrial")

env_terr_sums <- subset_for_curves(metadata = culled_meta,
                                     asv_table = culled_abun,
                                     comm = "environmental",
                                     habitat = "Terrestrial")

# make list
terr <- list(plant_terr_sums, anim_terr_sums, env_terr_sums)
names(terr) <- c("Primary Producer", "Animal", "Environmental")


# inext_result <- pbmclapply(terrestrial, parallel_rarefaction, mc.cores = Upper_Limit_CPU_Cores) # 11:23



## curves

job::job({
  terr_nonpar <- iNEXT(terr, nboot = 200, endpoint = 100000000) 
})


saveRDS(terr_nonpar, "../outputs/terrestrial_inext_results_new_endpoint.rds")

ggiNEXT(terr_nonpar)



### other habitats


## stream

plant_stream_sums <- subset_for_curves(metadata = culled_meta,
                                       asv_table = culled_abun,
                                       comm = "plant",
                                       habitat = "Riverine")

anim_stream_sums <- subset_for_curves(metadata = culled_meta,
                                      asv_table = culled_abun,
                                      comm = "animal",
                                      habitat = "Riverine")

env_stream_sums <- subset_for_curves(metadata = culled_meta,
                                     asv_table = culled_abun,
                                     comm = "environmental",
                                     habitat = "Riverine")


# make list
stream <- list(plant_stream_sums, anim_stream_sums, env_stream_sums)
names(stream) <- c("Primary Producer", "Animal", "Environmental")


# run parallelized function from before
# stream_result <- pbmclapply(stream, parallel_rarefaction, mc.cores = Upper_Limit_CPU_Cores) # 4:13

job::job({
  stream_nonpar <- iNEXT(stream, nboot = 200, endpoint = 30000000)
})

saveRDS(stream_nonpar, "../outputs/stream_inext_results_new_endpoint.rds")

ggiNEXT(stream_nonpar)


## marine

plant_marine_sums <- subset_for_curves(metadata = culled_meta,
                                       asv_table = culled_abun,
                                       comm = "plant",
                                       habitat = "Marine")

anim_marine_sums <- subset_for_curves(metadata = culled_meta,
                                      asv_table = culled_abun,
                                      comm = "animal",
                                      habitat = "Marine")

env_marine_sums <- subset_for_curves(metadata = culled_meta,
                                     asv_table = culled_abun,
                                     comm = "environmental",
                                     habitat = "Marine")


# make list
marine <- list(plant_marine_sums, anim_marine_sums, env_marine_sums)
names(marine) <- c("Primary Producer", "Animal", "Environmental")


# run parallelized function from before
# marine_result <- pbmclapply(marine, parallel_rarefaction, mc.cores = Upper_Limit_CPU_Cores) # 1:28
marine_nonpar <- iNEXT(marine, nboot = 200, endpoint = 15000000)
saveRDS(marine_nonpar, "../outputs/marine_inext_results_new_endpoint.rds")

ggiNEXT(marine_nonpar)




# plots


mar_inext <- readRDS("../outputs/marine_inext_results_new_endpoint.rds")
str_inext <- readRDS("../outputs/stream_inext_results_new_endpoint.rds")
ter_inext <- readRDS("../outputs/terrestrial_inext_results_new_endpoint.rds")


marine_accum_curve <- ggiNEXT(mar_inext) +
  theme_classic() +
  ggtitle("Marine") +
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 16,
                                  face = "bold",
                                  margin = margin(0,0,20,0)),
        axis.title.x = element_text(vjust=-2),
        axis.title.y = element_text(vjust=2)) +
  scale_shape_manual(values = c(19,19,19)) +
  scale_color_brewer(palette = "Set2") +
  scale_fill_brewer(palette = "Set2") +
  theme(plot.margin = margin(20,30,20,5)) +
  scale_y_continuous(limits=c(0,6000), breaks=seq(0,6000, by = 2000)) +
  xlab("Number of sequences") +
  ylab("ASV richness")


terr_accum_curve <- ggiNEXT(ter_inext) +
  theme_classic() +
  ggtitle("Terrestrial") +
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 16,
                                  face = "bold",
                                  margin = margin(0,0,20,0)),
        axis.title.x = element_text(vjust=-2),
        axis.title.y = element_text(vjust=2)) +
  scale_shape_manual(values = c(19,19,19)) +
  scale_color_brewer(palette = "Set2") +
  scale_fill_brewer(palette = "Set2") +
  theme(plot.margin = margin(20,5,20,5)) +
  #scale_x_continuous(limits=c(100000000), breaks=seq(0,100000000, by = 25000000)) +
  scale_y_continuous(limits=c(0,30000), breaks=seq(0,30000, by = 10000)) +
  xlab("Number of sequences") +
  ylab("ASV richness")


stream_accum_curve <- ggiNEXT(str_inext) +
  theme_classic() +
  ggtitle("Stream") +
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 16,
                                  face = "bold",
                                  margin = margin(0,0,20,0)),
        axis.title.x = element_text(vjust=-2),
        axis.title.y = element_text(vjust=2)) +
  scale_shape_manual(values = c(19,19,19)) +
  scale_color_brewer(palette = "Set2") +
  scale_fill_brewer(palette = "Set2") +
  theme(plot.margin = margin(20,10,20,5)) +
  #scale_y_continuous(limits=c(0,30000), breaks=seq(0,30000, by = 10000)) +
  xlab("Number of sequences") +
  ylab("ASV richness")


save.image(file="accum_curves_workspace.RData")


library(ggpubr)

all_accum <- ggarrange(terr_accum_curve, 
                       stream_accum_curve, 
                       marine_accum_curve, 
                       ncol = 3, 
                       common.legend = TRUE, 
                       legend = "bottom") + bgcolor("white")

# options(bitmapType='cairo')
ggsave("../outputs/all_accumulation_curves_new_endpoint.png", width = 16, height = 5)

# things to fix in plot: need right side margin on stream and marine plots, 
# don't cut off x axis labels



############## what is driving the high diversity of terrestrial primary producers #################


pp_met <- culled_meta[which(culled_meta$trophic=="PrimaryProducer" & culled_meta$habitat=="Terrestrial"),]

pp_types <- unique(pp_met$sample_type)


pp_terr_list <- list()

for (a_type in pp_types) {
  
  sub_df <- pp_met[which(pp_met$sample_type==a_type),][["sequencing_id"]]
  
  sub_asvs <- culled_abun[,names(culled_abun) %in% sub_df]
  
  sub_asvs <- sub_asvs[rowSums(sub_asvs)>0,]
  
  pp_terr_list[[a_type]] <- rowSums(sub_asvs)   
  
}

terr_plant_curves <- iNEXT(pp_terr_list, nboot = 200)

saveRDS(terr_plant_curves, "../outputs/terrestrial_plant_inext_results.rds")

ggiNEXT(terr_plant_curves)

# plot the plant terrestrial curves

terr_plant_curve_plot <- ggiNEXT(terr_plant_curves) +
  theme_classic() +
  ggtitle("Terrestrial Primary Producers by Sample Type") +
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 16,
                                  face = "bold",
                                  margin = margin(0,0,20,0)),
        axis.title.x = element_text(vjust=-2),
        axis.title.y = element_text(vjust=2),
        legend.position = "bottom") +
  scale_shape_manual(values = rep(19, length(pp_types))) +
  #scale_color_brewer(palette = "Set2") +
  #scale_fill_brewer(palette = "Set2") +
  theme(plot.margin = margin(20,0,20,5)) +
  scale_y_continuous(limits=c(0,9000), breaks=seq(0,9000, by = 1500)) +
  xlab("Number of sequences") +
  ylab("ASV richness")

# options(bitmapType='cairo')
ggsave("../outputs/terrestrial_plant_curves.png", width = 14, height = 8)

save.image(file="../plant_accum_curves_workspace.RData")


