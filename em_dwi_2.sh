# Perform eddy, tensor fitting, and CSD

# Modules
# -----------------------------------------------------------------------------

module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

# Parameters
# -----------------------------------------------------------------------------

# Options
# dir="/lustre/archive/p00423/PREVENT_Elijah/MRTRIX"
subject=${1}
BET=${2}

# Inputs
raw_dwi="dwi.nii"
raw_dwi_mif="dwi.mif"
denoised_dwi="dwi.denoised.nii"
denoised_degibbs_dwi="dwi.denoised.degibbs.nii"
b0="denoised_degibbs_dwi_b0.nii"
mask="denoised_degibbs_dwi_b0_brain_mask.nii"
output_edc="denoised_degibbs.edc.repol"
edc="denoised_degibbs.edc.repol.nii"
edc_rotated_bvecs="denoised_degibbs.edc.repol.eddy_rotated_bvecs"
edc_mif="denoised_degibbs.edc.repol.mif"
edc_mif_bfc="denoised_degibbs.edc.repol.bfc.mif"
edc_mif_bfc_tensor="denoised_degibbs.edc.repol.bfc.tensor.mif"
edc_mif_bfc_tensor_FA="denoised_degibbs.edc.repol.bfc.tensor.FA.mif"
edc_mif_bfc_tensor_MD="denoised_degibbs.edc.repol.bfc.tensor.MD.mif"
edc_mif_bfc_tensor_RD="denoised_degibbs.edc.repol.bfc.tensor.RD.mif"
edc_mif_bfc_tensor_AD="denoised_degibbs.edc.repol.bfc.tensor.AD.mif"
edc_nii_bfc_tensor_FA="denoised_degibbs.edc.repol.bfc.tensor.FA.nii"
edc_nii_bfc_tensor_MD="denoised_degibbs.edc.repol.bfc.tensor.MD.nii"
edc_nii_bfc_tensor_RD="denoised_degibbs.edc.repol.bfc.tensor.RD.nii"
edc_nii_bfc_tensor_AD="denoised_degibbs.edc.repol.bfc.tensor.AD.nii"


# Initialising Text
# -------------------------------------------------------------------------------------------------

echo "███████╗███╗   ███╗       ██████╗ ██╗███████╗███████╗██╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗
██╔════╝████╗ ████║       ██╔══██╗██║██╔════╝██╔════╝██║   ██║██╔════╝██║██╔═══██╗████╗  ██║
█████╗  ██╔████╔██║       ██║  ██║██║█████╗  █████╗  ██║   ██║███████╗██║██║   ██║██╔██╗ ██║
██╔══╝  ██║╚██╔╝██║       ██║  ██║██║██╔══╝  ██╔══╝  ██║   ██║╚════██║██║██║   ██║██║╚██╗██║
███████╗██║ ╚═╝ ██║██╗    ██████╔╝██║██║     ██║     ╚██████╔╝███████║██║╚██████╔╝██║ ╚████║██╗
╚══════╝╚═╝     ╚═╝╚═╝    ╚═════╝ ╚═╝╚═╝     ╚═╝      ╚═════╝ ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝
                                                                                               "
echo "Diffusion pipeline started at $(date)"
echo "Initialising diffusion preprocessing for ${subject}"

echo "--------------------------------"
echo "              Eddy              "
echo "--------------------------------"

cd ${subject}


 # Eddy current correction
 eddy_openmp --imain=${denoised_degibbs_dwi} \
 --mask=${mask} --acqp=acqparams.txt \
 --index=index.txt --bvecs=bvec \
 --bvals=bval --fwhm=10,0,0,0,0 \
 --repol \
 --out=$output_edc \
 --cnr_maps \
 --verbose


# Bias-field correction and tensor fitting
# -------------------------------------------------------------------------------------------------

echo "================================"
echo "         Tensor Fitting         "
echo "================================"

# Convert to mif
mrconvert ${edc} ${edc_mif} -fslgrad ${output_edc}.eddy_rotated_bvecs bval -datatype float32 -strides 0,0,0,1

# Perform bias-field correction
dwibiascorrect ants -mask ${mask} -bias bias.nii ${edc_mif} ${edc_mif_bfc}
mrconvert ${edc_mif_bfc} denoised_degibbs.edc.repol.bfc.nii -force

# Extract tensor maps
dwi2tensor -mask ${mask} ${edc_mif_bfc} ${edc_mif_bfc_tensor}

#Remove NaNs
mrcalc ${edc_mif_bfc_tensor} -finite ${edc_mif_bfc_tensor} 0 -if ${edc_mif_bfc_tensor} -force

# Fit tensor maps
tensor2metric -fa ${edc_mif_bfc_tensor_FA} ${edc_mif_bfc_tensor} -force
tensor2metric -adc ${edc_mif_bfc_tensor_MD} ${edc_mif_bfc_tensor} -force
tensor2metric -ad ${edc_mif_bfc_tensor_AD} ${edc_mif_bfc_tensor} -force
tensor2metric -rd ${edc_mif_bfc_tensor_RD} ${edc_mif_bfc_tensor} -force
mrconvert ${edc_mif_bfc_tensor_FA} ${edc_nii_bfc_tensor_FA} -force
mrconvert ${edc_mif_bfc_tensor_MD} ${edc_nii_bfc_tensor_MD} -force
mrconvert ${edc_mif_bfc_tensor_AD} ${edc_nii_bfc_tensor_AD} -force
mrconvert ${edc_mif_bfc_tensor_RD} ${edc_nii_bfc_tensor_RD} -force

# Estimate response for FOD
dwi2response tournier ${edc_mif_bfc} tournier_response.txt -voxels tournier_voxels.mif -mask ${mask}

# Perform CSD
dwi2fod csd ${edc_mif_bfc} tournier_response.txt tournier_response_fod.mif -mask ${mask}
