#!/bin/bash

# Load modules
. /etc/profile.d/modules.sh
module purge
module load default-wbic
module load openmpi/3.0.0
module load freesurfer/7.1.0

# Directory
export SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/Freesurfer7_T1FLAIR"

subject=${1}

# Recon-all
recon-all -s ${subject} \
-i ${SUBJECTS_DIR}/T1w_${subject}.nii \
-FLAIR ${SUBJECTS_DIR}/FLAIR_${subject}.nii \
-FLAIRpial \
-all \
-openmp 8 \
