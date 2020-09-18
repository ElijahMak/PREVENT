#!/bin/bash

# Coregister DTI scalar maps to T1 to enable ROI measurements in native T1 space

# Module
module unload fsl/5.0.10
module unload fsl/6.0.1
module load fsl/6.0.3
module load freesurfer/7.1.0

# Subject
subject="${1}"
cd $subject

# Check if FLIRT registration of FA to T1 has been done previously

if [ -f FAtoT1_NMI.mat ]
then
echo "FLIRT of FA to T1 has been done"
echo "Skipping FLIRT to apply warps now"
else
echo "FLIRT of FA to T1 not done"
echo "Running FLIRT of FA to T1 now"
# Register FA to T1
flirt -in dti_FA.nii.gz -ref T1w_${subject}_BFC_brain.nii -dof 6 -cost normmi -omat FAtoT1_NMI.mat -out FAtoT1_NMI
fi

# Warp MD to T1
applywarp -i dti_MD.nii.gz -o MDtoT1_NMI --premat=FAtoT1_NMI.mat -r T1w_${subject}_BFC_brain.nii

# Warp RD to T1
applywarp -i dti_RD.nii.gz -o RDtoT1_NMI --premat=FAtoT1_NMI.mat -r T1w_${subject}_BFC_brain.nii

# Create WM mask from FAST
if [ -f  T1w_${subject}_BFC_brain_pve_2_mask_50.nii ]
then
echo "Binarised WM from FAST is available. Skipping mri_binarize."
else
mri_binarize --i T1w_${subject}_BFC_brain_pve_2.nii --min 0.5 --o T1w_${subject}_BFC_brain_pve_2_mask_50.nii
fi
