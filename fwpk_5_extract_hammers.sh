subject=${1}

cd $subject

file="${subject}.FW.FLIRT.nii.gz"

if [ -f ${file} ]; then

  for roinum in `cat ../index` ; do

    padroi=`$FSLDIR/bin/zeropad $roinum 3`

    if [ -f ${subject}_FW_hammers_whole_${padroi}.txt ]; then
      rm ${subject}_FW_hammers_whole_roi${padroi}.txt  ; fi

      fslmeants -i ${file} -m hammers/${roinum}.nii.gz >> ${subject}_FW_hammers_whole_${padroi}.txt

      paste *_FW_hammers_whole_roi*.txt > all_FW_hammers_whole.txt

    done

  else

    for roinum in `cat ../index` ; do

      padroi=`$FSLDIR/bin/zeropad $roinum 3`

      if [ -f ${subject}_FW_hammers_native_roi${padroi}.txt ]; then
        rm ${subject}_FW_hammers_native_roi${padroi}.txt  ; fi

        echo "NA" >> ${subject}_FW_hammers_whole_${padroi}.txt
        paste *_FW_hammers_whole_roi*.txt > all_FW_hammers_whole.txt
      done
    fi
