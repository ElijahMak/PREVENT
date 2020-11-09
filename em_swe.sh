#!/bin/bash
# Example
# bash em_swe_eyo.sh design_number (1 , 2 , etc) perm_number

# Load modules
. /etc/profile.d/modules.sh
module purge
module load default-wbic
module load openmpi/3.0.0
module unload fsl/5.0.10
module load fsl/6.0.3

# Select according to the design/contrast
design=${1}
contrast=${2}
sub=${3}
perm=${4}
mask="mean_FA_skeleton_mask.nii"
nTask=4

for m in FA MD RD;
do
sbatch --job-name=swe2 --account hphi --qos=long.q --partition wbic-cs --error=${design%.*}_%j.err \
--output=${design%.*}_%j.out --time=5-23:00:00 --nodes=1 --ntasks-per-node=1 --mem=10000 \
--wrap="swe -i all_EYO_${m}_skeletonised.nii -o ${m}_D{$design}_C_${contrast}_n${perm} -d design_${design}.mat -t contrast_${contrast}.con -s design_${sub}.sub -m $mask --T2 --logp --wb  -n $perm --corrp" --mail-type=ALL
done
sleep 1

# Binarise statistical maps
#for m in FA MD RD;
#do
#for i in 1 2 3 4 5 6 7 8 9 10;
#do
#fslmaths ${group}_${measure}_${perm}_tfce_lcorrp_tstat${i}.nii -thr 1.3 ${group}_${measure}_${perm}_tfce_lcorrp_tstat${i}_bin.nii;

# Run this on HPHI and ignore the warnings
#cm="red-yellow"
#xvfb-run -s "-screen 0 640x480x24" fsleyes render --scene ortho --outfile ${group}_${measure}_${perm}_tfce_lcorrp_tstat${i}_bin.png -std1mm ${group}_${measure}_${perm}_tfce_lcorrp_tstat${i}_bin.nii -cm $cm

# Transfer images to results
#cp ${group}_${measure}_${perm}_tfce_lcorrp_tstat${i}_bin.png ../results
