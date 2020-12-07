# DWI preprocessing, using a single B0 from PA to correct distortions in AP.
# Author: Elijah Make

# Directory
# --------------------------------------------
dir="/scratch/hphi/fkm24/projects/ucbjxnoddi/noddi/nba_noddi"

# Modules
# --------------------------------------------
module unload fsl/5.0.10
module load fsl/6.0.3

# Parameters
# --------------------------------------------
subject=${1}
cd $subject

# Merge B0s from AP and PAs
# --------------------------------------------
fslroi ap.nii nodif 0 1
fslroi pa.nii nodif_PA 0 1
fslmerge -t AP_PA_b0 nodif nodif_PA

# Create ACQPARAMS
# --------------------------------------------
printf "0 -1 0 0.07\n0 1 0 0.07 " > acqparams.txt

# Run TOPUP
# --------------------------------------------
topup --imain=AP_PA_b0 --datain=acqparams.txt --config=b02b0.cnf --out=topup_AP_PA_b0 --iout=topup_AP_PA_b0_iout --fout=topup_AP_PA_b0_fout

# Create mean of corrected B0s
# --------------------------------------------
fslmaths topup_AP_PA_b0_iout -Tmean hifi_nodif

echo "--------------------------------"
echo "      Generate brain masks      "
echo "--------------------------------"

for f in 0.1 0.2 0.3
  do
     bet hifi_nodif hifi_nodif_brain_f${f} -m -f $f
  done

echo "--------------------------------"
echo "      Generate screenshots      "
echo "--------------------------------"

 mkdir qc_brainmasks

 for f in 0.1 0.2 0.3; do

   outfile="qc_brainmasks/b0.mask.f${f}.png"
   qc_mask="hifi_nodif_brain_f${f}_mask.nii"

   pkill Xvfb
   xvfb-run -s "-screen 0, 1024x768x24" fsleyes render --scene lightbox --outfile $outfile --size 2500 2500 --worldLoc 108.2101927736983 124.64060310792524 -42.83765119809547 --displaySpace ${b0} --zaxis 2 --sliceSpacing 2.0 --zrange -1.0 124.99980163574219 --ncols 10 --nrows 10 --bgColour 0.0 0.0 0.0 --fgColour 1.0 1.0 1.0 --hideCursor --cursorColour 0.0 1.0 0.0 --colourBarLocation top --colourBarLabelSide top-left --performance 3 --movieSync ${b0} --name "b0" --overlayType volume --alpha 100.0 --brightness 67.02551834130782 --contrast 84.05103668261563 --cmap greyscale --negativeCmap greyscale --displayRange 0.0 800.0 --clippingRange 0.0 2533.08 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 ${qc_mask} --name "b0_brain_mask" --overlayType volume --alpha 47.76828976994573 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 1.0 --clippingRange 0.0 1.01 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0
 done


# Generate index file for AP eddy
# --------------------------------------------
indx=""
for ((i=0; i<104; ++i)); do indx="$indx 1"; done
echo $indx > index_beta.txt

echo "--------------------------------"
echo "               eddy             "
echo "--------------------------------"

eddy_openmp --imain=ap.nii --mask=${qc_mask} --acqp=acqparams.txt --index=index_beta.txt --bvecs=ap.bvecs --bvals=ap.bvals --out=eddy_unwarped_images --verbose --data_is_shelled --fwhm=0 --flm=quadratic --repol --cnr_maps --topup=topup_AP_PA_b0

eddy_quad eddy_unwarped_images -idx index_beta.txt -par acqparams.txt -m ${qc_mask} -b ap.bvals
