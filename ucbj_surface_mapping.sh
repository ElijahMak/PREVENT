# Author: Elijah Mak

# Directory
# --------------------------------------------

# Modules
# --------------------------------------------
module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

# --------------------------------------------
# ODI
# --------------------------------------------

# Parameters
# --------------------------------------------
SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"
subject=${1}
# Use b0 as warps
mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi2/${subject}/hifi_nodif.nii"
# Use coreg files
reg="$SUBJECTS_DIR/${subject}/noddi/coreg_hifi_nodif.lta"
odi="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/mdt/${subject}/mdt/NODDI_GM/ODI.nii.gz"

# Project ODI volume to fsaverage and native surfaces, and smooth by 8mm
# --------------------------------------------
for h in lh rh; do
projfrac="0.5"; fwhm="8"
fsaverage_output="${SUBJECTS_DIR}/${subject}/noddi/${h}_mdt_odi_fsaverage.nii.gz"
fsaverage_output_smooth="${SUBJECTS_DIR}/${subject}/noddi/${h}_mdt_odi_fsaverage_sm${fwhm}.nii.gz"
native_output="${SUBJECTS_DIR}/${subject}/noddi/${h}_mdt_odi.nii.gz"
mri_vol2surf --mov $odi --reg $reg --hemi ${h} --projfrac 0.5 --o $fsaverage_output --cortex --trgsubject fsaverage
mri_vol2surf --mov $odi --reg $reg --hemi ${h} --projfrac 0.5 --o $native_output --cortex --trgsubject ${subject}
mris_fwhm --smooth-only --i ${fsaverage_output} --fwhm ${fwhm} --o ${fsaverage_output_smooth} --cortex --s fsaverage --hemi ${h}; done
done


# --------------------------------------------
# UCBJ
# --------------------------------------------

# Parameters
# --------------------------------------------
SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"
subject=${1}
# Use b0 as warps
mov_pvc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
# Use coreg files
reg="$SUBJECTS_DIR/${subject}/ucbj2/coreg_pvc_r1.lta"

# Coregister UCBJ to T1
# --------------------------------------------
# mri_coreg --s ${subject} --mov /archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_R1_Radio.nii --reg $SUBJECTS_DIR/${subject}/ucbj2/coreg_pvc_r1.lta

# Project UCBJ to fsaverage and native surfaces
# --------------------------------------------
for h in lh rh; do
fwhm="8"
mov_pvc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
reg="$SUBJECTS_DIR/${subject}/ucbj2/coreg_pvc_r1.lta"
projfrac="0.5"
fsaverage_output="${SUBJECTS_DIR}/${subject}/ucbj2/${h}_pvc_ucbj_bp_fsaverage.nii.gz"
native_output="${SUBJECTS_DIR}/${subject}/ucbj2/${h}_pvc_ucbj_bp.nii.gz"
fsaverage_output_smooth="${SUBJECTS_DIR}/${subject}/ucbj2/${h}_pvc_ucbj_bp_fsaverage_sm${fwhm}.nii.gz"
mri_vol2surf --mov $mov_pvc --reg $reg --hemi ${h} --projfrac 0.5 --o $fsaverage_output --cortex --trgsubject fsaverage
mri_vol2surf --mov $mov_pvc --reg $reg --hemi ${h} --projfrac 0.5 --o $native_output --cortex --trgsubject ${subject}
mris_fwhm --smooth-only --i $fsaverage_output --fwhm $fwhm --o $fsaverage_output_smooth  --cortex --s fsaverage --hemi ${h}
done

# --------------------------------------------
# Derive volumes
# --------------------------------------------

# Derive ODI volume in native T1
# --------------------------------------------
reg="$SUBJECTS_DIR/${subject}/noddi/coreg_hifi_nodif.lta"
targ="$SUBJECTS_DIR/${subject}/mri/brainmask.mgz"
output_volume="$SUBJECTS_DIR/${subject}/noddi2/vol_mdt_odi_anat.nii"
mri_vol2vol --mov ${odi} --reg ${reg} --targ ${targ} --o ${output_volume}

# Derive UCBJ volume in native T1
# --------------------------------------------
reg="$SUBJECTS_DIR/${subject}/ucbj2/coreg_pvc_r1.lta"
targ="$SUBJECTS_DIR/${subject}/mri/brainmask.mgz"
mov_pvc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
output_volume="$SUBJECTS_DIR/${subject}/ucbj2/vol_pvc_ucbj_bp_anat.nii"
mri_vol2vol --mov ${mov_pvc} --reg ${reg} --targ ${targ} --o ${output_volume}
