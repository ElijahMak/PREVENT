#!/bin/bash

# Load modules
. /etc/profile.d/modules.sh
module purge
module load default-wbic
module load openmpi/3.0.0
module load freesurfer/7.1.0

# Directory
export SUBJECTS_DIR="lustre/archive/p00423/PREVENT_Elijah/Freesurfer7_T1T2"
subject=${1}

# Recon-all
recon-all -s ${subject} \
-i ${SUBJECTS_DIR}/T1w_${subject}.nii \
-T2 ${SUBJECTS_DIR}/T2w_${subject}.nii \
-all \
-openmp 4

