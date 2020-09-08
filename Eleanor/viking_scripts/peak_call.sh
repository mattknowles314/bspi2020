#!/bin/bash
#SBATCH --job-name=peak_Call
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=es1554@york.ac.uk
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=15gb
#SBATCH --time=08:00:00
#SBATCH --output=peak_Call_%j.log
#SBATCH --account=biol-hic-2020



#saves single peaks as different file name as paired loop
seq_list='GSM798392_1 GSM798385_1 GSM798393_1' 

for seq in $seq_list; do macs2 callpeak -t ./aligned/${seq}.sorted.bam -f BAM -n ./peaks/$seq -B & done

reads=('aligned/GSM798383_1.sorted.bam' 'aligned/GSM798384_1.sorted.bam' 'aligned/GSM798386_1.sorted.bam' 'aligned/GSM798387_1.sorted.bam' 'aligned/GSM798388_1.sorted.bam' 'aligned/GSM798389_1.sorted.bam' 'aligned/GSM798390_1.sorted.bam' 'aligned/GSM798391_1.sorted.bam' 'aligned/GSM798394_1.sorted.bam' 'aligned/GSM798395_1.sorted.bam' 'aligned/GSM798396_1.sorted.bam' 'aligned/GSM798397_1.sorted.bam' 'aligned/GSM798398_1.sorted.bam' 'aligned/GSM798399_1.sorted.bam' 'aligned/GSM798400_1.sorted.bam' 'aligned/GSM798401_1.sorted.bam' 'aligned/GSM798402_1.sorted.bam' 'aligned/GSM798403_1.sorted.bam')
control=('aligned/GSM798406_1.sorted.bam' 'aligned/GSM798407_1.sorted.bam' 'aligned/GSM798408_1.sorted.bam' 'aligned/GSM798409_1.sorted.bam' 'aligned/GSM798409_1.sorted.bam' 'aligned/GSM798410_1.sorted.bam' 'aligned/GSM798411_1.sorted.bam' 'aligned/GSM798412_1.sorted.bam' 'aligned/GSM798413_1.sorted.bam' 'aligned/GSM798414_1.sorted.bam' 'aligned/GSM798415_1.sorted.bam' 'aligned/GSM798415_1.sorted.bam' 'aligned/GSM798416_1.sorted.bam' 'aligned/GSM798416_1.sorted.bam' 'aligned/GSM798417_1.sorted.bam' 'aligned/GSM798418_1.sorted.bam' 'aligned/GSM798419_1.sorted.bam' 'aligned/GSM798420_1.sorted.bam')

for seq in $(seq 0 17); do macs2 callpeak -t ./${reads[$seq]} -c ./${control[$seq]} -f BAM -n ./peaks/${reads[$seq]:8:11}.bam -B & done
