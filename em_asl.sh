# Extract ASL maps

#!/bin/bash

# Load modules
module unload fsl/5.0.10
module load fsl/6.0.3
module load freesurfer/7.1.0

# Parameters
subject=${1}
brain="/lustre/archive/p00423/PREVENT_Elijah/Neuroimage_ASLxR1/t1/mri/${subject}.brain.nii.gz"
pvgm="/lustre/archive/p00423/PREVENT_Elijah/Neuroimage_ASLxR1/t1/mri/p1${subject}.nii"
pvwm="/lustre/archive/p00423/PREVENT_Elijah/Neuroimage_ASLxR1/t1/mri/p2${subject}.nii"
pvgm_asl="p1${subject}_asl.nii"
pvwm_asl="p2${subject}_asl.nii"
m0="${subject}.asl.m0.nii"
lc="${subject}.asl.lc.nii.gz"
bolus="0.7"
slicedt="0.045"
tis="1.8"
tr="2.5"
fwhm="4"

# CD subject directory
cd ${i}

# Generate M0 and LC
fslroi ${subject}.asl.nii.gz ${subject}.asl.m0.nii  0 1
fslroi 1 90 ${subject}.asl.lc.nii.gz

# Register M0 to T1 skull stripped brain
mri_coreg --mov ${subject}.asl.m0.nii --ref ${brain} --reg ${subject}.asl.m0.coreg.lta

# Downsample PV images to ASL space
mri_vol2vol --mov ${subject}.asl.m0.nii --targ ${pvgm} --lta ${subject}.asl.m0.coreg.lta --trilin --o ${pvgm_asl} --inv
mri_vol2vol --mov ${subject}.asl.m0.nii --targ ${pvwm} --lta ${subject}.asl.m0.coreg.lta --trilin --o ${pvwm_asl} --inv

# Run FSL BASIL
oxford_asl -i ${lc} -o basil --bolus=${bolus} --slicedt=${slicedt} --iaf=tc -c ${m0} --tis=1.8 --mc --wp --spatial --tr=2.5 --pvcorr --pvgm ${pvgm_asl} --pvwm ${pvwm_asl}

# Warp perfusion to T1
mri_vol2vol --mov basil/pvcorr/perfusion_calib.nii --targ ${brain} --lta ${subject}.asl.m0.coreg.lta --trilin --o basil/pvcorr/perfusion_calib_anat.nii

# Smooth perfusion at 4
fslmaths perfusion_calib_Anat.nii -kernel gauss ${fwhm} -fmean basil/pvcorr/perfusion_calib_anat_sm${fwhm}.nii
