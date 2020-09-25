for subject in `cat list`; do

fa="/lustre/archive/p00423/PREVENT_Elijah/FAST/${subject}/FAtoT1_NMI.nii.gz"
gm_mask="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/p1T1w_${subject}_mask_20.nii"
wm_mask="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/p2T1w_${subject}_mask_50.nii"

echo subject >> metrics_file.txt
echo ${subject} >> metrics_file.txt
echo fa_gm >> metrics_file.txt
fslstats -t ${fa} -k ${gm_mask} -M >> metrics_file.txt
echo fa_wm >> metrics_file.txt
fslstats -t ${fa} -k ${wm_mask} -M >> metrics_file.txt

done
