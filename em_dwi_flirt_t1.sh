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

fa="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA.nii"

md="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_MD.nii"

rd="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_RD.nii"

odi="/lustre/archive/p00423/PREVENT_Elijah/NODDI/${subject}/ODI.nii.gz"

t1_brain="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/T1w_${subject}_cat12_brain.nii.gz"

# Register FA to T1
#flirt -in ${fa} -ref ${t1_brain} -dof 6 -cost normmi -omat fa_flirt_cat12brain.mat -out fa_flirt_cat12brain

# Warp MD to T1
#applywarp -i ${md} -o md_flirt_cat12brain --premat=/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/fa_flirt_cat12brain.mat -r ${t1_brain}

# Warp RD to T1
#applywarp -i dti_RD.nii -o rd_flirt_cat12brain --premat=/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/fa_flirt_cat12brain.mat -r ${t1_brain}

# Warp ODI to T1
applywarp -i ${odi} -o odi_flirt_cat12brain --premat=/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/fa_flirt_cat12brain.mat -r ${t1_brain}
