# Load modules
module load cuda/8.0
module unload fsl/5.0.10
module load fsl/6.0.3

# Define variables
subject="${1}"
input_edc="dwi.denoised.nii"
mask="b0_brain_mask.nii.gz"
bvec="bvec"
bval="bval"
rotated_bvecs="edc.repol.eddy_rotated_bvecs"
output_edc="edc.repol";
input_dti="edc.repol.nii.gz"
output_dti="dti"

cd $subject

eddy_openmp --imain=$input_edc \
--mask=$mask --acqp=acqparams.txt \
--index=index.txt --bvecs=$bvec \
--bvals=$bval --fwhm=10,0,0,0,0 \
--repol \
--out=$output_edc \
--cnr_maps \
--verbose

dtifit --data=$input_dti  \
--mask=$mask \
--bvecs=$rotated_bvecs \
--bvals=$bval \
--out=$output_dti


dtifit --data=denoised_degibbs.edc.repol.bfc.nii --mask=denoised_degibbs_dwi_b0_brain_f0.2_mask.nii --bvecs=denoised_degibbs.edc.repol.eddy_rotated_bvecs --bvals=bval --out=FSL_DTIdtifit --data=denoised_degibbs.edc.repol.bfc.nii --mask=denoised_degibbs_dwi_b0_brain_f0.2_mask.nii --bvecs=denoised_degibbs.edc.repol.eddy_rotated_bvecs --bvals=bval --out=FSL_DTI

flirt -in FSL_DTI_FA.nii.gz -ref $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz -omat flirt.mat -bins 257 -cost corratio -dof 12 -interp "trilinear" -searchrx -90 90 -searchry -90 90 -searchrz -90 90


flirt -in denoised_degibbs.edc.repol.bfc.tensor.FA.nii -ref $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz -omat flirt_mrtrx.mat -bins 257 -cost corratio -dof 12 -interp "trilinear" -searchrx -90 90 -searchry -90 90 -searchrz -90 90

flirt -in dt_out.nii -ref $FSLDIR/data/standard/FMRIB58_FA_1mm.nii.gz -omat flirt_mrtrx.mat -bins 257 -cost corratio -dof 12 -interp "trilinear" -searchrx -90 90 -searchry -90 90 -searchrz -90 90



fnirt --ref=${FMRIB58_FA_1mm} --in=${edc_nii_bfc_tensor_FA} --aff=flirt.mat --cout=${fnirt_omat} --config=FA_2_FMRIB58_1mm -v
