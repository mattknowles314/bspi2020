#!/bin/bash
#SBATCH --job-name=align_seqs
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=es1554@york.ac.uk 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20gb
#SBATCH --time=06:00:00
#SBATCH --output=align_seqs_%j.log
#SBATCH --account=biol-hic-2020


module load bio/BWA/0.7.17-foss-2019b
module load bio/SAMtools/1.10-foss-2019b

for sequ in ./sequencesx/*.fastq; do
	sequ=${sequ%.fastq}
	sequ=${sequ##*/}
	bwa aln GRCH38 ./sequencesx/${sequ}.fastq> ./aligned/${sequ}.bwa
	bwa samse GRCH38 ./aligned/${sequ}.bwa ./sequencesx/${sequ}.fastq> ./aligned/${sequ}.sam 
	samtools view -bS ./aligned/${sequ}.sam> ./aligned/${sequ}.bam
	samtools sort -O bam -o ./aligned/${sequ}.sorted.bam -T temp ./aligned/${sequ}.bam
	samtools index ./aligned/${sequ}.sorted.bam
done 
