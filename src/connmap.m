function connmap(data,fmri_nii,out_dir,tag)

Vfmri = spm_vol(fmri_nii);
Yfmri = spm_read_vols(Vfmri);
osize = size(Yfmri);
rYfmri = reshape(Yfmri,[],osize(4))';

% Bivariate Pearson correlation
R = corr(data,rYfmri);
Z = atanh(R) * sqrt(size(data,1)-3);

for r = 1:size(data,2)
	
	Rout = reshape(R(r,:),osize(1:3));
	Vout = rmfield(Vfmri(1),'pinfo');
	Vout.fname = fullfile(out_dir,sprintf('R_%s_%03d.nii',tag,r));
	Vout.dt(1) = spm_type('float32');
	spm_write_vol(Vout,Rout);
	
	Zout = reshape(Z(r,:),osize(1:3));
	Vout = rmfield(Vfmri(1),'pinfo');
	Vout.fname = fullfile(out_dir,sprintf('Z_%s_%03d.nii',tag,r));
	Vout.dt(1) = spm_type('float32');
	spm_write_vol(Vout,Zout);

end


% Partial correlation w.r.t. other seed ROIs
for r = 1:size(data,2)
	
	pR = partialcorr(data(:,r),rYfmri,data(:,[1:r-1 r+1:end]));
	pZ = atanh(pR) * sqrt(size(data,1)-3);

	Rout = reshape(pR,osize(1:3));
	Vout = rmfield(Vfmri(1),'pinfo');
	Vout.fname = fullfile(out_dir,sprintf('pR_%s_%03d.nii',tag,r));
	Vout.dt(1) = spm_type('float32');
	spm_write_vol(Vout,Rout);
	
	Zout = reshape(pZ,osize(1:3));
	Vout = rmfield(Vfmri(1),'pinfo');
	Vout.fname = fullfile(out_dir,sprintf('pZ_%s_%03d.nii',tag,r));
	Vout.dt(1) = spm_type('float32');
	spm_write_vol(Vout,Zout);

end
