# Visualise statistic in fsleyes

for roinum in {1..48}
do
p=`echo $(sed "${roinum}q;d" p)`
fslmaths ${roinum} -mul ${p} ${roinum}_p
done


ls *p.nii.gz

10_p.nii.gz     14_p.nii.gz     18_p.nii.gz     21_p.nii.gz     25_p.nii.gz     29_p.nii.gz     32_p.nii.gz     36_p.nii.gz     3_p.nii.gz      43_p.nii.gz     47_p.nii.gz     7_p.nii.gz
11_p.nii.gz     15_p.nii.gz     19_p.nii.gz     22_p.nii.gz     26_p.nii.gz     2_p.nii.gz      33_p.nii.gz     37_p.nii.gz     40_p.nii.gz     44_p.nii.gz     4_p.nii.gz      8_p.nii.gz
12_p.nii.gz     16_p.nii.gz     1_p.nii.gz      23_p.nii.gz     27_p.nii.gz     30_p.nii.gz     34_p.nii.gz     38_p.nii.gz     41_p.nii.gz     45_p.nii.gz     5_p.nii.gz      9_p.nii.gz
13_p.nii.gz     17_p.nii.gz     20_p.nii.gz     24_p.nii.gz     28_p.nii.gz     31_p.nii.gz     35_p.nii.gz     39_p.nii.gz     42_p.nii.gz     46_p.nii.gz     6_p.nii.gz


fslmaths 10_p.nii.gz -add 14_p.nii.gz -add 18_p.nii.gz -add 21_p.nii.gz -add 25_p.nii.gz -add 29_p.nii.gz -add 32_p.nii.gz -add 36_p.nii.gz -add 3_p.nii.gz -add  43_p.nii.gz -add 47_p.nii.gz -add 7_p.nii.gz -add 11_p.nii.gz -add 15_p.nii.gz -add 19_p.nii.gz -add 22_p.nii.gz -add 26_p.nii.gz -add 2_p.nii.gz -add  33_p.nii.gz -add 37_p.nii.gz -add 40_p.nii.gz -add 44_p.nii.gz -add 4_p.nii.gz -add  8_p.nii.gz -add 12_p.nii.gz -add 16_p.nii.gz -add 1_p.nii.gz -add  23_p.nii.gz -add 27_p.nii.gz -add 30_p.nii.gz -add 34_p.nii.gz -add 38_p.nii.gz -add 41_p.nii.gz -add 45_p.nii.gz -add 5_p.nii.gz -add  9_p.nii.gz -add 13_p.nii.gz -add 17_p.nii.gz -add 20_p.nii.gz -add 24_p.nii.gz -add 28_p.nii.gz -add 31_p.nii.gz -add 35_p.nii.gz -add 39_p.nii.gz -add 42_p.nii.gz -add 46_p.nii.gz -add 6_p.nii.gz total_p
