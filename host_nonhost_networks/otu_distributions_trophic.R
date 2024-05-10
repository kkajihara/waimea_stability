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

trophs <- unique(fung_meta$host)

#habs <- c("Terrestrial","Riverine", "Marine")

troph_subset <- function(otu_table, meta_table) {
  trophs <- unique(fung_meta$host)
  
  troph_list <- list()
  
  for (a_troph in trophs) {
    sub_met <- meta_table[which(meta_table$host==a_troph),]
    
    sub_troph_abun <- otu_table[,which(names(otu_table) %in% sub_met$x_seq_id)]
    sub_troph_abun <- data.frame(sub_troph_abun)
    sub_troph_abun <- sub_troph_abun[which(rowSums(sub_troph_abun) > 0),]
    sub_troph_abun <- data.frame(sub_troph_abun)
    
    troph_list[[a_troph]] <- sub_troph_abun
    
  }
  
  return(troph_list)
}

fung_otus_by_troph <- troph_subset(fung_abun, fung_meta)
bact_otus_by_troph <- troph_subset(bact_abun, bact_meta)


get_plot <- function(abun, troph, color) {
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
    labs(title = troph, y = "Total Reads")
  
  return(pl)
}

pal <- c("#9e194d", "#baa600", "#96bfe6")

fung_plots <- mapply(get_plot, fung_otus_by_troph, names(fung_otus_by_troph), pal, SIMPLIFY = FALSE)

fung_plots[[1]] <- fung_plots[[1]] + ggtitle("Fungi Environmental")
fung_plots[[2]] <- fung_plots[[2]] + ggtitle("Fungi Consumer")
fung_plots[[3]] <- fung_plots[[3]] + ggtitle("Fungi Primary Producer")

bact_plots <- mapply(get_plot, bact_otus_by_troph, names(bact_otus_by_troph), pal, SIMPLIFY = FALSE)

bact_plots[[1]] <- bact_plots[[1]] + ggtitle("Bacteria Environmental")
bact_plots[[2]] <- bact_plots[[2]] + ggtitle("Bacteria Consumer")
bact_plots[[3]] <- bact_plots[[3]] + ggtitle("Bacteria Primary Producer")

names(fung_plots) <- c("Environmental", "Consumer", "Primary Producer")
names(bact_plots) <- c("Environmental", "Consumer", "Primary Producer")


fung_plots <- fung_plots[c("Primary Producer", "Consumer", "Environmental")]
bact_plots <- bact_plots[c("Primary Producer", "Consumer", "Environmental")]


library(patchwork)

all_plots <- fung_plots[[1]] + fung_plots[[2]] + fung_plots[[3]] +
  bact_plots[[1]] + bact_plots[[2]] + bact_plots[[3]] + plot_layout(nrow = 2, ncol = 3)
  
  wrap_plots(fung_plots) + wrap_plots(bact_plots) + plot_layout(nrow = 2, ncol = 3)

all_cross <- cross_key_rob_plots[[1]] + cross_key_rob_plots[[2]] + cross_key_rob_plots[[3]] & theme(legend.position = "bottom")
#plots <- plots & xlab(NULL) & ylab(NULL)
all_cross <- all_cross + plot_layout(guides = "collect") 

ggsave("figures/global/otu_trophic_abundance_distribution_plots.pdf", width = 15, height=9)


zoom <- test[[2]] +
 xlim(0,500) +   ylim(0,500000)







