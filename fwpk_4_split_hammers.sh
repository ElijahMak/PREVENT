# Split each atlases into its various components
subject=${1}

cd $subject


# Full hammers
for i in `cat ../index`
      do fslmaths hammers/w${subject}_Hammers_mith_icbm_psp.nii.gz -thr ${i} -uthr ${i} hammers/${i}.nii.gz
done

# 50 GM
for i in `cat ../index`
      do fslmaths hammers/w${subject}_Hammers_mith_icbm_psp_gm_mask_50.nii.gz -thr ${i} -uthr ${i} hammers/${i}_gm_mask_50.nii.gz
done

# 50 WM
for i in `cat ../index`
      do fslmaths hammers/w${subject}_Hammers_mith_icbm_psp_gm_mask_50.nii.gz -thr ${i} -uthr ${i} hammers/${i}_wm_mask_50.nii.gz
done
