# This script was created to process the new batch of subjecst as part of the UCBJ x NODDI NBA major revisions.
# Author : Elijah Make

# NIIs were obtained from NEgin Holland.

# PETSURFER

# Modules
# -----------------------------------------------------------------------------

. /etc/profile.d/modules.sh
module purge
module load default-wbic
module load openmpi/3.0.0
module load freesurfer/7.1.0
module unload fsl/5.0.10
module unload fsl/6.0.1
module load fsl/6.0.3

subject=${1}

dir="/scratch/hphi/fkm24/projects/ucbjxnoddi/noddi/nba_noddi/unprocessed_mri_for_noddi_ucbj_mans_131120"
noddi_dir="/scratch/hphi/fkm24/projects/ucbjxnoddi/noddi/nba_noddi"
SUBJECTS_DIR="/scratch/hphi/fkm24/projects/ucbjxnoddi/noddi/t1"

cd $noddi_dir

# Copy T1 MPRAGE ND
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/anat/sub-${subject}_*_acq-mpragesag_rec-nd* ${subject}
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/anat/sub-${subject}_*_acq-mpragesag_rec-nd*.nii.gz ${subject}/${subject}.nii.gz


# Copy NODDI
# Copy AP
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddiapcbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.nii.gz ${subject}/ap.nii.gz
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddiapcbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.bval ${subject}/ap.bval
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddiapcbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.bvec ${subject}/ap.bvec

# Copy PA
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddipacbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.nii.gz ${subject}/pa.nii.gz
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddipacbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.bvec ${subject}/pa.bvec
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddipacbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.bval ${subject}/pa.bval

# To execute, for i in `cat list`; do bash /lustre/scratch/hphi/fkm24/em_code/ucbj_0_rawdata.sh ${i}; done

# Copy T1s over to subject folders
for i in `cat new`; do cp ${i}/${i}.nii.gz $SUBJECTS_DIR; done

# Previous FS was based on FS6 segmentations using em_reconall.sh in SUBJECTS_DIR="/scratch/hphi/fkm24/projects/ucbjxnoddi/noddi/t1"
