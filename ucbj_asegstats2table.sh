# Author: Elijah Mak


# Directory
# --------------------------------------------

# Modules
# --------------------------------------------
module load freesurfer/6.0.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3
module load MRtrix/mrtrix-3.0.2

# Parameters
# --------------------------------------------
SUBJECTS_DIR="/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/freesurfer"
subjectsfile=${1}

# Compute surface data
# --------------------------------------------
for h in lh rh; do
  for x in mdt_odi; do
  asegstats2table --subjectsfile ${subjectsfile} --meas mean --stats=${h}_${x}.dat --table fs_outputs/${h}_${x}.csv  --all-segs
done
done

# Compute aseg data
# --------------------------------------------
for x in aseg_2_mdt_odi aseg_2_pvc_ucbj; do
  asegstats2table --subjectsfile ${subjectsfile} --meas mean --stats=${x}.dat --table fs_outputs/${x}.csv --all-segs --skip
done

# Compute volumetric aseg data
# --------------------------------------------
asegstats2table --subjectsfile list --table fs_outputs/aseg.csv --skip

# Compute thickness
# --------------------------------------------
for h in lh rh; do
aparcstats2table --subjectsfile list --hemi ${h}  --table fs_outputs/${h}_thickness.csv  --meas thickness --skip; done

# Compute surface area
# --------------------------------------------
for h in lh rh; do
aparcstats2table --subjectsfile list --hemi ${h}  --table fs_outputs/${h}_area.csv  --skip; done

# Compute brain stem volumes
# --------------------------------------------
quantifyBrainstemStructures.sh fs_outputs/brainstem_vol.csv ${SUBJECTS_DIR}
