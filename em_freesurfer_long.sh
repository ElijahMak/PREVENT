#!/bin/bash

# Load modules
. /etc/profile.d/modules.sh
module purge
module load default-wbic
module load openmpi/3.0.0
module load freesurfer/7.1.0
module load ANTS/2.3.4

# Directory
export SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/project_msn"

subject=${1}

# Recon-all

N4BiasFieldCorrection -i T1w_${subject}v1.nii -o T1w_${subject}v1_N4.nii

recon-all -s ${subject}v1 \
-i ${SUBJECTS_DIR}/T1w_${subject}v1_N4.nii \
-all \
-openmp 4

N4BiasFieldCorrection -i T1w_${subject}v2.nii -o T1w_${subject}v2_N4.nii

recon-all -s ${subject}v2 \
-i ${SUBJECTS_DIR}/T1w_${subject}v2_N4.nii \
-all \
-openmp 4

recon-all -base ${subject} -tp ${subject}v1 -tp ${subject}v2 -all

recon-all -long ${subject}v1  ${subject} -all
recon-all -long ${subject}v2  ${subject} -all
