% Batch script: Extracts networks from grey matter segmentations.
%	Network analyses is done with other scripts.
%
% Depends on:
% - the matlab nifti toolbox, download from: www/mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
% - the output created with the 'create_cube_template.m script'.
% - SPM5 or SPM8 imcalc function
% - the functions that live in the "ALl_network_scripts" dir:
%	- determine_rois_with_minimum_nz : Determines which template extracts networks of minimum size.
%	- create_rrois : Permutes all the values in the scan.
%	- fast_cross_correlation: Computes the correlation matrices
%
% PLEASE ADJUST the following lines:
% - line 43: add the path to the directory where you want to store the results
% - line 46: add the full path to the directory were All_network_scripts/functions/ live.
% - line 49: add the full path + file name of the txt file that contains the dir+names of all the scans (1 line per scan)
% - line 52: add the full path of the directory were the resliced images need to be written to.
% - line 55: add the full path of the directory where the spm canonical brain lives.
% - line 58: add the full path of the directory where /bl_ind directory lives, this directory contains the cube templates (output from 'create_cube_template.m')
%
%
%
% Output (stored in the subject directory unless specified otherwise):
% - iso2mm_s (subject number) .img : resliced images (this is stored in designated directory)
% - creates a directory for each subject (1:n).
% - Sa = 3D volume that contains the MRI data in a matrix form
% - Va = header file that contains the scan info
% - nz = number of cubes (i.e., size of the network)
% - nancount = number of cubes that have standard deviation of 0. (these are excluded from further calculations)
% - off_set = the template used to extract the minimum number of cubes.
% - bind.m (in single precision): this file contains the indices of the cubes that contain grey matter values
% - rois.m and rrois.m (in single precision): these files contain the cubes
% - lookup.m and rlookup.m : provide the link between the cubes from rois and rrois and the original scans (bind). These files are needed later when results are written in images (e.g., the degree or clustering values of the cubes).
% - rotcorr and rrcorr (in single precision) are the correlation matrices maximised for with reflection over all angles and rotation with multiples of 45degrees.
% - th = threshold to binarise the matrices: corresponds to the correlation value where in the random image
% - fp = percentage of positive random correlations
% - sp = sparsity of the matrix with threshold p_corrected = 0.05
%
% Author: Betty Tijms, 2011, version 12.08.2013
% -------------------------------------------------------------------------------------------------------------------------------

%%%-----------------------------%%%
%% ADJUSTED FOR USE ON NCA GRID  %%
%%	longitudinal		 %%
%%	version 2016/12/2	 %%
%%	E Dicks			 %%
%%%-----------------------------%%%

%%%
% 0) extracts networks
% 1) warp AAL to subject space
% 2) reslice AAL atlas
% 3) batch AAL cube match
% 4) compute the graph measures
% 5) local AAL volume
% 6) local measures
%%%

%%---------- DONE GRID: make sure that you save everything where it's normally saved (look up in Betty's org script)
%%---------- you need to specify this with the .script

% Make sure workingspace is empty
clear all

%%---------- get (and add) all the paths that you need

% addpath to all the folders/functions needed
SPMpath='eeeee' 		% fill in with sed
addpath(SPMpath)

NiftiToolbox='xxxxx' 		% fill in with sed
addpath(NiftiToolbox)

AllNetworkScripts='yyyyy'	% fill in with sed
addpath(strcat(AllNetworkScripts,'/functions'))

cat12Toolbox='wwwww'		% fill in with sed
% copy cat12 folder to spm functions folder
copyfile(cat12Toolbox,strcat(SPMpath,'/toolbox/cat12/'))

% get the current directory (this is where everything is stored on the cluster)
headdir='%%%%%'			% fill in with sed
disp(['headdir = ' headdir])

%%---------- get all the scans that you need

% get the grey matter segmentation and the T1 scan (which was co-registered to the median template in case of longitudinal)
c1_scan=strcat(headdir,'#####')		% grey matter
c2_scan=strcat(headdir,'jjjjj')		% white matter
c3_scan=strcat(headdir,'kkkkk')		% CSF
t1_scan=strcat(headdir,'aaaaa')		% co-registered T1

% get the AAL atlas that you later need for the normalization step
AAL_Atlas='zzzzz'

% get the inverse deformation fields for this subject for the normalization step
this_iDF='qqqqq'

% get the subject identifier
subject_nii='#####';
expression='ADNI_\w*';
subject_ID=char(regexp(subject_nii,expression,'match'));
subject_ID=subject_ID(1:15) % get subjectID (adni format ADNI_XXX_S_XXXX)

% as you have many scans per subject, add I_ID to subject identifier
expression='_I\w*.nii';
end_nii=char(regexp(subject_nii,expression,'match'));
I_ID=end_nii(2:end-4)			%%% !!! adjust for batch02 (_resl.nii)

% PATH where the canonical SPM image "avg305T1.niiÃÂ´ can be found --> this is used to reslice the images
P1=strcat(SPMpath,'/canonical/avg305T1.nii')

bl_dir=strcat(AllNetworkScripts,'/bl_ind/')

% Get content of all_dirs.txt files ( this file contains all the dirs of the cube template for all possible off set values)
CN_a2=textread(strcat(bl_dir, 'all_dirs.txt'),'%s');

%%----------

% number of dimensions
n=3;
s=n^3;


% Extract network. Takes ~25 minutes per scan.


