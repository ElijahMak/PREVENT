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
echo "=== Creating protocol for MDT === "

cd $subject

# Define input files
bvec="edc.repol.s2v.eddy_rotated_bvecs"
bval="$subject.bval"
noddi_input="edc.repol.s2v.nii.gz"
mask="b0_brain_mask.nii.gz"

# Checking input files
echo "== Checking input files ... =="

if [ ! -f $bvec ]
then
    echo "Input rotated bvec is found."
    echo "$subject missing bvec" >> ../missing_data.log
  else
    echo "Input rotated bvec is found."
fi

if [ ! -f $bval ]
then
    echo "Input bval is missing."
    echo "$subject missing bval" >> ../missing_data.log
  else
    echo "Input bval is found."
fi

# Create protocol
python $(which mdt-create-protocol) $bvec $bval -o $subject.prtcl

prtcl=$subject.prtcl

# Fitting NODDI maps
mkdir mdt_s2v_fwpk
python $(which mdt-model-fit) NODDI $noddi_input $prtcl $mask -o mdt_s2v_fwpk
python $(which mdt-model-fit) NODDI_GM $noddi_input $prtcl $mask -o mdt_s2v_fwpk

echo "=== MDT completed for ${subject} ==="
