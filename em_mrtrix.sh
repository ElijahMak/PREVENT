# MRTRIX pipeline

# To generate connectomes from eddy-corrected data.
# Author: Elijah Mak

# Modules
# -----------------------------------------------------------------------------

module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

# Parameters
# -----------------------------------------------------------------------------

dir="/lustre/archive/p00423/PREVENT_Elijah/MRTRIX"
subject=${1}
BET=${2}
raw_dwi="dwi.nii"
denoised_dwi="dwi.denoised.nii"
denoised_degibbs_dwi="dwi.denoised.degibbs.nii"
b0="denoised_degibbs_dwi_b0.nii"
mask="denoised_degibbs_dwi_b0_brain_f0.2_mask.nii"
output_edc="denoised_degibbs.edc.repol"
edc="denoised_degibbs.edc.repol.nii"
edc_rotated_bvecs="denoised_degibbs.edc.repol.eddy_rotated_bvecs"
edc_mif="denoised_degibbs.edc.repol.mif"
edc_mif_bfc="denoised_degibbs.edc.repol.bfc.mif"
edc_mif_bfc_tensor="denoised_degibbs.edc.repol.bfc.tensor.mif"
edc_mif_bfc_tensor_FA="denoised_degibbs.edc.repol.bfc.tensor.FA.mif"
edc_mif_bfc_tensor_MD="denoised_degibbs.edc.repol.bfc.tensor.MD.mif"
edc_mif_bfc_tensor_RD="denoised_degibbs.edc.repol.bfc.tensor.RD.mif"
edc_mif_bfc_tensor_AD="denoised_degibbs.edc.repol.bfc.tensor.AD.mif"
edc_nii_bfc_tensor_FA="denoised_degibbs.edc.repol.bfc.tensor.FA.nii"
edc_nii_bfc_tensor_MD="denoised_degibbs.edc.repol.bfc.tensor.MD.nii"
edc_nii_bfc_tensor_RD="denoised_degibbs.edc.repol.bfc.tensor.RD.nii"
edc_nii_bfc_tensor_AD="denoised_degibbs.edc.repol.bfc.tensor.AD.nii"