% make a copy of the grey matter segmentation in the current (subject's) dir
copyfile(c1_scan, 'temp_grey.nii')


%% Next: Make sure that scan origin matches MNI space & reslice the scan to 2x2x2 mm isotropic voxels to reduce amount of data.
coreg_est = spm_coreg(P1,t1_scan);
M = inv(spm_matrix(coreg_est));
MM = spm_get_space('temp_grey.nii');
spm_get_space('temp_grey.nii',M*MM);

% save the reorientation parameters --> so we can use it again for e.g., atlasses
save coreg_est.mat coreg_est


%%----------
% Now reslice
%P = strvcat(P1,'temp_grey.nii');
%Q = strcat('iso2mm_s_',subject_ID,'_', I_ID, '.nii');
%f = 'i2';
%flags = {[],[],[],[]};	% default values for imcalc
%R = spm_imcalc_ui(P,Q,f,flags);

%%---------- reslicing (s.a.) changed so that batch editor is used instead of spm_imcalc_ui
% startup spm batch

spm_jobman('initcfg')

disp(['SPMpath = ' SPMpath])
disp(['canonical SPM img = ' P1])
disp(['running reslicing of grey matter segm with canonical SPM'])

clear matlabbatch

matlabbatch{1}.spm.util.imcalc.input = {	strcat(P1,',1'),
						strcat('temp_grey.nii',',1')
					};
matlabbatch{1}.spm.util.imcalc.output = strcat('iso2mm_s_',subject_ID,'_', I_ID, '.nii');
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 0;	% interpolation is 0=nearest neighbour
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;


spm_jobman('run',matlabbatch);

disp(['reslicing finished'])
%%----------------------%%


%close the figure window
close

% remove the temporary grey matter scan
delete('temp_grey.nii')

%% Now extract Sa and Va --> Va contains all the info from the .hrd file, Sa is the actual image, it contains the grey matter intensity values.
Va=spm_vol(strcat('iso2mm_s_', subject_ID,'_',I_ID, '.nii'));
%Va=spm_vol(c1_scan);
Sa=spm_read_vols(Va);

% Save them in the current directory
save Va.mat Va
save Sa.mat Sa

% clear variables that aren't needed anymore
%clear P Q R f flags


%% Get the off_set bl_ind (this corresponds to the indices that make up the 3d cubes)  with the minimum number if cubes (min. nz).
%% function adjusted for use one grid (only change is adjustment of directories for saving and loading bind.mat)
[nz, nan_count, off_set] = adj_determine_rois_with_minimumNZ(CN_a2, bl_dir, n, Sa)

% Store nz.m : the number of cubes, this is the size of the network
save nz.mat nz

% nan_count = number of cubes that have a variance of 0, these are excluded because cannot compute correlation coefficient for these cubes.
save nan_count.mat nan_count

% off_set indicates which specific template was used to get the cubes.
save off_set.mat off_set

% Get bind and store bind too. Bind contains the indices of the cubes, so we can efficiently do computations later. It is a long vector of which every 27 consecutive voxels are a cube.
% [output of adj_determine_rois_with_minimumNZ.m]
load bind.m

% Convert to single, for memory reasons
bind=single(bind);
disp(['deleting any previous bind.mat'])
delete bind.mat
save bind.mat bind

% Now create:
% - the rois: This is a matrix of which each column corresponds to a cube, we will compute use this to compute the correlations
% - lookup table --> to lookup the cubes that correspond to the correlations.

lb=length(bind); % End point for loop
col=1;		% iteration counter

rois=zeros(s,nz, 'single');	% Create variable to store the rois (i.e., cubes)
lookup=zeros(s,nz, 'single');	% Create variable to store the lookup table --> this table links the cubes to the indices in the original iso2mm image.

% The next loop goes through bind for indices of voxels that belong to each ROI (i.e. cube)
% lb is the last voxel that belongs to a roi
%lookup is lookup table to go from corr index to bind to Sa

for i=1:s:lb
	rois(:,col)=Sa(bind(i:(i+(s-1))));
	lookup(:,col)=i:(i+(s-1));
	col=col+1;
end


% Save the rois and lookup table
save rois.mat rois

% look up table --> to go from corr index to bind to Sa
save lookup.mat lookup

%clear unneeded variables
%clear lookup lb

%% Randomise ROIS: Create a 'random brain' to estimate the threshold with for later stages
[rrois, rlookup]= create_rrois (rois, n, Sa, Va, off_set, bind, bl_dir, nz);

% save rrois and rlookup
save rrois.mat rrois
save rlookup.mat rlookup

% Remove all variables that take space and aren't needed anymore
%clear bind lookup rlookup Sa Va

% Set the following variable to 2 when correlation is maximised for rotation with angle multiples of 45degrees.
forty=2;

[rotcorr, rrcorr] = fast_cross_correlation(rois, rrois, n,forty);

%%% only save the upper triangle of rotcorr.mat and rrcorr.mat (saves disk space)
triu_rotcorr=triu(rotcorr,1);
triu_rrcorr=triu(rrcorr,1);

% Save it
save rotcorr.mat rotcorr % this won't be archived
save triu_rotcorr.mat triu_rotcorr
save triu_rrcorr.mat triu_rrcorr

%% Now get the threshold and save it
tth= 95;
[th, fp, sp] = auto_threshold(rotcorr, rrcorr, nz, tth);

% Add this threshold to all_th
%all_th(im,:)=[th,fp,sp];
%save this and get later
save th.mat th
save fp.mat fp
save sp.mat sp

% Clear all variables - do not clear
%clear rotcorr rrcorr th fp sp

disp(['Network extraction finished'])

%%----------------------%%
% warp AAL to subject space
%%----------------------%%

% get the AAL atlas, make a temp copy and rename using S_ID + I_ID
subject_AAL=strcat(subject_ID,'_',I_ID,'_Atlas.nii')
copyfile(AAL_Atlas, subject_AAL)

% get the subject specific inverse deformation field parameters
%%%% do that above, you have to specify that in the jobs file and fill in with sed
this_iDF;

%%% adjusted again, use spm12 instead of cat12, get bbox first
[b_box,b_vox]=spm_get_bbox(this_iDF);

%%% start the SPM normalisation batch

spm_jobman('initcfg')

disp(['SPMpath = ' SPMpath])

headdir='%%%%%' % fill in with sed
disp(['headdir = ' headdir])

disp(['this_iDF = ' this_iDF])

disp(['running SPM12 normalization on ' this_iDF])

clear matlabbatch

matlabbatch{1}.spm.spatial.normalise.write.subj(1).def = cellstr(this_iDF);
matlabbatch{1}.spm.spatial.normalise.write.subj(1).resample = cellstr(strcat(subject_AAL));
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = b_box;
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = b_vox;
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 0;

spm_jobman('run',matlabbatch);

disp(['Normalization to AAL finished'])



%%% old: cat12 toolbox to warp aal
%%matlabbatch{1}.spm.tools.cat.tools.defs2.field = cellstr(this_iDF);
%%matlabbatch{1}.spm.tools.cat.tools.defs2.images = {cellstr(subject_AAL)};
%%matlabbatch{1}.spm.tools.cat.tools.defs2.interp = 0;		% interpolation is nearest neighbour
%%matlabbatch{1}.spm.tools.cat.tools.defs2.modulate = 0;

%%% old: spm12 w/o bbox to warp aal
%%matlabbatch{1}.spm.spatial.normalise.write.subj(1).def = cellstr(this_iDF);
%%matlabbatch{1}.spm.spatial.normalise.write.subj(1).resample = cellstr(strcat(subject_AAL));
%%matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [NaN NaN NaN
%%                                                          NaN NaN NaN];
%%matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [NaN NaN NaN];
%%matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 0;



%% Make sure it has the same orientation as the original scan

%%----------------------
%P = strvcat(c1_scan,strcat('w',subject_AAL));
%Q = strcat('reor_','w', subject_AAL);
%f = 'i2';
%flags = {[],[],0,[]};	% wild guess of betty to set to nearest neighbour interpolation
%R = spm_imcalc_ui(P,Q,f,flags);
%%close the figure window
%close
%%----------------------
% startup spm batch


spm_jobman('initcfg')

disp(['SPMpath = ' SPMpath])
disp(['grey matter seg = ' c1_scan])
disp(['running reslicing of grey matter segm with canonical SPM'])

clear matlabbatch

matlabbatch{1}.spm.util.imcalc.input = {	strcat(c1_scan,',1'),
						strcat('w',subject_AAL,',1')
					};
matlabbatch{1}.spm.util.imcalc.output = strcat('reor_w',subject_AAL);
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 0;	% interpolation is nearest neighbour
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;


spm_jobman('run',matlabbatch);

disp(['reorienting of AAL to c1 scan finished'])

%%----------------------


%close the figure window
close


%%----------------------%%
% orig reslice_AAL_atlas.m
%%----------------------%%


% PATH where the canonical SPM image "avg305T1.niiÂ´ can be found --> this is used to reslice the images
P1;	% already defined above

%atlas_dir = '/haso/users/bettytij/CODA/data/Atlassed/SPM12_TMP/';
% FILL IN THE FULL PATH of the directory where the resliced images should live.
%reslice_dir = '/haso/users/bettytij/CODA/GM_graphs/reslice/';


% Get this scan and do the following loop to threshold and then reslice it
this_scan=strcat('reor_w',subject_AAL);
disp(['reoriented scan warped to AAL = ' this_scan])

% make a copy of the scan in the subject dir
copyfile(this_scan, 'temp_grey.nii')


%% Next: Make sure that scan origin matches MNI space & reslice the scan to 2x2x2 mm isotropic voxels to reduce amount of data.
load coreg_est.mat
M = inv(spm_matrix(coreg_est));
MM = spm_get_space('temp_grey.nii');
spm_get_space('temp_grey.nii',M*MM);

% Bouw een check in om te controleren dat origin hetzelfde is in de scans: Geef waarschuwing als dat niet zo is.


% Now reslice
%P = strvcat(P1,'temp_grey.nii');
%Q = strcat('iso2mm_atlas_', subject_ID, '_',I_ID, '.nii');
%f = 'i2';
%flags = {[],[],[],[]};
%R = spm_imcalc_ui(P,Q,f,flags);

%%----------------------
%% reslicing (s.a.) changed so that batch editor is used instead of spm_imcalc_ui
% startup spm batch


spm_jobman('initcfg')

disp(['SPMpath = ' SPMpath])
disp(['running reslicing of reor scan warped to AAL with canonical SPM'])

clear matlabbatch

matlabbatch{1}.spm.util.imcalc.input = {	strcat(P1,',1'),
						strcat('temp_grey.nii,1')
					};
matlabbatch{1}.spm.util.imcalc.output = strcat('iso2mm_atlas_', subject_ID, '_',I_ID, '.nii');
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 0;	% interpolation is nearest neighbour
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;


spm_jobman('run',matlabbatch);

disp(['reslicing of reor scan warped to AAL with canonical SPM finished'])

%%----------------------


%close the figure window
close

% remove the temporary grey matter scan
delete('temp_grey.nii')

%% Now extract Sa and Va --> Va contains all the info from the .hrd file, Sa is the actual image, it contains the grey matter intensity values.
aVa=spm_vol(strcat('iso2mm_atlas_',subject_ID, '_',I_ID,'.nii'));
Va=spm_vol(this_scan);
aSa=spm_read_vols(aVa);

% Mask with the resliced grey matter image
%P = strvcat(strcat('iso2mm_s_', subject_ID, '_',I_ID,'.nii'),aVa.fname);
%Q = strcat('iso2mm_atlas_',subject_ID, '_',I_ID,'.nii');
%f = 'i2.*(i1>0)';
%flags = {[],[],[],[]};
%R = spm_imcalc_ui(P,Q,f,flags);

%%----------------------
%%---- masking (s.a.) changed so that batch editor is used instead of spm_imcalc_ui
% startup spm batch


spm_jobman('initcfg')

disp(['SPMpath = ' SPMpath])
disp(['running masking with resliced grey matter seg'])

clear matlabbatch

matlabbatch{1}.spm.util.imcalc.input = {	strcat('iso2mm_s_', subject_ID, '_',I_ID,'.nii',',1'),
						aVa.fname
					};
matlabbatch{1}.spm.util.imcalc.output = strcat('iso2mm_atlas_', subject_ID, '_',I_ID, '.nii');
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'i2.*(i1>0)';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 0;	% interpolation is nearest neighbour
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;


spm_jobman('run',matlabbatch);

disp(['masking with resliced grey matter seg finished'])
%%----------------------


%close the figure window
close


% Save them in the current directory
aVa=spm_vol(strcat('iso2mm_atlas_',subject_ID, '_',I_ID,'.nii'));
%Va=spm_vol(this_scan);
aSa=spm_read_vols(aVa);

save aVa.mat aVa
save aSa.mat aSa

disp(['Reslice AAL atlas finished'])


%%----------------------%%
% batch_AAL_cube_match.m
%%----------------------%%
% Link cubes to AAL mask --> to be able to extract % hubs e.g.


% Get the mask
%taSa = load_nii(strcat(reslice_dir, 'iso2mm_atlas_', char(all_ids(im)),'.nii' ));
load aSa.mat
%aSa=aSa.img;
aSa = round(aSa);

% Load other data necessary from this subject
load Va.mat
load bind.mat
load lookup.mat
load nz.mat

% Label the voxels in a roi
label_rois = zeros(size(lookup));

s = 27;
lb=length(bind); % End point for loop
col=1;		% iteration counter

for i=1:s:lb
	label_rois(:,col)=aSa(bind(i:(i+(s-1))));
	col=col+1;
end

% Remove cubes that are not labelled --> perhaps redo network statistics with this subset ??
aal_rois_ind = find(sum(label_rois)~=0);
aal_rois_labels = label_rois(:,aal_rois_ind);
aal_rois_labels (aal_rois_labels ==0)=NaN;
aal_rois_labels = mode(aal_rois_labels);

% Save indices of labeled rois --> needed because we only want the stats from this subset.
save aal_rois_ind.mat aal_rois_ind
save aal_rois_labels.mat aal_rois_labels

disp(['AAL cube match finished'])

%%----------------------%%
% batch_sw_networks_v20152909.m
%%----------------------%%

%% Small World Analyses - Batch script to compute graph properties
%% Adjusted on 20140203 --> auto_threshold function is simplified using Matlabs internal percentile function to obtain threshold to binarise that gives exactly 5% spurious connection in the random corrlation matrix.

% Please set the number of random graphs to compute in order to obtain the small world property. Twnety is enough to get stable results. For testing set to 2 (for time management issues).
nrand = 5;

%%% No adjustments necessary below this line %%%

%loop through the dirs and create
%	1. binarized matrix based on th that gives a 5% chance that false positive edges are included
%	2. degree
%	3. cluster coefficient
%	4. R and D distance matrices: Based on this we can compute the path length and betweenness centrality value
%	5. average characteristic pathlength per node in all_L


%th=th_all(im);
load th.mat -mat
load rotcorr.mat -mat

% Threshold & binarize
bin_all=rotcorr>th;
degree=sum(bin_all);

% Save so this doesn't need to be computed again
save degree.mat degree
save bin_all.mat bin_all

% hoeveel rijen zitten er in bin_all? == het aantal kubussen
nz=size(bin_all,1);

bin = single(rotcorr >= th);

% If any of the nodes becomes disconnected than break
if any(degree == 0)	% a disconnected node

	discon_th = th;
	save discon_th.mat -mat
	echo_warning = strcat('this scan (subject ID: ', subject_ID, ', Image ID: ', I_ID,') has disconnected nodes')

	% Deze break moet eruit --> moet een variabele 0 1 worden om wel niet volgende analyses uit te rekenen --> en dus de disconnected node bijv te verwijderen.

else
	% Get the clustering coefficient
	C_i = clustering_coef_bu(bin);

	save C_i.mat C_i

	% Get the betweenness centrality & path length in one go
	[BC L] = betweenness_bin(bin);

	L=mean(L);
	save L.mat L
	save BC.mat BC

	% Now determine gamma & lambda with 5 random graphs (should be enough)
	rand_sw = zeros(nrand, 2, 'single');

	for j = 1:nrand

		% Make a random version of bin
		rbin=makerandCIJdegreesfixed(degree',degree');

		% compute clustering
		rC_i = clustering_coef_bu(rbin);
		rand_sw(j,1)=mean(rC_i);

		% Compute path length & BC
		%[rR rD] = reachdist(rbin);	% This doesn work for the random bin matrices anymore --> use alternative reachdist_alt
		[rR rD] = reachdist_alt(rbin);
		rand_sw(j, 2) = mean(rD(:));
		%rand_sw(j,3)= mean(BC);
		clear rbin
	end

	save rand_sw.mat rand_sw

end


disp(['Batch sw networks finished'])

%%% it should definitely work until here (e.g. .mats are there ..and contains something)

%%----------------------%%
% orig compute_local_aal_volume_20160921.m
%%----------------------%%

% 1. 2 input files : de personal atlas & de c1 file.

% Initialise AAL_volumes matrix
% Initialise voxel dimension matrix
%%% you cannot store numbers and string (i.e. subject ID, I_ID) in a matrix, use cell instead
% one cell per subject is stored now, later you need to concatenate the txt files created (outside of the grid)
aal_vols = cell(1,91);	%numimages,90);
m_aal_vols = cell(1,91);%numimages,90);

