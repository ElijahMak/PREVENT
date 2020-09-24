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
mye_dr="0.2 1"

# GM Axial
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render -outfile ${dir}/${outputdir}/${subject}.MYELIN.png --scene lightbox --hideCursor  --worldLoc -25.040941687671577 -37.32170315056568 -22.79834519205592 --displaySpace /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/T1w_CB001.nii --zaxis 2 --sliceSpacing 6 --zrange 68.22089955694904 194.9572843305086 --ncols 7 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/T1w_CB001.nii --name "T1w_CB001" --overlayType volume --alpha 100.0 --brightness 60.63218390804598 --contrast 71.26436781609196 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 1405.92 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/mri/p1T1w_CB001.nii --name "p1T1w_CB001" --overlayType volume --alpha 48.28306686791663 --brightness 50.0 --contrast 50.0 --cmap red-yellow --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

# GM Coronal
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render -outfile ${dir}/${outputdir}/${subject}.MYELIN.png --scene lightbox --hideCursor  --worldLoc -25.040941687671577 -37.32170315056568 -22.79834519205592 --displaySpace /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/T1w_CB001.nii --zaxis 1 --sliceSpacing 6 --zrange 68.22089955694904 194.9572843305086 --ncols 7 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/T1w_CB001.nii --name "T1w_CB001" --overlayType volume --alpha 100.0 --brightness 60.63218390804598 --contrast 71.26436781609196 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 1405.92 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/mri/p1T1w_CB001.nii --name "p1T1w_CB001" --overlayType volume --alpha 48.28306686791663 --brightness 50.0 --contrast 50.0 --cmap red-yellow --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

# GM Sag
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render -outfile ${dir}/${outputdir}/${subject}.MYELIN.png --scene lightbox --hideCursor --worldLoc -25.040941687671577 -37.32170315056568 -22.79834519205592 --displaySpace /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/T1w_CB001.nii --zaxis 0 --sliceSpacing 6 --zrange 68.22089955694904 194.9572843305086 --ncols 7 --nrows 2 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/T1w_CB001.nii --name "T1w_CB001" --overlayType volume --alpha 100.0 --brightness 60.63218390804598 --contrast 71.26436781609196 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 1405.92 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/mri/p1T1w_CB001.nii --name "p1T1w_CB001" --overlayType volume --alpha 48.28306686791663 --brightness 50.0 --contrast 50.0 --cmap red-yellow --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 

# WM
pkill Xvfb -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor  --worldLoc -25.040941687671577 -37.32170315056568 -22.79834519205592 --displaySpace /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/T1w_CB001.nii --zaxis 2 --sliceSpacing 6 --zrange 68.22089955694904 194.9572843305086 --ncols 7 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/T1w_CB001.nii --name "T1w_CB001" --overlayType volume --alpha 100.0 --brightness 60.63218390804598 --contrast 71.26436781609196 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 1405.92 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 /Volumes/NEURITE/PREVENT_700/QC/Freesurfer7_T1/mri/p2T1w_CB001.nii --name "p1T1w_CB001" --overlayType volume --alpha 48.28306686791663 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

