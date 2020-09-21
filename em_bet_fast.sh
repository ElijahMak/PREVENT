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
# 21.9.2029. Added function to capture QC screenshots.

# Module
module unload fsl/5.0.10
module unload fsl/6.0.1
module load fsl/6.0.3

# Directory
dir="/lustre/archive/p00423/PREVENT_Elijah/FAST"

# Subject
subject=${1}
cd ${i}
setting=${2}

# Images 
T1="T1w_${subject}_BFC.nii"
BRAIN="T1w_${subject}_BFC_brain.nii"
GM="T1w_${subject}_BFC_brain_pve_1.nii"
WM="T1w_${subject}_BFC_brain_pve_2.nii"
b0="b0.nii.gz"
b0_mask="b0_brain_mask.nii.gz"
FA_flirt="FAtoT1_NMI.nii.gz"
FMRIB="FMRIB58_FA_1mm.nii.gz"
FA_fnirt="dti_FA_fnirt_FMRIB58.nii"

# Settings
outputdir="QC"
cm="blue-lightblue"
alpha="75"
dr="0 1"
fa_dr="0.2 1"
cols="5"

# Parameters
t1_bfc="T1w_${subject}_BFC.nii"

if [ "${setting}" = "WL" ]; then
# Run BET with WL settings
echo "${t1_bfc} ${t1_bfc}_brain -B -S -R"
bet ${t1_bfc} ${t1_bfc}_brain -B -S -R
elif [ "${setting}" = "FOV" ]; then
# Run BET with large FOV settings
echo "robustfov -i ${t1_bfc} -r T1w_${subject}_BFC_FOV_crop"
robustfov -i ${t1_bfc} -r T1w_${subject}_BFC_FOV_crop
echo "bet T1w_${subject}_BFC_FOV_crop ${t1_bfc}_brain -R"
bet T1w_${subject}_BFC_FOV_crop.nii ${t1_bfc}_brain -R
else
# Run BET with default settings
echo "${t1_bfc} ${t1_bfc}_brain"
bet ${t1_bfc} ${t1_bfc}_brain
fi

# Run FAST
fast ${t1_bfc}_brain

# Generate QC

# BET
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.BET.png ${subject}/${T1} ${subject}/${BRAIN} -cm $cm --alpha $alpha -dr $dr

# GM
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.GM.png ${subject}/${T1} ${subject}/${GM} -cm $cm --alpha $alpha -dr $dr

# WM
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.WM.png ${subject}/${T1} ${subject}/${WM} -cm $cm --alpha $alpha -dr $dr
