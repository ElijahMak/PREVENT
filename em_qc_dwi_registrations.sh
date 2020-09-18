# Produce screenshots of FA in T1 and MNI spaces.
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
T1="T1w_${subject}_BFC_brain.nii"
FA_flirt="FAtoT1_NMI.nii.gz"
FMRIB="FMRIB58_FA_1mm.nii.gz"
FA_fnirt="dti_FA_fnirt_FMRIB58.nii"
outputdir="QC"
cm="blue-lightblue"
alpha="75"
dr="0.2 1"

# FA FLIRT
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 8 --ncols 3 --nrows 3 --outfile ${dir}/${outputdir}/${subject}.FA.FLIRT.T1.png ${subject}/${T1} ${subject}/${FA_flirt} -cm $cm --alpha $alpha -dr $dr

# FA FNIRT FMRIB68
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 8 --ncols 3 --nrows 3 --outfile ${dir}/${outputdir}/${subject}.FA.FNIRT.FMRIB.png ${FMRIB} ${subject}/${FA_fnirt} -cm $cm --alpha $alpha -dr $dr 
