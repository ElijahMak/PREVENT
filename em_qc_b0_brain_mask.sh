# PREVENT QC Pipeline

# Author: Elijah Mak
# Date: 17th September 2020

# Module
module unload fsl/5.0.10
module unload fsl/6.0.1
module load fsl/6.0.3

# Directory
dir="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised"
outputdir="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/QC"

# Subject
subject="${1}"

# Images 
b0="${subject}/b0.nii.gz"
b0mask="b0_masks/${subject}_b0_brain_mask.nii.gz"

# Settings
cm="blue-lightblue"
alpha="65"
dr="0 1"
cols="3"
rows="3"

# QC b0 mask
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --outfile ${outputdir}/${subject}.b0.mask.sag.png --worldLoc 75.29885899478357 -64.5606884122168 109.51285666632612 --displaySpace world --zaxis 0 --sliceSpacing 7.578215848323474 --zrange -0.4998931884765625 79.08796691894531 --ncols $cols --nrows $rows --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --hideCursor --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${b0} --name "b0" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 1218.2269287109375 --clippingRange 0.0 1230.409197998047 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${b0mask} --name "b0mask" --overlayType volume --alpha 49.16121606928325 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange ${dr} --clippingRange 0.0 933.2130609130859 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --hideCursor --sliceSpacing 5 --ncols $cols --nrows $cols --outfile ${outputdir}/${subject}.b0.mask.sag2.png ${b0} --displayRange 0.0 700.00 ${b0_mask} -cm $cm --alpha $alpha -dr $dr --clippingRange 0.0 2602.77 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --outfile ${outputdir}/${subject}.b0.mask.3.png --worldLoc 108.2101927736983 124.64060310792524 -42.83765119809547 --displaySpace ${b0} --zaxis 2 --sliceSpacing 2.0 --zrange -1.0 124.99980163574219 --ncols 19 --nrows 4 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${b0} --name "b0" --overlayType volume --alpha 100.0 --brightness 67.02551834130782 --contrast 84.05103668261563 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 2533.08 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${b0mask} --name "b0_brain_mask" --overlayType volume --alpha 47.76828976994573 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0
