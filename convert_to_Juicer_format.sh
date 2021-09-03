# make script for Juicer_convert.slurm


## convert HiC data to Juicer
## Convert the bam file from bwt2 to 4DN DCIC format using pairx
## Then convert to .hic for use with Juicer GUI

    export ANALYSISDIR=
    export SAMPLE=
    export JOB_NAME=${SAMPLE}_Juicer_convert
    export MAIL=
    export BAMDIR=
    export GENOME= #hg19, mm10, etc.
    export GENOME_SIZE= #<path to .chrom.sizes file>
    export JUICERTOOLS= #<path to juicer_tools.jar>  
    export REFILE= #<path to genome_enzyme.txt, downloaded or created with https://github.com/aidenlab/juicer/blob/master/misc/generate_site_positions.py>

echo "#!/bin/bash
#SBATCH -N 1
#SBATCH -n 12 
#SBATCH -t 100:00:00
#SBATCH --mem=400G
#SBATCH -p himem
#SBATCH	--qos=himem
#SBATCH --mail-user=${MAIL}
#SBATCH --mail-type=end
#SBATCH --job-name=${JOB_NAME}
#SBATCH -o ${JOB_NAME}_%j.out
#SBATCH -e ${JOB_NAME}_%j.err

module load samtools/1.9
module load htslib/1.10.2
module load juicer/1.8.9
module load juicebox/1.9.8

cd ~/ANALYSIS/HiC/Juicer

bam2pairs -l -c ${GENOME_SIZE} ${BAMDIR}/${SAMPLE}_${GENOME}.bwt2pairs.bam  ${SAMPLE}

#Running without any options will default to the genome of hg19 and the restriction site of MboI.

java -Xmx48g -jar ${JUICERTOOLS} pre ${SAMPLE}.bsorted.pairs.gz ${SAMPLE}.hic ${GENOME_SIZE} -f ${REFILE}" > ${JOB_NAME}.slurm

# Run on Juicer GUI
#	Download SIP
# 	It opens, good!
# 	Transfer hic file
# 	Download juicer_tools
# Run with defaults and res=5000*5









