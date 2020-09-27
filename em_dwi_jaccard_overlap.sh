# Compute the overlap between registered FA and MNI152_T1_1mm_brain_mask

# Author: Elijah Mak

# Module
module load freesurfer/7.1.0

# Subject
subject=${1}
cd ${subject}

# Binarise FA map
mri_binarize --i dti_FA_fnirt_FMRIB58.nii --min 0.0001 --o dti_FA_fnirt_FMRIB58_mask.nii

mri_compute_overlap dti_FA_fnirt_FMRIB58_mask.nii $prevent/templates/MNI152_T1_1mm_brain_mask.nii.gz -a > em_dwi_mni152_overlap.txt

# output
#label 0: volume diff = |(5358085 - 5393789)| / 5375937.0 (%)= 0.66%
#label 0: volume overlap (Dice) = 5274673 / 5375937.0 (%)= 98.12%
#label 0: volume overlap (Jaccard) = 5274673 / 5477201.0 (%)= 96.30%

# Extract Jaccard overlap

grep -A 2 "Jaccard" em_dwi_mni152_overlap.txt | awk '{ print $11 }' > em_dwi_mni152_overlap_jaccard.txt
