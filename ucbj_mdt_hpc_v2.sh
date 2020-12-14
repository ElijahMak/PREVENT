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
input="edc.nii"
rotated_bvecs="edc.eddy_rotated_bvecs"
bval="ap_pa.bvals"
prtcl="mdt.prtcl"

# Create protocol
# ---------------------------------------------------
mdt-create-protocol ${rotated_bvecs} ${bval} -o ${prtcl}

# Remove ocassional locks
# ---------------------------------------------------
rm -rf /home/fkm24/.cache/pyopencl/pyopencl-compiler-cache-v2-py3.6.5.final.0/lock

# Fit NODDI models
# ---------------------------------------------------
mkdir mdt
mdt-model-fit NODDI_GM $input mdt.prtcl ${mask} -o mdt
