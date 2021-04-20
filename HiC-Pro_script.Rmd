HiC Pipeline for UCHC HPC
================

Please note
-----------

The scripts included in this document are formatted for use with a slurm scheduler, where applicable

The citation for the packages being used are:

HiC-Pro: Servant N., Varoquaux N., Lajoie BR., Viara E., Chen CJ., Vert JP., Dekker J., Heard E., Barillot E. HiC-Pro: An optimized and flexible pipeline for Hi-C processing. Genome Biology 2015, 16:259 <doi:10.1186/s13059-015-0831-x>

<https://github.com/nservant/HiC-Pro>

HiC-Pro
-------

### create the config file

    export ANALYSISDIR=#<location where you want new analysis directory created, not desired directory name>
    export SAMPLE=
    export JOB_NAME=${SAMPLE}_HiC-Pro
    export MAIL=
    export BOWTIE2_IDX_PATH=
    export REFERENCE_GENOME=
    export GENOME_SIZE=#<path to .chrom.sizes file>
    export GENOME_FRAGMENT=#<path to _resfrag_*.bed>  
    export LIGATION_SITE=# DpnII:GATCGATC, HindIII:AAGCTAGCTT


    # double-check the names of your fastq(.gz) files, expects read 1 and read 2 to have _R1 and _R2 identifiers. Change filename or config file to match
    # The bin sizes will be 50000 10000 20000 40000 100000 500000 1000000 : this is a good range to start
    # No max or min fragment or insert size specified, change if desired

    echo "#########################################################################

    ## Paths and Settings  - Do not edit !

    #########################################################################

    TMP_DIR = tmp

    LOGS_DIR = logs

    BOWTIE2_OUTPUT_DIR = bowtie_results

    MAPC_OUTPUT = hic_results

    RAW_DIR = rawdata

    #######################################################################

    ## SYSTEM - PBS - Start Editing Here !!

    #######################################################################

    N_CPU = 8

    LOGFILE = hicpro.log

    JOB_NAME = ${JOB_NAME}

    JOB_MEM = 8G

    JOB_WALLTIME = 100:00:00

    JOB_QUEUE = general

    JOB_MAIL = ${MAIL}

    #########################################################################

    ## Data

    #########################################################################

    PAIR1_EXT = _R1

    PAIR2_EXT = _R2

    #######################################################################

    ## Alignment options

    #######################################################################

    FORMAT = phred33

    MIN_MAPQ = 0

    BOWTIE2_IDX_PATH = ${BOWTIE2_IDX_PATH}

    BOWTIE2_GLOBAL_OPTIONS = --very-sensitive -L 30 --score-min L,-0.6,-0.2 --end-to-end --reorder

    BOWTIE2_LOCAL_OPTIONS =  --very-sensitive -L 20 --score-min L,-0.6,-0.2 --end-to-end --reorder

    #######################################################################

    ## Annotation files

    #######################################################################

    REFERENCE_GENOME = ${REFERENCE_GENOME}

    GENOME_SIZE = ${GENOME_SIZE}

    #######################################################################

    ## Allele specific

    #######################################################################

    ALLELE_SPECIFIC_SNP = 

    #######################################################################

    ## Digestion Hi-C

    #######################################################################

    GENOME_FRAGMENT = ${GENOME_FRAGMENT}

    LIGATION_SITE = ${LIGATION_SITE}

    MIN_FRAG_SIZE = 

    MAX_FRAG_SIZE =

    MIN_INSERT_SIZE =

    MAX_INSERT_SIZE =

    #######################################################################

    ## Hi-C processing

    #######################################################################

    MIN_CIS_DIST = 1000

    GET_ALL_INTERACTION_CLASSES = 1

    GET_PROCESS_SAM = 0

    RM_SINGLETON = 1

    RM_MULTI = 1

    RM_DUP = 1

    #######################################################################

    ## Contact Maps

    #######################################################################

    BIN_SIZE = 50000 10000 20000 40000 100000 500000 1000000

    MATRIX_FORMAT = upper

    #######################################################################

    ## ICE Normalization

    #######################################################################

    MAX_ITER = 100

    FILTER_LOW_COUNT_PERC = 0.02

    FILTER_HIGH_COUNT_PERC = 0

    EPS = 0.1" > ${SAMPLE}_config.txt

### RUN HIC-PRO INITIAL COMMAND

This command creates the directory to contain the bowtie and hic results, it will also create two slurm scripts to launch and they will be found within the newly-created directory.

