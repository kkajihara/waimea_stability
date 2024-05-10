#!/bin/bash
#SBATCH --job-name=sample_pd
#SBATCH --account=cmaiki
#SBATCH --partition=cmaiki
#SBATCH --time=3-00:00:00

#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=40GB

#SBATCH --constraint="ib_hdr"

#SBATCH --error=sample_pd_%A.err
#SBATCH --output=sample_pd_%A.out

#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE,TIME_LIMIT_80
#SBATCH --mail-user=kaciekaj@hawaii.edu

## Start of sampleands to execute

module load lang/R/4.2.1-foss-2022a

Rscript r_scripts/picante_by_sample.R
