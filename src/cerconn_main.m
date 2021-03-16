function cerconn_main(inp)


%% Setup

% Shortcuts
out_dir = inp.out_dir;
fwhm = str2double(inp.fwhm);

% Expected ROI indices in final ROI image
expected_rois = (0:7)';


%% Processing


% Copy inputs
copyfile(inp.cerseg_niigz,fullfile(out_dir,'cerseg.nii.gz'));
cerseg_niigz = fullfile(out_dir,'cerseg.nii.gz');
gunzip(cerseg_niigz);
cerseg_nii = strrep(cerseg_niigz,'.gz','');

copyfile(inp.meanfmri_niigz,fullfile(out_dir,'meanfmri.nii.gz'));
meanfmri_niigz = fullfile(out_dir,'meanfmri.nii.gz');
gunzip(meanfmri_niigz);
meanfmri_nii = strrep(meanfmri_niigz,'.gz','');

copyfile(inp.fwddef_niigz,fullfile(out_dir,'y_fwddef.nii.gz'));
fwddef_niigz = fullfile(out_dir,'y_fwddef.nii.gz');
gunzip(fwddef_niigz);
fwddef_nii = strrep(fwddef_niigz,'.gz','');


% Create ROI images in fMRI geometry
[roi_nii,eroi_nii,fmrimask_nii] = make_rois( ...
	meanfmri_nii,cerseg_nii,expected_rois,out_dir);


% Get ROI time series. Save labels to file (labels the same for both
% because same ROI image used)
disp('Extract ROI time series')
[data_removegm,vals] = extract_roi_timeseries(inp.removegm_niigz,roi_nii);
data_keepgm = extract_roi_timeseries(inp.keepgm_niigz,roi_nii);
edata_removegm = extract_roi_timeseries(inp.removegm_niigz,eroi_nii);
edata_keepgm = extract_roi_timeseries(inp.keepgm_niigz,eroi_nii);
csvwrite(fullfile(out_dir,'roi-labels.csv'), vals)


% Connectivity matrices
disp('Connectivity matrices')
connmat(data_removegm,out_dir,'removegm');
connmat(data_keepgm,out_dir,'keepgm');
connmat(edata_removegm,out_dir,'eremovegm');
connmat(edata_keepgm,out_dir,'ekeepgm');


% Connectivity maps
disp('Connectivity maps')
connmap(data_removegm,inp.removegm_niigz,out_dir,'removegm')
connmap(data_keepgm,inp.keepgm_niigz,out_dir,'keepgm')
connmap(edata_removegm,inp.removegm_niigz,out_dir,'eremovegm')
connmap(edata_keepgm,inp.keepgm_niigz,out_dir,'ekeepgm')


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


% PDF
system([ ...
	' OUTDIR=' out_dir
	' WCERSEG=' inp.wcerseg_niigz
	' WMEANFMRI=' inp.wmeanfmri_niigz
	' WMT1=' inp.wmt1
	' PROJECT=' inp.project
	' SUBJECT=' inp.subject
	' SESSION=' inp.session
	' SCAN=' inp.scan
	' MAGICKDIR=' inp.magick_dir
	' FSLDIR=' inp.fsl_dir
	inp.src_dir '/make_pdf.sh'
	]);


% Arrange outputs
mkdir([out_dir filesep 'FMRIMASK'])
gzip(fmrimask_nii)
movefile([fmrimask_nii '.gz'],[out_dir filesep 'FMRIMASK']);

mkdir([out_dir filesep 'ROIS'])
gzip(roi_nii)
gzip(eroi_nii)
movefile([roi_nii '.gz'],[out_dir filesep 'ROIS']);
movefile([eroi_nii '.gz'],[out_dir filesep 'ROIS']);
movefile([out_dir filesep 'roi-labels.csv'],[out_dir filesep 'ROIS']);

	

