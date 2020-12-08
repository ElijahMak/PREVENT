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
# mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/${subject}/hifi_nodif.nii"
# reg="$SUBJECTS_DIR/${subject}/noddi/coreg_hifi_nodif.lta"
# mov2="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/${subject}/NODDI_MATLAB_v101/noddi_odi.nii.gz"
mov_pvc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
mov_unvpc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_BP_Radio.nii"
template="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/MCALT_v1.4/MCALT_T1_brain.nii"

antsRegistrationSyN.sh -d 3 -f ${template} -m T1.nii -o reg/MNIxT1
