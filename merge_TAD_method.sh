# Another approach to working with TADs at multiple resolutions after initial hicexplorer slurm script is run
# Allows creation of TAD heirarchies
 
export MAIL=awilderman@uchc.edu
export MCSOURCE="/home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer"
export OUTDIR=/home/FCAM/awilderman/ANALYSIS/HiC/CNCC/HiCExplorer
export HICPRODIR="/home/FCAM/awilderman/ANALYSIS/HiC/Lyu_H9"
export SAMPLE=fastq
export LABEL=H9
export RESOLUTION=10000
export RESONE=20K
export RESTWO=50K
export RESTHREE=100K
export RESFOUR=500K
export REGION=chr7:25000000-28000000
export GENEFILE="/home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer/region_genes.bed"
export DEPTH=3000000 #span of region in bp

echo "#!/bin/bash
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=awilderman@uchc.edu
#SBATCH -o HiCExplorer_mergeTAD_test_%j.out
#SBATCH -e HiCExplorer_mergeTAD_test_%j.err

source /home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer/.bashrc_miniconda3
conda activate /home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer/hicexplorer

cd /home/FCAM/awilderman/ANALYSIS/HiC

hicMergeDomains --domainFiles "$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_corrected_1_05_TADs_Domains.bed \
"$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_corrected_1_05_TADs_Domains.bed \
"$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_corrected_1_05_TADs_Domains.bed \
"$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_corrected_1_05_TADs_Domains.bed \
--minimumNumberOfPeaks 1 \
--value 5000 \
--percent 0.1 \
--outputMergedList "$LABEL"_1_05_MergedDomains.bed \
--outputRelationList "$LABEL"_1_05_RelationList.txt \
--outputTreePlotPrefix "$LABEL"_1_05_relationship_tree_ \
--outputTreePlotFormat pdf

conda deactivate" > hicexplorer_mergeTAD.slurm
