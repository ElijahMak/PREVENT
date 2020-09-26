	# PREVENT QC Pipeline
	# Author: Elijah Mak
	# Date: 17th September 2020

	# Module
	module unload fsl/5.0.10
	module unload fsl/6.0.1
	module load fsl/6.0.3

	# Directory
	dir="/lustre/archive/p00423/PREVENT_Elijah/CAT12"
	outputdir="/lustre/archive/p00423/PREVENT_Elijah/CAT12/QC"
	fa_fmrib="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA_fnirt_FMRIB58.nii"
fmrib="/lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz"
	# Subject
	subject="${1}"

	input = ${2}

	if [ $input == "all" ]; then
	# GM Axial
	pkill Xvfb
	xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.gm.axial.png --scene lightbox --hideCursor  --worldLoc -25.040941687671577 -37.32170315056568 -22.79834519205592 --displaySpace ${dir}/T1w_${subject}.nii --zaxis 2 --sliceSpacing 6 --zrange 68.22089955694904 194.9572843305086 --ncols 7 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${dir}/T1w_${subject}.nii --name "T1w_${subject}" --overlayType volume --alpha 100.0 --brightness 60.63218390804598 --contrast 71.26436781609196 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 1405.92 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${dir}/mri/p1T1w_${subject}.nii --name "p1T1w_${subject}" --overlayType volume --alpha 48.28306686791663 --brightness 50.0 --contrast 50.0 --cmap red-yellow --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

	# GM Coronal
	pkill Xvfb
	xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.gm.coronal.png  --scene lightbox --hideCursor  --worldLoc -25.040941687671577 -37.32170315056568 -22.79834519205592 --displaySpace ${dir}/T1w_${subject}.nii --zaxis 1 --sliceSpacing 6 --zrange 68.22089955694904 194.9572843305086 --ncols 7 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${dir}/T1w_${subject}.nii --name "T1w_${subject}" --overlayType volume --alpha 100.0 --brightness 60.63218390804598 --contrast 71.26436781609196 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 1405.92 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${dir}/mri/p1T1w_${subject}.nii --name "p1T1w_${subject}" --overlayType volume --alpha 48.28306686791663 --brightness 50.0 --contrast 50.0 --cmap red-yellow --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

	# GM Sag
	pkill Xvfb
	xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.gm.sag.png  --scene lightbox --hideCursor --worldLoc -25.040941687671577 -37.32170315056568 -22.79834519205592 --displaySpace  ${dir}/T1w_${subject}.nii --zaxis 0 --sliceSpacing 4 --zrange 68.22089955694904 194.9572843305086 --ncols 7 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${dir}/T1w_${subject}.nii --name "T1w_${subject}" --overlayType volume --alpha 100.0 --brightness 60.63218390804598 --contrast 71.26436781609196 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 1405.92 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${dir}/mri/p1T1w_${subject}.nii --name "p1T1w_${subject}" --overlayType volume --alpha 48.28306686791663 --brightness 50.0 --contrast 50.0 --cmap red-yellow --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

	# WM
	pkill Xvfb
	xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.wm.png  --scene lightbox --hideCursor  --worldLoc -25.040941687671577 -37.32170315056568 -22.79834519205592 --displaySpace ${dir}/T1w_${subject}.nii --zaxis 1 --sliceSpacing 6 --zrange 68.22089955694904 194.9572843305086 --ncols 7 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${dir}/T1w_${subject}.nii --name "T1w_${subject}" --overlayType volume --alpha 100.0 --brightness 60.63218390804598 --contrast 71.26436781609196 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 1405.92 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${dir}/mri/p2T1w_${subject}.nii --name "p2T1w_${subject}" --overlayType volume --alpha 48.28306686791663 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0


	## CAT12 normalisation

	# GM
	pkill Xvfb
	xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.gm.mni152.png  --scene lightbox --hideCursor --worldLoc 51.881539367386516 91.3974919323673 -51.81227616006569 --displaySpace ${dir}/MNI152_T1_1mm_brain.nii.gz --zaxis 2 --sliceSpacing 4.77867613448265 --zrange 17.798385772692978 162.01332661970616 --ncols 9 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${dir}/MNI152_T1_1mm_brain.nii.gz --name "MNI152_T1_1mm_brain" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 /${dir}/mri/mwp1T1w_${subject}.nii --name "mwp1T1w_${subject}" --overlayType volume --alpha 81.52252905571892 --brightness 61.21621728204645 --contrast 81.6216230427286 --cmap red-yellow --negativeCmap greyscale --displayRange 0.2 1.0 --clippingRange 0.2 1 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

	# WM
	pkill Xvfb
	xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.wm.mni152.png  --scene lightbox --hideCursor --worldLoc 51.881539367386516 91.3974919323673 -51.81227616006569 --displaySpace ${dir}/MNI152_T1_1mm_brain.nii.gz --zaxis 2 --sliceSpacing 4.77867613448265 --zrange 17.798385772692978 162.01332661970616 --ncols 9 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${dir}/MNI152_T1_1mm_brain.nii.gz --name "MNI152_T1_1mm_brain" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 /${dir}/mri/mwp2T1w_${subject}.nii --name "mwp2T1w_${subject}" --overlayType volume --alpha 81.52252905571892 --brightness 61.21621728204645 --contrast 81.6216230427286 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.2 1.0 --clippingRange 0.2 2.1982354640960695 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

	# DWI FMRIB normalisation

	# FA
	pkill Xvfb
	xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.fa.fmrib.png  --scene lightbox --hideCursor --worldLoc 51.881539367386516 91.3974919323673 -51.81227616006569 --displaySpace /lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz --zaxis 2 --sliceSpacing 4.77867613448265 --zrange 17.798385772692978 162.01332661970616 --ncols 9 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync /lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz --name "FMRIB" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 /${fa_fmrib} --name "FA" --overlayType volume --alpha 81.52252905571892 --brightness 61.21621728204645 --contrast 81.6216230427286 --cmap red-yellow --negativeCmap greyscale --displayRange 0 0.7 --clippingRange 0 0.7 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

elif [ $input == "dwi_fmrib" ]; then

	pkill Xvfb
	xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.fa.fmrib.png  --scene lightbox --hideCursor --worldLoc 51.881539367386516 91.3974919323673 -51.81227616006569 --displaySpace /lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz --zaxis 2 --sliceSpacing 4.77867613448265 --zrange 17.798385772692978 162.01332661970616 --ncols 9 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync /lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz --name "FMRIB" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 /${fa_fmrib} --name "FA" --overlayType volume --alpha 81.52252905571892 --brightness 61.21621728204645 --contrast 81.6216230427286 --cmap red-yellow --negativeCmap greyscale --displayRange 0 0.7 --clippingRange 0 0.7 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

fi
