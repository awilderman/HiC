# HiC
Set of scripts for processing HiC data

### Create matrix with HiC-Pro (the original pipeline)
HiC-Pro_script.Rmd

HiCPlotter_example.md

### Convert format of matrix (analyze and create multi-layered plots with other tools)
convert_format.sh (writes the slurm script "hicexplorer_convert.slurm" to use HiCExplorer to convert hic-pro files to .h5, .cool or .mcool)

convert_to_Juicer_format.sh (writes a slurm script to convert hic-pro .bwt2pairs.bam to .hic for visualization in Juicer)

### Analyze an individual matrix
1) merge_and_diagostic.sh (writes the slurm script "hicexplorer_merge.slurm" to merge bins e.g. 10Kb merged to 50Kb, 100Kb, 500Kb and produce diagnostic plots that you view to determine the correction thresholds)

2) correct_and_call.sh (writes the all-in-one slurm script "hicexplorer_TADs_and_Loops.txt" to ICE correct the matrices at various resolutions, detect TADs, plot a 10Kb resolution hic matrix with TADs detected at various resolutions overlaid, detect loops, plot the loops on a diagonal matrix. Note: writes a .txt version of the slurm script to remind you to manually enter the threshold values!!)

### Compare two or more matrices
1) 

### Extra and alternative methods
make_interact.sh (will create "write_interact.sh" to convert .loops file to UCSC interact format)

make_TADClassifier.sh (writes "hicexplorer_TADClassifier.slurm to call TADs with an alternative method, uses .cool files only)

merge_TAD_method.sh (uses hicMergeDomains to work with TADs called at multiple resolutions, writes "hicexplorer_mergeTAD.slurm")

validate_loops.sh (writes slurm script "hicexplorer_with_ChIP.slurm" to validate loops using ChIP-seq data)







## Notes for me from installation of HiCExplorer:

https://github.com/deeptools/HiCExplorer/archive/refs/heads/master.zip

https://github.com/deeptools/HiCExplorer/archive/refs/tags/3.7.zip

Note: HiC-Pro for resolutions at 5kb, 10kb, lower resolutions using merge in HiCExplorer

will re-do HiCPro at only these resolutions to conserve storage space

### Justin installed and I can make symbolic links to use:
ln -s /home/FCAM/jcotney/.bashrc_miniconda3 .bashrc_miniconda3

ln -s /home/FCAM/jcotney/miniconda3/envs/hicexplorer hicexplorer
