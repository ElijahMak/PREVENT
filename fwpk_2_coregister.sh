# Register b0 to T1
# Warp FW to T1

cd /archive/p00423/PREVENT_Elijah/FWPK

i=${1}

cd ${i}

# Register b0 to T1
flirt -in denoised_degibbs_dwi_b0.nii -ref ${i}_cat12_brain.nii.gz -dof 6 -cost normmi -omat b0_flirt_cat12_brain.mat -out denoised_degibbs_dwi_b0_flirt.nii

# Warp FW maps
applywarp -i noddi_fiso.nii.gz -o noddi_fiso_t1.nii.gz  --premat=b0_flirt_cat12_brain.mat -r ${i}_cat12_brain.nii.gz
