# Author: Elijah Make

# Directory
# --------------------------------------------
dir="/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi"

# Modules
# --------------------------------------------
module unload fsl/5.0.10
module load fsl/6.0.3
module load cuda/8.0

# Parameters
# --------------------------------------------
subject=${1}
cd $subject

# # Merge B0s from AP and PAs
# # --------------------------------------------
# fslroi ap.nii nodif 0 1
# fslroi pa.nii nodif_PA 0 1
# fslmerge -t AP_PA_b0.nii nodif.nii nodif_PA.nii

# Merge AP and PA
# --------------------------------------------
rm ap_pa.bvecs; rm ap_pa.bvals
fslmerge -t ap_pa.nii ap.nii pa.nii
paste -d" " ap.bvecs pa.bvecs >> ap_pa.bvecs
paste -d" " ap.bvals pa.bvals >> ap_pa.bvals

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

eddy_cuda8.0 --imain=ap_pa.nii --mask=hifi_nodif_brain_f0.2_mask.nii --acqp=acqparams.txt --index=index.txt --bvecs=ap_pa.bvecs --bvals=ap_pa.bvals --out=revisions_appa --verbose --data_is_shelled --fwhm=0 --flm=quadratic --repol --cnr_maps --topup=topup_AP_PA_b0
