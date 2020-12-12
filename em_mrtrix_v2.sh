# MRTRIX pipeline
# Perform denoising, degibbs, top up and eddy corrections from DICOMs. First convert everything to .mif, and then concatenate the results, in which case MRtrix3 handles concatenation of the gradient tables automatically.

# Date: 11th Dec 2020

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
dir="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/"
subject=${1}
cd $subject

# Inputs
raw_dwi="all_DWIs.mif"
denoised_dwi="all.dwi.denoised.mif"
denoised_degibbs_dwi="dwi.denoised.degibbs.mif"
denoised_degibbs_preproc_dwi="dwi.denoised.degibbs.preproc.mif"
denoised_degibbs_preproc_bfc_dwi="dwi.denoised.degibbs.preproc.bfc.mif"
denoised_degibbs_preproc_bfc_dwi_nii="dwi.denoised.degibbs.preproc.bfc.nii"
mask="mask.nii"
b0="denoised_degibbs_preproc_bfc_dwi_b0.nii"
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

echo "--------------------------------"
echo "        Modify BVEC             "
echo "--------------------------------"

cp ap.bvecs temp.bvecs
awk '{$1=0 ; print ;}' temp.bvecs > temp1.bvecs
awk '{$2=0 ; print ;}' temp1.bvecs > temp2.bvecs
awk '{$11=0 ; print ;}' temp2.bvecs > temp3.bvecs
awk '{$27=0 ; print ;}' temp3.bvecs > temp4.bvecs
awk '{$43=0 ; print ;}' temp4.bvecs > temp5.bvecs
awk '{$74=0 ; print ;}' temp5.bvecs > temp6.bvecs
cp temp6.bvecs a.bvecs
rm temp*

cp pa.bvecs temp.bvecs
awk '{$1=0 ; print ;}' temp.bvecs > temp1.bvecs
awk '{$2=0 ; print ;}' temp1.bvecs > temp2.bvecs
awk '{$11=0 ; print ;}' temp2.bvecs > temp3.bvecs
awk '{$27=0 ; print ;}' temp3.bvecs > temp4.bvecs
awk '{$43=0 ; print ;}' temp4.bvecs > temp5.bvecs
awk '{$74=0 ; print ;}' temp5.bvecs > temp6.bvecs
cp temp6.bvecs p.bvecs
rm temp*

echo "--------------------------------"
echo "        Convert to mif          "
echo "--------------------------------"

# Concatenate both AP and PA nii
mrcat ap.nii.gz pa.nii.gz appa.nii
paste -d" " a.bvecs p.bvecs >> ap_pa.bvecs
paste -d" " ap.bvals pa.bvals >> ap_pa.bvals

echo "--------------------------------"
echo "          Denoising             "
echo "--------------------------------"

# Denoising of DWI
dwidenoise appa.nii appa.denoised.nii

echo "--------------------------------"
echo "            DeGibbs             "
echo "--------------------------------"

# Remove Gibbs Ringing artifact
mrdegibbs appa.denoised.nii appa.denoised.degibbs.nii -force

echo "--------------------------------"
echo "           dwifslpreproc        "
echo "--------------------------------"

dwifslpreproc appa.denoised.degibbs.nii -fslgrad ap_pa.bvecs ap_pa.bvals  -export_grad_fsl mrtrix_bvecs mtrix_bvals appa.denoised.degibbs.preproc.nii -force -rpe_all -pe_dir AP -eddyqc_all eddyqc -eddy_mask hifi_nodif_brain_f0.3_mask.nii -eddy_options '  --repol --data_is_shelled --slm=linear --cnr_maps'

# Bias-field correction and tensor fitting
# -------------------------------------------------------------------------------------------------

echo "================================"
echo "       Bias field correction    "
echo "================================"

dwibiascorrect ants -bias bias.nii appa.denoised.degibbs.preproc.nii appa.denoised.degibbs.preproc.bfc.nii -fslgrad mrtrix_bvecs mtrix_bvals

echo "--------------------------------"
echo "         Package for NODDI      "
echo "--------------------------------"

mkdir /lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/mrtrix_hpc/${subject}
dir_storage="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/mrtrix_hpc/${subject}"
cp appa.denoised.degibbs.preproc.bfc.nii ${dir_storage}
cp mtrix_bvals ${dir_storage}
cp mrtrix_bvecs ${dir_storage}
cp hifi_nodif_brain_f0.3_mask.nii ${dir_storage}
