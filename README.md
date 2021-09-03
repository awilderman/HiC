# HiC
Set of scripts for processing HiC data

### Create matrix with HiC-Pro
HiC-Pro_script.Rmd
HiCPlotter_example.md

### Convert format of matrix
convert_format.sh (writes a slurm script to use HiCExplorer to convert hic-pro files to .h5, .cool or .mcool)
convert_to_Juicer_format.sh (writes a slurm script to convert hic-pro .bwt2pairs.bam to .hic)

### Analyze an individual matrix


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
