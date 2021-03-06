# DWI  Extract
# Author: Elijah Mak
# Date : 16th Septmember 2020

# Objectives
# Extract mean FA / DWI values after FA volumes have been coregistered to the T1
# using FLIRT in FSL. Applywarp is applied to other scalar maps (MD) to bring them 
# into common space. T1 was first bias-corrected (Marialena), tissue volumes of GM
# WM and CSF were segmented using FSL FAST.  WM masks were created after using 
# Freesurfer mri_binarize at 50% threshold.

# Updates
# 16th Sept 2020: Added RD 

# Subject
subject=${1}
cd $subject

# Parameters
fa="FAtoT1_NMI"
md="MDtoT1_NMI"
rd="RDtoT1_NMI"
mask="T1w_${subject}_BFC_brain_pve_2_mask_50.nii"

# Run script
# RD

if [ -f ${rd}.nii.gz ]
then
date >> mean_${rd}.txt
echo  $PWD  >> mean_${rd}.txt
echo "fslstats -t ${rd}.nii.gz -k $mask -M" >> mean_${rd}.txt
fslstats -t ${rd}.nii.gz -k $mask -M >> mean_${rd}.txt
echo "${subject} extracted."
else
echo  $PWD  >> mean_${rd}.txt
echo "fslstats -t ${rd}.nii.gz -k $mask -M" >> mean_${rd}.txt
echo "${rd} not found" >> mean_${rd}.txt
echo "${subject} failed due to missing files."
fi
