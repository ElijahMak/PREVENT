# Update JHU matrix with new ROI 48

for i in `cat list`
do
for dti in FA MD RD
do
paste ${i}/*${dti}_jhu_native*.txt > ${i}/all_${dti}_jhu.txt
done
done
