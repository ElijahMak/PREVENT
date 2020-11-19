module unload fsl/5.0.10
module load fsl/6.0.3

subject=${1}
cd $subject


fslroi ap.nii nodif 0 1
fslroi pa.nii nodif_PA 0 1
fslmerge -t AP_PA_b0 nodif nodif_PA

printf "0 -1 0 0.07\n0 1 0 0.07 " > acqparams.txt

topup --imain=AP_PA_b0 --datain=acqparams.txt --config=b02b0.cnf --out=topup_AP_PA_b0 --iout=topup_AP_PA_b0_iout --fout=topup_AP_PA_b0_fout

fslmaths topup_AP_PA_b0_iout -Tmean hifi_nodif

bet hifi_nodif hifi_nodif_brain -m -f 0.2

indx=""
for ((i=0; i<104; ++i)); do indx="$indx 1"; done
echo $indx > index_beta.txt

eddy_openmp --imain=ap.nii --mask=hifi_nodif_brain_mask --acqp=acqparams.txt --index=index_beta.txt --bvecs=ap.bvecs --bvals=ap.bvals --out=eddy_unwarped_images --verbose --data_is_shelled --fwhm=0 --flm=quadratic --repol --cnr_maps --topup=topup_AP_PA_b0
