# Extract ASL and R1 statistics

#!/bin/bash
# Load modules
module unload fsl/5.0.10
module load fsl/6.0.3
module load freesurfer/7.1.0

# Parameters
export SUBJECTS_DIR=/lustre/archive/p00423/PREVENT_Elijah/Neuroimage_ASLxR1/freesurfer
r1="/lustre/archive/p00423/PREVENT_Elijah/Neuroimage_ASLxR1/${subject}/${subject}_AV-1451_R1_Radio"
targ="$SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz"
lta="$SUBJECTS_DIR/${subject}/r1/coreg.lta"
interp="nearest"
aparcaseg_r1="$SUBJECTS_DIR/${subject}/r1/aparcaseg_r1.mgz"

# CD to subject
cd $SUBJECTS_DIR
cd $subject

# Downsample aparcaseg parcellations to native ASL
mri_vol2vol --mov ${r1}.nii --targ ${targ} --lta ${lta} --${interp} --o ${aparcaseg_r1} --inv

# Extract statistics
mri_segstats --seg $SUBJECTS_DIR/${i}/r1/aparcaseg_r1.mgz --i ${r1}.nii --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt --sum $SUBJECTS_DIR/${i}/stats/r1_aparcaseg.stats
