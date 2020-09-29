# MNI transformation of DTI maps
# Link:  https://www.brown.edu/carney/mri/researchers/analysis-pipelines/dti#step5
# Author: Elijah Mak
# Date: 17th September 2020

# Objective
# To warp DTI maps to FMRIB for ROI analysis using JHU atlas

# Module
module unload fsl/5.0.10
module unload fsl/6.0.1
module load fsl/6.0.3

# Parameters
subject=${1}
cd $subject

# Initial FLIRT
FA="dti_FA.nii"
MD="dti_MD.nii"
RD="dti_RD.nii"
ref="/lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz"
flirt_out="dti_FA_flirt_FMRIB58.nii"
omat="dti_FA_flirt_FMRIB58.mat"
bins="256"
cost="corratio"
dof="12"
interp="trilinear"
cout="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA_fnirt_FMRIB58.mat"
FA_fnirt_out="dti_FA_fnirt_FMRIB58.nii"
MD_fnirt_out="dti_MD_fnirt_FMRIB58.nii"
RD_fnirt_out="dti_RD_fnirt_FMRIB58.nii"

# Apply warp

## FA
#applywarp --ref=${ref} --in=$FA --warp=$cout \
--out=${FA_fnirt_out}

# MD
#applywarp --ref=${ref} --in=$MD --warp=$cout \
--out=${MD_fnirt_out}

# RD
applywarp --ref=${ref} --in=$RD --warp=$cout \
--out=${RD_fnirt_out}
