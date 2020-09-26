subject=${1}
cd ${subject}

# Running NODDI
module load mdt/0.21.0
module load miniconda3/4.5.1

# Parameters
mask="b0_brain_mask.nii.gz"
input="edc.repol.nii"
rotated_bvecs="edc.repol.eddy_rotated_bvecs"
bval="bval"

# Create protocol
python $(which mdt-create-protocol) $rotated_bvecs $bval -o mdt.prtcl
prtcl="mdt.prtcl"
rm -rf /home/fkm24/.cache/pyopencl/pyopencl-compiler-cache-v2-py3.6.5.final.0/lock

echo "Fitting NODDI WM"
mkdir mdt_WM
echo "python $(which mdt-model-fit) NODDI $input $prtcl ${mask} -o mdt_WM"
python $(which mdt-model-fit) NODDI $input $prtcl ${mask} -o mdt_WM

echo "Fitting NODDI GM"
mdt_GM
echo "python $(which mdt-model-fit) NODDI_GM $input $prtcl ${mask} -o mdt_GM"
python $(which mdt-model-fit) NODDI_GM $input $prtcl ${mask} -o mdt_GM
