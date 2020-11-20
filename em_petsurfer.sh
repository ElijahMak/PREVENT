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
export SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/freesurfer/include"
pet="/lustre/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/pet/${subject}_concat_tau.nii"
mov="/lustre/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/pet/${subject}_concat_tau_mcf_mean_reg.nii"
pet_mcf="/lustre/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/pet/${subject}_concat_tau_mcf.nii"
reg="$SUBJECTS_DIR/${subject}/tau/mri_coreg_concat_tau_mcf_mean_reg.lta"
gtmseg="$SUBJECTS_DIR/${subject}/mri/gtmseg.mgz"
mgxthresh="0.25"
tac="$SUBJECTS_DIR/dynamic_pet/PET_$tac/tac*.dat"
hemi="lustre/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/freesurfer/hemi"

# Notes
# -----------------------------------------------------------------------------
# Files were renamed: fkm24@wbic-gate-2:/archive/p00423/PREVENT_Elijah/NeuroimageClinical_TauWM/pet$ for i in `cat list`; do cp Concat_${subject}_AV-1451_PET*.nii ${subject}_concat_tau.nii; done

# Motion Correction
# -----------------------------------------------------------------------------

echo "Motion correction + deriving mean volumes"
#mcflirt -in ${pet} -meanvol -mats -report

# GTM segmentation
# -----------------------------------------------------------------------------

# gtmseg --s ${subject}

echo "Coregister mean volumes to T1"
# mkdir $SUBJECTS_DIR/${subject}/tau
# mri_coreg --s ${subject} --mov ${mov} --reg ${reg}

# MRTM1
# for i in `cat ../list`; do cp tac_58.dat ../freesurfer/include/${subject}/tau/tac.dat
# for i in `cat frame_58`; do cp tac_58.dat ../freesurfer/include/${subject}/tau/tac.dat; done
# for i in `cat frame_55`; do cp tac_55.dat ../freesurfer/include/${subject}/tau/tac.dat; done
# for i in `cat frame_54`; do cp tac_54.dat ../freesurfer/include/${subject}/tau/tac.dat; done
# for i in `cat frame_52`; do cp tac_52.dat ../freesurfer/include/${subject}/tau/tac.dat; done

#mri_gtmpvc --i ${pet_mcf}  --reg ${reg} --psf 6.8 --seg $SUBJECTS_DIR/${subject}/mri/gtmseg.mgz --default-seg-merge --auto-mask PSF .01 --mgx $mgxthresh --o $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/ --km-ref 8 47 --km-hb 11 12 13 50 51 52 --no-rescale

# mri_glmfit --y $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/km.hb.tac.nii.gz --mrtm1 $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/km.ref.tac.dat $SUBJECTS_DIR/${subject}/tau/tac.dat --o $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/mrtm1 --no-est-fwhm  --nii.gz

#k2p=`cat $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/mrtm1/k2prime.dat`

# mri_glmfit --y $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/gtm.nii.gz --mrtm2 $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/km.ref.tac.dat  $SUBJECTS_DIR/${subject}/tau/tac.dat $k2p --o $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/mrtm2 --no-est-fwhm --nii.gz

for h in `cat ${hemi} `; do mri_vol2surf --mov ${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/mgx.ctxgm.nii.gz --reg ${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/aux/bbpet2anat.lta --hemi ${h} --projfrac 0.5 --o $SUBJECTS_DIR/${subject}/surf/${h}.tau.mgx.ctxgm.fsaverage.mgx.thresh.${mgxthresh}.sm00.nii.gz --cortex --trgsubject fsaverage; mris_fwhm --smooth-only --i $SUBJECTS_DIR/${subject}/surf/${h}.${modality}.mgx.ctxgm.dynamic.fsaverage.mgx.thresh.${mgxthresh}.sm00.nii.gz  --fwhm $fwhm --o $SUBJECTS_DIR/${subject}/surf/${h}.${modality}.mgx.ctxgm.dynamic.fsaverage.mgx.thresh.${mgxthresh}.sm0${fwhm}.nii.gz  --cortex --s fsaverage --hemi ${h}; done

for h in `cat hemi `;  do  k2p=`cat $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/mrtm1/k2prime.dat`; mri_glmfit --y $SUBJECTS_DIR/${subject}/surf/${h}.tau.mgx.ctxgm.fsaverage.mgx.thresh.${mgxthresh}.sm0${fwhm}.nii.gz --mrtm2 $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/km.ref.tac.dat $SUBJECTS_DIR/${subject}/tau/tac.dat $k2p --o $SUBJECTS_DIR/${subject}/tau/dynamic_gtm_thresh_${mgxthresh}/mrtm2/${h}.sm0${fwhm} --no-est-fwhm --nii.gz --surface fsaverage ${h}; done
