
#Author: Elijah Mak

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
subject=29121

SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"
#mri_segstats --seg $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_unpvc_ucbj.nii --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${subject}/stats/aparcaseg_2_unpvc_ucbj.dat --i ${mov_unpvc}

mri_segstats --seg $SUBJECTS_DIR/${subject}/ucbj2/aparcaseg_2_pvc_ucbj.nii --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --excludeid 0 --sum ${subject}/stats/aparcaseg_2_pvc_ucbj.dat --i ${mov_pvc} --mask /lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/29121/29121_UCB-J_PVC_BP_Radio_Mask.nii --maskinvert
