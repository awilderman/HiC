# Convert to h5 format for HiCExplorer- (also can make cool and mcool files)
## edit environmental variables
export MAIL=awilderman@uchc.edu
export MCSOURCE="/home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer"
export OUTDIR=/home/FCAM/awilderman/ANALYSIS/HiC/CNCC/HiCExplorer
export HICPRODIR="/home/FCAM/awilderman/ANALYSIS/HiC/Lyu_H9"
export SAMPLE=fastq
export LABEL=H9
export RESOLUTION=10000

echo "#!/bin/bash
#SBATCH --job-name=HiCExplorer_convert
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user="$MAIL"
#SBATCH -o HiCExplorer_convert_%j.out
#SBATCH -e HiCExplorer_convert_%j.err


source "$MCSOURCE"/.bashrc_miniconda3
conda activate "$MCSOURCE"/hicexplorer

cd "$OUTDIR"

hicConvertFormat --matrices "$HICPRODIR"/"$LABEL"/hic_results/matrix/"$SAMPLE"/raw/"$RESOLUTION"/"$SAMPLE"_"$RESOLUTION".matrix --outFileName "$LABEL"_"$RESOLUTION" --inputFormat hicpro --outputFormat h5 --bedFileHicpro "$HICPRODIR"/"$LABEL"/hic_results/matrix/"$SAMPLE"/raw/"$RESOLUTION"/"$SAMPLE"_"$RESOLUTION"_abs.bed

conda deactivate" > hicexplorer_convert.slurm
