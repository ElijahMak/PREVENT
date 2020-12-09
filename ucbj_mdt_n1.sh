# Process DWI dataset for the extraction of NODDI maps in HPHI
# Author: Elijah Mak


# Load modules
# ---------------------------------------------------
source ~/mdt/bin/activate

# Parameters
# ---------------------------------------------------
subject=${1}
cd ${subject}

mask="hifi_nodif_brain_f0.3_mask.nii"
input="eddy_unwarped_images.nii"
rotated_bvecs="eddy_unwarped_images.eddy_rotated_bvecs"
bval="ap.bvals"
prtcl="mdt_n1.prtcl"

# Create protocol
# ---------------------------------------------------
mdt-create-protocol ${rotated_bvecs} ${bval} -o ${prtcl}

# Remove ocassional locks
# ---------------------------------------------------
rm -rf /home/fkm24/.cache/pyopencl/pyopencl-compiler-cache-v2-py3.6.5.final.0/lock

# Fit NODDI models
# ---------------------------------------------------
mkdir mdt_noise1
mdt-model-fit NODDI_GM $input mdt.prtcl ${mask} -o mdt_noise1 -n 1
