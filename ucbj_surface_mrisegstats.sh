# Author: Elijah Make

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
subject=${1}

SUBJECTS_DIR="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"

for h in lh rh; do
mri_segstats --annot ${subject} ${h} aparc --i ${subject}/ucbj2/${h}_unpvc_ucbj_bp_native.nii.gz --sum ${subject}/stats/${h}_unpvc_ucbj_bp_native.dat
done

# Parameters
# --------------------------------------------
mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
reg="${SUBJECTS_DIR}/${subject}/ucbj2/coreg_unpvc_r1.lta"

mri_vol2vol --mov ${mov} --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_unpvc_ucbj.nii --reg ${reg}

mri_segstats --seg $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_unpvc_ucbj.nii --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${subject}/stats/aparcaseg_2_unpvc_ucbj.dat --i ${mov}
