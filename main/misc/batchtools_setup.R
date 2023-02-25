library(SpiecEasi)
library(batchtools)

setwd("~/cmaiki_lts/kaciekaj/waimea/networks/r_scripts/")

download.file("https://bit.ly/3Oh9dRO", "slurm.tmpl")
download.file("https://bit.ly/3KPBwou", ".batchtools.conf.R") 


# test
data(amgut1.filt)

bargs <- list(rep.num=30, seed=10010, conffile=".batchtools.conf.R")
se5 <- spiec.easi(amgut1.filt, method='glasso', lambda.min.ratio=1e-3, nlambda=30,
            sel.criterion='stars', pulsar.select='batch', pulsar.params=bargs)

getStatus()
killJobs()
clearRegistry()
