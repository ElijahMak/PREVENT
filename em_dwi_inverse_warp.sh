# Inverse transform JHU labels from FMRIB space into the native diffusion displaySpace

# Author: Elijah MAK

# subject
subject=${1}

cd /lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/
cd $subject

mkdir warped_jhu

fa="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA.nii"

invwarp --warp=dti_FA_fnirt_FMRIB58.mat.nii --ref=dti_FA.nii --out=invwarp_FMRIB_to_FA

for i in {1..48}

do

  applywarp -i /lustre/archive/p00423/PREVENT_Elijah/data/em_jhu_toolbox/${i}.nii.gz -o warped_jhu/${i}.nii.gz -r ${fa} -w invwarp_FMRIB_to_FA.nii.gz --interp=nn

done
