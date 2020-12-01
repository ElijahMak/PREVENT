# Concatenate all data outputs from subjects into a table
# Author: Elijah MAK

# Directory
dir="/lustre/archive/p00423/PREVENT_Elijah/Neuroimage_FreewaterPK/data_jhu"

# # Copy individual data files into folder for collection
# for i in cat list`; do
#   for dti in FA MD RD AD FW ODI; do
#     cp ${i}/JHU/all_${dti}_jhu.txt ${dir}/${i}_all_${dti}_jhu.txt
#   done
#   done

for dti in FA MD RD AD FW ODI; do

  # Merge all data files
  column *_all_${dti}_jhu.txt >> temp_1

  # Append ROIs to data file
  sed -e '1i\${dti}_mcp ${dti}_pct ${dti}_gcc ${dti}_bcc ${dti}_scc ${dti}_fornix ${dti}_rh_cst ${dti}_lh_cst ${dti}_rh_mlemn ${dti}_lh_mlemn ${dti}_rh_icp ${dti}_lh_icp ${dti}_rh_scp ${dti}_lh_scp ${dti}_rh_cp ${dti}_lh_cp ${dti}_rh_alic ${dti}_lh_alic ${dti}_rh_plic ${dti}_lh_plic ${dti}_rh_ric ${dti}_lh_ric ${dti}_rh_acr ${dti}_lh_acr ${dti}_rh_scr ${dti}_lh_scr ${dti}_rh_pcr ${dti}_lh_pcr ${dti}_rh_ptr ${dti}_lh_ptr ${dti}_rh_sags ${dti}_lh_sags ${dti}_rh_exc ${dti}_lh_exc ${dti}_rh_ccg ${dti}_lh_ccg ${dti}_rh_chip ${dti}_lh_chip ${dti}_rh_forcr ${dti}_lh_forcr ${dti}_rh_slf ${dti}_lh_slf ${dti}_rh_sfof ${dti}_lh_sfof ${dti}_rh_uncf ${dti}_lh_uncf ${dti}_rh_tap ${dti}_lh_tap' temp_1 > temp_2

  # Append subjects to data file
  paste subjects temp_2 > all_${dti}.txt
  # Remove temp files
  rm temp_1
  rm temp_2
done