masked1_atl_aal_vols= cell(1,91);%numimages,90); % gm > wm & gm >csf & gm > none);
masked2_atl_aal_vols= cell(1,91);%numimages,90); %gm > 0

voxdim = zeros(1,4);

%% [changed var name 'Va' to read in the volumes to 'Van', since var 'Va' is already used in extract networks script]
Van=spm_vol(strcat('reor_w',subject_AAL));
t_atlas = spm_read_vols(Van);

Van=spm_vol(c1_scan);
t_c1 = spm_read_vols(Van);

Van=spm_vol(c2_scan);
t_c2 = spm_read_vols(Van);

Van=spm_vol(c3_scan);
t_c3 = spm_read_vols(Van);

% First make sure the atlas labels are discrete
t_atlas= round(t_atlas);

% maakt het nog uit als je masked? Nee: Correlatie is bijna 1.
None = 1 - (t_c1 + t_c2 + t_c3);
indGM = find((t_c1> t_c2) & (t_c1> t_c3) & (t_c1> None));

mt_c1 = t_c1.* (  (t_c1> t_c2) & (t_c1> t_c3) & (t_c1> None) );

% hoe correleert het dan met de manier van ibaspm (= gemasked aal & sum voxels)
mt_atlas = t_atlas;
mt_atlas = t_atlas.* (  (t_c1> t_c2) & (t_c1> t_c3) & (t_c1> None) );

