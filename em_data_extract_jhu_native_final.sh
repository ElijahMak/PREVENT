
subject=${1}
dti=${2}
cd $subject

file="/lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/dti_${dti}.nii"

if [ -f ${file} ]; then

  for roinum in {1..48} ; do

    padroi=`$FSLDIR/bin/zeropad $roinum 3`

    if [ -f ${subject}_${dti}_jhu_native_roi${padroi}.txt ]; then
      rm ${subject}_${dti}_jhu_native_roi${padroi}.txt; fi

      #echo $(sed "${roinum}q;d" /lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/list_jhu) >> ${subject}_${dti}_jhu_native_roi${padroi}.txt

      #echo ${roinum} >> ${subject}_${dti}_jhu_native_roi${padroi}.txt

      fslmeants -i ${file} -m warped_jhu/${roinum}.nii >> ${subject}_${dti}_jhu_native_roi${padroi}.txt

      paste *${dti}_jhu_native*.txt > all_${dti}_jhu.txt

    done

  else

    for roinum in {1..48} ; do

      padroi=`$FSLDIR/bin/zeropad $roinum 3`

      if [ -f ${subject}_${dti}_jhu_native_roi${padroi}.txt ]; then
        rm ${subject}_${dti}_jhu_native_roi${padroi}.txt; fi

        echo "NA" >> ${subject}_${dti}_jhu_native_roi${padroi}.txt
        paste *${dti}_jhu_native*.txt > all_${dti}_jhu.txt
      done
    fi
    
