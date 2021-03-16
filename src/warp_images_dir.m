function warp_images_dir( ...
	fwddef_nii, ...
	img_dir, ...
	refimg_nii, ...
	interp, ...
	out_dir ...
	)

if ~exist(out_dir,'dir'), mkdir(out_dir), end

D = dir([img_dir filesep '*.nii']);

for d = 1:length(D)
		
	clear job
	job.comp{1}.def = {fwddef_nii};
	job.comp{2}.id.space = {which(refimg_nii)};
	job.out{1}.pull.fnames = {[img_dir filesep D(d).name]};
	job.out{1}.pull.savedir.saveusr = {out_dir};
	job.out{1}.pull.interp = interp;
	job.out{1}.pull.mask = 0;
	job.out{1}.pull.fwhm = [0 0 0];
	
	spm_deformations(job);
	
end
