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

# # UCBJ
# # --------------------------------------------
# for h in lh rh; do
# mri_segstats --annot ${subject} ${h} aparc --i ${subject}/ucbj2/${h}_pvc_ucbj_bp_native.nii.gz --sum ${subject}/stats/${h}_pvc_ucbj_bp_native.dat
# done

# ODI
# --------------------------------------------
for h in lh rh; do
  mri_segstats --annot ${subject} ${h} aparc --i ${subject}/noddi/${h}_mdt_odi.nii.gz --sum ${subject}/stats/${h}_mdt_odi.dat
done

# Volumetric data
# Parameters
# --------------------------------------------
mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi2/${subject}/hifi_nodif.nii"
reg="$SUBJECTS_DIR/${subject}/noddi/coreg_hifi_nodif.lta"
aseg="$SUBJECTS_DIR/${subject}/mri/aseg.mgz"
aparcaseg="$SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz"
aparcaseg_seg="$SUBJECTS_DIR/${subject}/noddi/aparcaseg_2_hifi_nodif.nii"
aparcaseg_stats="$SUBJECTS_DIR/${subject}/stats/aparcaseg_2_mdt_odi.dat"
aseg_seg="$SUBJECTS_DIR/${subject}/noddi/aseg_2_hifi_nodif.nii"
aseg_stats="$SUBJECTS_DIR/${subject}/stats/aseg_2_mdt_odi.dat"
odi="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi2/${subject}/mdt/NODDI_GM/ODI.nii.gz"
brainstem="$SUBJECTS_DIR/${subject}/mri/brainstemSsLabels.v10.FSvoxelSpace.mgz"
brainstem_seg="$SUBJECTS_DIR/${subject}/noddi/brainstem_2_hifi_nodif.nii"
brainstem_stats="$SUBJECTS_DIR/${subject}/stats/brainstem_2_mdt_odi.dat"

# Aparc+Aseg
mri_vol2vol --mov ${mov} --targ ${aparcaseg} --inv --interp nearest --o ${aparcaseg_seg} --reg ${reg}
mri_segstats --seg ${aparcaseg_seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${aparcaseg_stats} --i ${odi}

# Aseg
mri_vol2vol --mov ${mov} --targ ${aseg} --inv --interp nearest --o ${aseg_seg} --reg ${reg}
mri_segstats --seg ${aseg_seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${aseg_stats} --i ${odi}

# Brainstem
mri_vol2vol --mov ${mov} --targ ${brainstem} --inv --interp nearest --o ${brainstem_seg} --reg ${reg}
mri_segstats --seg ${brainstem_seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${brainstem_stats} --i ${odi}

# ----------------------------------------------------
#
# # UCBJ
# mov="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_R1_Radio.nii"
# targ="$SUBJECTS_DIR/${subject}/mri/aseg.mgz"
# seg="$SUBJECTS_DIR/${subject}/ucbj2/aseg_2_ucbj.nii"
# reg="$SUBJECTS_DIR/${subject}/ucbj2/coreg_pvc_r1.lta"
# stats="$SUBJECTS_DIR/${subject}/stats/aseg_2_pvc_ucbj.dat"
# ucbj="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/${subject}/${subject}_UCB-J_PVC_BP_Radio.nii"
# aparcaseg="$SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz"
# aparcaseg_seg="$SUBJECTS_DIR/${subject}/noddi/aparcaseg_2_ucbj.nii"
# aparcaseg_stats="$SUBJECTS_DIR/${subject}/stats/aparcaseg_2_pvc_ucbj.dat"
# brainstem="$SUBJECTS_DIR/${subject}/mri/brainstemSsLabels.v10.FSvoxelSpace.mgz"
# brainstem_seg="$SUBJECTS_DIR/${subject}/ucbj2/brainstem_2_ucbj.nii"
# brainstem_stats="$SUBJECTS_DIR/${subject}/stats/brainstem_2_ucbj.dat"
#
# # Aparc+Aseg
# mri_vol2vol --mov ${mov} --targ ${aparcaseg} --inv --interp nearest --o ${aparcaseg_seg} --reg ${reg}
# mri_segstats --seg ${aparcaseg_seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${aparcaseg_stats} --i ${ucbj}
#
# # Aseg
# mri_vol2vol --mov ${mov} --targ ${targ} --inv --interp nearest --o ${seg} --reg ${reg}
# mri_segstats --seg ${seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${stats} --i ${ucbj}
#
# # Brainstem
# mri_vol2vol --mov ${mov} --targ ${brainstem} --inv --interp nearest --o ${brainstem_seg} --reg ${reg}
# mri_segstats --seg ${brainstem_seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${brainstem_stats} --i ${ucbj}
