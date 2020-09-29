# Extract mean DTI values from ROIs in the JHU WM atlas
# Author: Elijah MAK

# Subject
subject=${1}

# measure
measure=${2}

# Output
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/${subject}_${measure}_fnirt_jhu_roi.txt"

rm $outputfile

# Files
fa="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA_fnirt_FMRIB58.nii"
md="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_MD_fnirt_FMRIB58.nii"
odi="/lustre/archive/p00423/PREVENT_Elijah/NODDI/${subject}/dti_ODI_fnirt_FMRIB58.nii"
fw="/lustre/archive/p00423/PREVENT_Elijah/NODDI/${subject}/dti_FW_fnirt_FMRIB58.nii"

# Subject
# ------------------------------------------------------------------------
echo subject >> $outputfile
echo $subject >> $outputfile

if [ ${measure} = "DTI" ]; then

# Loop through JHU ROIs if FA file is present
# ------------------------------------------------------------------------
if test -a ${fa};

then

  for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`;

  do

  echo dwi_fa_${i} >> $outputfile
  fslstats -t ${fa} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

  echo dwi_md_${i} >> $outputfile
  fslstats -t ${md} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

  echo dwi_rd_${i} >> $outputfile
  fslstats -t ${rd} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

  done

else

#  Print NA if FA is missing for each ROI
# ------------------------------------------------------------------------

    for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`;

    do

      echo dwi_fa_${i} >> $outputfile
      echo "NA"  >> $outputfile

      echo dwi_md_${i} >> $outputfile
      echo "NA"  >> $outputfile

      echo dwi_rd_${i} >> $outputfile
      echo "NA"  >> $outputfile

    done

  fi

  elif  [ ${measure} = "NODDI" ];

  then

# Loop through JHU ROIs if ODI file is present
# ------------------------------------------------------------------------

    if test -a ${odi};

    then

      for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`;

      do

        echo dwi_ODI_${i} >> $outputfile

        fslstats -t ${odi} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

        echo dwi_FW_${i} >> $outputfile
        fslstats -t ${fw} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

      done

#  Print NA if ODI is missing for each ROI
# ------------------------------------------------------------------------
    else

        for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`;

        do
          echo dwi_ODI_${i} >> $outputfile
          echo "NA"  >> $outputfile

          echo dwi_FW_${i} >> $outputfile
          echo "NA"  >> $outputfile

        done

      fi

fi
