# HiC
Set of scripts for processing HiC data

### Create matrix with HiC-Pro (the original pipeline)
HiC-Pro_script.Rmd

HiCPlotter_example.md

### Convert format of matrix (to analyze and create multi-layered plots of individual matrix or many matrices with HiCExplorer or Juicer)
convert_format.sh (writes a slurm script to use HiCExplorer to convert hic-pro files to .h5, .cool or .mcool)

convert_to_Juicer_format.sh (writes a slurm script to convert hic-pro .bwt2pairs.bam to .hic for visualization in Juicer)

### Analyze an individual matrix
1) merge_and_diagostic.sh (writes a slurm script to merge bins e.g. 10Kb merged to 50Kb, 100Kb, 500Kb and produce diagnostic plots that you view to determine the correction thresholds)

2) correct_and_call.sh (writes and all-in-one slurm script to ICE correct the matrices at various resolutions, detect TADs, plot a 10Kb resolution hic matrix with TADs detected at various resolutions overlaid, detect loops, plot the loops on a diagonal matrix. Note: writes a .txt version of the slurm script to remind you to manually enter the threshold values!!)

### Compare two or more matrices

### Extra and alternative methods










## Notes for me from installation of HiCExplorer:

https://github.com/deeptools/HiCExplorer/archive/refs/heads/master.zip

https://github.com/deeptools/HiCExplorer/archive/refs/tags/3.7.zip

Note: HiC-Pro for resolutions at 5kb, 10kb, lower resolutions using merge in HiCExplorer

will re-do HiCPro at only these resolutions to conserve storage space

### Justin installed and I can make symbolic links to use:
ln -s /home/FCAM/jcotney/.bashrc_miniconda3 .bashrc_miniconda3

ln -s /home/FCAM/jcotney/miniconda3/envs/hicexplorer hicexplorer
