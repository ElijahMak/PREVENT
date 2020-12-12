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
subject=${1}
SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"

# UCBJ
# --------------------------------------------
for h in lh rh; do
mri_segstats --annot ${subject} ${h} aparc --i ${subject}/ucbj2/${h}_pvc_ucbj_bp_native.nii.gz --sum ${subject}/stats/${h}_pvc_ucbj_bp_native.dat
done

# ODI
# --------------------------------------------
for h in lh rh; do
mri_segstats --annot ${subject} ${h} aparc --i ${subject}/noddi/${h}_mdt_odi_native.nii.gz --sum ${subject}/stats/${h}_mdt_odi_native.dat
done


# Volumetric data
# Parameters
# --------------------------------------------
mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/${subject}/hifi_nodif.nii"
# mov_pvc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
# mov_unpvc="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_BP_Radio.nii"
reg="$SUBJECTS_DIR/${subject}/noddi/coreg_hifi_nodif.lta"
# reg="${SUBJECTS_DIR}/${subject}/ucbj2/coreg_unpvc_r1.lta"
seg="$SUBJECTS_DIR/${subject}/noddi/wmparc_2_noddi_b0.nii"
stats="$SUBJECTS_DIR/${subject}/stats/wmparc_2_noddi_odi.dat"
targ="$SUBJECTS_DIR/${subject}/mri/wmparc.mgz"
odi="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/${subject}/NODDI_MATLAB_v101/noddi_odi.nii.gz"

# NODDI
mri_vol2vol --mov ${mov} --targ ${targ} --inv --interp nearest --o ${seg} --reg ${reg}
mri_segstats --seg ${seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${stats} --i ${odi}

# UCBJ
#mri_vol2vol --mov ${mov_unvpc} --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_unpvc_ucbj.nii --reg ${reg}
# mri_vol2vol --mov ${mov_pvc} --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_pvc_ucbj.nii --reg ${reg}
# mri_segstats --seg ${seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${stats} --i ${mov}
# mri_segstats --seg $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_unpvc_ucbj.nii --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${subject}/stats/aparcaseg_2_unpvc_ucbj.dat --i ${mov_unpvc}
# mri_segstats --seg $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_pvc_ucbj.nii --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${subject}/stats/aparcaseg_2_pvc_ucbj.dat --i ${mov_pvc}
