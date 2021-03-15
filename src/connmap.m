function connmap(data,fmri_nii,out_dir,tag)

Vfmri = spm_vol(fmri_nii);
Yfmri = spm_read_vols(Vfmri);
osize = size(Yfmri);
rYfmri = reshape(Yfmri,[],osize(4))';

R = corr(data,rYfmri);
Z = atanh(R) * sqrt(size(data,1)-3);

for r = 1:size(R,1)
	
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
