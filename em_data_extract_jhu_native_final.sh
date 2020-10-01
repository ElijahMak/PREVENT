cd /lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/

subject=${1}

cd $subject

for roinum in {1..47} ; do

  for dti in FA MD RD; do

    file="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_${dti}.nii"

     padroi=`$FSLDIR/bin/zeropad $roinum 3`

     rm ${subject}_${dti}_jhu_native_roi${padroi}.txt

     echo ${roinum} >> ${subject}_${dti}_jhu_native_roi${padroi}.txt

     fslmeants -i ${file} -m warped_jhu/${roinum} >> ${subject}_${dti}_jhu_native_roi${padroi}.txt

  done
done
