# # Script to perform the full pipeline of DWI preprocessing
# # Author: Elijah Mak
#
# # Objectives
# # --------------------------------------------------------
# # Denoising
# # Brain extraction
# # Eddy current correction
# # Fitting of DTI tensors
# # Generating RD maps
# # Normalisation to FMRIB
# # Inverse warping of JHU labels
# # Calculate DTI metrics in JHU
#
# # Load required modules
# module load MRtrix/mrtrix3rc2
# module unload fsl/5.0.10
# module load fsl/6.0.3
# module load freesurfer/7.1.0
#
# Define variables
subject="${1}"
BET=${2}
input_denoise="dwi.nii"
input_edc="dwi.denoised.nii"
mask="b0_brain_mask.nii.gz"
bvec="bvec"
bval="bval"
rotated_bvecs="edc.repol.eddy_rotated_bvecs"
output_edc="edc.repol";
input_dti="edc.repol.nii.gz"
output_dti="dti"
outputdir="/lustre/archive/p00423/QualityControl/dwi/"
fa_fmrib="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA_fnirt_FMRIB58.nii"
fmrib="/lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz"
fa_fmrib_mask="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA_fnirt_FMRIB58_mask.nii"

# Initialising Text
echo "Diffusion pipeline started at $(date)"
echo "Initialising diffusion preprocessing for ${subject}"

# Switch to subject directory
cd ${subject}

# # 1 Denoise
# dwidenoise $input_denoise $input_edc
#
# # 2 Brain extraction
# if [ "${BET}" = "0" ]; then
#   echo "Running BET"
#   echo "fslroi ${input_edc} b0 0 1"
#   fslroi ${input_edc} b0 0 1
#   echo "bet b0 b0_brain -m -f 0.2"
#   bet b0 b0_brain -m -f 0.2
# else
#   echo "Using corrected BET"
#   mask="b0_brain_mask.nii.gz"
# fi
#
# # 2.1 Generate screenshots
# echo "Started: b0 mask screenshots ${subject}"
# pkill Xvfb

# xvfb-run -s "-screen 0, 1024x768x24" fsleyes render --scene lightbox --outfile ${outputdir}/${subject}.b0.mask.png --worldLoc 108.2101927736983 124.64060310792524 -42.83765119809547 --displaySpace b0 --zaxis 2 --sliceSpacing 2.0 --zrange -1.0 124.99980163574219 --ncols 10 --nrows 10 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --hideCursor --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync b0 --name "b0" --overlayType volume --alpha 100.0 --brightness 67.02551834130782 --contrast 84.05103668261563 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 2533.08 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${mask} --name "b0_brain_mask" --overlayType volume --alpha 47.76828976994573 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0
#
# echo "Completed: b0 mask screenshots ${subject}"
#
#
# # Generate index files
# echo "Started: Gen index files ${subject}"
#
# myVar=($(wc -w bval)) #Count the number of volumes and save as a variable
# indx=""
# for ((i=1; i<=$myVar; i+=1)); do indx="$indx 1"; done
# echo $indx > index.txt
#
# echo "Completed: Gen index files ${subject}"
#
#
# # 3 Eddy
# echo "Started: Eddy ${subject}"
#
# eddy_openmp --imain=$input_edc \
# --mask=$mask --acqp=acqparams.txt \
# --index=index.txt --bvecs=$bvec \
# --bvals=$bval --fwhm=10,0,0,0,0 \
# --repol \
# --out=$output_edc \
# --cnr_maps \
# --verbose
#
# echo "Completed: Eddy ${subject}"
#
#
# # 4 Fit tensors
# echo "Started: DTIFIT ${subject}"
#
# dtifit --data=$input_dti  \
# --mask=$mask \
# --bvecs=$rotated_bvecs \
# --bvals=$bval \
# --out=$output_dti
#
# echo "Ended: Eddy ${subject}"


echo "Started: Gen screenshots for tensor check ${subject}"

# 4 Generate screenshots
pkill Xvfb

xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.fa.tensor.png --hideCursor --scene ortho --worldLoc 4.730075084169755 -1.9461487140778786 56.261993285775134 --displaySpace dti_V1.nii.gz --xcentre -0.01637  0.48866 --ycentre  0.06170  0.48866 --zcentre  0.06170 -0.01637 --xzoom 1667.0088434980737 --yzoom 1667.0088434980737 --zzoom 1667.0088434980737 --hideLabels --labelSize 14 --layout horizontal --hidez --hideCursor --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync dti_FA.nii.gz --name "dti_FA" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 1.2247447967529297 --clippingRange 0.0 1.2369922447204589 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 dti_V1.nii.gz --name "dti_V1" --overlayType linevector --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --lineWidth 3.8377115005715083 --lengthScale 100.0 --xColour 1.0 0.0 0.0 --yColour 0.0 1.0 0.0 --zColour 0.0 0.0 1.0 --suppressMode white --modulateRange 0.0 1.0 --clippingRange 0.0 1.0