%%% load_nii is giving an error ('non-orthogonal rotation or shearing found..'); using load_untouch_nii instead.
mtatlas = load_untouch_nii(strcat('reor_w',subject_AAL));
mtatlas.img=mt_atlas;

%%% don't save masked image, if something is weird for the corr between masked and unmasked aal vols you'll have to come back to this
%save_nii(mtatlas, strcat('masked_reor_w',subject_AAL))

% 2de manier van maskeren; alleen gm > 0 nemen : deze correleerd het hoogste met Ibaspm. Maar alle andere manieren correleren ook met > .9
%mt_atlas2 = t_atlas.img .* ( t_c1.img > 0 );

% Compute voxel size: Store this to double check if all went well
voxdim(1,:) = mtatlas.hdr.dime.pixdim(1:4);
%voxvol = prod(t_c1.hdr.dime.pixdim(2:4))/100^3; % volume of a voxel, in litres;
voxvol = prod(mtatlas.hdr.dime.pixdim(2:4))/1000; % volume of a voxel in cm3 of cc

% loop through the atlas labels & find corresponding voxels
n_labels= length(unique(t_atlas(:)))-1;

for(i = 1:n_labels)
	% find these voxels in the atlas image
	tind = find(t_atlas==i);

	% sum the grey matter of these voxels in the c1 image
	t_gm = sum(t_c1(tind));

	% compute the volume
	aal_vols{1,(i+1)}= t_gm *voxvol;
	m_aal_vols{1,(i+1)}= sum(mt_c1(tind)) *voxvol;
  	%masked1_atl_aal_vols{1,i}= length(find(mt_atlas.img==i)) *voxvol;
	%masked2_atl_aal_vols{1,i}= length(find(mt_atlas2==i)) *voxvol;

end

%%% you cannot store numbers and string in a matrix, use cell instead
aal_vols{1,1}=strcat(subject_ID,'_',I_ID);
m_aal_vols{1,1}=strcat(subject_ID,'_',I_ID);

save aal_vols.mat aal_vols
save m_aal_vols.mat m_aal_vols

%%% dlmwrite does not work for cells, you have append with fprintf in txt file
%dlmwrite('aal_vols.txt',aal_vols,'delimiter','\t','precision',5)
%dlmwrite('masked_aal_vols.txt',m_aal_vols,'delimiter','\t','precision',5)
fileID1=fopen(strcat(subject_ID, '_',I_ID,'_aal_vols.txt'),'a')
fileID2=fopen(strcat(subject_ID, '_',I_ID,'_masked_aal_vols.txt'),'a')

% print subject ID, image ID to first column in txt file
fprintf(fileID1,'%s\t',aal_vols{:,1});
fprintf(fileID2,'%s\t',m_aal_vols{:,1});

% print the vols to the rest of the columns (i.e. 2:end)
for jk=2:size(aal_vols,2)
	fprintf(fileID1,'%f\t',aal_vols{:,jk});
	fprintf(fileID2,'%f\t',m_aal_vols{:,jk});
end
fprintf(fileID1,'\n')
fprintf(fileID2,'\n')



% Maakt niet heel veel uit, alleen als je aal masker maskeert met gm >0 dan krijg je veel grotere waarden, dus dat is fout.

disp(['Compute local AAL volume finished'])

%%----------------------%%
%% extract_AAL_properties.m -> prob better to do on lnx machines? nope
%%----------------------%%
% Extract AAL properties

% Go through directories and get:
% - atlassed ROIs
% - the rot_bin_all_degree.m
% - rot_c_i.m -mat
% - BC.m -mat
% - rotD.m -mat --> get the mean for the nodal rotD.

% Save the mean data of this subject in a AAL based matrix that we can further test with kruskal wallis tests
% you have to save this in a cell (matrix cannot store numbers and strings)
aal_c = cell(1, 91);

aal_d =cell(1, 91);

aal_L = cell(1, 91);

aal_BC = cell(1, 91);

%aal_d_hub = cell(1,91);

% Get the labelled rois
load aal_rois_labels.mat

% Get the indices of rois that received a label
load aal_rois_ind.mat

% Load other data necessary from this subject
load C_i.mat
load degree.mat
load L.mat
load BC.mat

% hub threshold: top 20%
%d_hub = prctile(degree,80);

% Select only the labeled data
rot_c_i = C_i(aal_rois_ind);
rot_bin_all_degree = degree(aal_rois_ind);
rotD = L(aal_rois_ind);
BC = BC(aal_rois_ind);

% Add the I_ID to the first column
aal_c{1,1}=strcat(subject_ID,'_',I_ID);
aal_d{1,1}=strcat(subject_ID,'_',I_ID);
aal_L{1,1}=strcat(subject_ID,'_',I_ID);
aal_BC{1,1}=strcat(subject_ID,'_',I_ID);
aal_d_hub{1,1}=strcat(subject_ID,'_',I_ID);

% Now go through the rois and store the mean of the measure in this
for i = 1:90
	% Get the indices of this AAL
	ai = find(aal_rois_labels ==i);

	% Check if this region exists in this individual --> otherwise fill in 0
	if isempty(ai)
		aal_c{1,(i+1)} = 0;
		aal_d{1,(i+1)} = 0;
		aal_L{1,(i+1)} = 0;
		aal_BC{1,(i+1)} = 0;
		%aal_d_hub{1,(i+1)}=0;


	else
		aal_c{1,(i+1)} = mean(rot_c_i(ai));
		aal_d{1,(i+1)} = mean(rot_bin_all_degree(ai));
		aal_L{1,(i+1)}= mean(rotD(ai));
		aal_BC{1,(i+1)} = mean(BC(ai));
		%aal_d_hub{1,(i+1)} = sum(rot_bin_all_degree(ai)>d_hub);
	end
end

%
save aal_c.mat aal_c
save aal_d.mat aal_d
save aal_L.mat aal_L
save aal_BC.mat aal_BC
%save aal_d_hub.mat aal_d_hub


% For R
%%%% dlmwrite does not work for cells, you have append with fprintf in txt file
%dlmwrite('aal_c.txt', aal_c, 'precision' , '%.33f');
%dlmwrite('aal_d.txt', aal_d, 'precision' , '%.33f');
%dlmwrite('aal_L.txt', aal_L, 'precision' , '%.33f');
%dlmwrite('aal_BC.txt', aal_BC, 'precision' , '%.33f');
%dlmwrite('aal_d_hub.txt', aal_d_hub, 'precision' , '%.33f');

fileID3=fopen(strcat(subject_ID, '_',I_ID,'_aal_c.txt'),'a');
fileID4=fopen(strcat(subject_ID, '_',I_ID,'_aal_d.txt'),'a');
fileID5=fopen(strcat(subject_ID, '_',I_ID,'_aal_L.txt'),'a');
fileID6=fopen(strcat(subject_ID, '_',I_ID,'_aal_BC.txt'),'a');


% print subject ID, imageID ID to first column in txt file
fprintf(fileID3,'%s\t',aal_c{:,1});
fprintf(fileID4,'%s\t',aal_d{:,1});
fprintf(fileID5,'%s\t',aal_L{:,1});
fprintf(fileID6,'%s\t',aal_BC{:,1});

% print the vols to the rest of the columns (i.e. 2:end)
for jk=2:size(aal_vols,2)
	fprintf(fileID3,'%f\t',aal_c{:,jk});
	fprintf(fileID4,'%f\t',aal_d{:,jk});
	fprintf(fileID5,'%f\t',aal_L{:,jk});
	fprintf(fileID6,'%f\t',aal_BC{:,jk});
