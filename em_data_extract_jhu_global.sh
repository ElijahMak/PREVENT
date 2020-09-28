
subject=${1}

cd $subject

# Files
fa="dti_FA_fnirt_FMRIB58.nii"
md="dti_MD_fnirt_FMRIB58.nii"

#rd="dti_RD_fnirt_FMRIB58.nii"
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/jhu_global_data.txt"

echo subject >> $outputfile
echo $subject >> $outputfile

if test -a ${fa};
then
  echo fa_jhu_global >> $outputfile
  fslstats -t ${fa} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/jhu_global_mask.nii -M >> $outputfile

  echo md_jhu_global >> $outputfile
  fslstats -t ${md} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/jhu_global_mask.nii -M >> $outputfile

else
  echo fa_jhu_global >> $outputfile
      echo "NA"  >> $outputfile
      echo md_jhu_global >> $outputfile
      echo "NA"  >> $outputfile
    done
fi
