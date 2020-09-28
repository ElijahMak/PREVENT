
subject=${1}
cd $subject

fa="fa_flirt_cat12brain.nii.nii.gz"
md="md_flirt_cat12brain.nii.nii.gz"
rd="rd_flirt_cat12brain.nii.nii.gz"
gm_mask="p1T1w_${subject}_mask_20.nii"
wm_mask="p2T1w_${subject}_mask_50.nii"
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/metrics.txt"


  echo subject >> $outputfile
  echo ${subject} >> $outputfile

  echo fa_gm >> $outputfile

  if [ -f ${fa} ] & [ -f ${gm_mask} ]
  then
  fslstats -t ${fa} -k ${gm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo fa_wm >> $outputfile

  if [ -f ${fa} ] & [ -f ${wm_mask} ]; then
    fslstats -t ${fa} -k ${wm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo md_gm >> $outputfile

  if [ -f ${md} ] & [ -f ${gm_mask} ]; then
    fslstats -t ${md} -k ${gm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo md_wm >> $outputfile

  if [ -f ${md} ] & [ -f ${wm_mask} ]; then
    fslstats -t ${fa} -k ${wm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo rd_gm >> $outputfile


  if [ -f ${rd} ] & [ -f ${gm_mask} ]; then
    fslstats -t ${rd} -k ${gm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo rd_wm >> $outputfile

  if [ -f ${rd} ] & [ -f ${wm_mask} ]; then
    fslstats -t ${rd} -k ${wm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi
