cd /archive/p00423/PREVENT_Elijah/FWPK

subject=${1}

cd $subject

file="noddi_fiso_t1.nii.gz"

if [ -f ${file} ]; then

  for roinum in {1..90} ; do

    padroi=`$FSLDIR/bin/zeropad $roinum 3`

    if [ -f ${subject}_FW_hammers_native_roi${padroi}.txt ]; then
      rm ${subject}_FW_hammers_native_roi${padroi}.txt  ; fi

      #echo $(sed "${roinum}q;d" /lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/list_jhu) >> ${subject}_${dti}_jhu_native_roi${padroi}.txt

      #echo ${roinum} >> ${subject}_${dti}_jhu_native_roi${padroi}.txt

      fslmeants -i ${file} -m hammers/${roinum}.nii.gz >> ${subject}_FW_hammers_native_roi${padroi}.txt

      paste *_FW_hammers_native_roi*.txt > all_FW_hammers.txt

    done

  else

    for roinum in {1..90} ; do

      padroi=`$FSLDIR/bin/zeropad $roinum 3`

      if [ -f ${subject}_FW_hammers_native_roi${padroi}.txt ]; then
        rm ${subject}_FW_hammers_native_roi${padroi}.txt  ; fi

        echo "NA" >> ${subject}_FW_hammers_native_roi${padroi}.txt
        paste *_FW_hammers_native_roi*.txt > all_FW_hammers.txt
      done
    fi
