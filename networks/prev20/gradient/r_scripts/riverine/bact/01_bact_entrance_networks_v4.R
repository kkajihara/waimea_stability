library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/r_scripts/riverine/bact")

bact_data <- readRDS("~/cmaiki_lts/kaciekaj/waimea/intermediates/gradient/riverine/riverine_bact_grad_data_ordered.rds")


data <- t(bact_data[[1]])

# things to change: thresh, min lam ratio, nlambda, rep.num, 

# keep thresh01, change min lam
net1_thresh01_minlam1e1 <- spiec.easi(data, 
                                      method='mb',
                                      pulsar.params = list(thresh=0.01),
                                      lambda.min.ratio=1e-1,
                                      scr=TRUE)

net2_thresh01_minlam1e3 <- spiec.easi(data, 
                                      method='mb',
                                      pulsar.params = list(thresh=0.01),
                                      lambda.min.ratio=1e-3,
                                      scr=TRUE)

net3_thresh01_minlam1e5 <- spiec.easi(data, 
                                      method='mb',
                                      pulsar.params = list(thresh=0.01),
                                      lambda.min.ratio=1e-5,
                                      scr=TRUE)

# keep threso01 and min lam 1e-5, change rep num
net4_thresh01_minlam1e5_rep100 <- spiec.easi(data, 
                                      method='mb',
                                      pulsar.params = list(thresh=0.01, rep.num=100),
                                      lambda.min.ratio=1e-5,
                                      scr=TRUE)

net5_thresh01_minlam1e5_rep200 <- spiec.easi(data, 
                                             method='mb',
                                             pulsar.params = list(thresh=0.01, rep.num=200),
                                             lambda.min.ratio=1e-5,
                                             scr=TRUE)

net6_thresh01_minlam1e5_rep300 <- spiec.easi(data, 
                                             method='mb',
                                             pulsar.params = list(thresh=0.01, rep.num=300),
                                             lambda.min.ratio=1e-5,
                                             scr=TRUE)

# instead of change rep num, change nlambda and minlam
net7_thresh01_minlam1e5_nlam50 <- spiec.easi(data, 
                                             method='mb',
                                             pulsar.params = list(thresh=0.01),
                                             nlambda = 50,
                                             lambda.min.ratio=1e-5,
                                             scr=TRUE)

net8_thresh01_minlam1e15_nlam150 <- spiec.easi(data, 
                                               method='mb',
                                               pulsar.params = list(thresh=0.01),
                                               nlambda = 100,
                                               lambda.min.ratio=1e-15,
                                               scr=TRUE)


saveRDS(list(net1_thresh01_minlam1e1,
             net2_thresh01_minlam1e3,
             net3_thresh01_minlam1e5,
             net4_thresh01_minlam1e5_rep100,
             net5_thresh01_minlam1e5_rep200,
             net6_thresh01_minlam1e5_rep300,
             net7_thresh01_minlam1e5_nlam50,
             net8_thresh01_minlam1e15_nlam150,
             net9_thresh01_minlam1e50_nlam500),
        "~/cmaiki_lts/kaciekaj/waimea/networks/prev20/gradient/outputs/riverine/param_test_bact_entrance_results_list.rds")






