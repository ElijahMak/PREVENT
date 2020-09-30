subject=${1}

cd /lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/
cd $subject

for roinum in {1..47} ; do

  for dti in FA MD RD; do

    file="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_${dti}.nii"

     padroi=`$FSLDIR/bin/zeropad $roinum 3`

     fslmeants -i ${file} -m warped_jhu/${roinum} -o ${subject}_${dti}_jhu_native_roi${padroi}.txt

  done
done
