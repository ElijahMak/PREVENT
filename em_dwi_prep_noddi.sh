# After DWI preprocessing, prepare images for NODDI fitting in HPC

cp ${i}/edc.repol.nii noddi/${i}/edc.repol.nii
cp ${i}/bval noddi/${i}/bval
cp ${i}/edc.repol.eddy_rotated_bvecs noddi/${i}/edc.repol.eddy_rotated_bvecs
cp ${i}/b0_brain_mask.nii.gz noddi/${i}/b0_brain_mask.nii.gz
cp ${i}/bvec noddi/${i}/bvec
cp ${i}/acqparams.txt noddi/${i}/acqparams.txt
cp ${i}/index.txt noddi/${i}/index.txt
