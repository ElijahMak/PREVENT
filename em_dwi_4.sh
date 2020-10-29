Perform eddy, tensor fitting, and CSD

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
dir="/lustre/archive/p00423/PREVENT_Elijah/MRTRIX"
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

# Connectome pipeline
#-------------------------------------------------------------------------------------------------
echo "================================"
echo "         Connectomising         "
echo "================================"
#

cd ${dir}
cd ${subject}

# # Freesurfer registration
# export SUBJECTS_DIR=/lustre/archive/p00423/PREVENT_Elijah/Freesurfer7_GS
#
# mri_coreg --s ${subject} --mov ${b0} --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta
#
# # Inverse warp segmentations into DTI space
# mri_vol2vol --mov ${b0} --targ $SUBJECTS_DIR/${subject}/mri/brainmask.mgz --inv --interp nearest --o rbrainmask.nii --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta
#
# mri_vol2vol --mov ${b0} --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o raparcaseg.nii --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta
#
# 5ttgen freesurfer raparcaseg.nii 5ttseg.mif -sgm_amyg_hipp -lut $FREESURFER_HOME/FreeSurferColorLUT.txt -lut $FREESURFER_HOME/FreeSurferColorLUT.txt
#
# 5tt2gmwmi 5ttseg.mif 5tt_mask.mif

tckgen -seed_gmwmi 5tt_mask.mif -act 5ttseg.mif -crop_at_gmwmi -seeds 5000000 tournier_response_fod.mif wholebrain.tck

tcksift wholebrain.tck tournier_response_fod.mif sift1_wholebrain.tck

tcksift2 wholebrain.tck tournier_response_fod.mif wholebrain_sift2_weights.txt

labelconvert raparcaseg.nii $FREESURFER_HOME/FreeSurferColorLUT.txt $code/fs_default.txt output_parcels.mif

tck2connectome -assignment_radial_search 2 -scale_length -out_assignments assignments2.txt -tck_weights_in wholebrain_sift2_weights.txt wholebrain.tck output_parcels.mif connectome.csv -force

connectome2tck wholebrain.tck assignments2.txt exemplars.tck -files single -exemplars output_parcels.mif

echo "Completed: Connetomising ${subject}"
echo "Diffusion pipeline completed at $(date)"
