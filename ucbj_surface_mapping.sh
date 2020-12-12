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

# Parameters
# --------------------------------------------
SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"
subject=${1}
mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi2/${subject}/hifi_nodif.nii"
reg="$SUBJECTS_DIR/${subject}/noddi/coreg_hifi_nodif.lta"
mov2="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/${subject}/NODDI_MATLAB_v101/noddi_odi.nii.gz"
# mov_pvc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
# mov_unvpc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_BP_Radio.nii"

# #  Coregister UCBJ to T1
# #  --------------------------------------------
mri_coreg --s ${subject} --mov ${mov} --reg ${reg}

# Project NODDI volume to fsaverage surface
# --------------------------------------------
for h in lh rh; do
fsaverage_output="${SUBJECTS_DIR}/${subject}/noddi/${h}_noddi_odi_fsaverage.nii.gz"
native_output="${SUBJECTS_DIR}/${subject}/noddi/${h}_noddi_odi_native.nii.gz"
projfrac="0.5"
projfrac="0.5"
mri_vol2surf --mov $mov2 --reg $reg --hemi ${h} --projfrac 0.5 --o $fsaverage_output --cortex --trgsubject fsaverage; done

# Project pvc volume to native surface
# --------------------------------------------
for h in lh rh; do
native_output="${SUBJECTS_DIR}/${subject}/noddi/${h}_noddi_odi_native.nii.gz"
projfrac="0.5"
mri_vol2surf --mov $mov2 --reg $reg --hemi ${h} --projfrac 0.5 --o $native_output --cortex --trgsubject ${subject}; done

# Smooth surfaces on fsaverage
# --------------------------------------------
for h in lh rh; do
fwhm="8"
fsaverage_output="${SUBJECTS_DIR}/${subject}/noddi/${h}_noddi_odi_fsaverage.nii.gz"
fsaverage_output_smooth="${SUBJECTS_DIR}/${subject}/noddi/${h}_noddi_odi_fsaverage_sm${fwhm}.nii.gz"
mris_fwhm --smooth-only --i ${fsaverage_output} --fwhm ${fwhm} --o ${fsaverage_output_smooth} --cortex --s fsaverage --hemi ${h}; done


# # Coregister UNPVC UCBJ to T1
# # --------------------------------------------
# mri_coreg --s ${subject} --mov /archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_R1_Radio.nii --reg $SUBJECTS_DIR/${subject}/ucbj2/coreg_unpvc_r1.lta

# # Project unpvc to fsaverage surface
# # --------------------------------------------
# for h in lh rh; do
# mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_BP_Radio.nii"
# reg="${SUBJECTS_DIR}/${subject}/ucbj2/coreg_unpvc_r1.lta"
# projfrac="0.5"
# output="${SUBJECTS_DIR}/${subject}/ucbj2/${h}_unpvc_ucbj_bp.nii.gz"
# mri_vol2surf --mov $mov --reg $reg --hemi ${h} --projfrac 0.5 --o $output --cortex --trgsubject fsaverage; done

# # Project unpvc to native surface
# # --------------------------------------------
# for h in lh rh; do
# mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_BP_Radio.nii"
# reg="${SUBJECTS_DIR}/${subject}/ucbj2/coreg_unpvc_r1.lta"
# projfrac="0.5"
# output="${SUBJECTS_DIR}/${subject}/ucbj2/${h}_unpvc_ucbj_bp_native.nii.gz"
# mri_vol2surf --mov $mov --reg $reg --hemi ${h} --projfrac 0.5 --o $output --cortex --trgsubject ${subject}; done
#
# # Smooth unpvc surfaces
# # --------------------------------------------
# for h in lh rh; do
# fwhm="8"
# input="${SUBJECTS_DIR}/${subject}/ucbj2/${h}_unpvc_ucbj_bp.nii.gz"
# output="${SUBJECTS_DIR}/${subject}/ucbj2/${h}_unpvc_ucbj_bp_sm${fwhm}.nii.gz"
# mris_fwhm --smooth-only --i $input --fwhm $fwhm --o $output  --cortex --s fsaverage --hemi ${h}; done

