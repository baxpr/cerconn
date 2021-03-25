function cerconn_main(inp)


%% Setup

% Shortcuts
out_dir = inp.out_dir;
fwhm = str2double(inp.fwhm);

% Expected ROI indices in final ROI image
expected_rois = (0:7)';


%% Processing

% Copy inputs
[cerseg_nii,wcerseg_nii,removegm_nii,keepgm_nii, ...
	meanfmri_nii,wmeanfmri_nii,fwddef_nii] = prep_files(inp);


% Create ROI images in fMRI geometry
[roi_nii,eroi_nii,fmrimask_nii,ecerseg_nii] = make_rois( ...
	meanfmri_nii,cerseg_nii,expected_rois,out_dir);


% Get ROI time series. Save labels to file (labels the same for both
% because same ROI image used)
disp('Extract ROI time series')
[data_removegm,vals] = extract_roi_timeseries(removegm_nii,roi_nii);
data_keepgm = extract_roi_timeseries(keepgm_nii,roi_nii);
edata_removegm = extract_roi_timeseries(removegm_nii,eroi_nii);
edata_keepgm = extract_roi_timeseries(keepgm_nii,eroi_nii);
csvwrite(fullfile(out_dir,'roi-labels.csv'), vals)


% Connectivity matrices
disp('Connectivity matrices')
connmat(data_removegm,out_dir,'removegm');
connmat(data_keepgm,out_dir,'keepgm');
connmat(edata_removegm,out_dir,'eremovegm');
connmat(edata_keepgm,out_dir,'ekeepgm');


% Connectivity maps
disp('Connectivity maps')
connmap(data_removegm,removegm_nii,out_dir,'removegm')
connmap(data_keepgm,keepgm_nii,out_dir,'keepgm')
connmap(edata_removegm,removegm_nii,out_dir,'eremovegm')
connmap(edata_keepgm,keepgm_nii,out_dir,'ekeepgm')


% Warp to MNI
disp('Warp')
warp_images_dir(fwddef_nii,[out_dir filesep 'CONNMAP_REMOVEGM'], ...
	inp.refimg_nii,1,[out_dir filesep 'CONNMAP_REMOVEGM_MNI']);
warp_images_dir(fwddef_nii,[out_dir filesep 'CONNMAP_KEEPGM'], ...
	inp.refimg_nii,1,[out_dir filesep 'CONNMAP_KEEPGM_MNI']);
warp_images_dir(fwddef_nii,[out_dir filesep 'CONNMAP_EREMOVEGM'], ...
	inp.refimg_nii,1,[out_dir filesep 'CONNMAP_EREMOVEGM_MNI']);
warp_images_dir(fwddef_nii,[out_dir filesep 'CONNMAP_EKEEPGM'], ...
	inp.refimg_nii,1,[out_dir filesep 'CONNMAP_EKEEPGM_MNI']);


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


% Wrap up
if isdeployed
	exit
end

