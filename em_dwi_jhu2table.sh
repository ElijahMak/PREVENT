# Concatenate all data outputs from subjects into a table
# Author: Elijah MAK

# Directory
cd /lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/


for dti in FA MD RD; do

  # Merge all data files
    column v2*/all_${dti}_jhu.txt >> temp_1

  # Append ROIs to data file
ca
  # Append subjects to data file
  paste list_wlv2 temp_2 > all_${dti}_jhu.txt

done

  # Remove temp files
  rm temp_1
  rm temp_2
