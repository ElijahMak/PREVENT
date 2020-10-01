# Extract mean DTI values from ROIs in the JHU WM atlas
# Author: Elijah MAK

# Example
# bash code CB001 DTI
# bash code CB001 NODDI

# Subject
subject=${1}

# measure
measure=${2}

# Output
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/${subject}_${measure}_native_jhu_roi.txt"

rm $outputfile

# Files
fa="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA.nii"
md="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_MD.nii"
rd="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_RD.nii"
odi="/lustre/archive/p00423/PREVENT_Elijah/NODDI/${subject}/ODI.nii.gz"
fw="/lustre/archive/p00423/PREVENT_Elijah/NODDI/${subject}/w_csf.w.nii.gz"

# Subject
# ------------------------------------------------------------------------
echo subject >> $outputfile
echo $subject >> $outputfile

if [ ${measure} = "DTI" ]; then

# Loop through JHU ROIs if FA file is present
# ------------------------------------------------------------------------
if test -a ${fa};

then

  jhu_dir="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/warped_jhu"

  for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`;

  do

  echo dwi_fa_${i} >> $outputfile
  fslstats -t ${fa} -k ${jhu_dir}/warped_jhu_${i}.nii -M >> $outputfile

  echo dwi_md_${i} >> $outputfile
  fslstats -t ${md} -k ${jhu_dir}/warped_jhu_${i}.nii -M >> $outputfile

  echo dwi_rd_${i} >> $outputfile
  fslstats -t ${rd} -k ${jhu_dir}/warped_jhu_${i}.nii -M >> $outputfile

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

      jhu_dir="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/warped_jhu"

      for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`;

        do

          echo dwi_ODI_${i} >> $outputfile

          fslstats -t ${odi} -k ${jhu_dir}/warped_jhu_${i}.nii -M >> $outputfile

          echo dwi_FW_${i} >> $outputfile
          fslstats -t ${fw} -k ${jhu_dir}/warped_jhu_${i}.nii -M >> $outputfile

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