dti_rigid_reg IITmean_tensor_256.nii.gz mean_group_template_high_res.nii.gz EDS 4 4 4 0.001

dti_affine_reg IITmean_tensor_256.nii.gz mean_group_template_high_res.nii.gz EDS 4 4 4 0.001 1

dti_diffeomorphic_reg IITmean_tensor_256.nii.gz mean_group_template_high_res_aff.nii.gz IITmean_tensor_mask_256.nii.gz 1 6 0.002

dfRightComposeAffine -aff mean_group_template_high_res_aff.nii.gz -df mean_group_template_high_res_aff_diffeo.df.nii.gz -out mean_group_template_high_res_aff_diffeo_combined.df.nii.gz

deformationScalarVolume -in mean_group_template_high_res.nii.gz -trans mean_group_template_high_res_aff_diffeo_combined.df.nii.gz -target IITmean_tensor_256.nii.gz -out mean_group_template_high_res_IIT256.nii.gz -vsize 1 1 1

fslorient -setsform 1 0 0 -128 0 1 0 -145 0 0 1 -109 0 0 0 1 mean_group_template_high_res_IIT256.nii.gz





TVtool -in IITmean_tensor.nii.gz -tr
BinaryThresholdImageFilter IITmean_tensor_tr.nii.gz IITmean_tensor_tr_mask.nii.gz 0.01 100 1 0

dfRightComposeAffine -aff mean_diffeomorphic_initial6.aff -df mean_diffeomorphic_initial6_aff_diffeo.df.nii.gz -out mean_combined.2df.nii.gz

dti_rigid_reg FMRIB58_FA_1mm.nii.gz mean_FA.nii.gz EDS 4 4 4 0.001
dti_affine_reg FMRIB58_FA_1mm.nii.gz mean_FA.nii.gz EDS 4 4 4 0.001 1
affineScalarVolume -in mean_FA.nii.gz -out mean_FA_fmrib.nii.gz -trans mean_FA_aff.nii.gz -target FMRIB58_FA_1mm.nii.gz


affineScalarVolume -in input.nii.gz -out output.nii.gz -trans input.aff -target reference.nii.gz

deformationScalarVolume -in mean_group_template_high_res.nii.gz -trans mean_combined.2df.nii.gz  -target IITmean_tensor.nii.gz -out mean_group_template_high_res_IIT182.nii.gz -vsize 1 1 1



deformationScalarVolume -in mean_group_template_high_res.nii.gz -trans mean_combined.2df.nii.gz  -target IITmean_tensor.nii.gz -out mean_group_template_high_res_IIT182.nii.gz -vsize 1 1 1

dfComposition -df2 subj_combined.df.nii.gz -df1 mean_combined.df.nii.gz -out subj_to_template.df.nii.gz
