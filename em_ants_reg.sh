# Warp multi-modal data to standard space

# Load modules
. /etc/profile.d/modules.sh
module purge
module unload fsl/5.0.10
module load fsl/6.0.3
module load freesurfer/7.1.0
module load ANTS/2.3.4

# Parameters
subject=${1}
pet="${2}"
t1="${subject}.brain.nii"
t1n4="${subject}.brain.n4.nii"
template="/scratch/hphi/fkm24/em_code/MCALT_v1.4/MCALT_T1_brain.nii"
cd $subjects

# Bias correction on T1
N4BiasFieldCorrection ${t1} ${t1n4}

# Register N4 T1 to MCALT
antsRegistrationSyNQuick -d 3 -f ${template} -m ${t1n4} -o T1xMCALT

# Rigidly align PET to T1
antsRegistrationSyNQuick -d 3 -f ${t1n4} -m ${pet}.nii -t r -o PETxT1

# Warp PET to MNI
antsApplyTransforms -d 3 -v 1 -i ${other} -r ${template} -o ${pet}_warped_to_MCALT.nii -n Linear -t T1xMCALT1Warp.nii.gz -t T1xMCALT0GenericAffine.mat -t PETxT10GenericAffine.mat
