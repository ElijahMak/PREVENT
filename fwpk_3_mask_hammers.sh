module load freesurfer/7.1.0
subject=${1}

cd $subject

# mri_binarize --i p1${subject}.nii --min 0.5 --o gm_mask_50.nii
# mri_binarize --i p1${subject}.nii --min 0.9 --o gm_mask_90.nii
# mri_binarize --i p1${subject}.nii --min 0.2 --o gm_mask_20.nii
#
# mri_binarize --i p2${subject}.nii --min 0.5 --o wm_mask_50.nii
# mri_binarize --i p2${subject}.nii --min 0.9 --o wm_mask_90.nii
# mri_binarize --i p2${subject}.nii --min 0.2 --o wm_mask_20.nii

#fslmaths hammers/w${subject}_Hammers_mith_icbm_psp.nii -mul gm_mask_50.nii hammers/w${subject}_Hammers_mith_icbm_psp_gm_mask_50.nii

# fslmaths hammers/w${subject}_Hammers_mith_icbm_psp.nii -mul gm_mask_90.nii hammers/w${subject}_Hammers_mith_icbm_psp_gm_mask_90.nii

# fslmaths hammers/w${subject}_Hammers_mith_icbm_psp.nii -mul gm_mask_20.nii hammers/w${subject}_Hammers_mith_icbm_psp_gm_mask_20.nii

fslmaths hammers/w${subject}_Hammers_mith_icbm_psp.nii -mul wm_mask_50.nii hammers/w${subject}_Hammers_mith_icbm_psp_wm_mask_50.nii
