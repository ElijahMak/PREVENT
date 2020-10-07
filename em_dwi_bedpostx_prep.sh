# Prepare images for BEDPOSTX
cd $prevent/dwi_denoised
i=${1}
cp ${i}/dwi.denoised.nii $prevent/BEDPOSTX/${i}/data.nii
cp ${i}/bval $prevent/BEDPOSTX/${i}/bvals
cp ${i}/bvec $prevent/BEDPOSTX/${i}/bvecs
cp ${i}/b0_brain_mask.nii.gz $prevent/BEDPOSTX/${i}/nodif_brain_mask.nii.gz
cp ${i}/acqparams.txt $prevent/BEDPOSTX/${i}/acqparams.txt
cp ${i}/index.txt $prevent/BEDPOSTX/${i}/index.txt
