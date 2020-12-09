# Process DWI dataset for the extraction of NODDI maps in HPHI
# Author: Elijah Mak


# Load modules
# ---------------------------------------------------


# Parameters
# ---------------------------------------------------
subject=${1}
cd ${subject}ls
mask="hifi_nodif_brain_f0.2_mask.nii"
input="eddy_unwarped_images.nii"
rotated_bvecs="eddy_unwarped_images.eddy_rotated_bvecs"
bval="ap.bvals"
prtcl="mdt.prtcl"

# Create protocol
# ---------------------------------------------ls------
mdt-create-protocol ${rotated_bvecs} ${bval} -o ${prtcl}

# Remove ocassional locks
# ---------------------------------------------------
rm -rf /home/fkm24/.cache/pyopencl/pyopencl-compiler-cache-v2-py3.6.5.final.0/lock

# Fit NODDI models
# ---------------------------------------------------
echo "Fitting NODDI WM"
mkdir mdt_WM
mdt-model-fit NODDI $input mdt.prtcl ${mask} -o mdt_WM


# echo "Fitting NODDI GM"
# mdt_GM
# echo "python $(which mdt-model-fit) NODDI_GM $input $prtcl ${mask} -o mdt_GM"
# python $(which mdt-model-fit) NODDI_GM $input $prtcl ${mask} -o mdt_GM
