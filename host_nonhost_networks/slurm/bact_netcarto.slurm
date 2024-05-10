#!/bin/bash
#SBATCH --job-name=bact_hubs
#SBATCH --account=cmaiki
#SBATCH --partition=cmaiki
#SBATCH --time=3-00:00:00

#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=60GB

#SBATCH --constraint="ib_hdr"

#SBATCH --error=bact_hubs_%A.err
#SBATCH --output=bact_hubs_%A.out

#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE,TIME_LIMIT_80
#SBATCH --mail-user=kaciekaj@hawaii.edu

## Start of commands to execute

module load lang/R/4.2.1-foss-2022a

Rscript r_scripts/bact_netcarto_hubs.R
