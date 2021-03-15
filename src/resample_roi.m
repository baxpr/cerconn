function rroi_nii = resample_roi(roi_nii,meanfmri_nii)

% Params. Critically, 0 order (nearest neighbor) interpolation
flags = struct('mask',true,'mean',false,'interp',0,'which',1, ...
	'wrap',[0 0 0],'prefix','r');

% Use SPM to reslice
spm_reslice_quiet({meanfmri_nii roi_nii},flags);

% Figure out the new filename
[p,n,e] = fileparts(roi_nii);
rroi_nii = fullfile(p,['r' n e]);
