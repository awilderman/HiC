# reveiw diagnostic plot and correct
export MAIL=awilderman@uchc.edu
export MCSOURCE="/home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer"
export OUTDIR=/home/FCAM/awilderman/ANALYSIS/HiC/CNCC/HiCExplorer
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
#SBATCH --job-name=HiCExplorer_correct_call_TADs_Loops
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

cd "$OUTDIR"

## Correct and Compare normalized matrices, use merged bins for best resolution

# Correct (ICE normalize using filter thresholds decided on using the diagnostic plot)
hicCorrectMatrix correct --correctionMethod ICE -m "$LABEL"_"$RESOLUTION".h5 --filterThreshold -T T -o "$LABEL"_"$RESOLUTION"_corrected_matrix.h5
hicCorrectMatrix correct --correctionMethod ICE -m "$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_matrix.h5 --filterThreshold -T T -o "$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_corrected_matrix.h5
hicCorrectMatrix correct --correctionMethod ICE -m "$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_matrix.h5 --filterThreshold -T T -o "$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_corrected_matrix.h5
hicCorrectMatrix correct --correctionMethod ICE -m "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_matrix.h5 --filterThreshold -T T -o "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_corrected_matrix.h5
hicCorrectMatrix correct --correctionMethod ICE -m "$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_matrix.h5 --filterThreshold -T T -o "$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_corrected_matrix.h5

# Plot region of interest at three higher resolutions (e.g. 10Kb, 20Kb, 50Kb)

hicPlotMatrix -m \
"$LABEL"_"$RESOLUTION"_corrected_matrix.h5 \
--clearMaskedBins \
--region "$REGION" \
-o "$LABEL"_"$RESOLUTION"_corrected_plot.png

hicPlotMatrix -m \
"$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_corrected_matrix.h5 \
--clearMaskedBins \
--region "$REGION" \
-o "$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_corrected_plot.png

hicPlotMatrix -m \
"$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_corrected_matrix.h5 \
--clearMaskedBins \
--region "$REGION" \
-o WT_CNCC_1Kmerged_to_6K_corrected_plot.png

# Plot each whole chromosome as a separate figure, two lower resolutions (e.g. 100Kb, 500Kb)

hicPlotMatrix -m \
"$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_corrected_matrix.h5 \
--clearMaskedBins \
--perChromosome \
-o "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_corrected_plot_perChrom.png

hicPlotMatrix -m \
"$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_corrected_matrix.h5 \
--clearMaskedBins \
--perChromosome \
-o "$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_corrected_plot_perChrom.png


# call TADs

hicFindTADs -m "$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_corrected_matrix.h5 \
--outPrefix "$LABEL"_"$RESOLUTION"merged_to_"$RESONE"_corrected_1_05_TADs \
--correctForMultipleTesting fdr \
--thresholdComparisons 0.1 \
--delta 0.05 \
-p 16

hicFindTADs -m "$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_corrected_matrix.h5 \
--outPrefix "$LABEL"_"$RESOLUTION"merged_to_"$RESTWOE"_corrected_1_05_TADs \
--correctForMultipleTesting fdr \
--thresholdComparisons 0.1 \
--delta 0.05 \
-p 16

hicFindTADs -m "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_corrected_matrix.h5 \
--outPrefix "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_corrected_1_05_TADs \
--correctForMultipleTesting fdr \
--thresholdComparisons 0.1 \
--delta 0.05 \
-p 16

hicFindTADs -m "$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_corrected_matrix.h5 \
--outPrefix "$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_corrected_1_05_TADs \
--correctForMultipleTesting fdr \
--thresholdComparisons 0.1 \
--delta 0.05 \
-p 16

### Create the .ini file 

echo \"[x-axis]
where = top

[hic matrix]
file = "$LABEL"_"$RESOLUTION"_corrected_matrix.h5
title = "$LABEL"_"$RESOLUTION"
# depth is the maximum distance plotted in bp. In Hi-C tracks
# the height of the track is calculated based on the depth such
# that the matrix does not look deformed
depth = "$DEPTH"
colormap = Reds
file_type = hic_matrix
show_masked_bins = false

[tads]
file = "$LABEL"_"$RESOLUTION"merged_to_"$RESFOUR"_corrected_1_05_TADs_Domains.bed
file_type = domains 
title = "$RESFOUR" TADs
display=triangles
border_color = black
color = none
# the tads are overlay over the hic-matrix
# the share-y options sets the y-axis to be shared
# between the Hi-C matrix and the TADs.
overlay_previous = share-y

[spacer]
height = 0.5

[hic matrix]
file = "$LABEL"_"$RESOLUTION"_corrected_matrix.h5
title = "$LABEL"_"$RESOLUTION"
# depth is the maximum distance plotted in bp. In Hi-C tracks
# the height of the track is calculated based on the depth such
# that the matrix does not look deformed
depth = "$DEPTH"
colormap = Reds
file_type = hic_matrix
show_masked_bins = false

[tads]
file = "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_corrected_1_05_TADs_Domains.bed
file_type = domains 
title = "$RESTHREE" TADs
display=triangles
border_color = black
color = none
# the tads are overlay over the hic-matrix
# the share-y options sets the y-axis to be shared
# between the Hi-C matrix and the TADs.
overlay_previous = share-y

[spacer]
height = 0.5

[hic matrix]
file = "$LABEL"_"$RESOLUTION"_corrected_matrix.h5
title = "$LABEL"_"$RESOLUTION"
# depth is the maximum distance plotted in bp. In Hi-C tracks
# the height of the track is calculated based on the depth such
# that the matrix does not look deformed
depth = "$DEPTH"
colormap = Reds
file_type = hic_matrix
show_masked_bins = false

[tads]
file = "$LABEL"_"$RESOLUTION"merged_to_"$RESTWO"_corrected_1_05_TADs_Domains.bed
file_type = domains 
title = "$RESTWO" TADs
display=triangles
border_color = black
color = none
# the tads are overlay over the hic-matrix
# the share-y options sets the y-axis to be shared
# between the Hi-C matrix and the TADs.
overlay_previous = share-y

[spacer]
height = 0.5

[bed file test]
file = "$GENEFILE"
height = 10
title = Genes
fontsize = 12
file_type = bed\" > hic_track.ini

hicPlotTADs --tracks hic_track.ini -o "$LABEL"_hic_track.png --region "$REGION"

hicDetectLoops -m "$LABEL"_"$RESOLUTION"_corrected_matrix.h5 -o "$LABEL"_"$RESOLUTION"_loops.bedgraph --maxLoopDistance 4000000 --windowSize 10 --peakWidth 6 --pValuePreselection 0.05 --pValue 0.05
hicPlotMatrix -m "$LABEL"_"$RESOLUTION"_corrected_matrix.h5 -o "$LABEL"_"$RESOLUTION"_loops_plot.pdf --log1p --region "$REGION" --loops "$LABEL"_"$RESOLUTION"_loops.bedgraph

conda deactivate" > hicexplorer_TADs_and_Loops.txt
