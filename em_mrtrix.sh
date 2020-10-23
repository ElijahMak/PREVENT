# MRTRIX pipeline

# To generate connectomes from eddy-corrected data.
# Author: Elijah Mak

# Modules
# -----------------------------------------------------------------------------

module load freesurfer/7.1.0
module load ANTS/2.2.0
module unload fsl/5.0.10
module load fsl/6.0.3



# Parameters
# -----------------------------------------------------------------------------

dir="/lustre/archive/p00423/PREVENT_Elijah/MRTRIX"
subject=${1}
BET=${2}
raw_dwi="dwi.nii"
denoised_dwi="dwi.denoised.nii"
denoised_degibbs_dwi="dwi.denoised.degibbs.nii"
b0="denoised_degibbs_dwi_b0.nii.gz"
mask="denoised_degibbs_dwi_b0_brain_f02_mask.nii.gz"
output_edc="denoised_degibbs.edc.repol"
edc="denoised_degibbs.edc.repol.nii.gz"
edc_rotated_bvecs="denoised_degibbs.edc.repol.eddy_rotated_bvecs"
edc_mif="denoised_degibbs.edc.repol.mif"
edc_mif_bfc="denoised_degibbs.edc.repol.bfc.mif"
edc_mif_bfc_tensor="denoised_degibbs.edc.repol.bfc.tensor.mif"
edc_mif_bfc_tensor_FA="denoised_degibbs.edc.repol.bfc.tensor.FA.mif"
edc_mif_bfc_tensor_MD="denoised_degibbs.edc.repol.bfc.tensor.MD.mif"
edc_mif_bfc_tensor_RD="denoised_degibbs.edc.repol.bfc.tensor.RD.mif"
edc_mif_bfc_tensor_AD="denoised_degibbs.edc.repol.bfc.tensor.AD.mif"
edc_nii_bfc_tensor_FA="denoised_degibbs.edc.repol.bfc.tensor.FA.nii"
edc_nii_bfc_tensor_MD="denoised_degibbs.edc.repol.bfc.tensor.MD.nii"
edc_nii_bfc_tensor_RD="denoised_degibbs.edc.repol.bfc.tensor.RD.nii"
edc_nii_bfc_tensor_AD="denoised_degibbs.edc.repol.bfc.tensor.AD.nii"

# Initialising Text
# -------------------------------------------------------------------------------------------------

echo "███████╗███╗   ███╗       ██████╗ ██╗███████╗███████╗██╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗
██╔════╝████╗ ████║       ██╔══██╗██║██╔════╝██╔════╝██║   ██║██╔════╝██║██╔═══██╗████╗  ██║
█████╗  ██╔████╔██║       ██║  ██║██║█████╗  █████╗  ██║   ██║███████╗██║██║   ██║██╔██╗ ██║
██╔══╝  ██║╚██╔╝██║       ██║  ██║██║██╔══╝  ██╔══╝  ██║   ██║╚════██║██║██║   ██║██║╚██╗██║
███████╗██║ ╚═╝ ██║██╗    ██████╔╝██║██║     ██║     ╚██████╔╝███████║██║╚██████╔╝██║ ╚████║██╗
╚══════╝╚═╝     ╚═╝╚═╝    ╚═════╝ ╚═╝╚═╝     ╚═╝      ╚═════╝ ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝
                                                                                               "

echo "Diffusion pipeline started at $(date)"
echo "Initialising diffusion preprocessing for ${subject}"


# Preprocessing
# -------------------------------------------------------------------------------------------------
echo "_   _   _   _   _   _   _   _   _   _
  / \ / \ / \ / \ / \ / \ / \ / \ / \ / \
 ( P | r | e | p | r | o | c | e | s | s )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ "

cd ${dir}
cd ${subject}

# Denoising of DWI
dwidenoise ${raw_dwi} ${denoised_dwi}

# Remove Gibbs Ringing artifact
mrdegibbs ${denoised_dwi} ${denoised_degibbs_dwi}

# Perform brain extraction
if [ "${BET}" = "0" ]; then
  echo "Running BET [1/3]"
  echo "fslroi $denoised_degibbs_dwi $b0 0 1"
  fslroi ${denoised_degibbs_dwi} ${b0} 0 1
  echo "bet b0 b0_brain -m -f 0.2"
  bet ${b0} denoised_degibbs_dwi_b0_brain_f01 -m -f 0.1
  bet ${b0} denoised_degibbs_dwi_b0_brain_f02 -m -f 0.2
  bet ${b0} denoised_degibbs_dwi_b0_brain_f03 -m -f 0.3
  bet ${b0} denoised_degibbs_dwi_b0_brain_f04 -m -f 0.4
else
  echo "Using edited BET [1/3]"
fi

