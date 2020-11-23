# DWI preprocessing, using a single B0 from PA to correct distortions in AP.
# Author: Elijah Make

# Directory
# --------------------------------------------
dir="/scratch/hphi/fkm24/projects/ucbjxnoddi/noddi/"

# Modules
# --------------------------------------------
module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

# Parameters
# --------------------------------------------
subject=${1}
SUBJECTS_DIR="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"
# Coregister UCBJ to T1
# --------------------------------------------
mri_coreg --s ${i} --mov /archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${i}/${i}_UCB-J_PVC_R1_Radio.nii --reg $SUBJECTS_DIR/${i}/ucbj2/coreg_pvc_r1.lta

# Project pvc volume to surface
# --------------------------------------------

for h in lh rh; do

mov="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${i}/${i}_UCB-J_PVC_BP_Radio.nii"
reg="${SUBJECTS_DIR}/${i}/ucbj2/coreg_pvc_r1.lta"
projfrac="0.5"
output="${SUBJECTS_DIR}/${i}/ucbj2/${h}_pvc_ucbj_bp.nii.gz"
mri_vol2surf --mov $mov --reg $reg --hemi ${h} --projfrac 0.5 --o $output --cortex --trgsubject fsaverage; done

for h in lh rh; do
fwhm="8"
input="${SUBJECTS_DIR}/${i}/ucbj2/${h}_pvc_ucbj_bp.nii.gz"
output="${SUBJECTS_DIR}/${i}/ucbj2/${h}_pvc_ucbj_bp_sm${fwhm}.nii.gz"
mris_fwhm --smooth-only --i $input --fwhm $fwhm --o $output  --cortex --s fsaverage --hemi ${h}; done



# Project un pvc to surface
# --------------------------------------------
mov="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${i}/${i}_UCB-J_BP_Radio.nii"
reg="${SUBJECTS_DIR}/${i}/ucbj2/coreg_pvc_r1.lta"
projfrac="0.5"
output="${SUBJECTS_DIR}/${i}/ucbj2/${h}_unpvc_ucbj_bp.nii.gz"
mri_vol2surf --mov $mov --reg $reg --hemi ${h} --projfrac 0.5 --o $output --cortex --trgsubject fsaverage; done

for h in lh rh; do
fwhm="8"
input="${SUBJECTS_DIR}/${i}/ucbj2/${h}_unpvc_ucbj_bp.nii.gz"
output="${SUBJECTS_DIR}/${i}/ucbj2/${h}_unpvc_ucbj_bp_sm${fwhm}.nii.gz"
mris_fwhm --smooth-only --i $input --fwhm $fwhm --o $output  --cortex --s fsaverage --hemi ${h}; done
