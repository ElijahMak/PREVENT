% Computes NODDI map from nifty files
% 11 Feb 2020
% Rafael Romero Garcia
% rr480@cam.ac.uk

function NODDI_processing(path_dwi,path_mask,path_bvals,path_bvecs,path_out)

[s1 s2 s3]=mkdir(path_out);

if not(exist([path_out '/NODDI_brain.mat']))
    CreateROI(path_dwi, path_mask, [path_out '/NODDI_brain.mat']);
end

%Calculate NODDI
if not(exist([path_out '/noddi_fibredirs_zvec.nii.gz']))
    protocol = FSL2Protocol(path_bvals, path_bvecs,10);
    noddi = MakeModel('WatsonSHStickTortIsoV_B0');
    %batch_fitting([path_out '/NODDI_brain.mat'], protocol, noddi,[path_out '/FittedParams.mat'],4);
    batch_fitting_single([path_out '/NODDI_brain.mat'], protocol, noddi,[path_out '/FittedParams.mat']);
end

%Save NODDI as nifty map
if not(exist([path_out  '/noddi_fibredirs_zvec.nii.gz']))
    SaveParamsAsNIfTI([path_out 'FittedParams.mat'], [path_out '/NODDI_brain.mat'],path_mask,[path_out  '/noddi'])
    system(['gzip ' path_out  '/noddi_*']);
end

%Extract brain
%if not(exist([path_dti 'NODDI/dwi_brain_mask.nii']))
%  system(['bet ' path_dti '/diffusion/dwi_ec.nii.gz ' path_dti 'NODDI/dwi_brain.nii -f ' num2str(th_mask) ' -m']);
%system(['gunzip ' path_dti 'NODDI/*.nii.gz']); RAFA CHANGE 28 Sep
%2018
% end

end
