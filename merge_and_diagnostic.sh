export MAIL=awilderman@uchc.edu
export MCSOURCE="/home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer"
export OUTDIR=/home/FCAM/awilderman/ANALYSIS/HiC/CNCC/HiCExplorer
export LABEL=H9
export RESOLUTION=10000
export RESONE=20K
export RESTWO=50K
export RESTHREE=100K
export RESFOUR=500K

echo "#!/bin/bash
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user="$MAIL"
#SBATCH -o HiCExplorer_merge_%j.out
#SBATCH -e HiCExplorer_merge_%j.err

source "$MCSOURCE"/.bashrc_miniconda3
conda activate "$MCSOURCE"/hicexplorer

cd "$OUTDIR"
hicMergeMatrixBins --matrix "$LABEL"_"$RESOLUTION".h5 --outFileName "$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_matrix.h5 --numBins 2
hicMergeMatrixBins --matrix "$LABEL"_"$RESOLUTION".h5 --outFileName "$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_matrix.h5 --numBins 5
hicMergeMatrixBins --matrix "$LABEL"_"$RESOLUTION".h5 --outFileName "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_matrix.h5 --numBins 10
hicMergeMatrixBins --matrix "$LABEL"_"$RESOLUTION".h5 --outFileName "$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_matrix.h5 --numBins 50

hicCorrectMatrix diagnostic_plot -m "$LABEL"_"$RESOLUTION".h5 -o plot_"$LABEL"_"$RESOLUTION"_matrix.h5.png
hicCorrectMatrix diagnostic_plot -m "$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_matrix.h5 -o plot_"$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_matrix.h5.png
hicCorrectMatrix diagnostic_plot -m "$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_matrix.h5 -o plot_"$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_matrix.h5.png
hicCorrectMatrix diagnostic_plot -m "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_matrix.h5 -o plot_"$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_matrix.h5.png
hicCorrectMatrix diagnostic_plot -m "$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_matrix.h5 -o plot_"$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_matrix.h5.png

conda deactivate" > hicexplorer_merge.slurm
