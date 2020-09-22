# Myelin  Extract
# Author: Elijah Mak
# Date : 22nd Septmember 2020

# Objectives
# Extract mean myeline values in native T1 after myelin maps were generated from
# coregistered T2/T1 FLIRT in FSL. T1 was first bias-corrected (Marialena), tissue volumes of GM
# WM and CSF were segmented using FSL FAST. GM and WM masks were created after using 
# Freesurfer mri_binarize at 20% and 90% threshold respectively.

# Updates


# Module
module load freesurfer/6.0.0
# Subject
subject=${1}
cd $subject

# Parameters
MYELIN="${subject}_myelin.nii"
GM_mask="T1w_${subject}_BFC_brain_pve_1_mask_20.nii"
WM_mask="T1w_${subject}_BFC_brain_pve_2_mask_90.nii"

# Run script

# Create GM mask from FAST
mri_binarize --i T1w_${subject}_BFC_brain_pve_1.nii --min 0.2 --o T1w_${subject}_BFC_brain_pve_1_mask_20.nii

# Create WM mask from FAST
mri_binarize --i T1w_${subject}_BFC_brain_pve_2.nii --min 0.9 --o T1w_${subject}_BFC_brain_pve_2_mask_90.nii

# Extract GM
date >> mean_GM_${MYELIN}.txt
echo  $PWD  >> mean_GM_${MYELIN}.txt
echo "fslstats -t ${MYELIN} -k $GM_mask -M" >> mean_GM_myelin.txt
fslstats -t ${MYELIN} -k $GM_mask -M >> mean_GM_myelin.txt
echo "${subject} GM MYELIN extracted."

# Extract WM
date >> mean_WM_${MYELIN}.txt
echo  $PWD  >> mean_WM_${MYELIN}.txt
echo "fslstats -t ${MYELIN} -k $WM_mask -M" >> mean_WM_myelin.txt
fslstats -t ${MYELIN} -k $WM_mask -M >> mean_WM_myelin.txt
echo "${subject} WM MYELIN extracted."
