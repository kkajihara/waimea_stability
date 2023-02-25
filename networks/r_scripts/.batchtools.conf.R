cluster.functions = makeClusterFunctionsSlurm(template="slurm.tmpl")
default.resources = list(walltime = 3600, memory = 2000, ntasks = 2, ncpus = 3, partition = "kill-exclusive")