end
fprintf(fileID3,'\n')
fprintf(fileID4,'\n')
fprintf(fileID5,'\n')
fprintf(fileID6,'\n')

disp(['Extract local AAL properties finished'])




%%----------------------%%
%% getResults.m
%%----------------------%%
% open file to print the global results to

globalNW=fopen(strcat(subject_ID, '_',I_ID,'_global_results.txt'),'a');
fprintf(globalNW,'%s\t',strcat(subject_ID,'_',I_ID));

% get the network size (: size BC.mat, e.g.)
% if network extraction failed, BC.mat does not exist
% skip those, but keep track of them!!
try
	load('BC.mat')
catch
	disp(strcat('Network extraction failed for',{' '},subject_ID,', imgID:',I_ID))
	continue
end


% see if there are any disconnected nodes
try
	load('discon_th.mat')
	discon_nodes=1;
catch
	disp(strcat('No disconnected nodes for',{' '},subject_ID,', imgID:',I_ID))
	discon_nodes=0;
	continue
end


% load local data
load('aal_vols.mat');
load('m_aal_vols')


% average across AAL areas
% for some 0 values in local results (0 values double precis, floats single precis)
% aal warping failed for those


%%% convert all values in cell array to single precision
aal_vols_single=cellfun(@single,aal_vols,'un',0);
m_aal_vols_single=cellfun(@single,m_aal_vols,'un',0);

mean_degree=mean(degree);
condens=sp;
mean_clustering=mean(C_i);
mean_pathLength=mean(L);
mean_BC=mean(BC);
sum_vols=sum(cell2mat(aal_vols_single(:,2:91)),2);
sum_m_vols=sum(cell2mat(m_aal_vols_single(:,2:91)),2);


% print size to results file
nnodes=size(BC,2);
fprintf(globalNW,'%d\t',nnodes);

% load rand_sw.mat, get C_rand, L_rand
load('rand_sw.mat');
C_rand=mean(rand_sw(:,1),1);
L_rand=mean(rand_sw(:,2),1);

% compute gamma, lambda, sw
gamma=mean_clustering/C_rand;
lambda=mean_pathLength/L_rand;
sw=gamma/lambda;

% save results to global results txt file for this subj
fprintf(globalNW,'%f\t',mean_degree,condens,mean_clustering,mean_pathLength,mean_BC,gamma,lambda,sw,sum_vols,sum_m_vols,discon_nodes);