# # Initialising Text
# # -------------------------------------------------------------------------------------------------
#
# echo "███████╗███╗   ███╗       ██████╗ ██╗███████╗███████╗██╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗
# ██╔════╝████╗ ████║       ██╔══██╗██║██╔════╝██╔════╝██║   ██║██╔════╝██║██╔═══██╗████╗  ██║
# █████╗  ██╔████╔██║       ██║  ██║██║█████╗  █████╗  ██║   ██║███████╗██║██║   ██║██╔██╗ ██║
# ██╔══╝  ██║╚██╔╝██║       ██║  ██║██║██╔══╝  ██╔══╝  ██║   ██║╚════██║██║██║   ██║██║╚██╗██║
# ███████╗██║ ╚═╝ ██║██╗    ██████╔╝██║██║     ██║     ╚██████╔╝███████║██║╚██████╔╝██║ ╚████║██╗
# ╚══════╝╚═╝     ╚═╝╚═╝    ╚═════╝ ╚═╝╚═╝     ╚═╝      ╚═════╝ ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝
#                                                                                                "
#
# echo "Diffusion pipeline started at $(date)"
# echo "Initialising diffusion preprocessing for ${subject}"
#
#
# # Preprocessing
# # -------------------------------------------------------------------------------------------------
# echo "================================"
# echo "         Preprocessing          "
# echo "================================"
#
cd ${dir}
cd ${subject}
#
# echo "" | > start_em_mrtrix
#
# echo "--------------------------------"
# echo "          Denoising             "
# echo "--------------------------------"
#
# # Denoising of DWI
# dwidenoise ${raw_dwi} ${denoised_dwi}
#
# echo "--------------------------------"
# echo "            DeGibbs             "
# echo "--------------------------------"
#
# # Remove Gibbs Ringing artifact
# mrdegibbs ${denoised_dwi} ${denoised_degibbs_dwi}
#
# echo "--------------------------------"
# echo "              BET               "
# echo "--------------------------------"
#
# # Perform brain extraction
# if [ "${BET}" = "0" ]; then
#   echo "Running BET [1/3]"
#   echo "fslroi $denoised_degibbs_dwi $b0 0 1"
#   fslroi ${denoised_degibbs_dwi} ${b0} 0 1
#
#   for f in 0.1 0.2 0.3 0.4; do
#     bet ${b0} denoised_degibbs_dwi_b0_brain_f${f} -m -f $f; done
# else
#   echo "Using edited BET [1/3]"
# fi
#
# echo "--------------------------------"
# echo "      Generate screenshots      "
# echo "--------------------------------"
#
# mkdir QC
#
# for f in 0.1 0.2 0.3 0.4; do
#
#   outfile="QC/b0.mask.f${f}.png"
#   qc_mask="denoised_degibbs_dwi_b0_brain_f${f}_mask.nii"
#
#   pkill Xvfb
#   xvfb-run -s "-screen 0, 1024x768x24" fsleyes render --scene lightbox --outfile $outfile --size 2500 2500 --worldLoc 108.2101927736983 124.64060310792524 -42.83765119809547 --displaySpace ${b0} --zaxis 2 --sliceSpacing 2.0 --zrange -1.0 124.99980163574219 --ncols 10 --nrows 10 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --hideCursor --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${b0} --name "b0" --overlayType volume --alpha 100.0 --brightness 67.02551834130782 --contrast 84.05103668261563 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 2533.08 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${qc_mask} --name "b0_brain_mask" --overlayType volume --alpha 47.76828976994573 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0
#
# done
#
# echo "--------------------------------"
# echo "              Eddy              "
# echo "--------------------------------"
#
# # Eddy current correction
# eddy_openmp --imain=${denoised_degibbs_dwi} \
# --mask=${mask} --acqp=acqparams.txt \
# --index=index.txt --bvecs=bvec \
# --bvals=bval --fwhm=10,0,0,0,0 \
# --repol \
# --out=$output_edc \
# --cnr_maps \
# --verbose
#
#
# # Bias-field correction and tensor fitting
# # -------------------------------------------------------------------------------------------------
#
# echo "================================"
# echo "         Tensor Fitting         "
# echo "================================"
#
# # Convert to mif
# mrconvert ${edc} ${edc_mif} -fslgrad ${output_edc}.eddy_rotated_bvecs bval -datatype float32 -strides 0,0,0,1
#
# # Perform bias-field correction
# dwibiascorrect ants -mask ${mask} -bias bias.nii ${edc_mif} ${edc_mif_bfc}
#
# # Extract tensor maps
# dwi2tensor -mask ${mask} ${edc_mif_bfc} ${edc_mif_bfc_tensor}
#
# # Fit tensor maps
# tensor2metric -fa ${edc_mif_bfc_tensor_FA} ${edc_mif_bfc_tensor} -force
# tensor2metric -adc ${edc_mif_bfc_tensor_MD} ${edc_mif_bfc_tensor} -force
# tensor2metric -ad ${edc_mif_bfc_tensor_AD} ${edc_mif_bfc_tensor} -force
# tensor2metric -rd ${edc_mif_bfc_tensor_RD} ${edc_mif_bfc_tensor} -force
# mrconvert ${edc_mif_bfc_tensor_FA} ${edc_nii_bfc_tensor_FA}
# mrconvert ${edc_mif_bfc_tensor_MD} ${edc_nii_bfc_tensor_MD}
# mrconvert ${edc_mif_bfc_tensor_AD} ${edc_nii_bfc_tensor_AD}
# mrconvert ${edc_mif_bfc_tensor_RD} ${edc_nii_bfc_tensor_RD}
#
# # Estimate response for FOD
# dwi2response tournier ${edc_mif_bfc} tournier_response.txt -voxels tournier_voxels.mif -mask ${mask}
#
# # Perform CSD
# dwi2fod csd ${edc_mif_bfc} tournier_response.txt tournier_response_fod.mif -mask ${mask}

# Connectome pipeline
# -------------------------------------------------------------------------------------------------
echo "================================"
echo "         Connectomising         "
echo "================================"

# Freesurfer registration
export SUBJECTS_DIR=/lustre/archive/p00423/PREVENT_Elijah/Freesurfer7_GS
#
# mri_coreg --s ${subject} --mov ${b0} --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta
#
# # Inverse warp segmentations into DTI displaySpace
# mri_vol2vol --mov ${b0} --targ $SUBJECTS_DIR/${subject}/mri/brainmask.mgz --inv --interp nearest --o rbrainmask.nii --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta
#
# mri_vol2vol --mov ${b0} --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o raparcaseg.nii --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta

