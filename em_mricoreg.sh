# Register data to T1
#!/bin/bash

# Load modules
module unload fsl/5.0.10
module load fsl/6.0.1
module load freesurfer/7.1.0
subject=${1}
mov="${subject}_AV-1451_R1_Neuro"
brain="${subject}.brain.nii.gz"
fwhm="4"

cd $subject

mri_coreg --mov ${mov}.nii --ref ${brain} --reg ${mov}_coreg.lta
mri_vol2vol --mov ${mov}.nii --targ ${brain} --lta ${mov}_coreg.lta --trilin --o ${mov}_Anat.nii
fslmaths ${mov}_Anat.nii -kernel gauss ${fwhm} -fmean ${mov}_Anat_sm${fwhm}.nii
fslmaths ${subject}.brain.mask.nii.gz -kernel gauss ${fwhm} -fmean ${subject}.brain.mask.sm${fwhm}.nii
#divide the result from step 1 by the result from step 2 and save this
fslmaths ${mov}_Anat_sm${fwhm}.nii -div ${subject}.brain.mask.sm${fwhm}.nii  ${mov}_Anat_sm${fwhm}.out.nii
