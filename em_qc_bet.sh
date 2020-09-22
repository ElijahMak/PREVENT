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

# Settings
outputdir="QC"
cm="blue-lightblue"
alpha="65"
dr="0 1"
cols="5"

# BET
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${dir}/${outputdir}/${subject}.BET.png ${subject}/${T1} ${subject}/${BRAIN} -cm $cm --alpha $alpha -dr $dr
