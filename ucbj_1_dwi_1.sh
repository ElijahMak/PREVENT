# MRTRIX pipeline
# Perform denoising, degibbs and BET masks

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
# dir="/lustre/archive/p00423/PREVENT_Elijah/MRTRIX"
subject=${1}
BET=${2}

# Inputs
raw_dwi="dwi.nii"
raw_dwi_mif="dwi.mif"
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


# Initialising Text
# -------------------------------------------------------------------------------------------------

echo "███████╗███╗   ███╗       ██████╗ ██╗███████╗███████╗██╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗
 ██╔════╝████╗ ████║       ██╔══██╗██║██╔════╝██╔════╝██║   ██║██╔════╝██║██╔═══██╗████╗  ██║
 █████╗  ██╔████╔██║       ██║  ██║██║█████╗  █████╗  ██║   ██║███████╗██║██║   ██║██╔██╗ ██║
 ██╔══╝  ██║╚██╔╝██║       ██║  ██║██║██╔══╝  ██╔══╝  ██║   ██║╚════██║██║██║   ██║██║╚██╗██║
 ███████╗██║ ╚═╝ ██║██╗    ██████╔╝██║██║     ██║     ╚██████╔╝███████║██║╚██████╔╝██║ ╚████║██╗
 ╚══════╝╚═╝     ╚═╝╚═╝    ╚═════╝ ╚═╝╚═╝     ╚═╝      ╚═════╝ ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝
                                                                                                "
echo "Diffusion pipeline started at $(date)"
echo "Initialising diffusion preprocessing for ${subject}"

# Preprocessing
# -------------------------------------------------------------------------------------------------
echo "================================"
echo "         Preprocessing          "
echo "================================"

# cd ${dir}
cd ${subject}

echo "--------------------------------"
echo "          NII to MIF            "
echo "--------------------------------"

mrconvert ${raw_dwi} ${raw_dwi_mif} -fslgrad bvec bval -datatype float32 -strides 0,0,0,1

echo "--------------------------------"
echo "          Denoising             "
echo "--------------------------------"

# Denoising of DWI
dwidenoise ${raw_dwi} ${denoised_dwi}

echo "--------------------------------"
echo "            DeGibbs             "
echo "--------------------------------"

# Remove Gibbs Ringing artifact
mrdegibbs ${denoised_dwi} ${denoised_degibbs_dwi}

echo "--------------------------------"
echo "              BET               "
echo "--------------------------------"

# Perform brain extraction
if [ "${BET}" = "0" ]; then
   echo "Running BET [1/3]"
   echo "fslroi $denoised_degibbs_dwi $b0 0 1"
   fslroi ${denoised_degibbs_dwi} ${b0} 0 1

   for f in 0.1 0.2 0.3 0.4; do
     bet ${b0} denoised_degibbs_dwi_b0_brain_f${f} -m -f $f; done
 else
   echo "Using edited BET [1/3]"
 fi

 echo "--------------------------------"
 echo "      Generate screenshots      "
 echo "--------------------------------"

 mkdir QC

 for f in 0.1 0.2 0.3 0.4; do

   outfile="QC/b0.mask.f${f}.png"
   qc_mask="denoised_degibbs_dwi_b0_brain_f${f}_mask.nii"

   pkill Xvfb
   xvfb-run -s "-screen 0, 1024x768x24" fsleyes render --scene lightbox --outfile $outfile --size 2500 2500 --worldLoc 108.2101927736983 124.64060310792524 -42.83765119809547 --displaySpace ${b0} --zaxis 2 --sliceSpacing 2.0 --zrange -1.0 124.99980163574219 --ncols 10 --nrows 10 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --hideCursor --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${b0} --name "b0" --overlayType volume --alpha 100.0 --brightness 67.02551834130782 --contrast 84.05103668261563 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 2533.08 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${qc_mask} --name "b0_brain_mask" --overlayType volume --alpha 47.76828976994573 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

 done
