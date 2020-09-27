subject=${1}
cd $subject
fslmaths dti_L2.nii -add dti_L3.nii -div 2 dti_RD.nii
gunzip dti_RD.nii.gz
