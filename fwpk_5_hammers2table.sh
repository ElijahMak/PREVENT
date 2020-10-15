# Concatenate all data outputs from subjects into a table
# Author: Elijah MAK

# Directory

dti=${1}

#for dti in FA MD RD ODI; do

  # Merge all data files
    column */all_${dti}_jhu.txt >> temp_1

  # Append ROIs to data file
  sed -e '1i\Hippocampus_r	Hippocampus_l	Amygdala_r	Amygdala_l	Ant_TL_med_r	Ant_TL_med_l	Ant_TL_inf_lat_r	Ant_TL_inf_lat_l	G_paraH_amb_r	G_paraH_amb_l	G_sup_temp_cent_r	G_sup_temp_cent_l	G_tem_midin_r	G_tem_midin_l	G_occtem_la_r	G_occtem_la_l	NA	NA	NA	Insula_l	Insula_r	OL_rest_lat_l	OL_rest_lat_r	G_cing_ant_sup_l	G_cing_ant_sup_r	G_cing_post_l	G_cing_post_r	FL_mid_fr_G_l	FL_mid_fr_G_r	PosteriorTL_l	PosteriorTL_r	PL_rest_l	PL_rest_r	CaudateNucl_l	CaudateNucl_r	NuclAccumb_l	NuclAccumb_r	Putamen_l	Putamen_r	Thalamus_l	Thalamus_r	Pallidum_l	Pallidum_r	Corp_Callosum	FrontalHorn_r	FrontalHorn_l	TemporaHorn_r	TemporaHorn_l	ThirdVentricl	FL_precen_G_l	FL_precen_G_r	FL_strai_G_l	FL_strai_G_r	FL_OFC_AOG_l	FL_OFC_AOG_r	FL_inf_fr_G_l	FL_inf_fr_G_r	FL_sup_fr_G_l	FL_sup_fr_G_r	PL_postce_G_l	PL_postce_G_r	PL_sup_pa_G_l	PL_sup_pa_G_r	OL_ling_G_l	OL_ling_G_r	OL_cuneus_l	OL_cuneus_r	FL_OFC_MOG_l	FL_OFC_MOG_r	FL_OFC_LOG_l	FL_OFC_LOG_r	FL_OFC_POG_l	FL_OFC_POG_r	S_nigra_l	S_nigra_r	Subgen_antCing_l	Subgen_antCing_r	Subcall_area_l	Subcall_area_r	Presubgen_antCing_l	Presubgen_antCing_r	G_sup_temp_ant_l	G_sup_temp_ant_r	Brainstem_mid	Brainstem_pon	Brainstem_med	Pituitary	Cerebellum_gm_r	Cerebellum_gm_l	Cerebellum_wm_r	Cerebellum_wm_l	Cerebellum_dentate_l	Cerebellum_dentate_r' temp_1 > temp_2

  # Append subjects to data file
  paste subjects temp_2 > all_${dti}_jhu.txt

  # Remove temp files
  rm temp_1
  rm temp_2
#done
