
# Subject
subject=${1}

# CD to subject
cd $subject

# Files
fa="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/fa_flirt_cat12brain.nii.gz"
md="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/md_flirt_cat12brain.nii.gz"
rd="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/rd_flirt_cat12brain.nii.gz"

gm_mask="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/p1T1w_${subject}_mask_20.nii"
gm_mask="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/p2T1w_${subject}_mask_90.nii"
fa_flirt_outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/${i}_dwi_flirt.txt"


echo subject >> $outputfile
echo ${subject} >> $outputfile
echo fa_gm >> $outputfile

if test -a ${fa} && test -a ${gm_mask};
  then
    fslstats -t ${fa} -k ${gm_mask} -M >> $outputfile
  else
    echo "NA"  >> $outputfile
  fi

  echo fa_wm >> $outputfile

  if test -a ${fa} && test -a ${wm_mask}; then
    fslstats -t ${fa} -k ${wm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo md_gm >> $outputfile

  if test -a ${md} && test -a ${gm_mask}; then
    fslstats -t ${md} -k ${gm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo md_wm >> $outputfile

  if test -a ${md} && test -a ${wm_mask}; then
    fslstats -t ${md} -k ${wm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo rd_gm >> $outputfile

  if test -a ${rd} && test -a ${gm_mask}; then
    fslstats -t ${rd} -k ${gm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi

  echo rd_wm >> $outputfile

  if test -a ${rd} && test -a ${wm_mask}; then
    fslstats -t ${rd} -k ${wm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi
