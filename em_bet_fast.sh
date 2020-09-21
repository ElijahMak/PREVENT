# Perform BET extraction and FAST segmentation 
# for GM, WM and CSF volumes.

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


# Module
module unload fsl/5.0.10
module load fsl/6.0.1

# Subject
i=${1}
cd ${i}
setting=${2}

# Parameters
t1_bfc="T1w_${i}_BFC.nii"

if [ "${setting}" = "WL" ]; then
# Run BET with WL settings
echo "${t1_bfc} ${t1_bfc}_brain -B -S -R"
bet ${t1_bfc} ${t1_bfc}_brain -B -S -R
else if [ "${setting}" = "FOV" ]
# Run BET with large FOV settings
echo "robustfov -i ${t1_bfc} -r T1w_WL001_BFC_FOV_crop"
robustfov -i ${t1_bfc} -r T1w_${i}_BFC_FOV_crop
echo "bet T1w_${i}_BFC_FOV_crop ${t1_bfc}_brain -R"
bet T1w_${i}_BFC_FOV_crop ${t1_bfc}_brain -R
else
# Run BET with default settings
echo "${t1_bfc} ${t1_bfc}_brain"
bet ${t1_bfc} ${t1_bfc}_brain
fi

# Run FAST
fast ${t1_bfc}_brain

# To generate images for QC of segmentations, run em_qc_segmentations.sh
