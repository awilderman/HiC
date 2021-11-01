## Correct and compare reps
# will have to view diagnostic plot (may have to scp to desktop) and set thresholds, 
# edit next script for ICE correction with thresholds chosen
# I set it up to write the script as a .txt to remind you to manually enter the threshold values
# Save as .slurm when done

echo "#!/bin/bash
#SBATCH --job-name=HiCExplorer_correct_compare
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user="$MAIL"
#SBATCH -o HiCExplorer_correct_%j.out
#SBATCH -e HiCExplorer_correct_%j.err

source "$MCSOURCE"/.bashrc_miniconda3
conda activate "$MCSOURCE"/hicexplorer

## Correct and Compare normalized matrices, use merged bins for best resolution

# Correct (ICE normalize using filter thresholds decided on using the diagnostic plot)

cd "$OUTDIR"
hicCorrectMatrix correct --correctionMethod ICE -m "$LABELONE"_normalized.h5 --filterThreshold -T T -o  "$LABELONE"_normalized_corrected_matrix.h5
hicCorrectMatrix correct --correctionMethod ICE -m "$LABELTWO"_normalized.h5 --filterThreshold -T T -o  "$LABELTWO"_normalized_corrected_matrix.h5
hicCorrectMatrix correct --correctionMethod ICE -m "$LABELTHREE"_normalized.h5 --filterThreshold -T T -o  "$LABELTHREE"_normalized_corrected_matrix.h5

# Compare using log2ratio (there are other options)

hicCompareMatrices -m \
"$LABELONE"_normalized_corrected_matrix.h5 \
"$LABELTWO"_normalized_corrected_matrix.h5 \
--operation log2ratio -o "$LABELONE"_v_"$LABELTWO"_compare.h5

hicCompareMatrices -m \
"$LABELONE"_normalized_corrected_matrix.h5 \
"$LABELTHREE"_normalized_corrected_matrix.h5 \
--operation log2ratio -o "$LABELONE"_v_"$LABELTHREE"_compare.h5

hicCompareMatrices -m \
"$LABELTWO"_normalized_corrected_matrix.h5 \
"$LABELTHREE"_normalized_corrected_matrix.h5 \
--operation log2ratio -o "$LABELTWO"_v_"$LABELTHREE"_compare.h5


# Plot comparisons in a given region

hicPlotMatrix -m \
"$LABELONE"_v_"$LABELTWO"_compare.h5 \
--clearMaskedBins \
--region "$REGION" \
-o "$LABELONE"_v_"$LABELTWO"_compare_plot.png

hicPlotMatrix -m \
"$LABELONE"_v_"$LABELTHREE"_compare.h5 \
--clearMaskedBins \
--region "$REGION" \
-o "$LABELONE"_v_"$LABELTHREE"_compare_plot.png

hicPlotMatrix -m \
"$LABELTWO"_v_"$LABELTHREE"_compare.h5 \
--clearMaskedBins \
--region "$REGION" \
-o "$LABELTWO"_v_"$LABELTHREE"_compare_plot.png

# Plot comparisons per chromosome

hicPlotMatrix -m \
"$LABELONE"_v_"$LABELTWO"_compare.h5 \
--clearMaskedBins \
--perChromosome \
-o "$LABELONE"_v_"$LABELTWO"_compare_plot_perChrom.png

hicPlotMatrix -m \
"$LABELONE"_v_"$LABELTHREE"_compare.h5 \
--clearMaskedBins \
--perChromosome \
-o "$LABELONE"_v_"$LABELTHREE"_compare_plot_perChrom.png

hicPlotMatrix -m \
"$LABELTWO"_v_"$LABELTHREE"_compare.h5 \
--clearMaskedBins \
--perChromosome \
-o "$LABELTWO"_v_"$LABELTHREE"_compare_plot_perChrom.png

conda deactivate" > hicexplorer_correct_compare.txt

