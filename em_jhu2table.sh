# Concatenate all data outputs from subjects into a table
# Author: Elijah MAK

# Directory

dir="/lustre/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/DATA_JHU"

for dti in FA MD RD AD; do

  # Merge all data files
  column *_all_${dti}_jhu.txt >> temp_1

  # Append ROIs to data file
  sed -e '1i\mcp	pct	gcc	bcc	scc	fornix	rh_cst	lh_cst	rh_mlemn	lh_mlemn	rh_icp	lh_icp	rh_scp	lh_scp	rh_cp	lh_cp rh_alic lh_alic rh_plic	lh_plic	rh_ric	lh_ric	rh_acr	lh_acr	rh_scr	lh_scr	rh_pcr	lh_pcr	rh_ptr	lh_ptr	rh_sags	lh_sags	rh_exc	lh_exc	rh_ccg	lh_ccg	rh_chip	lh_chip	rh_forcr	lh_forcr	rh_slf	lh_slf	rh_sfof	lh_sfof	rh_uncf	lh_uncf	rh_tap	lh_tap' temp_1 > temp_2

  # Append subjects to data file
  paste subjects temp_2 > all_${dti}.txt

  # Remove temp files
  rm temp_1
  rm temp_2
done
