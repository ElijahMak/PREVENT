# Modules
# -------------------------------

module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

subject=${1}

cd $subject

# BP and SUVR maps

fslchfiletype NIFTI ${subject}_UCB-J_BP_Neuro.hdr
fslswapdim ${subject}_UCB-J_BP_Neuro.nii -x y z ${subject}_UCB-J_BP_Radio.nii.gz
fslorient -swaporient ${subject}_UCB-J_BP_Radio.nii.gz

fslchfiletype NIFTI ${subject}_UCB-J_PVC_BP_Neuro.hdr
fslswapdim ${subject}_UCB-J_PVC_BP_Neuro.nii -x y z ${subject}_UCB-J_PVC_BP_Radio.nii.gz
fslorient -swaporient ${subject}_UCB-J_PVC_BP_Radio.nii.gz

fslchfiletype NIFTI ${subject}_AV-1451_BP_Neuro.hdr
fslswapdim ${subject}_AV-1451_BP_Neuro.nii -x y z ${subject}_AV-1451_BP_Radio.nii.gz
fslorient -swaporient ${subject}_AV-1451_BP_Radio.nii.gz

fslchfiletype NIFTI ${subject}_AV-1451_R1_Neuro.hdr
fslswapdim ${subject}_AV-1451_R1_Neuro.nii -x y z ${subject}_AV-1451_R1_Radio.nii.gz
fslorient -swaporient ${subject}_AV-1451_R1_Radio.nii.gz


fslchfiletype NIFTI ${subject}_UCB-J_R1_Neuro.hdr
fslswapdim ${subject}_UCB-J_R1_Neuro.nii -x y z ${subject}_UCB-J_R1_Radio.nii.gz
fslorient -swaporient ${subject}_UCB-J_R1_Radio.nii.gz

fslchfiletype NIFTI ${subject}_UCB-J_PVC_R1_Neuro.hdr
fslswapdim ${subject}_UCB-J_PVC_R1_Neuro.nii -x y z ${subject}_UCB-J_PVC_R1_Radio.nii.gz
fslorient -swaporient ${subject}_UCB-J_PVC_R1_Radio.nii.gz

fslchfiletype NIFTI ${subject}_wRPMV_BP_Neuro.hdr
fslswapdim ${subject}_wRPMV_BP_Neuro.nii -x y z ${subject}_wRPMV_BP_Radio.nii.gz
fslorient -swaporient ${subject}_wRPMV_BP_Radio.nii.gz

fslchfiletype NIFTI ${subject}_PIB_SUVR_Neuro.hdr
fslswapdim ${subject}_PIB_SUVR_Neuro.nii -x y z ${subject}_PIB_SUVR_Radio.nii.gz
fslorient -swaporient ${subject}_PIB_SUVR_Radio.nii.gz

# Mean

fslchfiletype NIFTI ${subject}_PK_mean_Neuro.hdr
fslswapdim ${subject}_PK_mean_Neuro.nii -x y z ${subject}_PK_mean_Radio.nii.gz
fslorient -swaporient ${subject}_PK_mean_Radio.nii.gz

fslchfiletype NIFTI ${subject}_PIB_mean_Neuro.hdr
fslswapdim ${subject}_PIB_mean_Neuro.nii -x y z ${subject}_PIB_mean_Radio.nii.gz
fslorient -swaporient ${subject}_PIB_mean_Radio.nii.gz

fslchfiletype NIFTI ${subject}_PIB_mean_Neuro.hdr
fslswapdim ${subject}_PIB_mean_Neuro.nii -x y z ${subject}_PIB_mean_Radio.nii.gz
fslorient -swaporient ${subject}_PIB_mean_Radio.nii.gz

fslchfiletype NIFTI ${subject}_AV-1451_mean_Neuro.hdr
fslswapdim ${subject}_AV-1451_mean_Neuro.nii -x y z ${subject}_AV-1451_mean_Radio.nii.gz
fslorient -swaporient ${subject}_AV-1451_mean_Radio.nii.gz


# In order to use the FSL tools to convert "neurologically" ordered data into the "radiologically" ordered format for use with the current version of FSL (3.3) the following commands should be run. This will create a new image (output) which has the opposite left-right ordering as the input image. That is, if the input image was "neurologically" ordered, the output will be "radiologically" ordered. This assumes that the original orientation information in the input image is set correctly. If these commands are used on Analyze images, or nifti images where neither qform or sform are set, then the fslorient command will not change anything, but the underlying data will be changed by fslswapdim and the left-right orientation will still have changed, although the default orientation of "radiological" will be used. The first of the above commands changes the order of the data that is stored in the file. The command fslswapdim input -x y z output swaps the order of the x-axis of the input image to create the output image. It will not change the orientation information in the header, and so fslorient -getorient will report the same orientation for both input and output images, although looking at them in FSLVIEW will clearly show that flipping has occurred. Note that this way also changes the orientation for Analyze files (and in previous versions of FSL it was the only tool that could affect left/right orientation). The other command that affects orientation is fslorient. This can either report the current orientation, swap the orientation, or force "radiological" or "neurological" orientation. This does not change the order that the data is stored - it only changes the information in the header which tells programs how to interpret the stored data. Both methods of changing the orientation only change half of the information on orientation and so when run separately on a correct and valid nifti file they will cause the orientation to be inconsistent between data and header. For instance, if the data is originally correctly stored in "neurological"o rder, the correct way to change it to a valid "radiologically" ordered image (as shown above) is to run both fslorient and fslswapdim on the data. Alternatively, if the image is know to have the data stored "neurologically", but the header says it is (incorrectly) in "radiological"= order, then running fslorient -forceneurological will turn it into a valid "neurologically" ordered image. On the other hand, running fslswapdim input -x y z output on the same incorrect image will create an output image that is a valid "radiologically" ordered image.
