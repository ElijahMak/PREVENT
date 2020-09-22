# PREVENT QC Pipeline
# Author: Elijah Mak
# Date: 17th September 2020

# Module
module unload fsl/5.0.10
module unload fsl/6.0.1
module load fsl/6.0.3

# Directory
dir="/lustre/archive/p00423/PREVENT_Elijah/FAST"

# Subject
subject="${1}"

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
MYELIN="${subject}_myelin.nii"

# Settings
outputdir="QC"
cm="blue-lightblue"
alpha="75"
dr="0 1"
fa_dr="0.2 1"
cols="5"

# MYELIN
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.MYELIN.png ${subject}/${T1} ${subject}/${MYELIN} -cm $cm --alpha $alpha -dr $dr

# BET
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.BET.png ${subject}/${T1} ${subject}/${BRAIN} -cm $cm --alpha $alpha -dr $dr

# GM
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.GM.png ${subject}/${T1} ${subject}/${GM} -cm $cm --alpha $alpha -dr $dr

# WM
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.WM.png ${subject}/${T1} ${subject}/${WM} -cm $cm --alpha $alpha -dr $dr

# B0 and Brain Mask
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.B0MASK.png ${subject}/${b0} --displayRange 0.0 700.00  ${subject}/${b0_mask} -cm $cm --alpha $alpha -dr $dr.0 --clippingRange 0.0 2602.77 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

# FA FLIRT
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 8 --ncols 3 --nrows 3 --outfile ${dir}/${outputdir}/${subject}.FA.FLIRT.T1.png ${subject}/${T1} ${subject}/${FA_flirt} -cm $cm --alpha $alpha -dr $fa_dr

# FA FNIRT FMRIB68
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 8 --ncols 3 --nrows 3 --outfile ${dir}/${outputdir}/${subject}.FA.FNIRT.FMRIB.png ${FMRIB} ${subject}/${FA_fnirt} -cm $cm --alpha $alpha -dr $fa_dr
