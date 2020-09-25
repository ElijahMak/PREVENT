fa="/lustre/archive/p00423/PREVENT/FAST/${subject}/FAtoT1_NMI.nii.gz"
gm_mask="/lustre/archive/p00423/PREVENT/CAT12/mri/p1T1w_${subject}_mask_20.nii"
wm_mask="/lustre/archive/p00423/PREVENT/CAT12/mri/p2T1w_${subject}_mask_50.nii"

for subject in `cat list`; do
echo subject >> metrics_file.txt
echo ${i} >> metrics_file.txt
echo fa_gm >> metrics_file.txt
fslstats -t ${fa_gm} -k ${gm_mask} -M >> metrics_file.txt
echo fa_wm >> metrics_file.txt
fslstats -t ${fa_wm} -k ${wm_mask} -M >> metrics_file.txt
done
