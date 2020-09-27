subject=${1}
cd $subject
fslmaths L2 -add L3 -div 2 dti_RD
