# Compute the volume difference between voxels from MNI152_T1_1mm_brain_mask and normalised FA maps

# Author: Elijah Mak

# Module
module load freesurfer/7.1.0

# Subject
subject=${1}
cd ${subject}

# Binarise FA map
mri_binarize --i dti_FA_fnirt_FMRIB58.nii --min 0.0001 --o dti_FA_fnirt_FMRIB58_mask.nii

# Extract difference maps
fslmaths $prevent/templates/MNI152_T1_1mm_brain_mask.nii.gz -sub dti_FA_fnirt_FMRIB58_mask dti_FA_fnirt_FMRIB58_mask_diff_MNI152

# Threshold difference map, selecting voxels present in MNI152 but not in normalised FA map

mri_binarize --i dti_FA_fnirt_FMRIB58_mask_diff_MNI152.nii.gz --min 1 --o dti_FA_fnirt_FMRIB58_mask_diff_MNI152.nii.gz

# Calculate the volume of difference map
fslstats dti_FA_fnirt_FMRIB58_mask_diff_MNI152 -V > temp
cat temp | awk '{print $1}' > em_dwi_mni152_voldiff.txt
