# Perform normnalisation of tensor maps to FMRIB, generate QC of registration and extraction of mean FA etc in JHU ICBM ROIs.

# Modules
# -----------------------------------------------------------------------------

module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

# Parameters
# -----------------------------------------------------------------------------

# Options
dir="/archive/p00423/PREVENT_Elijah/Neuroimage_FreewaterPK"
subject=${1}

# Inputs
raw_dwi="dwi.nii"
raw_dwi_mif="dwi.mif"
denoised_dwi="dwi.denoised.nii"
denoised_degibbs_dwi="dwi.denoised.degibbs.nii"
b0="denoised_degibbs_dwi_b0.nii"
mask="denoised_degibbs_dwi_b0_brain_mask.nii"
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


# Initialising Text
# ----------------------------------------------------------------------------------

echo "███████╗███╗   ███╗       ██████╗ ██╗███████╗███████╗██╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗
██╔════╝████╗ ████║       ██╔══██╗██║██╔════╝██╔════╝██║   ██║██╔════╝██║██╔═══██╗████╗  ██║
█████╗  ██╔████╔██║       ██║  ██║██║█████╗  █████╗  ██║   ██║███████╗██║██║   ██║██╔██╗ ██║
██╔══╝  ██║╚██╔╝██║       ██║  ██║██║██╔══╝  ██╔══╝  ██║   ██║╚════██║██║██║   ██║██║╚██╗██║
███████╗██║ ╚═╝ ██║██╗    ██████╔╝██║██║     ██║     ╚██████╔╝███████║██║╚██████╔╝██║ ╚████║██╗
╚══════╝╚═╝     ╚═╝╚═╝    ╚═════╝ ╚═╝╚═╝     ╚═╝      ╚═════╝ ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝
                                                                                               "
echo "Diffusion pipeline started at $(date)"
echo "Initialising diffusion preprocessing for ${subject}"

# Extract ROI from JHU ICBM atlas
#-------------------------------------------------------------------------------------------------

echo "================================"
echo "         Extracting ROIs        "
echo "================================"

cd ${dir}
cd ${subject}

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
echo "flirt -in ${edc_nii_bfc_tensor_FA} -ref ${FMRIB58_FA_1mm} -out ${flirt_out} -omat ${flirt_omat} -bins ${bins} -cost ${cost} -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof ${dof} -interp ${interp}"

flirt -in ${edc_nii_bfc_tensor_FA} -ref ${FMRIB58_FA_1mm} -omat flirt.mat -bins ${bins} -cost ${cost} -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof ${dof} -interp ${interp} -v

echo "--------------------------------"
echo "            FNIRT               "
echo "--------------------------------"

# FNIRT
echo "fnirt --ref=${FMRIB58_FA_1mm}  --in=${edc_nii_bfc_tensor_FA} --aff=${flirt_omat} --cout=${fnirt_omat} --config=FA_2_FMRIB58_1mm"

fnirt --ref=${FMRIB58_FA_1mm} --in=${edc_nii_bfc_tensor_FA} --aff=flirt.mat --cout=${fnirt_omat} --config=FA_2_FMRIB58_1mm -v

echo "--------------------------------"
echo "            Apply Warps         "
echo "--------------------------------"

# Apply warps
for dti in FA MD RD AD; do
  file="denoised_degibbs.edc.repol.bfc.tensor.${dti}.nii"
  fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.${dti}.fnirt.nii"
  applywarp --ref=${FMRIB58_FA_1mm}  --in=${file} --warp=${fnirt_omat} -v --out=${fnirt_out}; done

echo "--------------------------------"
echo "     Generate screenshots       "
echo "--------------------------------"

mkdir QC
outfile="QC/fa.fmrib.png"
pkill Xvfb

xvfb-run -s "-screen 0, 1024x768x24"  fsleyes render --scene lightbox --outfile $outfile --size 2500 2500 --worldLoc 51.881539367386516 91.3974919323673 -51.81227616006569 --displaySpace ${FMRIB58_FA_1mm} --zaxis 2 --sliceSpacing 4.77867613448265 --zrange 17.798385772692978 162.01332661970616 --ncols 9 --nrows 3 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --hideCursor --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${FMRIB58_FA_1mm} --name "FMRIB" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${FA_fnirt_out} --name "FA" --overlayType volume --alpha 81.52252905571892 --brightness 61.21621728204645 --contrast 81.6216230427286 --cmap red-yellow --negativeCmap greyscale --displayRange 0 0.7 --clippingRange 0.2 0.7 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection

outfile="QC/fa.fov.png"
pkill Xvfb
xvfb-run -s "-screen 0, 640x480x24" fsleyes render --scene lightbox --outfile $outfile --size 2500 2500 --worldLoc 74.16673546158638 -124.73660349291424 108.75978727118911 --displaySpace ${FA_fnirt_out} --zaxis 0 --sliceSpacing 4.526647301513387 --zrange 13.569940887656918 163.50602044529867 --ncols 8 --nrows 4 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0  --hideCursor --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${MNI152_T1_1mm} --name "MNI152_T1_1mm_brain" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 8364.0 --clippingRange 0.0 8447.64 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${FA_fnirt_out} --name "dti_FA_fnirt_FMRIB58_mask" --overlayType volume --alpha 51.55644378428265 --brightness 50.0 --contrast 50.0 --cmap cool --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

echo "Completed: Normalisation to FMRIB using FA for ${subject}"

echo "--------------------------------"
echo "   Inverse warp of JHU labels  "
echo "--------------------------------"

# Inverse transform JHU labels from FMRIB space
echo "Started: Inverse warp JHU labels ${subject}"

em_jhu_toolbox="/lustre/archive/p00423/PREVENT_Elijah/MRTRIX/em_jhu_toolbox"
mkdir JHU

echo "invwarp -w ${fnirt_omat} -r ${edc_nii_bfc_tensor_FA} -o invwarp_FMRIB_to_FA"
invwarp -w ${fnirt_omat} -r ${edc_nii_bfc_tensor_FA} -o invwarp_FMRIB_to_FA

applywarp -i /lustre/archive/p00423/PREVENT_Elijah/MRTRIX/em_jhu_toolbox/JHU-ICBM-labels-1mm.nii.gz -o JHU/JHU.native.nii.gz -r denoised_degibbs.edc.repol.bfc.tensor.FA.nii -w invwarp_FMRIB_to_FA.nii --interp=nn

echo "--------------------------------"
echo "        Calculate metrics       "
echo "--------------------------------"

# copy FW map from NODDI MATLAB TOOLBOX
cp NODDI_MATLAB_v101/noddi_fiso.nii.gz denoised_degibbs.edc.repol.bfc.tensor.FW.nii.gz

cp NODDI_MATLAB_v101/noddi_odi.nii.gz denoised_degibbs.edc.repol.bfc.tensor.ODI.nii.gz

# Calculate metrics of JHU labels in native space
for dti in FA MD RD AD FW ODI
do
fslstats -K JHU/JHU.native.nii denoised_degibbs.edc.repol.bfc.tensor.${dti}.nii -M > JHU/all_${dti}_jhu.txt
done
