module load freesurfer/7.1.0

dir="/lustre/archive/p00423/PREVENT_Elijah/CAT12"
subject=${1}

#mri_binarize --i ${dir}/mri/p1T1w_${subject}.nii --min 0.2 --o ${dir}/mri/p1T1w_${subject}_mask_20.nii

#mri_binarize --i ${dir}/mri/p2T1w_${subject}.nii --min 0.5 --o ${dir}/mri/p2T1w_${subject}_mask_50.nii

mri_binarize --i ${dir}/mri/p2T1w_${subject}.nii --min 0.90 --o ${dir}/mri/p2T1w_${subject}_mask_90.nii
