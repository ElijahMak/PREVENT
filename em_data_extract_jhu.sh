
subject=${1}

cd $subject

# Files
# Files
fa="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA_fnirt_FMRIB58.nii.gz"
md="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_MD_fnirt_FMRIB58.nii.gz"
rd="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_RD_fnirt_FMRIB58.nii.gz"

outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/${subject}_dwi_fnirt_jhu_roi.txt"

rm $outputfile


echo subject >> $outputfile
echo $subject >> $outputfile

if test -a ${fa};
then
  for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`; do
  echo fa_${i} >> $outputfile
  fslstats -t ${fa} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

  echo md_${i} >> $outputfile
  fslstats -t ${md} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

  echo ${i}_rd >> $outputfile
  fslstats -t ${rd} -k /lustre/archive/p00423/PREVENT_Elijah/data/${i}.nii.gz -M >> $outputfile
  done

else
    for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`; do
      echo fa_${i} >> $outputfile
      echo "NA"  >> $outputfile
      echo md_${i} >> $outputfile
      echo "NA"  >> $outputfile
      echo rd_${i} >> $outputfile
      echo "NA"  >> $outputfile
    done
fi
