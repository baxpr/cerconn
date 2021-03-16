function smooth_images_dir(img_dir,fwhm,out_dir)

if ~exist(out_dir,'dir'), mkdir(out_dir), end

D = dir([img_dir filesep '*.nii']);

for d = 1:length(D)
	
	% Load the images
	V = spm_vol([img_dir filesep D(d).name]);
	Y = spm_read_vols(V);
	sY = zeros(size(Y));
	
	% Smooth
	for v = 1:size(Y,4)
		tmp = Y(:,:,:,v);
		tmp2 = nan(size(tmp));
		spm_smooth(tmp,tmp2,fwhm);
		sY(:,:,:,v) = tmp2;
	end
	
	% Write to file
	[~,n,e] = fileparts(V.fname);
	for v = 1:size(Y,4)
		Vout = V(v);
		Vout.fname = fullfile(out_dir,['s' n e]);
		Vout.n(1) = v;
		spm_write_vol(Vout,sY(:,:,:,v));
	end
	
end