# Derive volumes
# --------------------------------------------
# mov="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
# reg="${SUBJECTS_DIR}/${subject}/ucbj2/coreg_pvc_r1.lta"
targ="$SUBJECTS_DIR/${subject}/mri/brainmask.mgz"
# output_volume="${SUBJECTS_DIR}/${subject}/noddi/vol_noddi_odi.nii.gz"
# mni152_output="${SUBJECTS_DIR}/${subject}/noddi/mni_vol_noddi_odi.nii.gz"
# output_volume="${SUBJECTS_DIR}/${subject}/ucbj2/vol_pvc_ucbj_bp.nii.gz"
# mni152_output="${SUBJECTS_DIR}/${subject}/ucbj2/mni_vol_pvc_ucbj_bp.nii.gz"
# sm_output="${SUBJECTS_DIR}/${subject}/noddi/vol_pvc_ucbj_bp_sm${fwhm}.nii.gz"
# sm_mni152_output="${SUBJECTS_DIR}/${subject}/noddi/mni_vol_pvc_ucbj_bp_sm${fwhm}.nii.gz"
# sm_output="${SUBJECTS_DIR}/${subject}/noddi/vol_noddi_odi_sm${fwhm}.nii.gz"
# sm_mni152_output="${SUBJECTS_DIR}/${subject}/noddi/mni_vol_noddi_odi_sm${fwhm}.nii.gz"
# fwhm="8"
#
# # Derive PET volume in native T1
# # --------------------------------------------
# mri_vol2vol --mov ${mov2} --reg ${reg} --targ ${targ} --o ${output_volume}
#
# # Derive PET volume in MNI152 2MM
# # --------------------------------------------
# mri_vol2vol --mov ${mov2} --reg ${reg} --targ ${targ} --o ${mni152_output} --mni152reg
#
# # Smooth PET volumes in T1 and MNI152 spaces
# # --------------------------------------------
# mri_fwhm --smooth-only --i ${output_volume} --fwhm ${fwhm} --o ${sm_output}
# mri_fwhm --smooth-only --i ${mni152_output} --fwhm $fwhm --o ${sm_mni152_output}

# # Project UNPVC volume
# # --------------------------------------------
# mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_BP_Radio.nii"
# reg="${SUBJECTS_DIR}/${subject}/ucbj2/coreg_unpvc_r1.lta"
# targ=$SUBJECTS_DIR/${subject}/mri/brainmask.mgz
# output="${SUBJECTS_DIR}/${subject}/ucbj2/vol_unpvc_ucbj_bp.nii.gz"
# mni152_output="${SUBJECTS_DIR}/${subject}/ucbj2/mni_vol_unpvc_ucbj_bp.nii.gz"
# sm_output="${SUBJECTS_DIR}/${subject}/ucbj2/vol_unpvc_ucbj_bp_sm${fwhm}.nii.gz"
# sm_mni152_output="${SUBJECTS_DIR}/${subject}/ucbj2/mni_vol_unpvc_ucbj_bp_sm${fwhm}.nii.gz"
# fwhm="8"
#
# # Derive UNPVC PET volume in native T1 and MNI152
# # --------------------------------------------
# mri_vol2vol --mov $mov --reg $reg --targ ${targ} --o $output
# mri_vol2vol --mov $mov --reg $reg --targ ${targ} --o ${mni152_output} --mni152reg
#
# # Smooth UNPVC PET volumes
# # --------------------------------------------
# mri_fwhm --smooth-only --i $output --fwhm $fwhm --o $sm_output
# mri_fwhm --smooth-only --i $mni152_output --fwhm $fwhm --o $sm_mni152_output
