addpath('~/Dropbox/matlab/softwareinstallations/spm12_r7771')
addpath('external/spm_pct_lite')


%% Inputs

out_dir = '../OUTPUTS';

% From cersuit ATLASES_NATIVE
cerseg_niigz = '../INPUTS/iw_Buckner_7Networks_u_a_c_rt1_seg1.nii.gz';

% Expected ROI indices in final ROI image
expected_rois = (0:7)';

% From connprep FILTERED_REMOVEGM_NATIVE, FILTERED_KEEPGM_NATIVE
removegm_niigz = '../INPUTS/filtered_removegm_noscrub_nadfmri.nii.gz';
keepgm_niigz = '../INPUTS/filtered_keepgm_noscrub_nadfmri.nii.gz';

% From connprep MEAN_FMRI_NATIVE
meanfmri_niigz = '../INPUTS/meanadfmri.nii.gz';

% From cat12
fwddef_niigz = '../INPUTS/y_fwddef.nii.gz';

% Reference image
%refimg_nii = 'tpm/mask_ICV.nii';
refimg_nii = [spm('dir') 'tpm' filesep 'mask_ICV.nii'];

% Smoothing kernel
fwhm = 4;


%% Processing


% Copy inputs
copyfile(cerseg_niigz,fullfile(out_dir,'cerseg.nii.gz'));
cerseg_niigz = fullfile(out_dir,'cerseg.nii.gz');
gunzip(cerseg_niigz);
cerseg_nii = strrep(cerseg_niigz,'.gz','');

copyfile(meanfmri_niigz,fullfile(out_dir,'meanfmri.nii.gz'));
meanfmri_niigz = fullfile(out_dir,'meanfmri.nii.gz');
gunzip(meanfmri_niigz);
meanfmri_nii = strrep(meanfmri_niigz,'.gz','');

copyfile(fwddef_niigz,fullfile(out_dir,'y_fwddef.nii.gz'));
fwddef_niigz = fullfile(out_dir,'y_fwddef.nii.gz');
gunzip(fwddef_niigz);
fwddef_nii = strrep(fwddef_niigz,'.gz','');


% Create ROI images in fMRI geometry
[roi_nii,eroi_nii] = make_rois(meanfmri_nii,cerseg_nii,expected_rois,out_dir);


% Get ROI time series. Save labels to file (labels the same for both
% because same ROI image used)
disp('Extract ROI time series')
[data_removegm,vals] = extract_roi_timeseries(removegm_niigz,roi_nii);
data_keepgm = extract_roi_timeseries(keepgm_niigz,roi_nii);
edata_removegm = extract_roi_timeseries(removegm_niigz,eroi_nii);
edata_keepgm = extract_roi_timeseries(keepgm_niigz,eroi_nii);
csvwrite(fullfile(out_dir,'roi-labels.csv'), vals)


% Connectivity matrices
disp('Connectivity matrices')
connmat(data_removegm,out_dir,'removegm');
connmat(data_keepgm,out_dir,'keepgm');
connmat(edata_removegm,out_dir,'eremovegm');
connmat(edata_keepgm,out_dir,'ekeepgm');


% Connectivity maps
disp('Connectivity maps')
connmap(data_removegm,removegm_niigz,out_dir,'removegm')
connmap(data_keepgm,keepgm_niigz,out_dir,'keepgm')
connmap(edata_removegm,removegm_niigz,out_dir,'eremovegm')
connmap(edata_keepgm,keepgm_niigz,out_dir,'ekeepgm')


% Warp to MNI
disp('Warp')
warp_images_dir(fwddef_nii,[out_dir filesep 'CONNMAP_REMOVEGM'], ...
	refimg_nii,1,[out_dir filesep 'CONNMAP_REMOVEGM_MNI']);
warp_images_dir(fwddef_nii,[out_dir filesep 'CONNMAP_KEEPGM'], ...
	refimg_nii,1,[out_dir filesep 'CONNMAP_KEEPGM_MNI']);
warp_images_dir(fwddef_nii,[out_dir filesep 'CONNMAP_EREMOVEGM'], ...
	refimg_nii,1,[out_dir filesep 'CONNMAP_EREMOVEGM_MNI']);
warp_images_dir(fwddef_nii,[out_dir filesep 'CONNMAP_EKEEPGM'], ...
	refimg_nii,1,[out_dir filesep 'CONNMAP_EKEEPGM_MNI']);


% Smooth
disp('Smooth')
smooth_images_dir([out_dir filesep 'CONNMAP_REMOVEGM_MNI'],fwhm, ...
	[out_dir filesep 'SCONNMAP_REMOVEGM_MNI'])
smooth_images_dir([out_dir filesep 'CONNMAP_KEEPGM_MNI'],fwhm, ...
	[out_dir filesep 'SCONNMAP_KEEPGM_MNI'])
smooth_images_dir([out_dir filesep 'CONNMAP_EREMOVEGM_MNI'],fwhm, ...
	[out_dir filesep 'SCONNMAP_EREMOVEGM_MNI'])
smooth_images_dir([out_dir filesep 'CONNMAP_EKEEPGM_MNI'],fwhm, ...
	[out_dir filesep 'SCONNMAP_EKEEPGM_MNI'])


