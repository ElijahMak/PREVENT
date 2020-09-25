fa = "fa_flirt.nii.gz"
gm_mask = "p1T1w_${i}_mask.nii.gz"
wm_mask = "p2T1w_${i}_mask.nii.gz"

for subject in `cat list`; do
echo subject >> metrics_file.txt
echo ${i} >> metrics_file.txt
echo fa_gm >> metrics_file.txt
echo $(fslstats -t ${fa_gm} -k ${gm_mask} -M) >> metrics_file.txt
echo fa_wm >> metrics_file.txt
echo $(fslstats -t ${fa_wm} -k ${wm_mask} -M) >> metrics_file.txt