%%-------------------------------------------------------%%
%%%%	betty's original scripts 			%%%%
%%-------------------------------------------------------%%
%%----------------------%%
% batch_extract_networks_v20150902_BMT.m
%%----------------------%%
%cd /usr/local/MATLAB/R2011a/bin/
%matlab -nodesktop -singleCompThread
%
% Make sure workingspace is empty
%clear all
%
% --- ADJUST FOLLOWING ----%
% Go to the directory where you want to store your output (i.e., networks).
%cd /haso/users/bettytij/CODA/GM_graphs/Results
%
%%% DONE GRID: get name of grey matter segmentation
% FILL IN THE FILE NAME with full path that contains the text file with all the grey matter segmentations
%[CN_a1]= textread('/haso/users/bettytij/CODA/GM_graphs/scripts/manual_scannames.txt','%s');
%
%%% DONE GRID: get name of co-registered T1 scan
% FILL IN THE FILE NAME with original T1 images - needed for co-registration
%[CN_a3]= textread('/haso/users/bettytij/CODA/GM_graphs/scripts/manual_T1names.txt','%s');
%
%%% DONE GRID: get subject name
% Give a list with the subject identifiers
%[ids] = textread('/haso/users/bettytij/CODA/GM_graphs/scripts/manual_ids.txt','%s');
%
%
%%%% - Below we do not need to adjust anything ---
%
%%% DONE GRID: don't create separate dirs for the subjects, you copy the data where you want them later with the main grid script
% FILL IN THE FULL PATH of the directory where the resliced images should live.
%reslice_dir = '/haso/users/bettytij/CODA/GM_graphs/data/reslice/';
%
%
%%% DONE GRID: adjust to location on GRID
% Add the path to the Nifti toolbox (see read me file for download link)
%addpath /home/btijms/Staging/DCCoda_Ellen/NIFTI_20121012
%
%%% DONE GRID: adjust to SPM8 location GRID
% PATH where the canonical SPM image "avg305T1.niiÃÂ´ can be found --> this is used to reslice the images
%P1= '/home/nas01/bettytij/spm8/canonical/avg305T1.nii';
%
%%% DONE GRID: adjust to location on GRID, provided in express file CommonDir
% Please provide path to the folder All_network_scripts
%all_network_scripts_path ='/home/nas01/bettytij/1_Latest_scripts/All_network_scripts/';
%
%%% DONE GRID
%% -----Finished with the adjustments ---%
%bl_dir = strcat(all_network_scripts_path, 'bl_ind/');
%
%%% DONE GRID
% add path to the functions in All_network_scripts folder
%addpath(strcat(all_network_scripts_path,'/functions'))
%
%%% DONE GRID
% Get content of all_dirs.txt files ( this file contains all the dirs of the cube template for all possible off set values)
%CN_a2 =textread(strcat(bl_dir, 'all_dirs.txt'),'%s');
%
%%% DONE GRID: adjust loop, you do not need it
% end of loop
%numimages=size(CN_a1,1);
%
% number of dimensions
%n=3;
%s=n^3;
%
%
% Loop through all the grey matter segmentations listed in CN_a1 and extract network. Takes ~25 minutes per scan.
%
% Gedaan: Signa 3t, Sonata, impact
% to do: signa1.5t, avanto,  petmr, titan, vision
%
% NB Dit moet opnieuw voor de Sonata en Vision manually set AC scans.
%
% reason crash, im =
%for im=59:numimages
%	% Get this scan and do the following loop to threshold and then reslice it
%	this_scan=char(CN_a1(im));
%	t1_scan = char(CN_a3(im));
%
%%% DONE GRID: don't create separate dirs for the subjects, you copy the data where you want them later with the main grid script
% make the directory for this subject
%mkdir(strcat(char(ids(im))), '/data/rotation/')
%mkdir(strcat(char(ids(im))), '/images/')
%
%fileattrib(strcat(char(ids(im))),'+w','g')
%fileattrib(strcat(char(ids(im)), '/data/rotation/'),'+w','g')
%fileattrib(strcat(char(ids(im)), '/images/'),'+w','g')
%
% Go to this directory
%cd(strcat(char(ids(im))))
%
%%%% DONE GRID
% make a copy of the T1 scan in the subject dir
%copyfile(this_scan, 'temp_grey.nii')
%
%%% DONE GRID
%% Next: Make sure that scan origin matches MNI space & reslice the scan to 2x2x2 mm isotropic voxels to reduce amount of data.
%coreg_est = spm_coreg(P1,t1_scan);
%M = inv(spm_matrix(coreg_est));
%MM = spm_get_space('temp_grey.nii');
%spm_get_space('temp_grey.nii',M*MM);
%
%%% DONE GRID
% save the reorientation parameters --> so we can use it again for e.g., atlasses
%save coreg_est.mat coreg_est
%
%
%
%%% DONE GRID
%% Now reslice
%P = strvcat(P1,'temp_grey.nii');
%Q = strcat(reslice_dir,'/iso2mm_s', char(ids(im)), '.nii');
%f = 'i2';
%flags = {[],[],[],[]};
%R = spm_imcalc_ui(P,Q,f,flags);
%
%%close the figure window
%close
%
%% remove the temporary grey matter scan
%delete('temp_grey.nii')
%
%
%%% DONE GRID
%%% Now extract Sa and Va --> Va contains all the info from the .hrd file, Sa is the actual image, it contains the grey matter intensity values.
%Va=spm_vol(strcat(reslice_dir, '/iso2mm_s', char(ids(im)), '.nii'));
%%Va=spm_vol(this_scan);
%Sa=spm_read_vols(Va);
%
%% Save them in the current directory
%save Va.mat Va
%save Sa.mat Sa
%
%% clear variables that aren't needed anymore
%clear this_scan P Q R f flags
%
%
%%% DONE GRID
%% Get the off_set bl_ind (this corresponds to the indices that make up the 3d cubes)  with the minimum number if cubes (min. nz).
%[nz, nan_count, off_set] = determine_rois_with_minimumNZ(CN_a2, bl_dir, n, Sa);
%
%% Store nz.m : the number of cubes, this is the size of the network
%save data/nz.mat nz
%
%% nan_count = number of cubes that have a variance of 0, these are excluded because cannot compute correlation coefficient for these cubes.
%save data/nan_count.mat nan_count
%
%% off_set indicates which specific template was used to get the cubes.
%save data/off_set.mat off_set
%
%
%%% DONE GRID
%  	% Get bind and store bind too. Bind contains the indices of the cubes, so we can efficiently do computations later. It is a long vector of which every 27 consecutive voxels are a cube.
%  	load data/bind.m
%
%  	% Convert to single, for memory reasons
%  	bind=single(bind);
%  	delete data/bind.mat
%  	save data/bind.mat bind
%
%  	% Now create:
%  	% - the rois: This is a matrix of which each column corresponds to a cube, we will compute use this to compute the correlations
%  	% - lookup table --> to lookup the cubes that correspond to the correlations.
%
%  	lb=length(bind); % End point for loop
%  	col=1;		% iteration counter
%
%  	rois=zeros(s,nz, 'single');	% Create variable to store the rois (i.e., cubes)
%  	lookup=zeros(s,nz, 'single');	% Create variable to store the lookup table --> this table links the cubes to the indices in the original iso2mm image.
%
%  	% The next loop gos through bind for indices of voxels that belong to each ROI (i.e. cube)
%  	% lb is the last voxel that belongs to a roi
%  	%lookup is lookup table to go from corr index to bind to Sa
%
%  	for i=1:s:lb
%  		rois(:,col)=Sa(bind(i:(i+(s-1))));
%  		lookup(:,col)=i:(i+(s-1));
%  		col=col+1;
%  	end
%
%
%  	% Save the rois and lookup table
%  	save data/rois.mat rois
%
%  	% look up table --> to go from corr index to bind to Sa
%  	save data/lookup.mat lookup
%
%  	%clear unneeded variables
%  	clear lookup lb
%
%  	%% Randomise ROIS: Create a 'random brain' to estimate the threshold with for later stages
%  	[rrois, rlookup]= create_rrois (rois, n, Sa, Va, off_set, bind, bl_dir, nz);
%
%  	% save rrois and rlookup
%  	save data/rrois.mat rrois
%  	save data/rlookup.mat rlookup
%
%  	% Remove all variables that take space and aren't needed anymore
%  	clear bind lookup rlookup Sa Va
%
%  	% Set the following variable to 2 when correlation is maximised for rotation with angle multiples of 45degrees.
%  	forty=2;
%
%  	[rotcorr, rrcorr] = fast_cross_correlation(rois, rrois, n,forty);
%
%  	% Save it
%  	save data/rotation/rotcorr.mat rotcorr
%  	save data/rotation/rrcorr.mat rrcorr
%
%  	%% Now get the threshold and save it
%  	tth= 95;
%  	[th, fp, sp] = auto_threshold(rotcorr, rrcorr, nz, tth);
%
%  	% Add this threshold to all_th
%	%all_th(im,:)=[th,fp,sp];
%	%save this and get later
%	save data/th.mat th
%	save data/fp.mat fp
%	save data/sp.mat sp
%
%	% Clear all variables
%	clear rotcorr rrcorr th fp sp
%
%	cd ..
%	im
%
%end
%%----------------------%%
% orig reslice_AAL_atlas.m
%%----------------------%%
%
%
%clear all
%
%cd /haso/users/bettytij/CODA/GM_graphs/Results
%
%addpath /home/nas01/bettytij/NIFTI_20121012
%addpath /home/nas01/bettytij/spm12
%
%[all_ids]=textread('/haso/users/bettytij/CODA/GM_graphs/scripts/all_ids.txt','%s');
%
%% PATH where the canonical SPM image "avg305T1.niiÂ´ can be found --> this is used to reslice the images
%P1= '/home/nas01/bettytij/spm12/canonical/avg305T1.nii';
%
%atlas_dir = '/haso/users/bettytij/CODA/data/Atlassed/SPM12_TMP/';
%% FILL IN THE FULL PATH of the directory where the resliced images should live.
%reslice_dir = '/haso/users/bettytij/CODA/GM_graphs/reslice/';
%
%numimages=size(all_ids,1);
%
%% reason crash, im =
%for im=2:numimages
%	% Get this scan and do the following loop to threshold and then reslice it
%	this_scan=strcat(atlas_dir, 'w', char(all_ids(im)),'_Atlas.nii' );	%char(CN_a1(im));
%
%	% Go to this directory
%	cd(strcat('/haso/users/bettytij/CODA/GM_graphs/Results/', char(all_ids(im))))
%
%	% make atlas directory
%	mkdir atlas
%
%	% make a copy of the T1 scan in the subject dir
%	copyfile(this_scan, 'temp_grey.nii')
%
%
% 	%% Next: Make sure that scan origin matches MNI space & reslice the scan to 2x2x2 mm isotropic voxels to reduce amount of data.
%	load coreg_est.mat
%	M = inv(spm_matrix(coreg_est));
%	MM = spm_get_space('temp_grey.nii');
%	spm_get_space('temp_grey.nii',M*MM);
%
%	% Bouw een check in om te controleren dat origin hetzelfde is in de scans: Geef waarschuwing als dat niet zo is.
%
%
%	% Now reslice
% 	P = strvcat(P1,'temp_grey.nii');
%  	Q = strcat(reslice_dir,'iso2mm_atlas_', char(all_ids(im)), '.nii');
%  	f = 'i2';
%  	flags = {[],[],[],[]};
%  	R = spm_imcalc_ui(P,Q,f,flags);
%
%  	%close the figure window
% 	close
%
%	% remove the temporary grey matter scan
%	delete('temp_grey.nii')
%
%	%% Now extract Sa and Va --> Va contains all the info from the .hrd file, Sa is the actual image, it contains the grey matter intensity values.
%	aVa=spm_vol(strcat(reslice_dir,'iso2mm_atlas_', char(all_ids(im)), '.nii'));
%	Va=spm_vol(this_scan);
%	aSa=spm_read_vols(aVa);
%
%	% Mask with the resliced grey matter image
%	P = strvcat(strcat(reslice_dir,'iso2mm_s', char(all_ids(im)),'.nii'),aVa.fname);
% 	Q = strcat(reslice_dir,'iso2mm_atlas_', char(all_ids(im)), '.nii');
% 	f = 'i2.*(i1>0)';
%  	flags = {[],[],[],[]};
% 	R = spm_imcalc_ui(P,Q,f,flags);
%
%	% Save them in the current directory
%	aVa=spm_vol(strcat(reslice_dir,'iso2mm_atlas_', char(all_ids(im)), '.nii'));
%	%Va=spm_vol(this_scan);
%	aSa=spm_read_vols(aVa);
%
%	save atlas/aVa.mat aVa
%	save atlas/aSa.mat aSa
%end
%%----------------------%%
% orig batch_AAL_cube_match.m
%%----------------------%%
%% Link cubes to AAL mask --> to be able to extract % hubs e.g.
%
%
%% set result dir
%result_dir = '/haso/users/bettytij/CODA/GM_graphs/Results/';
%
%[all_ids]=textread('/haso/users/bettytij/CODA/GM_graphs/scripts/all_ids.txt','%s');
%
%reslice_dir = '/haso/users/bettytij/CODA/GM_graphs/reslice/';
%
%% Please enter the number of subjects to process below
%numimages= size(all_ids,1);
%
%% im= 134 = excluded
%for im=[1:numimages]
%	% Go to this person directory
%	cd(strcat(result_dir, char(all_ids(im))));
%
%	%mkdir atlas
%
%	% Get the mask
%	%taSa = load_nii(strcat(reslice_dir, 'iso2mm_atlas_', char(all_ids(im)),'.nii' ));
%	load atlas/aSa.mat
%	%aSa=aSa.img;
%	aSa = round(aSa);
%
%	% Load other data necessary from this subject
%	load Va.mat
%	load data/bind.mat
%	load data/lookup.mat
%	load data/nz.mat
%
%	% Label the voxels in a roi
%	label_rois = zeros(size(lookup));
%
%	s = 27;
%	lb=length(bind); % End point for loop
%	col=1;		% iteration counter
%
%	for i=1:s:lb
%		label_rois(:,col)=aSa(bind(i:(i+(s-1))));
%		col=col+1;
%	end
%
%	% Remove cubes that are not labelled --> perhaps redo network statistics with this subset ??
%	aal_rois_ind = find(sum(label_rois)~=0);
%	aal_rois_labels = label_rois(:,aal_rois_ind);
%	aal_rois_labels (aal_rois_labels ==0)=NaN;
%	aal_rois_labels = mode(aal_rois_labels);
%
%	% Save indices of labeled rois --> needed because we only want the stats from this subset.
%	save atlas/aal_rois_ind.mat aal_rois_ind
%	save atlas/aal_rois_labels.mat aal_rois_labels
%
%	im
%end
%%----------------------%%
% orig batch_sw_networks_v20152909.m
%%----------------------%%
%
%%% Small World Analyses - Batch script to compute graph properties
%
%%% Adjusted on 20140203 --> auto_threshold function is simplified using Matlabs internal percentile function to obtain threshold to binarise that gives exactly 5% spurious connection in the random corrlation matrix.
%
%% Start matlab
%
%cd /usr/local/MATLAB/R2011a/bin/
%matlab -nodesktop -singleCompThread
%
%% --- ADJUST FOLLOWING ----%
%% Go to the directory where you want to store your output (i.e., networks).
%cd /haso/users/bettytij/CODA/GM_graphs/Results
%
%% Clear workspace
%clear all;
%
%%% Please adjust the paths below
%
%% Please add path to the results directory
%result_dir = '/haso/users/bettytij/CODA/GM_graphs/Results/';
%ids = textread('/home/nas01/bettytij/Ileana/Matlab_Scripts/total_ids.txt','%s');
%
%%% - Below we do not need to adjust anything ---
%
%% Please add the path to the directory with all the functions
%addpath /home/nas01/bettytij/1_Latest_scripts/All_network_scripts/functions
%
%% Please add the number of subjects that we have here
%numimages=size(ids,1);
%
%% Please set the number of random graphs to compute in order to obtain the small world property. Twnety is enough to get stable results. For testing set to 2 (for time management issues).
%nrand = 5;
%
%%% No adjustments necessary below this line %%%
%
%%loop through the dirs and create
%%	1. binarized matrix based on th that gives a 5% chance that false positive edges are included
%%	2. degree
%%	3. cluster coefficient
%%	4. R and D distance matrices: Based on this we can compute the path length and betweenness centrality value
%%	5. average characteristic pathlength per node in all_L
%
%% Signa3 : 1 already processed: Start with 2
%
%% TO DO: Opnieuw netwerken uitrekenen voor signa3_ids.txt :  im = 201 : numimages
%
%for im=175:numimages
%
%	% go into the appropriate subject's directory & load required variables
%   	cd(strcat(result_dir, char(ids(im))))
%
%
%	%th=th_all(im);
%	load data/th.mat -mat
%	load data/rotation/rotcorr.mat -mat
%
%	% Threshold & binarize
%	bin_all=rotcorr>th;
%	degree=sum(bin_all);
%
%	% Save so this doesn't need to be computed again
%	save data/rotation/degree.mat degree
%	save data/rotation/bin_all.mat bin_all
%
%	% hoeveel rijen zitten er in bin_all? == het aantal kubussen
%	nz=size(bin_all,1);
%
%	bin = single(rotcorr >= th);
%
%	% If any of the nodes becomes disconnected than break
%	if any(degree == 0)	% a disconnected node
%
%		discon_th = th;
%		save discon_th.mat -mat
%		echo_warning = strcat('this scan id ', ids(im),' has disconnected nodes')
%
%		% Deze break moet eruit --> moet een variabele 0 1 worden om wel niet volgende analyses uit te rekenen --> en dus de disconnected node bijv te verwijderen.
%	else
%		% Get the clustering coefficient
%		C_i = clustering_coef_bu(bin);
%
%		save C_i.mat C_i
%		clear C_i
%
%		% Get the betweenness centrality & path length in one go
%		[BC L] = betweenness_bin(bin);
%
%		L=mean(L);
%		save L.mat L
%		save BC.mat BC
%		clear BC L
%
%		% Now determine gamma & lambda with 5 random graphs (should be enough)
%		rand_sw = zeros(nrand, 2, 'single');
%
%		for j = 1:nrand
%
%			% Make a random version of bin
%			rbin=makerandCIJdegreesfixed(degree',degree');
%
%			% compute clustering
%			rC_i = clustering_coef_bu(rbin);
%			rand_sw(j,1)=mean(rC_i);
%
%			% Compute path length & BC
%		%	[rR rD] = reachdist(rbin);	% This doesn work for the random bin matrices anymore --> use alternative reachdist_alt
%			[rR rD] = reachdist_alt(rbin);
%			rand_sw(j, 2) = mean(rD(:));
%			%rand_sw(j,3)= mean(BC);
%			clear rbin
%		end
%
%		save rand_sw.mat rand_sw
%
%	end
%	cd ..
%	im
%end
%
%exit
%%----------------------%%
% orig compute_local_aal_volume_20160921.m
%%----------------------%%
%
% clear all
%
% % addpaths
% addpath /home/nas01/bettytij/spm12
% addpath /home/nas01/bettytij/NIFTI_20121012/
%
% % check verschillende implementaties van structuur volume uitrekenen
% % test case = w260_Atlas.nii ; impact
%
% % 1. 2 input files : de personal atlas & de c1 file.
%
% [all_ids]=textread('/home/projects/AD_Niftis/work/VUmc/Jort/MDD/Script/ID_MDD_0929.txt','%s');
%
% %load_nii('/haso/users/bettytij/CODA/data/Atlassed/TEST/w2604_Atlas.nii');
% all_c1 = textread('/home/projects/AD_Niftis/work/VUmc/Jort/MDD/Script/c1_MDD_1_0929.txt','%s');
%
% all_c2 = textread('/home/projects/AD_Niftis/work/VUmc/Jort/MDD/Script/c2_MDD_1_0929.txt','%s');
%
% all_c3 = textread('/home/projects/AD_Niftis/work/VUmc/Jort/MDD/Script/c3_MDD_1_0929.txt','%s');
%
% atlas_dir ='/home/projects/AD_Niftis/work/VUmc/Jort/MDD/Data/Atlassed/SPM12_TMP/';
%
% %load_nii('/haso/users/bettytij/CODA/VBM/impact1/SPM12/c12604_o_T1_time_01_noneck.nii');
%
% numimages =size(all_ids,1) ;
%
% % Initialise AAL_volumes matrix
% % Initialise voxel dimension matrix
% aal_vols = zeros(7,91);	%numimages,90);
% m_aal_vols = zeros(7,91);%numimages,90);
% masked1_atl_aal_vols= zeros(7,91);%numimages,90); % gm > wm & gm >csf & gm > none);
% masked2_atl_aal_vols= zeros(7,91);%numimages,90); %gm > 0
%
% voxdim = zeros(numimages,4);
%
% % handmatig doen --> im = 1,9,  ; deze kan op een of andere manier niet goed geladen worden...
% % im = 134(i_id  2641) is geexcludeerd
%
% for(im = 1:numimages)
	% Va=spm_vol(strcat(atlas_dir,'w',char(all_ids(im)),'_Atlas.nii'));
	% t_atlas = spm_read_vols(Va);
