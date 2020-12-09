# MRTRIX pipeline
# Perform denoising, degibbs, top up and eddy corrections from DICOMs. First convert everything to .mif, and then concatenate the results, in which case MRtrix3 handles concatenation of the gradient tables automatically.

# Date: 20th Nov 2020
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
dir="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/"
subject=${1}

# Inputs
raw_dwi="all_DWIs.mif"
denoised_dwi="all.dwi.denoised.mif"
denoised_degibbs_dwi="dwi.denoised.degibbs.mif"
denoised_degibbs_preproc_dwi="dwi.denoised.degibbs.preproc.mif"
denoised_degibbs_preproc_bfc_dwi="dwi.denoised.degibbs.preproc.bfc.mif"
mask="mask.nii"
b0="denoised_degibbs_preproc_bfc_dwi_b0.nii"
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
echo "            NII to MIF          "
echo "================================"

cd ${subject}

cd *AP*
for img in **
do
dcmdjpeg $img ${img}.tmp
mv ${img}.tmp $img
done

cd ../*PA*
for img in **
do
dcmdjpeg $img ${img}.tmp
mv ${img}.tmp $img
done

cd ..

# Concatenate both DWI dicom folders
dwicat *AP* *PA* ${raw_dwi} -force

echo "--------------------------------"
echo "          Denoising             "
echo "--------------------------------"

# Denoising of DWI
dwidenoise ${raw_dwi} ${denoised_dwi} -force

echo "--------------------------------"
echo "            DeGibbs             "
echo "--------------------------------"

# Remove Gibbs Ringing artifact
mrdegibbs ${denoised_dwi} ${denoised_degibbs_dwi} -force

#mrcalc dwi_den.mif dwi_den_unr.mif –subtract residualUnringed.mif
# mrview dwi_den_unr.mif residualUnringed.mif

echo "--------------------------------"
echo "           dwifslpreproc        "
echo "--------------------------------"

dwifslpreproc ${denoised_degibbs_dwi} ${denoised_degibbs_preproc_dwi} -rpe_header -eddyqc_all eddyqc -eddy_mask hifi_nodif_brain_f0.3_mask.nii -eddy_options '  --repol --data_is_shelled --slm=linear'

mrconvert ${denoised_degibbs_preproc_dwi} -strides -1,2,3,4 -export_grad_fsl bvecs bvals dwi.nii

# Bias-field correction and tensor fitting
# -------------------------------------------------------------------------------------------------

echo "================================"
echo "       Bias field correction    "
echo "================================"

# Perform bias-field correction
dwibiascorrect ants -bias bias.mif ${denoised_degibbs_preproc_dwi} ${denoised_degibbs_preproc_bfc_dwi}

echo "================================"
echo "          MRTRIX Brain mask     "
echo "================================"

dwi2mask ${denoised_degibbs_preproc_bfc_dwi} ${mask}

echo "--------------------------------"
echo "            FSLBET              "
echo "--------------------------------"

fslroi dwi.nii ${b0} 0 1

for f in 0.1 0.2 0.3 0.4
    do
     bet ${b0} denoised_degibbs_preproc_bfc_dwi_b0_brain_f${f} -m -f $f
    done

echo "--------------------------------"
echo "      Generate screenshots      "
echo "--------------------------------"

 mkdir qc_brainmasks

 for f in 0.1 0.2 0.3 0.4; do

   outfile="qc_brainmasks/b0.mask.f${f}.png"
   qc_mask="denoised_degibbs_preproc_bfc_dwi_b0_brain_f${f}.nii"

   pkill Xvfb
   xvfb-run -s "-screen 0, 1024x768x24" fsleyes render --scene lightbox --outfile $outfile --size 2500 2500 --worldLoc 108.2101927736983 124.64060310792524 -42.83765119809547 --displaySpace ${b0} --zaxis 2 --sliceSpacing 2.0 --zrange -1.0 124.99980163574219 --ncols 10 --nrows 10 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --hideCursor --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${b0} --name "b0" --overlayType volume --alpha 100.0 --brightness 67.02551834130782 --contrast 84.05103668261563 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 2533.08 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${qc_mask} --name "b0_brain_mask" --overlayType volume --alpha 47.76828976994573 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0

 done
