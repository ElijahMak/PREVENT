# Register b0 to T1
# Warp FW to T1

i=${1}
cd ${i}
# Register FA to T1
flirt -in ${i}_b0.nii.gz -ref ${i}_cat12_brain.nii -dof 6 -cost normmi -omat ${i}_b0_flirt_cat12_brain.mat -out ${i}_b0_flirt.nii.gz

# Warp FW maps
applywarp -i ${i}.FW.nii.gz -o ${i}.FW.FLIRT.nii.gz  --premat=${i}_b0_flirt_cat12_brain.mat -r ${i}_cat12_brain.nii
