# MRTRIX pipeline

# To generate connectomes from eddy-corrected data.

# Modules
module load freesurfer/7.1.0
module load MRtrix/mrtrix-3.0.2
module load ANTS/2.2.0

# Subject
subject=${1}
cd $subject

# Convert the diffusion images into a non-compressed format (not strictly necessary, but will make subsequent processing faster), embed the diffusion gradient encoding information within the image header, re-arrange the data strides to make volume data contiguous in memory for each voxel, and convert to floating-point representation (makes data access faster in subsequent commands):

mrconvert edc.repol.nii edc.repol.mif -fslgrad edc.repol.eddy_rotated_bvecs bval -datatype float32 -strides 0,0,0,1

dwibiascorrect ants -mask b0_brain_mask.nii.gz -bias bias.nii edc.repol.mif edc.repol.bfc.mif

dwi2tensor -mask b0_brain_mask.nii.gz edc.repol.bfc.mif tensor.mif

tensor2metric -fa FA.mif tensor.mif -force
tensor2metric -adc MD.mif tensor.mif -force
tensor2metric -ad AD.mif tensor.mif -force
tensor2metric -rd RD.mif tensor.mif -force

dwi2response tournier edc.repol.bfc.mif wm_response.txt -voxels voxels.mif -mask b0_brain_mask.nii.gz

dwi2fod csd edc.repol.mif wm_response.txt fod.mif -mask b0_brain_mask.nii.gz

# The resulting WM fODFs can be displayed together with the mean fODF amplitude map using:
# mrview fod.mif -odf.load_sh fod.mif

# Freesurfer registration
export SUBJECTS_DIR=archive/p00423/PREVENT_Elijah/Freesurfer7_GS

mri_coreg --s ${subject} --mov /lustre/archive/p00423/PREVENT_Elijah/dwi_denoised/${subject}/b0.nii.gz --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta

# Inverse warp segmentations into DTI displaySpace
mri_vol2vol --mov b0.nii.gz --targ $SUBJECTS_DIR/${subject}/mri/brainmask.mgz --inv --interp nearest --o rbrainmask.nii --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta

mri_vol2vol --mov b0.nii.gz --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o raparcaseg.nii --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta

5ttgen freesurfer raparc+aseg.nii 5ttseg.mif -sgm_amyg_hipp -lut $FREESURFER_HOME/FreeSurferColorLUT.txt -lut $FREESURFER_HOME/FreeSurferColorLUT.txt

5tt2gmwmi 5ttseg.mif 5tt_mask.mif

tckgen -seed_gmwmi 5tt_mask.mif -act 5ttseg.mif -crop_at_gmwmi -seeds 5000000 fod.mif wholebrain.tck -force

tcksift wholebrain.tck fod.mif sift1_wholebrain.tck -force

tcksift2 wholebrain.tck fod.mif wholebrain_sift2_weights.txt -force

labelconvert raparc+aseg.nii $FREESURFER_HOME/FreeSurferColorLUT.txt $code/fs_default.txt output_parcels.mif -force

tck2connectome -assignment_radial_search 2 -scale_length -out_assignments assignments2.txt -tck_weights_in wholebrain_sift2_weights.txt wholebrain.tck output_parcels.mif connectome.csv -force

connectome2tck wholebrain.tck assignments2.txt exemplars.tck -files single -exemplars output_parcels.mif