%
	% Va=spm_vol(char(all_c1(im)));
	% t_c1 = spm_read_vols(Va);
%
	% Va=spm_vol(char(all_c2(im)));
	% t_c2 = spm_read_vols(Va);
%
	% Va=spm_vol(char(all_c3(im)));
	% t_c3 = spm_read_vols(Va);
%
%
	% % First make sure the atlas labels are discrete
	% t_atlas= round(t_atlas);
%
	% % maakt het nog uit als je masked? Nee: Correlatie is bijna 1.
  	% None = 1 - (t_c1 + t_c2 + t_c3);
        % indGM = find((t_c1> t_c2) & (t_c1> t_c3) & (t_c1> None));
%
	% mt_c1 = t_c1.* (  (t_c1> t_c2) & (t_c1> t_c3) & (t_c1> None) );
%
	% % hoe correleert het dan met de manier van ibaspm (= gemasked aal & sum voxels)
	% mt_atlas = t_atlas;
	% mt_atlas = t_atlas.* (  (t_c1> t_c2) & (t_c1> t_c3) & (t_c1> None) );
%
	% mtatlas = load_nii(strcat(atlas_dir,'w',char(all_ids(im)),'_Atlas.nii'));
	% mtatlas.img=mt_atlas;
	% save_nii(mtatlas, strcat(atlas_dir, 'masked_w',char(all_ids(im)),'_Atlas.nii') )
