# Inverse transform JHU labels from FMRIB space into the native diffusion displaySpace

# Author: Elijah MAK

# subject
subject=${1}
cd $subject

FA="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA.nii"

invwarp --warp=dti_FA_fnirt_FMRIB58.mat.nii \
--ref=dti_FA.nii \
--out=invwarp_FMRIB_to_FA

for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`

do

fslstats -t ${FA} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

applywarp -i /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -o warped_jhu_${i} -r ${FA} -w invwarp_FMRIB_to_FA.nii.gz --interp=nn

done
