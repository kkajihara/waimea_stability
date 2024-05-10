library(dplyr)
library(ggplot2)

# goal: plot out the OTU abundance distribution curves for each habitat in a locus

## Fungi
fung_abun <- readRDS("intermediates/global/fully_filtered_p20_fungal_otu_table_matched_up.rds")
bact_abun <- readRDS("intermediates/global/fully_filtered_p20_bact_otu_table_matched_up.rds")

fung_abun <- fung_abun[rownames(fung_abun)!="dummy",]
bact_abun <- bact_abun[rownames(bact_abun)!="dummy",]

fung_meta <- readRDS("intermediates/global/fully_filtered_p20_fungal_otu_metadata_matched_up.rds")
bact_meta <- readRDS("intermediates/global/fully_filtered_p20_bact_otu_metadata_matched_up.rds")

#empo1 <- c("Free-living", "Host-associated")


#habs <- c("Terrestrial","Riverine", "Marine")

empo_subset <- function(otu_table, meta_table) {
  empos <- unique(fung_meta$empo_1)
  
  empo_list <- list()
  
  for (a_empo in empos) {
    sub_met <- meta_table[which(meta_table$empo_1==a_empo),]
    
    sub_empo_abun <- otu_table[,which(names(otu_table) %in% sub_met$x_seq_id)]
    sub_empo_abun <- data.frame(sub_empo_abun)
    sub_empo_abun <- sub_empo_abun[which(rowSums(sub_empo_abun) > 0),]
    sub_empo_abun <- data.frame(sub_empo_abun)
    
    empo_list[[a_empo]] <- sub_empo_abun
    
  }
  
  return(empo_list)
}

fung_otus_by_empo <- empo_subset(fung_abun, fung_meta)
bact_otus_by_empo <- empo_subset(bact_abun, bact_meta)


get_plot <- function(abun, empo, color) {
  sums <- as.data.frame(rowSums(abun)) 
  sums <- arrange(sums, desc(rowSums(abun)))
  sums$otu_num <- seq(1:nrow(sums))
  
  names(sums) <- c("Total_Reads", "OTU")
  
  
  pl <- ggplot(sums, aes(x = OTU, y = Total_Reads)) +
    geom_point(color = color) +
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
          panel.background=element_blank(),
          axis.title = element_text(size=14),
          axis.text = element_text(size=12, color="black"),
          title=element_text(size=16)) +
    theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0))) +
    theme(axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0))) +
    labs(title = empo, y = "Total Reads")
  
  return(pl)
}

pal <- c("#c2612c", "#b8b8ff")

fung_plots <- mapply(get_plot, fung_otus_by_empo, names(fung_otus_by_empo), pal, SIMPLIFY = FALSE)

fung_plots[[1]] <- fung_plots[[1]] + ggtitle("Fungi Free-living")
fung_plots[[2]] <- fung_plots[[2]] + ggtitle("Fungi Host-associated")

bact_plots <- mapply(get_plot, bact_otus_by_empo, names(bact_otus_by_empo), pal, SIMPLIFY = FALSE)

bact_plots[[1]] <- bact_plots[[1]] + ggtitle("Bacteria Free-living")
bact_plots[[2]] <- bact_plots[[2]] + ggtitle("Bacteria Host-associated")


library(patchwork)

all_plots <- fung_plots[[1]] + fung_plots[[2]] +
  bact_plots[[1]] + bact_plots[[2]] + plot_layout(nrow = 2, ncol = 2)
  
#wrap_plots(fung_plots) + wrap_plots(bact_plots) + plot_layout(nrow = 2, ncol = 2)

#all_cross <- all_cross + plot_layout(guides = "collect") 

ggsave("figures/finals/hostnon/otu_hostnon_abundance_distribution_plots.pdf", width = 10.5, height=9)
ggsave("figures/finals/hostnon/otu_hostnon_abundance_distribution_plots.png", width = 10.5, height=9)


zoom <- test[[2]] +
 xlim(0,500) +   ylim(0,500000)







