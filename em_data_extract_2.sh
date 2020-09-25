
for subject in `cat list`; do

cd $subject

fa="FAtoT1_NMI.nii.gz"
gm_mask="p1T1w_${subject}_mask_20.nii"
wm_mask="p2T1w_${subject}_mask_50.nii"

if [ ls * | wc -l < 3 ]; then

echo subject >> metrics_file.txt
echo ${subject} >> metrics_file.txt
echo fa_gm >> metrics_file.txt
echo "files missing" >> metrics_file.txt
echo fa_wm >> metrics_file.txt
echo "files missing" >> metrics_file.txt
else 
echo subject >> metrics_file.txt
echo ${subject} >> metrics_file.txt
echo $(fslstats -t ${fa} -k ${gm_mask} -M) >> metrics_file.txt
echo fa_wm >> metrics_file.txt
echo $(fslstats -t ${fa} -k ${wm_mask} -M) >> metrics_file.txt
fi
done
