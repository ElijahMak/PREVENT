# Modules
# -------------------------------

module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2


subject=${1}
fslswapdim ${subject}_AV-1451_R1_Neuro.nii.gz -x y z ${subject}_AV-1451_R1_Radio.nii.gz
fslorient -swaporient ${subject}_AV-1451_R1_Radio.nii.gz
