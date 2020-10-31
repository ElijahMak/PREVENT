#!/bin/bash

# NODDI modelling

# Example: bash em_hpc_mdt.sh subjectA

# Load modules
module load mdt/0.21.0
module load miniconda3/4.5.1

# Strange error: MDT might present this error message after a successful NODDI fitting on a previous subject.
# If it happens, run this:
rm /home/fkm24/.cache/pyopencl/pyopencl-compiler-cache-v2-py3.6.5.final.0/lock

subject=${1}

echo "=== Welcome to the MDT pipeline ==="
echo "=== Author: Eljah Mak ==="
echo "=== MDT initialising for $subject ==="

cd $subject

# Define input files
bvec="denoised_degibbs.edc.repol.eddy_rotated_bvecs"
bval="bval"
noddi_input="denoised_degibbs.edc.repol.bfc.nii"
mask="denoised_degibbs_dwi_b0_brain_mask.nii"

# Create protocol
python $(which mdt-create-protocol) $bvec $bval -o $subject.prtcl

prtcl=$subject.prtcl

# Fitting NODDI maps
mkdir mdt_denoised_degibbs_edc_bfc
python $(which mdt-model-fit) NODDI $noddi_input $prtcl $mask -o mdt_denoised_degibbs_edc_bfc
python $(which mdt-model-fit) NODDI_GM $noddi_input $prtcl $mask -o mdt_denoised_degibbs_edc_bfc

echo "=== MDT completed for ${subject} ==="
