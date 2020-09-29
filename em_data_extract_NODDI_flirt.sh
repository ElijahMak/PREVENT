# Subject
subject=${1}

# Files
ODI="/lustre/archive/p00423/PREVENT_Elijah/NODDI/${subject}/odi_flirt_cat12brain.nii.gz"
gm_mask="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/p1T1w_${subject}_mask_20.nii"
wm_mask="/lustre/archive/p00423/PREVENT_Elijah/CAT12/mri/p2T1w_${subject}_mask_90.nii"
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/${subject}_ODI_flirt.txt"
rm $outputfile

# ODI GM
# --------------------------------------------------------------------
echo subject >> $outputfile
echo ${subject} >> $outputfile
echo odi_gm >> $outputfile

if test -a ${ODI} && test -a ${gm_mask};
  then
    fslstats -t ${ODI} -k ${gm_mask} -M >> $outputfile
  else
    echo "NA"  >> $outputfile
  fi

# Myelin WM
# --------------------------------------------------------------------
  echo ODI_wm >> $outputfile

  if test -a ${ODI} && test -a ${wm_mask}; then
    fslstats -t ${ODI} -k ${wm_mask} -M >> $outputfile
  else
    echo "NA" >> $outputfile
  fi
