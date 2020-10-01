# Extract mean DTI values from ROIs in the JHU WM atlas

# Author: Elijah MAK


# Subject
subject=${1}

# Output
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/${subject}_native_dti_jhu_roi_full.txt"

rm $outputfile

#files
check_file="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_FA.nii"
file="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_${m}.nii"

# Subject
# ------------------------------------------------------------------------
echo subject >> $outputfile
echo $subject >> $outputfile

# Loop through JHU ROIs if FA file is present
# ------------------------------------------------------------------------
if test -a ${check_file};

then

  jhu_dir="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/warped_jhu"

for dti in FA MD RD; do

  for i in {1..47}; do

    file="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_${dti}.nii"

  echo dwi_${dti}_${i} >> $outputfile
  fslstats -t ${file} -k ${jhu_dir}/${i}.nii -M >> $outputfile

done
done

else

#  Print NA if FA is missing for each ROI
# ------------------------------------------------------------------------

jhu_dir="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/warped_jhu"

for dti in FA MD RD; do

  for i in {1..47}; do

    file="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_${dti}.nii"

    echo dwi_${dti}_${i} >> $outputfile
    echo "NA"  >> $outputfile

    done
  done

  fi