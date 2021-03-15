
Vroi = spm_vol(cerseg_nii);
Yroi = spm_read_vols(Vroi);
vals = unique(Yroi(:));
vals = vals(vals~=0);

Yim = zeros(size(Yroi));
for v = 1:numel(vals)
	
	m = Yroi==vals(v);
	Yim = Yim + vals(v) * imerode(m,strel('cube',3));
	
end

% Write T1 geom eroded ROIs to file
Vout = Vroi;
Vout.pinfo(1:2) = [1 0];
Vout.dt(1) = spm_type('uint16');
Vout.fname = fullfile(out_dir,'cerseg_eroded.nii');
spm_write_vol(Vout,Yim);


return


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

