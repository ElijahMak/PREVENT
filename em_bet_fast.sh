# Perform BET extraction and FAST segmentation 
# for GM, WM and CSF volumes.

# Author: Elijah Mak
# Date : 17th September 2020

# Objectives
# Enable simple statistics of volumes in native T1
# Enable calculation of mean DWI / myelin metrics 

# Module
module unload fsl/5.0.10
module load fsl/6.0.1

# Subject
i=${1}
cd ${i}

# Parameters
t1_bfc="T1w_${i}_BFC.nii"

# Run BET with default settings
bet ${t1_bfc} ${t1_bfc}_brain

# Run FAST
fast ${t1_bfc}_brain

# To generate images for QC of segmentations, run em_qc_segmentations.sh
