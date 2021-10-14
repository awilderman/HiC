# Validate loops with overlap with CTCF or cohesin protein data
# part of script will write an .ini file to show the TADs relative to the ChIP data
# as written requires a peak file and bigwig

export MAIL=awilderman@uchc.edu
export MCSOURCE="/home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer"
export OUTDIR=/home/FCAM/awilderman/ANALYSIS/HiC/CNCC/HiCExplorer
export HICPRODIR="/home/FCAM/awilderman/ANALYSIS/HiC/Lyu_H9"
export SAMPLE=fastq
export LABEL=H9
export RESOLUTION=10000
export CHIP=CTCF
export CHIPPATH="/home/FCAM/awilderman/ANALYSIS/ChIP-seq/Human/Neural_Rosette_H9_CNCC/macs2"
export CHIPFILE=CTCF_H9_rep1_sorted_peaks.broadPeak
export BWFILE=CTCF_H9_rep1.pval.signal.bw
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
#SBATCH --mail-user="$MAIL"
#SBATCH -o HiCExplorer_detect_allchr_%j.out
#SBATCH -e HiCExplorer_detect_allchr_%j.err

source "$MCSOURCE"/.bashrc_miniconda3
conda activate "$MCSOURCE"/hicexplorer

cd "$OUTDIR"

# defaults or recommended parameters for 10Kb resolution

hicDetectLoops --matrix "$LABEL"_"$RESOLUTION"_corrected_matrix.h5 --outFileName "$LABEL"_loops_all_chr.bedgraph --peakWidth 6 \
--windowSize 10 --pValuePreselection 0.1 --peakInteractionsThreshold 10 \
--obsExpThreshold 1.5 --pValue 0.025 --maxLoopDistance 2000000 \
--threads 4 --threadsPerChromosome 4 --expected mean

                      
hicValidateLocations --data "$LABEL"_loops_all_chr.bedgraph --protein "$CHIPPATH"/"$CHIPFILE" \
--method loops --resolution "$RESOLUTION" --outFileName "$LABEL"_with_CHIP_all_chr --addChrPrefixLoops --addChrPrefixProtein

# Make a summary plot showing the hic and TADs relative to a p-value plot for ChIP data

echo \"[x-axis]
where = top

[hic matrix]
file = "$LABEL"_"$RESOLUTION"_corrected_matrix.h5
title = "$LABEL"
# depth is the maximum distance plotted in bp. In Hi-C tracks
# the height of the track is calculated based on the depth such
# that the matrix does not look deformed
depth = "$DEPTH"
transform = log1p
file_type = hic_matrix
colormap = Reds

[tads]
file = "$LABEL"_"$RESOLUTION"merged_to_"$RESTHREE"_corrected_1_05_TADs_Domains.bed
file_type = domains 
title = TADs_"$RESTHREE"
display=triangles
border_color = black
color = none
# the tads are overlay over the hic-matrix
# the share-y options sets the y-axis to be shared
# between the Hi-C matrix and the TADs.
overlay_previous = share-y

[spacer]
height = 0.5

[bedgraph of loops]
"$LABEL"_loops_all_chr.bedgraph

[bigwig nans to zeros]
file = "$CHIPPATH"/"$BWFILE"
file_type = bigwig
color = black
height = 5
nans_to_zeros = true
title = "$CHIP" ChIP pval signal

[spacer]
height = 0.5

[bed file of genes]
file = /home/FCAM/awilderman/ANALYSIS/HiC/Human/CS17_03-29-21/HiCExplorer/region_genes.bed
height = 7
title = Genes
fontsize = 12
file_type = bed\" > "$LABEL"_with_ChIP.ini

hicPlotTADs --tracks "$LABEL"_with_ChIP.ini -o "$LABEL"_hic_with_ChIP_track.png --region "$REGION"

conda deactivate" > hicexplorer_with_ChIP.slurm
