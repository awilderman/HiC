HiCPlotter for UCHC HPC
================
_________
Illustrates comparison between Fetal Heart HiC and Cardiomyocyte HiC

HiCPlotter Example
_________

### Run HiCPlotter interactively

	srun -N 1 -p general --qos general -n 1 --mem=32G --pty bash
	module load python/2.7.14
	export PYTHON_PATH=~/.local/lib/python2.7/site-packages
	export ANALYSISDIR=
	export HICPLOTTERDIR=
	export MATRIXDIR=

	cd $ANALYSISDIR

	# Fetal
	# Chromosome level (1Mb) Chr7 as example
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/1000000/Fetal_1000000_iced.matrix  -chr chr7 -o Fetal_1000000 -r 1000000 -tri 1 -n Fetal_1000000 -bed $MATRIXDIR/matrix/Fetal/raw/1000000/Fetal_1000000_abs.bed  

	# Region level (10Kb-50Kb) HOXA LCR region as example
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/10000/Fetal_10000_iced.matrix -chr chr7 -o Fetal_10000 -r 10000 -tri 1 -n Fetal_10000 -bed $MATRIXDIR/matrix/Fetal/raw/10000/Fetal_10000_abs.bed -s 2400 -e 2900 # start and end bins change with resolution
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/20000/Fetal_20000_iced.matrix -chr chr7 -o Fetal_20000 -r 20000 -tri 1 -n Fetal_20000 -bed $MATRIXDIR/matrix/Fetal/raw/20000/Fetal_20000_abs.bed -s 1200 -e 1450
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/40000/Fetal_40000_iced.matrix -chr chr7 -o Fetal_40000 -r 40000 -tri 1 -n Fetal_40000 -bed $MATRIXDIR/matrix/Fetal/raw/40000/Fetal_40000_abs.bed -s 600 -e 725 
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/50000/Fetal_50000_iced.matrix -chr chr7 -o Fetal_50000 -r 50000 -tri 1 -n Fetal_50000 -bed $MATRIXDIR/matrix/Fetal/raw/50000/Fetal_50000_abs.bed -s 480 -e 580

	# CM
	# Chromosome level (1Mb) Chr7 as example
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/1000000/CM_1000000_iced.matrix  -chr chr7 -o CM_1000000 -r 1000000 -tri 1 -n CM_1000000 -bed $MATRIXDIR/matrix/CM/raw/1000000/CM_1000000_abs.bed  

	# Region level (10Kb-50Kb) HOXA LCR region as example
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/10000/CM_10000_iced.matrix -chr chr7 -o CM_10000 -r 10000 -tri 1 -n CM_10000 -bed $MATRIXDIR/matrix/CM/raw/10000/CM_10000_abs.bed -s 2400 -e 2900
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/20000/CM_20000_iced.matrix -chr chr7 -o CM_20000 -r 20000 -tri 1 -n CM_20000 -bed $MATRIXDIR/matrix/CM/raw/20000/CM_20000_abs.bed -s 1200 -e 1450
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/40000/CM_40000_iced.matrix -chr chr7 -o CM_40000 -r 40000 -tri 1 -n CM_40000 -bed $MATRIXDIR/matrix/CM/raw/40000/CM_40000_abs.bed -s 600 -e 725 
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/50000/CM_50000_iced.matrix -chr chr7 -o CM_50000 -r 50000 -tri 1 -n CM_50000 -bed $MATRIXDIR/matrix/CM/raw/50000/CM_50000_abs.bed -s 480 -e 580 

#### Make the plots look better- add highlights of regions of interest -high/-hf option (bed file of HOXA LCR and HOXA cluster)
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/40000/CM_40000_iced.matrix  -chr chr7 -o CM_40000_v2 -r 40000 -tri 1 -n CM_40000 -bed $MATRIXDIR/matrix/CM/raw/40000/CM_40000_abs.bed -s 600 -e 725 -g ~/ANALYSIS/HiC/new_chr7_genes.bed -high 1 -hf ~/ANALYSIS/HiC/g1_6.bed 
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/40000/Fetal_40000_iced.matrix  -chr chr7 -o Fetal_40000_v2 -r 40000 -tri 1 -n Fetal_40000 -bed $MATRIXDIR/matrix/Fetal/raw/40000/Fetal_40000_abs.bed -s 600 -e 725 -g ~/ANALYSIS/HiC/new_chr7_genes.bed -high 1 -hf ~/ANALYSIS/HiC/g1_6.bed 

