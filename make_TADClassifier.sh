# alternative TAD calling method
# only takes cooler format, if using resolution other than 10kb have to train own ?

export MAIL=awilderman@uchc.edu
export MCSOURCE="/home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer"
export OUTDIR=/home/FCAM/awilderman/ANALYSIS/HiC/CNCC/HiCExplorer
export HICPRODIR="/home/FCAM/awilderman/ANALYSIS/HiC/Lyu_H9"
export SAMPLE=fastq
export LABEL=H9
export RESOLUTION=10000
export REGION=chr7:25000000-28000000

echo "#!/bin/bash
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user="$MAIL"
#SBATCH -o HiCExplorer_TADClassifier_%j.out
#SBATCH -e HiCExplorer_TADClassifier_%j.err

source "$MCSOURCE"/.bashrc_miniconda3
conda activate "$MCSOURCE"/hicexplorer

cd "$OUTDIR"
hicConvertFormat --matrices "$HICPRODIR"/"$LABEL"/hic_results/matrix/"$SAMPLE"/raw/"$RESOLUTION"/"$SAMPLE"_"$RESOLUTION".matrix --outFileName "$LABEL"_"$RESOLUTION" --inputFormat hicpro --outputFormat cool --bedFileHicpro "$HICPRODIR"/"$LABEL"/hic_results/matrix/"$SAMPLE"/raw/"$RESOLUTION"/"$SAMPLE"_"$RESOLUTION"_abs.bed --resolutions "$RESOLUTION"
hicTADClassifier -m "$LABEL"_"$RESOLUTION".cool -o "$LABEL"_"$RESOLUTION"_predictions -n range

conda deactivate" > hicexplorer_TADClassifier.slurm
