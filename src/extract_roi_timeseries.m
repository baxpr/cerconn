function [data,vals] = extract_roi_timeseries(fmri_nii,roi_nii)

Vroi = spm_vol(roi_nii);
Vfmri = spm_vol(fmri_nii);
spm_check_orientations([Vroi; rmfield(Vfmri,'dat')]);

Yroi = spm_read_vols(Vroi);
Yfmri = spm_read_vols(Vfmri);
rYfmri = reshape(Yfmri,[],size(Yfmri,4))';

vals = unique(Yroi(:));
vals = vals(vals~=0);

data = nan(size(rYfmri,1),numel(vals));

for v = 1:numel(vals)
	data(:,v) = mean( rYfmri(:,Yroi(:)==vals(v)), 2 );
end

