i=${1}

flirt -in FLAIR_${i}.nii -ref T1w_${i}.nii -out FLAIR_T1_${i}.nii -omat flirt_${i}.mat -bins 257 -cost corratio -dof 6 -searchrx -90 90 -searchry -90 90 -searchrz -90 90

flirt -in wmh_${i}A_FLAIR.nii -ref T1w_${i}.nii -out wmh_${i}A_FLAIR_T1.nii -init flirt_${i}.mat -applyxfm -interp nearestneighbour