`HIC-PRO_INSTALL_PATH/bin/HiC-Pro -i FULL_PATH_TO_DATA_FOLDER -o FULL_PATH_TO_OUTPUTS -c ${SAMPLE}_config.txt -p`

The full path to the outputs will likely be `${ANALYSISDIR}/${SAMPLE}`

#### Edit the scripts to suit the slurm scheduler

Edit HiCPro\_step1\_${JOB\_NAME}.sh and HiCPro\_step2\_${JOB\_NAME}.sh to include proper qos specification needed by UCHC HPC and modules

Header should look like this:

    #!/bin/bash
    #SBATCH -N 1
    #SBATCH -n 8 
    #SBATCH -t 100:00:00
    #SBATCH --mem-per-cpu=8G
    #SBATCH -p general
    #SBATCH --qos=general
    #SBATCH --mail-user=
    #SBATCH --mail-type=end
    #SBATCH --job-name=
    #SBATCH --export=ALL
    #SBATCH --array=#<automatically generated>

    module load python/2.7.14
    module load libstdc++/6.0.10
    module load libstdc++/6.0.13
    module load R/3.4.1
    module load gcc/4.9.1
    module load htslib/1.7
    module load zlib/1.2.11
    module load libncurses/4.0
    module load samtools/1.7
    module load bowtie2/2.2.9
    module load BEDtools/2.26.0
    export PYTHON_PATH=~/.local/lib/python2.7/site-packages

### Then submit HiCPro in a chain:

    cd ${ANALYSISDIR}/${SAMPLE}
    FIRST=$(sbatch --parsable HiCPro_step1_${JOB_NAME}.sh)
    echo $FIRST
    SECOND=$(sbatch --parsable --dependency=afterok:$FIRST HiCPro_step2_${JOB_NAME}.sh)

### HiCPro Outputs

#### The first set of outputs are graphs of the mapping quality and breakdown of types of pairs.

Of interest are: plotMapping\_*.pdf : Statistics of read alignments for read1 and read2 plotMappingPairing\_*.pdf : Breakdown of reported pairs, unmapped pairs and not reported ("filtered") pairs plotHiCFragment\_*.pdf : Statistics on types of valid and invalid pairs plotHiCFragmentSize\_*.pdf : Fragment size distribution of the valid pairs plotHiCContactRanges\_\*.pdf : Statistics on contact ranges for valid pairs (Trans, Cis short- or long-distance)

<img src="/Users/awilderman/Dropbox/Cotney_Lab/Capture_Hi-C/HiC/2020-02-01_NoLimits_CNCC_H9/pic-NoLimits/pic/AWIL064/plotMapping_AWIL064.pdf" alt="plotMapping.pdf" width="900" />
<p class="caption">
plotMapping.pdf
</p>

<img src="/Users/awilderman/Dropbox/Cotney_Lab/Capture_Hi-C/HiC/2020-02-01_NoLimits_CNCC_H9/pic-NoLimits/pic/AWIL064/plotMappingPairing_AWIL064.pdf" alt="plotMappingPairing.pdf" width="900" />
<p class="caption">
plotMappingPairing.pdf
</p>

<img src="/Users/awilderman/Dropbox/Cotney_Lab/Capture_Hi-C/HiC/2020-02-01_NoLimits_CNCC_H9/pic-NoLimits/pic/AWIL064/plotHiCFragment_AWIL064.pdf" alt="plotHiCFragment.pdf" width="900" />
<p class="caption">
plotHiCFragment.pdf
</p>

<img src="/Users/awilderman/Dropbox/Cotney_Lab/Capture_Hi-C/HiC/2020-02-01_NoLimits_CNCC_H9/pic-NoLimits/pic/AWIL064/plotHiCFragmentSize_AWIL064.pdf" alt="plotHiCFragmentSize.pdf" width="900" />
<p class="caption">
plotHiCFragmentSize.pdf
</p>

<img src="/Users/awilderman/Dropbox/Cotney_Lab/Capture_Hi-C/HiC/2020-02-01_NoLimits_CNCC_H9/pic-NoLimits/pic/AWIL064/plotHiCContactRanges_AWIL064.pdf" alt="plotHiCContactRanges.pdf" width="900" />
<p class="caption">
plotHiCContactRanges.pdf
</p>

#### The other set of HiC-Pro outputs are the matrices, which can be analyzed and visualized using other packages
