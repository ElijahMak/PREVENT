# Subject
subject=${1}

# Files
myelin="/lustre/archive/p00423/PREVENT_Elijah/myelin/${subject}/${subject}_myelin_brain.nii"
gm_mask="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/p1T1w_${subject}_mask_20.nii"
wm_mask="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/p2T1w_${subject}_mask_90.nii"
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/${subject}_myelin_flirt.txt"
rm $outputfile

# Myelin GM
# --------------------------------------------------------------------
echo subject >> $outputfile
echo ${subject} >> $outputfile
echo myelin_gm >> $outputfile

if test -a ${myelin} && test -a ${gm_mask};
  then
    fslstats -t ${myelin} -k ${gm_mask} -M >> $outputfile
  else
    echo "NA"  >> $outputfile
  fi

# Myelin WM
# --------------------------------------------------------------------
  echo myelin_wm >> $outputfile

  if test -a ${myelin} && test -a ${wm_mask}; then
    fslstats -t ${myelin} -k ${wm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi
