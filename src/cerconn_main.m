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

% Resample cerseg ROIs to fMRI geometry
fcerseg_nii = resample_roi(cerseg_nii,meanfmri_nii);

% Load cerseg ROIs (we already have combined hemispheres)
Vseg = spm_vol(fcerseg_nii);
Yseg = spm_read_vols(Vseg);

% Create mask of voxels with significant signal in the fMRI
Vmeanfmri = spm_vol(meanfmri_nii);
Ymeanfmri = spm_read_vols(Vmeanfmri);
thresh = spm_antimode(Ymeanfmri(:));

Yfmrimask = Ymeanfmri> thresh;

Vout = Vmeanfmri;
Vout.dt(1) = spm_type('uint16');
Vout.pinfo(1:2) = [1 0];
Vout.fname = fullfile(out_dir,'fmrimask.nii');
spm_write_vol(Vout,Yfmrimask);


% Apply mask to ROIs
Yseg(Yfmrimask(:)==0) = 0;
Yseg(isnan(Yseg(:))) = 0;
Vout = Vmeanfmri;
Vout.dt(1) = spm_type('uint16');
Vout.pinfo(1:2) = [1 0];
roi_nii = fullfile(out_dir,'rcerseg_masked.nii');
Vout.fname = roi_nii;
spm_write_vol(Vout,Yseg);


% Check that all ROIs are present after masking
if ~isequal( unique(Yseg(:)), expected_rois )
	error('Missing an ROI after masking')
end

% Get ROI time series. Save labels to file (labels the same for both)
[data_removegm,vals] = extract_roi_timeseries(removegm_niigz,roi_nii);
data_keepgm = extract_roi_timeseries(keepgm_niigz,roi_nii);
csvwrite(fullfile(out_dir,'fmrimask-labels.csv'), vals)


% Connectivity matrices
connmat(data_removegm,out_dir,'removegm');
connmat(data_keepgm,out_dir,'keepgm');

% Connectivity maps
connmap(data_removegm,removegm_niigz,out_dir,'removegm')
connmap(data_keepgm,keepgm_niigz,out_dir,'keepgm')


