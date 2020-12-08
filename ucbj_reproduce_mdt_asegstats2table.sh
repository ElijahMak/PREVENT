# Author: Elijah Mak


# Directory
# --------------------------------------------

# Modules
# --------------------------------------------
module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

# Parameters
# --------------------------------------------
SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"
subjectsfile=${1}

# # Compute surface data
# # --------------------------------------------
# for h in lh rh; do
#   for x in noddi_odi_native unpvc_ucbj_bp_native; do
#   asegstats2table --subjectsfile ${subjectsfile} --meas mean --stats=${h}_${x}.dat --table ${h}_${x}.csv  --all-segs
# done
# done
#
# # Merge files
# for x in noddi_odi_native unpvc_ucbj_bp_native; do
# cat lh_${x}.csv rh_${x}.csv > lh_rh_${x}.csv
# done

# Compute data
# --------------------------------------------
for x in wmparc_2_mdt_odi_gm.dat aparcaseg_2_mdt_odi_gm.dat; do
  asegstats2table --subjectsfile ${subjectsfile} --meas mean --stats=${x}.dat --table ${x}.csv --all-segs --skip
done
