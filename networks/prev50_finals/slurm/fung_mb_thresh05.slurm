#!/bin/bash
#SBATCH --job-name=fung_mb_thresh05
#SBATCH --account=cmaiki
#SBATCH --partition=cmaiki
#SBATCH --time=21-00:00:00

#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=40GB

#SBATCH --error=fung_mb_thresh05_%A.err
#SBATCH --output=fung_mb_thresh05_%A.out

#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE,TIME_LIMIT_80
#SBATCH --mail-user=kaciekaj@hawaii.edu

## Start of commands to execute

module load lang/R/4.0.0-intel-2018.5.274-Python-2.7.15

Rscript r_scripts/fung_mb_thresh05.R
