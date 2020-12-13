# Author: Elijah Make

# Directory
# --------------------------------------------
dir="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi"

# Modules
# -----------------------------------------------------------------------------
module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

# Parameters
# --------------------------------------------
subject=${1}
cd $subject

# Denoising of DWI
dwidenoise ap.nii.gz ap.denoised.nii
dwidenoise pa.nii.gz pa.denoised.nii

# Remove Gibbs Ringing artifact
mrdegibbs ap.denoised.nii ap.denoised.degibbs.nii -force
# Remove Gibbs Ringing artifact
mrdegibbs pa.denoised.nii pa.denoised.degibbs.nii -force

# Merge AP and PA
# --------------------------------------------
rm ap_pa.bvecs; rm ap_pa.bvals
fslmerge -t dwi.denoised.degibbs.nii ap.denoised.degibbs.nii pa.denoised.degibbs.nii
paste -d" " ap.bvecs pa.bvecs >> ap_pa.bvecs
paste -d" " ap.bvals pa.bvals >> ap_pa.bvals

# Merge B0s from AP and PAs
# --------------------------------------------
fslroi ap.denoised.degibbs.nii nodif 0 1
fslroi pa.denoised.degibbs.nii nodif_PA 0 1
fslmerge -t AP_PA_b0.nii nodif.nii nodif_PA.nii

# Create ACQPARAMS
# --------------------------------------------
printf "0 -1 0 0.07\n0 1 0 0.07 " > acqparams.txt

# Create index
# --------------------------------------------
myVar=($(wc -w ap.bvals))
indx=""
for ((i=1; i<=$myVar; i+=1)); do indx="$indx 1"; done
for ((i=1; i<=$myVar; i+=1)); do indx="$indx 2"; done
echo $indx > index.txt


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

eddy_openmp --imain=dwi.denoised.degibbs.nii --mask=hifi_nodif_brain_f0.3_mask.nii --acqp=acqparams.txt --index=index.txt --bvecs=ap_pa.bvecs --bvals=ap_pa.bvals --out=edc --verbose --data_is_shelled --flm=quadratic --repol --cnr_maps --topup=topup_AP_PA_b0
