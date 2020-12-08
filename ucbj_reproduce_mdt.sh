# Author: Elijah Mak

# To reproduce previous dataset, and determine whether differences in results are driven by toolbox.

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

# for h in lh rh; do
# mri_segstats --annot ${subject} ${h} aparc --i ${subject}/ucbj2/${h}_unpvc_ucbj_bp_native.nii.gz --sum ${subject}/stats/${h}_unpvc_ucbj_bp_native.dat
# done
#
# for h in lh rh; do
# mri_segstats --annot ${subject} ${h} aparc --i ${subject}/ucbj2/${h}_pvc_ucbj_bp_native.nii.gz --sum ${subject}/stats/${h}_pvc_ucbj_bp_native.dat
# done
#
# for h in lh rh; do
# mri_segstats --annot ${subject} ${h} aparc --i ${subject}/noddi/${h}_noddi_odi_native.nii.gz --sum ${subject}/stats/${h}_noddi_odi_native.dat
# done

# Parameters
# --------------------------------------------
mdt_odi_gm="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer/archive/data_mdt_odi_gm/${subject}_mdt_odi_gm.nii.gz"

mdt_odi_wm="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer/archive/data_mdt_odi_gm/${subject}_mdt_odi_wm.nii.gz"

reg="$SUBJECTS_DIR/${subject}/noddi/coreg_hifi_nodif.lta"
# reg="${SUBJECTS_DIR}/${subject}/ucbj2/coreg_unpvc_r1.lta"
# seg="$SUBJECTS_DIR/${subject}/noddi/aparcaseg_2_noddi_odi.nii"
wmparc_seg="$SUBJECTS_DIR/${subject}/noddi/wmparc_2_b0.nii"
aparcaseg_seg="$SUBJECTS_DIR/${subject}/noddi/aparcaseg_2_noddi_odi.nii"

wmparc_stats="$SUBJECTS_DIR/${subject}/stats/wmparc_2_mdt_odi_gm.dat"
aparcaseg_stats="$SUBJECTS_DIR/${subject}/stats/aparcaseg_2_mdt_odi_gm.dat"

targ="$SUBJECTS_DIR/${subject}/mri/wmparc.mgz"

# NODDI
mri_segstats --seg ${wmparc_seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${wmparc_stats} --i ${mdt_odi_wm}

mri_segstats --seg ${aparcaseg_seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${aparcaseg_stats} --i ${mdt_odi_wm}

# UCBJ
#mri_vol2vol --mov ${mov_unvpc} --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_unpvc_ucbj.nii --reg ${reg}
# mri_vol2vol --mov ${mov_pvc} --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_pvc_ucbj.nii --reg ${reg}
# mri_segstats --seg ${seg} --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${stats} --i ${mov}
# mri_segstats --seg $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_unpvc_ucbj.nii --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${subject}/stats/aparcaseg_2_unpvc_ucbj.dat --i ${mov_unpvc}
# mri_segstats --seg $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_pvc_ucbj.nii --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${subject}/stats/aparcaseg_2_pvc_ucbj.dat --i ${mov_pvc}
