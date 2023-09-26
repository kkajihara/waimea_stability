reg$cluster.functions = makeClusterFunctionsSlurm(template="slurm.tmpl")
reg$default.resources = list(walltime = 3600, memory = 4000, ntasks = 1, ncpus = 1)
