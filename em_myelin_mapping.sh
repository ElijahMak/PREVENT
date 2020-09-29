# Myelin Mapping

# Objectives
# To register raw T1 and T2, before deriving myelin maps using FSLMATHs.
# T1 brains were generated from CAT12 segmentations.

# Author: Elijah Mak
# Date: 17th September 2020

#!/bin/bash

# Load modules
module unload fsl/5.0.10
module load fsl/6.0.1

# Parameters
i="${1}"
T1="T1w_${i}.nii"
T2="T2w_${i}.nii"
T1_brain="T1w_${i}_cat12_brain.nii.gz"
omat="${i}_T2toT1_NMI.mat"
rT2="${i}_T2toT1_NMI"
mask="${i}_cat12_brain_mask.nii"

# Enter directory
cd ${i}

# Linear registration
flirt -in ${T2} -ref ${T1_brain} -dof 6 -cost normmi -omat $omat -out $rT2

# Derive myelin map
fslmaths ${T1} -div ${rT2} ${i}_myelin

# Derive myelin brain map
fslmaths ${i}_myelin -mul ${mask} ${i}_myelin_brain