%
	% % 2de manier van maskeren; alleen gm > 0 nemen : deze correleerd het hoogste met Ibaspm. Maar alle andere manieren correleren ook met > .9
	% %mt_atlas2 = t_atlas.img .* ( t_c1.img > 0 );
%
	% % Compute voxel size: Store this to double check if all went well
	% voxdim(im,:) = mtatlas.hdr.dime.pixdim(1:4);
	% %voxvol = prod(t_c1.hdr.dime.pixdim(2:4))/100^3; % volume of a voxel, in litres;
	% voxvol = prod(mtatlas.hdr.dime.pixdim(2:4))/1000; % volume of a voxel in cm3 of cc
%
	% % loop through the atlas labels & find corresponding voxels
	% n_labels= length(unique(t_atlas(:)))-1;
%
	% for(i = 1:n_labels)
%
		% % find these voxels in the atlas image
		% tind = find(t_atlas==i);

		% % sum the grey matter of these voxels in the c1 image
		% t_gm = sum(t_c1(tind));

		% % compute the volume
		% aal_vols(im,(i+1))= t_gm *voxvol;
		% m_aal_vols(im,(i+1))= sum(mt_c1(tind)) *voxvol;
  		% %masked1_atl_aal_vols(im,i)= length(find(mt_atlas.img==i)) *voxvol;
		% %masked2_atl_aal_vols(im,i)= length(find(mt_atlas2==i)) *voxvol;
 %
	% end

	% aal_vols(im,1) = str2num(char(all_ids(im)));
	% m_aal_vols(im, 1)= str2num(char(all_ids(im)));

% end
%
% save aal_vols.mat aal_vols
% save m_aal_vols.mat m_aal_vols
%
% dlmwrite(strcat(atlas_dir,'aal_vols.txt'),aal_vols,'delimiter','\t','precision',5)
% dlmwrite(strcat(atlas_dir,'masked_aal_vols.txt'),m_aal_vols,'delimiter','\t','precision',5)
%
%
%
% % Maakt niet heel veel uit, alleen als je aal masker maskeert met gm >0 dan krijg je veel grotere waarden, dus dat is fout.
%%----------------------%%
%%% Extract AAL properties -> prob better to do on lnx machines? nope
%%----------------------%%
% % Extract AAL properties

% % Set results directory

% cd /haso/users/bettytij/CODA/GM_graphs/Results

% [all_ids]=textread('/haso/users/bettytij/CODA/GM_graphs/scripts/all_ids.txt','%s');

% result_dir = '/haso/users/bettytij/CODA/GM_graphs/Results/';


% % ENTER THE NUMBER OF SUBJECTS
% numimages= size(all_ids,1) ;


% % Go through directories and get:
% % - atlassed ROIs
% % - the rot_bin_all_degree.m
% % - rot_c_i.m -mat
% % - BC.m -mat
% % - rotD.m -mat --> get the mean for the nodal rotD.

% % Save the mean data of this subject in a AAL based matrix that we can further test with kruskal wallis tests
% aal_c = zeros(numimages, 91);

% aal_d =zeros(numimages, 91);

% aal_L = zeros(numimages, 91);

% aal_BC = zeros(numimages, 91);

% %aal_d_hub = zeros(numimages,91);

% for im=[35:numimages]
	% % Get the labelled rois
	% load (strcat(result_dir, char(all_ids(im)),'/atlas/aal_rois_labels.mat'))

	% % Get the indices of rois that received a label
	% load (strcat(result_dir, char(all_ids(im)),'/atlas/aal_rois_ind.mat'))

	% % Load other data necessary from this subject
	% load (strcat(result_dir, char(all_ids(im)),'/C_i.mat'))
	% load (strcat(result_dir, char(all_ids(im)),'/data/rotation/degree.mat'))
	% load (strcat(result_dir, char(all_ids(im)),'/L.mat'))
	% load (strcat(result_dir, char(all_ids(im)),'/BC.mat'))

	% % hub threshold: top 20%
	% %d_hub = prctile(degree,80);

	% % Select only the labeled data
	% rot_c_i = C_i(aal_rois_ind);
	% rot_bin_all_degree = degree(aal_rois_ind);
	% rotD = L(aal_rois_ind);
	% BC = BC(aal_rois_ind);

	% % Add the I_ID to the first column
	% aal_c(im,1)=str2num(char(all_ids(im)));
	% aal_d(im,1)=str2num(char(all_ids(im)));
	% aal_L(im,1)=str2num(char(all_ids(im)));
	% aal_BC(im,1)=str2num(char(all_ids(im)));
	% aal_d_hub(im,1)=str2num(char(all_ids(im)));

	% % Now go through the rois and store the mean of the measure in this
	% for i = 1:90
		% % Get the indices of this AAL
		% ai = find(aal_rois_labels ==i);

		% % Check if this region exists in this individual --> otherwise fill in 0
		% if isempty(ai)
			% aal_c(im,(i+1)) = 0;
			% aal_d(im,(i+1)) = 0;
			% aal_L(im,(i+1)) = 0;
			% aal_BC(im,(i+1)) = 0;
	% %		aal_d_hub(im,(i+1))=0;


		% else

			% aal_c(im, (i+1)) = mean(rot_c_i(ai));
			% aal_d(im, (i+1)) = mean(rot_bin_all_degree(ai));
			% aal_L(im, (i+1))= mean(rotD(ai));
			% aal_BC(im, (i+1)) = mean(BC(ai));
	% %		aal_d_hub(im, (i+1)) = sum(rot_bin_all_degree(ai)>d_hub);
		% end
	% end
	% im
% end
% %
% save aal_c.mat aal_c
% save aal_d.mat aal_d
% save aal_L.mat aal_L
% save aal_BC.mat aal_BC
% %save aal_d_hub.mat aal_d_hub

% % For R
% dlmwrite('aal_c.txt', aal_c, 'precision' , '%.33f');
% dlmwrite('aal_d.txt', aal_d, 'precision' , '%.33f');
% dlmwrite('aal_L.txt', aal_L, 'precision' , '%.33f');
% dlmwrite('aal_BC.txt', aal_BC, 'precision' , '%.33f');
% %dlmwrite('aal_d_hub.txt', aal_d_hub, 'precision' , '%.33f');
%%----------------------
