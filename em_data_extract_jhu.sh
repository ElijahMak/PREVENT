
subject=${1}

cd $subject

# Files
fa="dti_FA_fnirt_FMRIB58.nii"
md="dti_MD_fnirt_FMRIB58.nii"
#rd="dti_RD_fnirt_FMRIB58.nii"
outputfile="/lustre/archive/p00423/PREVENT_Elijah/data/jhu_data_2.txt"

echo subject >> $outputfile
echo $subject >> $outputfile

for i in `cat /lustre/archive/p00423/PREVENT_Elijah/data/roi`; do
echo fa_${i} >> $outputfile
fslstats -t ${fa} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

echo md_${i} >> $outputfile
fslstats -t ${md} -k /lustre/archive/p00423/PREVENT_Elijah/data/JHU_ROI/${i}.nii.gz -M >> $outputfile

#echo ${i}_rd >> $outputfile
#fslstats -t ${rd} -k /lustre/archive/p00423/PREVENT_Elijah/data/${i}.nii.gz -M >> $outputfile
done