# # Estimate response for FOD
# dwi2response tournier ${edc_mif_bfc} tournier_response.txt -voxels tournier_voxels.mif -mask ${mask}
#
# # Perform CSD
# dwi2fod csd ${edc_mif_bfc} tournier_response.txt tournier_response_fod.mif -mask ${mask}
#
#
# 5ttgen freesurfer raparcaseg.nii 5ttseg.mif -sgm_amyg_hipp -lut $FREESURFER_HOME/FreeSurferColorLUT.txt -lut $FREESURFER_HOME/FreeSurferColorLUT.txt
#
# 5tt2gmwmi 5ttseg.mif 5tt_mask.mif
#
# tckgen -seed_gmwmi 5tt_mask.mif -act 5ttseg.mif -crop_at_gmwmi -seeds 5000000 tournier_response_fod.mif wholebrain.tck -force

# tcksift wholebrain.tck tournier_response_fod.mif sift1_wholebrain.tck -force
#
# tcksift2 wholebrain.tck tournier_response_fod.mif wholebrain_sift2_weights.txt -force
#
# labelconvert raparcaseg.nii $FREESURFER_HOME/FreeSurferColorLUT.txt $code/fs_default.txt output_parcels.mif -force
#
# tck2connectome -assignment_radial_search 2 -scale_length -out_assignments assignments2.txt -tck_weights_in wholebrain_sift2_weights.txt wholebrain.tck output_parcels.mif connectome.csv -force
#
# connectome2tck wholebrain.tck assignments2.txt exemplars.tck -files single -exemplars output_parcels.mif
#

# Extract ROI from JHU ICBM atlas
# -------------------------------------------------------------------------------------------------

echo "================================"
echo "         Extracting ROIs        "
echo "================================"

# Normalisation to MNI152

# Parameters
FMRIB58_FA_1mm="/lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz"
MNI152_T1_1mm="/lustre/archive/p00423/PREVENT_Elijah/FAST/MNI152_T1_1mm_brain.nii.gz"
flirt_out="denoised_degibbs.edc.repol.bfc.tensor.FA.flirt.nii"
flirt_omat="denoised_degibbs.edc.repol.bfc.tensor.FA.flirt.mat"
bins="256"
cost="corratio"
dof="12"
interp="trilinear"
fnirt_omat="denoised_degibbs.edc.repol.bfc.tensor.FA.fnirt.mat"
FA_fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.FA.fnirt.nii"
MD_fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.MD.fnirt.nii"
RD_fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.RD.fnirt.nii"
AD_fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.AD.fnirt.nii"

echo "Started: Normalisation to FMRIB using FA for ${subject}"

echo "--------------------------------"
echo "            FLIRT               "
echo "--------------------------------"

# FLIRT
echo "flirt -in ${edc_nii_bfc_tensor_FA} -ref ${FMRIB58_FA_1mm} -out ${flirt_omat} -omat ${omat} -bins ${bins} -cost ${cost} -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof ${dof} -interp ${interp}"

flirt -in ${edc_nii_bfc_tensor_FA} -ref ${FMRIB58_FA_1mm} -out ${flirt_omat} -omat ${flirt_omat} -bins ${bins} -cost ${cost} -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof ${dof} -interp ${interp} -v

echo "--------------------------------"
echo "            FNIRT               "
echo "--------------------------------"

# FNIRT
echo "fnirt --ref=${ref} --in=${FA} --aff=${flirt_omat} --cout=${fnirt_omat} --config=FA_2_FMRIB58_1mm"

fnirt --ref=${FMRIB58_FA_1mm} --in=${FA} --aff=${flirt_omat} \
--cout=${fnirt_omat} --config=FA_2_FMRIB58_1mm -v

echo "--------------------------------"
echo "            Apply Warps         "
echo "--------------------------------"

# Apply warps
for dti in FA MD RD AD; do
  file="denoised_degibbs.edc.repol.bfc.tensor.${dti}.nii"
  fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.${dti}.fnirt.nii"
  applywarp --ref=${ref} --in=${file} --warp=${fnirt_omat} -v \
  --out=${fnirt_out}; done

echo "--------------------------------"
echo "     Generate screenshots       "
echo "--------------------------------"

mkdir QC
outfile="QC/fa.fmrib.png"
pkill Xvfb

xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile $outfile  --size 2500 2500 --scene lightbox --hideCursor --worldLoc 51.881539367386516 91.3974919323673 -51.81227616006569 --displaySpace ${FMRIB58_FA_1mm} --zaxis 2 --sliceSpacing 4.77867613448265 --zrange 17.798385772692978 162.01332661970616 --ncols 9 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${FMRIB58_FA_1mm} --name "FMRIB" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${FA_fnirt_out} --name "FA" --overlayType volume --alpha 81.52252905571892 --brightness 61.21621728204645 --contrast 81.6216230427286 --cmap red-yellow --negativeCmap greyscale --displayRange 0 0.7 --clippingRange 0 0.7 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection

outfile="QC/fa.fov.png"
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --outfile $outfile --size 2500 2500 --scene lightbox --hideCursor --worldLoc 74.16673546158638 -124.73660349291424 108.75978727118911 --displaySpace ${FA_fnirt_out} --zaxis 0 --sliceSpacing 4.526647301513387 --zrange 13.569940887656918 163.50602044529867 --ncols 8 --nrows 4 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${MNI152_T1_1mm} --name "MNI152_T1_1mm_brain" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${FA_fnirt_out} --name "dti_FA_fnirt_FMRIB58_mask" --overlayType volume --alpha 51.55644378428265 --brightness 50.0 --contrast 50.0 --cmap cool --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

echo "Completed: Normalisation to FMRIB using FA for ${subject}"

echo "--------------------------------"
echo "   Inverse warp of JHU labels  "
echo "--------------------------------"

# Inverse transform JHU labels from FMRIB space
echo "Started: Inverse warp JHU labels ${subject}"

mkdir JHU
echo "invwarp --warp=${FA_fnirt_out} --ref=${FA} --out=invwarp_FMRIB_to_FA"
invwarp --warp=${FA_fnirt_out} --ref=${FA} --out=invwarp_FMRIB_to_FA

for i in {1..48}
do
  applywarp -i /lustre/archive/p00423/PREVENT_Elijah/data/em_jhu_toolbox/${i}.nii.gz \
  -o JHU/${i}.nii.gz \
  -r ${FA} \
  -w invwarp_FMRIB_to_FA.nii.gz \
  --interp=nn -v
done

echo "Completed: Inverse warp JHU labels ${subject}"

echo "--------------------------------"
echo "        Calculate metrics       "
echo "--------------------------------"

#  Calculate metrics of JHU labels in native space
echo "Started: Calculating FA, MD, AD, RD in JHU labels for ${subject}"

for dti in FA MD RD AD; do
  file="denoised_degibbs.edc.repol.bfc.tensor.${dti}.nii"
  if [ -f ${file} ]; then
    for roinum in {1..48} ; do
      padroi=`$FSLDIR/bin/zeropad $roinum 3`
      if [ -f JHU/${dti}_JHU_${padroi}.txt ];
      then
        rm JHU/${dti}_JHU_${padroi}.txt;
      fi
      fslmeants -i ${file} -m warped_jhu/${roinum}.nii >>
      JHU/${dti}_JHU_${padroi}.txt
      paste JHU/*${dti}_JHU_*.txt > JHU/all_${dti}_jhu.txt
    done
  else
    for roinum in {1..48} ; do
      padroi=`$FSLDIR/bin/zeropad $roinum 3`
      if [ -f JHU/${dti}_JHU_${padroi}.txt ]; then
        rm JHU/${dti}_JHU_${padroi}.txt; fi
        echo "NA" >> JHU/${dti}_JHU_${padroi}.txt
        paste JHU/*${dti}_JHU_*.txt > JHU/all_${dti}_jhu.txt
      done
    fi
  done

  echo "Completed: Calculating native FA, MD, AD, RD in JHU labels for ${subject}"
  echo "Diffusion pipeline completed at $(date)"

  echo "   _____ ____  __  __ _____  _      ______ _______ ______ _____
  / ____/ __ \|  \/  |  __ \| |    |  ____|__   __|  ____|  __ \
 | |   | |  | | \  / | |__) | |    | |__     | |  | |__  | |  | |
 | |   | |  | | |\/| |  ___/| |    |  __|    | |  |  __| | |  | |
 | |___| |__| | |  | | |    | |____| |____   | |  | |____| |__| |
  \_____\____/|_|  |_|_|    |______|______|  |_|  |______|_____/"

  echo "" | > end_em_mrtrix
