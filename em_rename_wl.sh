subject=${1}
cd $subject

mv T1w_${subject}A_BFC_brain_mixeltype.nii T1w_${subject}_BFC_brain_mixeltype.nii
mv T1w_${subject}A_BFC_brain.nii T1w_${subject}_BFC_brain.nii
mv T1w_${subject}A_BFC_brain_pve_0.nii T1w_${subject}_BFC_brain_pve_0.nii
mv T1w_${subject}A_BFC_brain_pve_1.nii T1w_${subject}_BFC_brain_pve_1.nii
mv T1w_${subject}A_BFC_brain_pve_2.nii T1w_${subject}_BFC_brain_pve_2.nii
mv T1w_${subject}A_BFC_brain_pveseg.nii T1w_${subject}_BFC_brain_pveseg.nii
mv T1w_${subject}A_BFC_brain_seg.nii T1w_${subject}_BFC_brain_seg.nii
mv T1w_${subject}A_BFC.nii T1w_${subject}_BFC.nii

