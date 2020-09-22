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

# Enter directory
cd ${i}

# Standardise FSL orientation
fslreorient2std ${T1}.nii ${T1}_std.nii
fslreorient2std ${T2}.nii ${T2}_std.nii

# Linear registration
flirt -in ${T2}_std.nii -ref ${T1}_std.nii -dof 6 -cost normmi -omat $omat -out $rT2

# Derive myelin map
fslmaths ${T1}_std -div $rT2 ${i}_myelin

