# Load modules
module load cuda/8.0
module unload fsl/5.0.10
module load fsl/6.0.3

# Define variables
subject="${1}"
input_edc="dwi.nii"
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
