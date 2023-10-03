#!/bin/bash
#SBATCH --job-name=calc_everything
#SBATCH --account=cmaiki
#SBATCH --partition=cmaiki
#SBATCH --time=3-00:00:00

#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=60GB

#SBATCH --constraint="ib_hdr"

#SBATCH --error=calc_everything_%A.err
#SBATCH --output=calc_everything_%A.out

#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE,TIME_LIMIT_80
#SBATCH --mail-user=kaciekaj@hawaii.edu

## Start of sampleands to execute

module load lang/R/4.0.0-intel-2018.5.274-Python-2.7.15

Rscript do_everything.R
