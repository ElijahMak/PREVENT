%Computes NODDI map from nifty files
%11 Feb 2019
%Rafael Romero Garcia rr480@cam.ac.uk

% enter MATLAB and run code without .m

%%Select the input folder - Uncomment your folder path
path_data='/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/lastbatch/';
addpath('/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/lastbatch/NODDI_toolbox_v1.01/');
addpath('/lustre/scratch/hphi/fkm24/em_code/');

dir_data=dir(path_data);
path_script_bash='/lustre/archive/p00423/PREVENT_Elijah/NeurobiologyAgeing_UCBJXNODDI/noddi/lastbatch/runMatlabHPHI_5par.sh';
for id=3:numel(dir_data)
    path_subj=[path_data dir_data(id).name '/'];
    cd(path_subj);
    path_dwi= [path_subj   'denoised_degibbs.edc.repol.bfc.nii'];
    path_bvals= [path_subj   'bval'];
    path_bvecs= [path_subj   'denoised_degibbs.edc.repol.eddy_rotated_bvecs'];
    path_mask= [path_subj   'denoised_degibbs_dwi_b0_brain_mask.nii'];
    path_out=[path_subj '/NODDI_MATLAB_v101/'];
    if not(exist([path_out 'noddi_ficvf.nii.gz']))   && not(exist([path_out 'FittedParams.mat']))
    %NODDI_processing(path_dwi,path_mask,path_bvals,path_bvecs,path_out)
        system(['rm ' path_out 'NODDI_brain.mat']);
        system(['sbatch --time 86:00:00 ' path_script_bash ' NODDI_processing ' path_dwi ' ' path_mask ' ' path_bvals ' ' path_bvecs ' ' path_out]);
    end
end