# Eddy current correction
eddy_openmp --imain=${denoised_degibbs_dwi} \
--mask=${mask} --acqp=acqparams.txt \
--index=index.txt --bvecs=bvec \
--bvals=bval --fwhm=10,0,0,0,0 \
--repol \
--out=$output_edc \
--cnr_maps \
--verbose


# Bias-field correction and tensor fitting
# -------------------------------------------------------------------------------------------------

echo "   _   _   _   _   _   _     _   _   _   _   _   _   _
  / \ / \ / \ / \ / \ / \   / \ / \ / \ / \ / \ / \ / \
 ( T | e | n | s | o | r ) ( F | i | t | t | i | n | g )
  \_/ \_/ \_/ \_/ \_/ \_/   \_/ \_/ \_/ \_/ \_/ \_/ \_/ "

# Convert to mif
mrconvert ${edc} ${edc_mif} -fslgrad ${output_edc}.eddy_rotated_bvecs bval -datatype float32 -strides 0,0,0,1

# Perform bias-field correction on
dwibiascorrect ants -mask ${mask} -bias bias.nii ${edc_mif} ${edc_mif_bfc}

# Extract tensor maps
dwi2tensor -mask ${mask} ${edc_mif_bfc} ${edc_mif_bfc_tensor}

# Fit tensor maps
tensor2metric -fa ${edc_mif_bfc_tensor_FA} ${edc_mif_bfc_tensor} -force
tensor2metric -adc ${edc_mif_bfc_tensor_MD} ${edc_mif_bfc_tensor} -force
tensor2metric -ad ${edc_mif_bfc_tensor_AD} ${edc_mif_bfc_tensor} -force
tensor2metric -rd ${edc_mif_bfc_tensor_RD} ${edc_mif_bfc_tensor} -force
mrconvert ${edc_mif_bfc_tensor_FA} ${edc_nii_bfc_tensor_FA}
mrconvert ${edc_mif_bfc_tensor_MD} ${edc_nii_bfc_tensor_MD}
mrconvert ${edc_mif_bfc_tensor_AD} ${edc_nii_bfc_tensor_AD}
mrconvert ${edc_mif_bfc_tensor_RD} ${edc_nii_bfc_tensor_RD}

# Estimate response for FOD
dwi2response tournier ${edc_mif_bfc} tournier_response.txt -voxels tournier_voxels.mif -mask ${mask}

# Perform CSD
dwi2fod csd ${edc_mif_bfc} tournier_response.txt tournier_response_fod.mif -mask ${mask}


# Connectome pipeline
# -------------------------------------------------------------------------------------------------
echo "   _   _   _   _   _   _   _   _   _   _
  / \ / \ / \ / \ / \ / \ / \ / \ / \ / \
 ( C | o | n | n | e | c | t | o | m | e )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ "

# Freesurfer registration
export SUBJECTS_DIR=/lustre/archive/p00423/PREVENT_Elijah/Freesurfer7_GS

mri_coreg --s ${subject} --mov ${b0} --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta

# Inverse warp segmentations into DTI displaySpace
mri_vol2vol --mov ${b0} --targ $SUBJECTS_DIR/${subject}/mri/brainmask.mgz --inv --interp nearest --o rbrainmask.nii --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta

mri_vol2vol --mov ${b0} --targ $SUBJECTS_DIR/${subject}/mri/aparc+aseg.mgz --inv --interp nearest --o raparcaseg.nii --reg $SUBJECTS_DIR/${subject}/b0.coreg.lta

5ttgen freesurfer raparc+aseg.nii 5ttseg.mif -sgm_amyg_hipp -lut $FREESURFER_HOME/FreeSurferColorLUT.txt -lut $FREESURFER_HOME/FreeSurferColorLUT.txt

5tt2gmwmi 5ttseg.mif 5tt_mask.mif

tckgen -seed_gmwmi 5tt_mask.mif -act 5ttseg.mif -crop_at_gmwmi -seeds 5000000 fod.mif wholebrain.tck -force

tcksift wholebrain.tck fod.mif sift1_wholebrain.tck -force

tcksift2 wholebrain.tck fod.mif wholebrain_sift2_weights.txt -force

labelconvert raparc+aseg.nii $FREESURFER_HOME/FreeSurferColorLUT.txt $code/fs_default.txt output_parcels.mif -force

tck2connectome -assignment_radial_search 2 -scale_length -out_assignments assignments2.txt -tck_weights_in wholebrain_sift2_weights.txt wholebrain.tck output_parcels.mif connectome.csv -force

connectome2tck wholebrain.tck assignments2.txt exemplars.tck -files single -exemplars output_parcels.mif


# Extract ROI from JHU ICBM atlas
# -------------------------------------------------------------------------------------------------

