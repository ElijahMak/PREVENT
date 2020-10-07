# Prepare images for BEDPOSTX
cd $prevent/dwi_denoised
i=${1}
cp ${i}/dwi.denoised.nii BEDPOSTX/${i}/data.nii
cp ${i}/bval BEDPOSTX/${i}/bvals
cp ${i}/bvec BEDPOSTX/${i}/bvecs
cp ${i}/b0_brain_mask.nii.gz BEDPOSTX/${i}/nodif_brain_mask.nii.gz
cp ${i}/acqparams.txt BEDPOSTX/${i}/acqparams.txt
cp ${i}/index.txt BEDPOSTX/${i}/index.txt
a
