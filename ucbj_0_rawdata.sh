# This script was created to process the new batch of subjecst as part of the UCBJ x NODDI NBA major revisions.
# Author : Elijah Make

# NIIs were obtained from NEgin Holland.

subject=${1}

dir="/scratch/hphi/fkm24/projects/ucbjxnoddi/noddi/nba_noddi/unprocessed_mri_for_noddi_ucbj_mans_131120"
noddi_dir="/scratch/hphi/fkm24/projects/ucbjxnoddi/noddi/nba_noddi"

cd $noddi_dir

# Copy T1 MPRAGE ND
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/anat/sub-${subject}_*_acq-mpragesag_rec-nd* ${subject}
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/anat/sub-${subject}_*_acq-mpragesag_rec-nd*.nii.gz ${subject}/${subject}.nii.gz


# Copy NODDI
# Copy AP
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddiapcbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.nii.gz ${subject}/ap.nii
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddiapcbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.bval ${subject}/ap.bval
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddiapcbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.bvec ${subject}/ap.bvec

# Copy PA
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddipacbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.nii.gz ${subject}/pa.nii
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddipacbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.bvec ${subject}/pa.bvec
cp unprocessed_mri_for_noddi_ucbj_mans_131120/sub-${subject}/ses-*/dwi/sub-${subject}_*_acq-noddipacbumbep2d175mmmb498dirb300b1000b2000_run-01_dwi.bval ${subject}/pa.bval
