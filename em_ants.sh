
antsCorticalThickness.sh \
-d 3 \
-a ${DATA}/ses-1/anat/sub-001-ses-1-T1w.nii \
-e ${TPL}/T_template0.nii.gz \
-t ${TPL}/T_template0_BrainCerebellum.nii.gz \
-m ${TPL}/T_template0_BrainCerebellumProbabilityMask.nii.gz \
-f ${TPL}/T_template0_BrainCerebellumExtractionMask.nii.gz \
-p ${TPL}/Priors2/priors%01d.nii.gz \
-q 1 \
-n 6 \
-x 6 \
-o $DATA/ants

time1_modality1=${DATA}/ses-1/anat/sub-001-ses-1-T1w.nii

time2_modality1=${DATA}/ses-2/anat/sub-001-ses-2-T1w.nii


antsLongitudinalCorticalThickness.sh -d 3 \
              -e ${TPL}/mni_icbm152_t1_tal_nlin_sym_09a.nii \
              -m ${TPL}/mni_icbm152_t1_tal_nlin_sym_09a_mask.nii \
              -p ${TPL}/Priors2/priors%01d.nii.gz \
              -o ${DATA}/ants \
              ${time1_modality1} ${time2_modality1}


              DATA=/lustre/archive/p00423/PREVENT_Elijah/project_gm_networks/sub-001
              TPL=/lustre/archive/p00423/PREVENT_Elijah/project_gm_networks/templates/mni152
              mkdir -p /lustre/archive/p00423/PREVENT_Elijah/project_gm_networks/sub-001

              time1_modality1=${DATA}/ses-1/anat/sub-001-ses-1-T1w.nii

              time2_modality1=${DATA}/ses-2/anat/sub-001-ses-2-T1w.nii




module load ANTS/2.3.4

DATA=/lustre/archive/p00423/PREVENT_Elijah/project_gm_networks/sub-001
TPL=/lustre/archive/p00423/PREVENT_Elijah/project_gm_networks/templates/mni152
mkdir -p /lustre/archive/p00423/PREVENT_Elijah/project_gm_networks/sub-001
time1_modality1=${DATA}/ses-1/anat/sub-001-ses-1-T1w.nii
time2_modality1=${DATA}/ses-2/anat/sub-001-ses-2-T1w.nii

  antsLongitudinalCorticalThickness.sh -d 3 \
                -e ${TPL}/template.nii.gz \
                -m ${TPL}/template_brain_probability_mask.nii.gz \
                -p ${TPL}/prior%d.nii.gz                                 \
                -t ${TPL}/template_brain.nii.gz                          \
                -f ${TPL}/template_brain_registration_mask.nii.gz        \
                -o ${DATA}/ants_mni_test \
                ${time1_modality1} ${time2_modality1}
