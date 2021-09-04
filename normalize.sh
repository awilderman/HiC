## Normalize matrices against eachother for comparisons
export MAIL=awilderman@uchc.edu
export MCSOURCE="/home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer"
export OUTDIR=/home/FCAM/awilderman/ANALYSIS/HiC/CNCC/HiCExplorer
export RESOLUTION=10000
export RESONE=20K
export RESTWO=50K
export RESTHREE=100K
export RESFOUR=500K
export REGION=chr7:25000000-28000000
export LABELONE=H9_rep1_10000
export LABELTWO=H9_rep2_10000
export LABELTHREE=H9_rep3_10000
export REGION=chr7:25000000-28000000

echo "#!/bin/bash
#SBATCH --job-name=HiCExplorer_normalize
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user="$MAIL"
#SBATCH -o HiCExplorer_normalize_%j.out
#SBATCH -e HiCExplorer_normalize_%j.err

source "$MCSOURCE"/.bashrc_miniconda3
conda activate "$MCSOURCE"/hicexplorer

cd "$OUTDIR"
hicNormalize -m "$LABELONE".h5 "$LABELTWO".h5 "$LABELTHREE".h5 --normalize smallest -o "$LABELONE"_normalized.h5 "$LABELTWO"_normalized.h5 "$LABELTHREE"_normalized.h5

# Check diagnostic plot
hicCorrectMatrix diagnostic_plot -m "$LABELONE"_normalized.h5 -o plot_"$LABELONE"_normalized.png
hicCorrectMatrix diagnostic_plot -m "$LABELTWO"_normalized.h5 -o plot_"$LABELTWO"_normalized.png
hicCorrectMatrix diagnostic_plot -m "$LABELTHREE"_normalized.h5 -o plot_"$LABELTHREE"_normalized.png

conda deactivate" > hicexplorer_normalize.slurm