echo "   _   _   _     _   _   _   _
  / \ / \ / \   / \ / \ / \ / \
 ( J | H | U ) ( I | C | B | M )
  \_/ \_/ \_/   \_/ \_/ \_/ \_/ "


# Normalisation to MNI152

# Parameters
FMRIB58_FA_1mm="/lustre/archive/p00423/PREVENT_Elijah/FAST/FMRIB58_FA_1mm.nii.gz"
flirt_out="denoised_degibbs.edc.repol.bfc.tensor.FA.flirt.nii"
flirt_omat="denoised_degibbs.edc.repol.bfc.tensor.FA.flirt.mat"
bins="256"
cost="corratio"
dof="12"
interp="trilinear"
fnirt_omat="denoised_degibbs.edc.repol.bfc.tensor.FA.fnirt.mat"
FA_fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.FA.fnirt.nii"
MD_fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.MD.fnirt.nii"
RD_fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.RD.fnirt.nii"
AD_fnirt_out="denoised_degibbs.edc.repol.bfc.tensor.AD.fnirt.nii"

echo "Started: Normalistion to FMRIB using FA ${subject}"

# FLIRT
flirt -in ${edc_nii_bfc_tensor_FA} -ref ${FMRIB58_FA_1mm} -out ${flirt_omat} -omat ${omat} -bins ${bins} -cost ${cost} \
-searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof ${dof} -interp ${interp}
# FNIRT
fnirt --ref=${ref} --in=${FA} --aff=${flirt_omat} \
--cout=${fnirt_omat} --config=FA_2_FMRIB58_1mm

# Apply warps
applywarp --ref=${ref} --in=${FA} --warp=${fnirt_omat} \
--out=${FA_fnirt_out}
applywarp --ref=${ref} --in=${MD} --warp=${fnirt_omat} \
--out=${MD_fnirt_out}
applywarp --ref=${ref} --in=${RD} --warp=${fnirt_omat} \
--out=${RD_fnirt_out}
applywarp --ref=${ref} --in=${AD} --warp=${fnirt_omat} \
--out=${AD_fnirt_out}

echo "Completed: Normalistion to FMRIB using FA ${subject}"

# Inverse transform JHU labels from FMRIB space
echo "Started: Inverse warp JHU labels ${subject}"

mkdir JHU

invwarp --warp=${FA_fnirt_out}\
--ref=${FA} \
--out=invwarp_FMRIB_to_FA

for i in {1..48}
do
  applywarp -i /lustre/archive/p00423/PREVENT_Elijah/data/em_jhu_toolbox/${i}.nii.gz \
  -o JHU/${i}.nii.gz \
  -r ${FA} \
  -w invwarp_FMRIB_to_FA.nii.gz \
  --interp=nn
done

echo "Completed: Inverse warp JHU labels ${subject}"

#  Calculate metrics of JHU labels in native space
echo "Started: Calculating FA, MD, AD, RD in JHU labels ${subject}"

for dti in FA MD RD AD; do
  file="denoised_degibbs.edc.repol.bfc.tensor.${dti}.nii"
  if [ -f ${file} ]; then
    for roinum in {1..48} ; do
      padroi=`$FSLDIR/bin/zeropad $roinum 3`
      if [ -f JHU/${dti}_JHU_${padroi}.txt ];
      then
        rm JHU/${dti}_JHU_${padroi}.txt;
      fi
      fslmeants -i ${file} -m warped_jhu/${roinum}.nii >>
      JHU/${dti}_JHU_${padroi}.txt
      paste JHU/*${dti}_JHU_*.txt > JHU/all_${dti}_jhu.txt
    done
  else
    for roinum in {1..48} ; do
      padroi=`$FSLDIR/bin/zeropad $roinum 3`
      if [ -f JHU/${dti}_JHU_${padroi}.txt ]; then
        rm JHU/${dti}_JHU_${padroi}.txt; fi
        echo "NA" >> JHU/${dti}_JHU_${padroi}.txt
        paste JHU/*${dti}_JHU_*.txt > JHU/all_${dti}_jhu.txt
      done
    fi
  done

  echo "Completed: Calculating native FA, MD, AD, RD in JHU labels for ${subject}"
  echo "Diffusion pipeline completed at $(date)"
  echo "   _____ ____  __  __ _____  _      ______ _______ ______ _____
  / ____/ __ \|  \/  |  __ \| |    |  ____|__   __|  ____|  __ \
 | |   | |  | | \  / | |__) | |    | |__     | |  | |__  | |  | |
 | |   | |  | | |\/| |  ___/| |    |  __|    | |  |  __| | |  | |
 | |___| |__| | |  | | |    | |____| |____   | |  | |____| |__| |
  \_____\____/|_|  |_|_|    |______|______|  |_|  |______|_____/

                                                                 "
