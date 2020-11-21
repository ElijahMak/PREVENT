# MRTRIX pipeline
# Perform denoising, degibbs, top up and eddy corrections from DICOMs. First convert everything to .mif, and then concatenate the results, in which case MRtrix3 handles concatenation of the gradient tables automatically.


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

# Inputs
raw_dwi="all_DWIs.mif"
denoised_dwi="all.dwi.denoised.mif"
denoised_degibbs_dwi="dwi.denoised.degibbs.mif"
denoised_degibbs_preproc_dwi="dwi.denoised.debibbs.preproc.mif"
denoised_degibbs_preproc_bfc_dwi="dwi.denoised.debibbs.preproc.bfc.mif"
mask="mask.nii"
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

# Preprocessing
# -------------------------------------------------------------------------------------------------
echo "================================"
echo "            NII to MIF          "
echo "================================"

cd ${subject}

cd *AP*
for img in **
do
dcmdjpeg $img ${img}.tmp
mv ${img}.tmp $img
done

cd ../*PA*
for img in **
do
dcmdjpeg $img ${img}.tmp
mv ${img}.tmp $img
done

cd ../..

# Concatenate both DWI dicom folders
mrcat *AP* *PA* ${raw_dwi} -axis 3

echo "--------------------------------"
echo "          Denoising             "
echo "--------------------------------"

# Denoising of DWI
dwidenoise ${raw_dwi} ${denoised_dwi}

echo "--------------------------------"
echo "            DeGibbs             "
echo "--------------------------------"

# Remove Gibbs Ringing artifact
mrdegibbs ${denoised_dwi} ${denoised_degibbs_dwi} -bias

mrcalc dwi_den.mif dwi_den_unr.mif –subtract residualUnringed.mif
# mrview dwi_den_unr.mif residualUnringed.mif

echo "--------------------------------"
echo "           dwifslpreproc        "
echo "--------------------------------"

dwifslpreproc ${denoised_degibbs_dwi} ${denoised_degibbs_preproc_dwi} -rpe_header -eddyqc_all eddyqc -eddy_options '  --repol --data_is_shelled --slm=linear --niter=5'

# Bias-field correction and tensor fitting
# -------------------------------------------------------------------------------------------------

echo "================================"
echo "       BIAS FIELD correction    "
echo "================================"

# Perform bias-field correction
dwibiascorrect ants -bias bias.mif ${denoised_degibbs_preproc_dwi} ${denoised_degibbs_preproc_bfc_dwi}

echo "================================"
echo "          Brain mask            "
echo "================================"

dwi2mask ${denoised_degibbs_preproc_bfc_dwi} ${mask}
