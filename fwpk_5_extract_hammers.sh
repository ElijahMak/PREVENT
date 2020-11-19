subject=${1}

cd $subject

file="noddi_fiso_t1.nii.gz"

if [ -f ${file} ]; then

  for roinum in `cat ../index` ; do

    padroi=`$FSLDIR/bin/zeropad $roinum 3`

    if [ -f ${subject}_FWNMT_hammers_whole_${padroi}.txt ]; then
      rm ${subject}_FWNMT_hammers_whole_roi${padroi}.txt  ; fi

      fslmeants -i ${file} -m hammers/${roinum}.nii.gz > ${subject}_FWNMT_hammers_whole_roi${padroi}.txt

      paste *_FWNMT_hammers_whole_roi*.txt > all_FWNMT_hammers_whole.txt

    done

  else

    for roinum in `cat ../index` ; do

      padroi=`$FSLDIR/bin/zeropad $roinum 3`

      if [ -f ${subject}_FWNMT_hammers_native_roi${padroi}.txt ]; then
        rm ${subject}_FWNMT_hammers_native_roi${padroi}.txt  ; fi

        echo "NA" >> ${subject}_FWNMT_hammers_whole_${padroi}.txt
        paste *_FWNMT_hammers_whole_roi*.txt > all_FWNMT_hammers_whole.txt
      done
    fi
