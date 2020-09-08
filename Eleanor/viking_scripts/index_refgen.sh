#!/bin/bash 
#SBATCH --job-name=index_refgenome          #Job name
#SBATCH --mail-type=END,FAIL                #Mail events 
#SBATCH --mail-user=es1554@york.ac.uk
#SBATCH --ntasks=1
#SBATCH --mem=5gb
#SBATCH --time=03:30:00
#SBATCH --output=index_refgenome_%j.log
#SBATCH --account=biol-hic-2020

module load bio/BWA/0.7.17-foss-2019b


bwa index -p GRCH38  -a bwtsw ./new/GRCH38.fa
 


