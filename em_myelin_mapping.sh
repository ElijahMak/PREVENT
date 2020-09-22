# Myelin Mapping

# Objective
# To register bias-corrected T1 and T2, before deriving myelin maps using FSLMATHs.

# Author: Elijah Mak
# Date: 17th September 2020

#!/bin/bash

# Load modules
module unload fsl/5.0.10
module load fsl/6.0.1

# Parameters
i="${1}"
T1="T1w_${i}_BFC"
T2="T2w_${i}_BFC"
omat="${i}_T2toT1_NMI.mat"
rT2="${i}_T2toT1_NMI"
mask="T1w_${i}_BFC_brain_mask.nii"

# Enter directory
cd ${i}

# Linear registration
flirt -in ${T2}.nii -ref ${T1}.nii -dof 6 -cost normmi -omat $omat -out $rT2

# Derive myelin map
fslmaths ${T1}.nii -div $rT2 ${i}_myelin

# Derive myelin brain map
fslmaths ${i}_myelin -mul ${mask} ${i}_myelin_brain
