# Extract mean DTI values from ROIs in the JHU WM atlas
# Author: Elijah MAK

# Subject
subject=${1}

# Files
fa="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA_fnirt_FMRIB58.nii"
md="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_MD_fnirt_FMRIB58.nii"
rd="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_RD_fnirt_FMRIB58.nii"

# Output
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/${subject}_dwi_fnirt_jhu_roi.txt"

rm $outputfile

# Subject
# ------------------------------------------------------------------------
echo subject >> $outputfile
echo $subject >> $outputfile


# Loop through JHU ROIs if FA file is present
# ------------------------------------------------------------------------
if test -a ${fa};
then
  for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`; do
  echo dwi_fa_${i} >> $outputfile
  fslstats -t ${fa} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

  echo dwi_md_${i} >> $outputfile
  fslstats -t ${md} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

  echo dwi_rd_${i} >> $outputfile
  fslstats -t ${rd} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile
  done

#  Print NA if FA is missing for each ROI
# ------------------------------------------------------------------------
else
    for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`; do
      echo dwi_fa_${i} >> $outputfile
      echo "NA"  >> $outputfile
      echo dwi_md_${i} >> $outputfile
      echo "NA"  >> $outputfile
      echo dwi_rd_${i} >> $outputfile
      echo "NA"  >> $outputfile
    done
fi
