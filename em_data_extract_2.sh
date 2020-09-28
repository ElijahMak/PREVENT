
subject=${1}
cd $subject

fa="fa_flirt_cat12brain.nii.nii.gz"
md="md_flirt_cat12brain.nii.nii.gz"
rd="rd_flirt_cat12brain.nii.nii.gz"
gm_mask="p1T1w_${subject}_mask_20.nii"
wm_mask="p2T1w_${subject}_mask_50.nii"
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/metrics.txt"

if [ `ls . | wc -l` -lt 6 ];
then
  echo subject >> $outputfile
  echo ${subject} >> $outputfile
  echo fa_gm >> $outputfile
  echo "NA" >> $outputfile
  echo fa_wm >> $outputfile
  echo "NA" >> $outputfile
  echo md_gm >> $outputfile
  echo "NA" >> $outputfile
  echo md_wm >> $outputfile
  echo "NA" >> $outputfile
  echo rd_gm >> $outputfile
  echo "NA" >> $outputfile
  echo rd_wm >> $outputfile
  echo "NA" >> $outputfile
else
  echo subject >> $outputfile
  echo ${subject} >> $outputfile
  echo fa_gm >> $outputfile
  fslstats -t ${fa} -k ${gm_mask} -M >> $outputfile
  echo fa_wm >> $outputfile
  fslstats -t ${fa} -k ${wm_mask} -M >> $outputfile
  echo md_gm >> $outputfile
  fslstats -t ${md} -k ${gm_mask} -M >> $outputfile
  echo md_wm >> $outputfile
  fslstats -t ${md} -k ${wm_mask} -M >> $outputfile
  echo rd_gm >> $outputfile
  fslstats -t ${rd} -k ${gm_mask} -M >> $outputfile
  echo rd_wm >> $outputfile
  fslstats -t ${rd} -k ${wm_mask} -M >> $outputfile
  fi
