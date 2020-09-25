
subject=${1}
cd $subject 

fa="FAtoT1_NMI.nii.gz"
gm_mask="p1T1w_${subject}_mask_20.nii"
wm_mask="p2T1w_${subject}_mask_50.nii"
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/metrics.txt"

if [ `ls . | wc -l` -lt 3 ];
then
  echo subject >> $outputfile
  echo ${subject} >> $outputfile
  echo fa_gm >> $outputfile
  echo "NA" >> $outputfile
  echo fa_wm >> $outputfile
  echo "NA" >> $outputfile
else 
  echo subject >> $outputfile
  echo ${subject} >> $outputfile
  echo fa_gm >> $outputfile
  fslstats -t ${fa} -k ${gm_mask} -M >> $outputfile
  echo fa_wm >> $outputfile
  fslstats -t ${fa} -k ${wm_mask} -M >> $outputfile
  fi 
