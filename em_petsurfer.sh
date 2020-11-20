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


# Parameters
# -----------------------------------------------------------------------------
subject=${1}
export SUBJECTS_DIR="/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/freesurfer/include"
dir_pet="/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/pet"
pet="${subject}_concat_tau.nii"
mov="${dir_pet}/${subject}_concat_tau_mcf_mean_reg.nii"
pet_mcf="${dir_pet}/${subject}_concat_tau_mcf.nii"
reg="$SUBJECTS_DIR/${subject}/tau/mri_coreg_concat_tau_mcf_mean_reg.lta"
gtmseg="$SUBJECTS_DIR/${i}/mri/gtmseg.mgz"
mgxthresh="0.25"

# Notes
# -----------------------------------------------------------------------------
# Files were renamed: fkm24@wbic-gate-2:/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/pet$ for i in `cat list`; do cp Concat_${i}_AV-1451_PET*.nii ${i}_concat_tau.nii; done


# Motion Correction
# -----------------------------------------------------------------------------

echo "Motion correction + deriving mean volumes"
mcflirt -in ${dir_pet}/${pet} -meanvol -mats -report


# GTM segmentation
# -----------------------------------------------------------------------------

echo "gtm seg "
gtmseg --s ${subject}

# Rename FS folders
# psub-18066_ses-20140812_acq-mpragend_rec-nd_run-01_T1w
# for i in `cat list`; do mv psub-${i}_ses-*_acq-mpragend_rec-nd_run-01_T1w ${i}; done
# for i in `cat list`; do mv psub-${i}_ses-*_acq-repmprag_rec-nd_run-01_T1w ${i}; done
# for i in `cat x`; do mv psub-${i}_ses-*_acq-mpragend_rec-nd_run-02_T1w ${i}_2; done
# mv psub-25109_ses-20150805_acq-repmprag_rec-nd_run-01_T1w 25109
# psub-23343_ses-20140512_acq-mpragend_rec-nd_run-02_T1w
# psub-23343_ses-20140512_acq-mpragend_rec-nd_run-02_T1w
# mv: cannot stat ‘psub-23343_ses-*_acq-mpragend_rec-nd_run-02_T1w’: No such file or directory
# Coregistration
# -----------------------------------------------------------------------------

echo "Coregister mean volumes to T1"
mkdir $SUBJECTS_DIR/${subject}/tau
mri_coreg --s ${subject} --mov ${mov} --reg ${reg}


# GTM - PVC
# -----------------------------------------------------------------------------

 mri_gtmpvc --i ${pet_mcf}  --reg ${reg} --psf 6.8 --seg ${gtm_seg} --default-seg-merge --auto-mask PSF .01 --mgx $mgxthresh --o $SUBJECTS_DIR/${i}/tau/dynamic_gtm_thresh_${mgxthresh}/ --km-ref 8 47 --km-hb 11 12 13 50 51 52 --no-rescale
