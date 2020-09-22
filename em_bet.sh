# Perform BET extraction.

# Author: Elijah Mak
# Date : 17th September 2020

# Objectives
# Enable simple statistics of volumes in native T1
# Enable calculation of mean DWI / myelin metrics 
# bash em_bet_fast.sh ${subject} "site" (i.e. WL)

# Updates
# 17.9.2029. BET was failing on WL subjects (i.e. excessive neck). 
#            Added "-B -S -R" to BET command for WL subjects.
# 21.9.2029. Added FOV as a setting to deal with large FOV.
# 21.9.2029. Added function to capture QC screenshots.

# Module
module unload fsl/5.0.10
module unload fsl/6.0.1
module load fsl/6.0.3
# Directory
dir="/lustre/archive/p00423/PREVENT_Elijah/FAST"

# Subject
subject=${1}
cd ${subject}
setting=${2}

# Images 
T1="T1w_${subject}_BFC.nii"
BRAIN="T1w_${subject}_BFC_brain.nii"

# Parameters
t1_bfc="T1w_${subject}_BFC.nii"

if [ "${setting}" = "FOV" ]; then
# Run BET with large FOV settings
echo "robustfov -i ${t1_bfc} -r T1w_${subject}_BFC_FOV_crop"
robustfov -i ${t1_bfc} -r T1w_${subject}_BFC_FOV_crop
echo "bet T1w_${subject}_BFC_FOV_crop ${BRAIN} -R -f 0.3 -m"
bet T1w_${subject}_BFC_FOV_crop.nii ${BRAIN} -R -f 0.3 -m
else
# Run BET with default settings
echo "${t1_bfc} ${BRAIN}"
bet ${t1_bfc} ${BRAIN}
fi

cp ${BRAIN} ${dir}/QC
