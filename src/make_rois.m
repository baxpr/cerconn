function [roi_nii,eroi_nii,fmrimask_nii,ecerseg_nii] = make_rois( ...
	meanfmri_nii,cerseg_nii,expected_rois,out_dir)


%% Create mask of voxels with significant signal in the fMRI
Vmeanfmri = spm_vol(meanfmri_nii);
Ymeanfmri = spm_read_vols(Vmeanfmri);
thresh = spm_antimode(Ymeanfmri(:));

Yfmrimask = Ymeanfmri> thresh;

Vout = Vmeanfmri;
Vout.dt(1) = spm_type('uint16');
Vout.pinfo(1:2) = [1 0];
fmrimask_nii = fullfile(out_dir,'fmrimask.nii');
Vout.fname = fmrimask_nii;
spm_write_vol(Vout,Yfmrimask);


%% Resample cerseg ROIs to fMRI geometry and apply fmri mask
fcerseg_nii = resample_roi(cerseg_nii,meanfmri_nii);
Vseg = spm_vol(fcerseg_nii);
Yseg = spm_read_vols(Vseg);

Yseg(Yfmrimask(:)==0) = 0;
Yseg(isnan(Yseg(:))) = 0;
Vout = Vmeanfmri;
Vout.dt(1) = spm_type('uint16');
Vout.pinfo(1:2) = [1 0];
[~,name] = fileparts(fcerseg_nii);
roi_nii = fullfile(out_dir,[name '_masked.nii']);
Vout.fname = roi_nii;
spm_write_vol(Vout,Yseg);

% Check that all ROIs are present after masking
if ~isequal( unique(Yseg(:)), expected_rois )
	error('Missing an ROI after masking (uneroded)')
end


%% Erode ROIs in T1 geometry and repeat
Vroi = spm_vol(cerseg_nii);
Yroi = spm_read_vols(Vroi);
Yroi(isnan(Yroi(:))) = 0;
vals = unique(Yroi(:));
vals = vals(vals~=0);

Yim = zeros(size(Yroi));
for v = 1:numel(vals)
	
	m = Yroi==vals(v);
	Yim = Yim + vals(v) * imerode(m,strel('sphere',1));
	
end

% Write eroded ROIs to file
Vout = Vroi;
Vout.pinfo(1:2) = [1 0];
Vout.dt(1) = spm_type('uint16');
ecerseg_nii = fullfile(out_dir,[name '_eroded.nii']);
Vout.fname = ecerseg_nii;
spm_write_vol(Vout,Yim);

% Resample eroded cerseg ROIs to fMRI geometry and apply fmri mask
fecerseg_nii = resample_roi(ecerseg_nii,meanfmri_nii);
Vseg = spm_vol(fecerseg_nii);
Yseg = spm_read_vols(Vseg);

Yseg(Yfmrimask(:)==0) = 0;
Yseg(isnan(Yseg(:))) = 0;
Vout = Vmeanfmri;
Vout.dt(1) = spm_type('uint16');
Vout.pinfo(1:2) = [1 0];
eroi_nii = fullfile(out_dir,[name '_masked_eroded.nii']);
Vout.fname = eroi_nii;
spm_write_vol(Vout,Yseg);

% Check that all ROIs are present after masking
if ~isequal( unique(Yseg(:)), expected_rois )
	error('Missing an ROI after masking (eroded)')
end