echo "Completed: Gen screenshots for tensor check ${subject}"


# 5 Derive RD
echo "Started: Gen RD maps ${subject}"

fslmaths L1 -add L2 -div 2 dti_RD

echo "Completed: Gen RD maps ${subject}"


# 6 Normalisation to MNI152

# Parameters
FA="dti_FA.nii.gz"
MD="dti_MD.nii.gz"
RD="dti_RD.nii.gz"
ref="/lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz"
flirt_out="dti_FA_flirt_FMRIB58.nii"
omat="dti_FA_flirt_FMRIB58.mat"
bins="256"
cost="corratio"
dof="12"
interp="trilinear"
cout="dti_FA_fnirt_FMRIB58.mat"
FA_fnirt_out="dti_FA_fnirt_FMRIB58.nii"
MD_fnirt_out="dti_MD_fnirt_FMRIB58.nii"
RD_fnirt_out="dti_RD_fnirt_FMRIB58.nii"

# FLIRT
echo "Started: Normalistion to FMRIB using FA ${subject}"

flirt -in $FA -ref $ref -out $flirt_out -omat $omat -bins $bins -cost $cost \
-searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof $dof -interp $interp

# FNIRT
fnirt --ref=$ref --in=$FA --aff=$omat \
--cout=$cout --config=FA_2_FMRIB58_1mm

# Apply warps
applywarp --ref=${ref} --in=$FA --warp=$cout \
--out=${FA_fnirt_out}
applywarp --ref=${ref} --in=$MD --warp=$cout \
--out=${MD_fnirt_out}
applywarp --ref=${ref} --in=${RD} --warp=$cout \
--out=${RD_fnirt_out}

echo "Completed: Normalistion to FMRIB using FA ${subject}"

# Generate screenshots
echo "Started: Gen screenshots for normalisation ${subject}"

xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile ${outputdir}/${subject}.fa.fmrib.png  --scene lightbox --hideCursor --worldLoc 51.881539367386516 91.3974919323673 -51.81227616006569 --displaySpace /lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz --zaxis 2 --sliceSpacing 4.77867613448265 --zrange 17.798385772692978 162.01332661970616 --ncols 9 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync /lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz --name "FMRIB" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${fa_fmrib} --name "FA" --overlayType volume --alpha 81.52252905571892 --brightness 61.21621728204645 --contrast 81.6216230427286 --cmap red-yellow --negativeCmap greyscale --displayRange 0 0.7 --clippingRange 0 0.7 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection

echo "Completed: Gen screenshots for normalisation ${subject}"

# 7 Inverse transform JHU labels from FMRIB space
echo "Started: Inverse warp JHU labels ${subject}"

mkdir warped_jhu

invwarp --warp=${FA_fnirt_out}\
--ref=${FA} \
--out=invwarp_FMRIB_to_FA

for i in {1..48}
do
  applywarp -i /lustre/archive/p00423/PREVENT_Elijah/data/em_jhu_toolbox/${i}.nii.gz \
  -o warped_jhu/${i}.nii.gz \
  -r ${fa} \
  -w invwarp_FMRIB_to_FA.nii.gz \
  --interp=nn
done

echo "Completed: Inverse warp JHU labels ${subject}"

# 8 Calculate metrics of JHU labels in native space
echo "Started: Calculating FA, MD, and RD in JHU labels ${subject}"

for dti in FA MD RD; do
  file="dti_${dti}.nii"
  if [ -f ${file} ]; then
    for roinum in {1..48} ; do
      padroi=`$FSLDIR/bin/zeropad $roinum 3`
      if [ -f ${subject}_${dti}_jhu_native_roi${padroi}.txt ];
      then
        rm ${subject}_${dti}_jhu_native_roi${padroi}.txt;
      fi
      fslmeants -i ${file} -m warped_jhu/${roinum}.nii >> ${subject}_${dti}_jhu_native_roi${padroi}.txt
      paste *${dti}_jhu_native*.txt > all_${dti}_jhu.txt
    done
  else
    for roinum in {1..48} ; do
      padroi=`$FSLDIR/bin/zeropad $roinum 3`
      if [ -f ${subject}_${dti}_jhu_native_roi${padroi}.txt ]; then
        rm ${subject}_${dti}_jhu_native_roi${padroi}.txt; fi
        echo "NA" >> ${subject}_${dti}_jhu_native_roi${padroi}.txt
        paste *${dti}_jhu_native*.txt > all_${dti}_jhu.txt
      done
    fi
  done

echo "Completed: Calculating FA, MD, and RD in JHU labels ${subject}"
echo "Diffusion pipeline completed at $(date)"