#### Making comparisons- at 40K and 10K

	#Comparisons!
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/40000/CM_40000_iced.matrix $MATRIXDIR/matrix/Fetal/iced/40000/Fetal_40000_iced.matrix -chr chr7 -o Compare_CM_and_Fetal_Heart -r 40000 -tri 1 -ptr 1 -n CM Fetal_Heart -bed $MATRIXDIR/matrix/CM/raw/40000/CM_40000_abs.bed -s 600 -e 725 -g ~/ANALYSIS/HiC/new_chr7_genes.bed -high 1 -hf ~/ANALYSIS/HiC/g1_6.bed -c 1 
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/40000/Fetal_40000_iced.matrix  $MATRIXDIR/matrix/CM/iced/40000/CM_40000_iced.matrix -chr chr7 -o Compare_Fetal_Heart_and_CM -r 40000 -tri 1 -ptr 1 -n Fetal_Heart CM -bed $MATRIXDIR/matrix/Fetal/raw/40000/Fetal_40000_abs.bed -s 600 -e 725 -g ~/ANALYSIS/HiC/new_chr7_genes.bed -high 1 -hf ~/ANALYSIS/HiC/g1_6.bed -c 1 

#### Closer look at HOXA cluster itself
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/10000/CM_10000_iced.matrix $MATRIXDIR/matrix/Fetal/iced/10000/Fetal_10000_iced.matrix -chr chr7 -o Compare_CM_and_Fetal_Heart -r 10000 -tri 1 -ptr 1 -n CM Fetal_Heart -bed $MATRIXDIR/matrix/CM/raw/10000/CM_10000_abs.bed -s 270 -e 274 -g ~/ANALYSIS/HiC/new_chr7_genes.bed -high 1 -hf ~/ANALYSIS/HiC/g1_6.bed -c 1 
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/10000/Fetal_10000_iced.matrix  $MATRIXDIR/matrix/CM/iced/10000/CM_10000_iced.matrix -chr chr7 -o Compare_Fetal_Heart_and_CM -r 10000 -tri 1 -ptr 1 -n Fetal_Heart CM -bed $MATRIXDIR/matrix/Fetal/raw/10000/Fetal_10000_abs.bed -s 270 -e 274 -g ~/ANALYSIS/HiC/new_chr7_genes.bed -high 1 -hf ~/ANALYSIS/HiC/g1_6.bed -c 1 

#### Find arcs (interactions) and plot them using HiCPlotter

	#create file for interaction plot 
	cd $MATRIXDIR/data/Fetal
	cat *.validPairs | grep chr7 | cut -f2-3,5-6,12 | awk '{if ($1==$3) print $1"\t"$2"\t"$4"\t"$5}' > Fetal_Heart_chr7_interactions.bg
	cd ../CM
	cat *.validPairs | grep chr7 | cut -f2-3,5-6,12 | awk '{if ($1==$3) print $1"\t"$2"\t"$4"\t"$5}' > CM_chr7_interactions.bg

	cd $MATRIXDIR/data/Fetal
	sort -n -k 2 -o sorted_Fetal_Heart_chr7_interactions.bg Fetal_Heart_chr7_interactions.bg
	#sed -i '1s/^/type=bedGraph\n/' Fetal_Heart_chr7_interactions.bg
	cd ../CM
	sort -n -k 2 -o sorted_CM_chr7_interactions.bg CM_chr7_interactions.bg
	#sed -i '1s/^/type=bedGraph\n/' CM_chr7_interactions.bg

#### Add arcs to the region
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/CM/iced/40000/CM_40000_iced.matrix -chr chr7 -o CM_40000_v3 -r 40000 -tri 1 -n CM_40000 -bed $MATRIXDIR/matrix/CM/raw/40000/CM_40000_abs.bed -s 600 -e 725 -g ~/ANALYSIS/HiC/new_chr7_genes.bed -high 1 -hf ~/ANALYSIS/HiC/g1_6.bed -a $MATRIXDIR/data/CM/sorted_CM_chr7_interactions.bg -al CM_HiC
	python $HICPLOTTERDIR/HiCPlotter.py -f $MATRIXDIR/matrix/Fetal/iced/40000/Fetal_40000_iced.matrix -chr chr7 -o Fetal_Heart_40000_v3 -r 40000 -tri 1 -n Fetal_Heart_40000 -bed $MATRIXDIR/matrix/Fetal/raw/40000/Fetal_40000_abs.bed -s 600 -e 725 -g ~/ANALYSIS/HiC/new_chr7_genes.bed -high 1 -hf ~/ANALYSIS/HiC/g1_6.bed -a $MATRIXDIR/data/Fetal/sorted_Fetal_Heart_chr7_interactions.bg -al Fetal_Heart_HiC