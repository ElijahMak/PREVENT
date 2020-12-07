# Concatenate all data outputs from subjects into a table
# Author: Elijah MAK

# Directory
  dir="/lustre/archive/p00423/PREVENT_Elijah/MovDis_LewyPIB/AMPLE/data_jhu"

# Copy individual data files into folder for collection
for i in `cat list_pet_mri`; do
  for dti in FA MD RD AD FW ODI; do
    cp ${i}/JHU/all_${dti}_jhu.txt ${dir}/${i}_all_${dti}_jhu.txt
  done
  done

# Check file size
ls /lustre/archive/p00423/PREVENT_Elijah/MovDis_LewyPIB/AMPLE/data_jhu -ltr -S


for dti in FA MD RD AD FW ODI; do

  # Merge all data files
  paste *_all_${dti}_jhu.txt > all_${dti}; done


  # Append subjects to data file
  paste subjects temp_2 > all_${dti}.txt
  # Remove temp files
  rm temp_1
  rm temp_2
done
