# Register data to T1
#!/bin/bash

# Load modules
module unload fsl/5.0.10
module load fsl/6.0.1
module load freesurfer/7.1.0

subject=${1}
mov="${subject}_AV-1451_R1_Radio"
mov2="${subject}_AV-1451_BP_Radio"
mov3="${subject}_PIB_SUVR_Radio"
mov4="${subject}_PK_mean_Radio"
mov5="${subject}_wRPMV_BP_Radio"
brain="${subject}.brain.nii.gz"
fwhm="4"
cd $subject

# AV1451 R1
# mri_coreg --mov ${mov}.nii --ref ${brain} --reg ${mov}_coreg.lta

mri_vol2vol --mov ${mov}.nii --targ ${brain} --lta ${mov}_coreg.lta --trilin --o ${mov}_Anat.nii
fslmaths ${mov}_Anat.nii -kernel gauss ${fwhm} -fmean ${mov}_Anat_sm${fwhm}.nii

# AV1451 BP
mri_vol2vol --mov ${mov2}.nii --targ ${brain} --lta ${mov}_coreg.lta --trilin --o ${mov2}_Anat.nii
fslmaths ${mov2}_Anat.nii -kernel gauss ${fwhm} -fmean ${mov2}_Anat_sm${fwhm}.nii

# PIB SUVR
# mri_coreg --mov ${mov3}.nii --ref ${brain} --reg ${mov3}_coreg.lta
mri_vol2vol --mov ${mov3}.nii --targ ${brain} --lta ${mov3}_coreg.lta --trilin --o ${mov3}_Anat.nii
fslmaths ${mov3}_Anat.nii -kernel gauss ${fwhm} -fmean ${mov3}_Anat_sm${fwhm}.nii

# PK Mean and BP
# mri_coreg --mov ${mov4}.nii --ref ${brain} --reg ${mov4}_coreg.lta
mri_vol2vol --mov ${mov4}.nii --targ ${brain} --lta ${mov4}_coreg.lta --trilin --o ${mov4}_Anat.nii
fslmaths ${mov4}_Anat.nii -kernel gauss ${fwhm} -fmean ${mov4}_Anat_sm${fwhm}.nii
mri_vol2vol --mov ${mov5}.nii --targ ${brain} --lta ${mov4}_coreg.lta --trilin --o ${mov5}_Anat.nii
fslmaths ${mov5}_Anat.nii -kernel gauss ${fwhm} -fmean ${mov5}_Anat_sm${fwhm}.nii
