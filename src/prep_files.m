function [cerseg_nii,wcerseg_nii,removegm_nii,keepgm_nii, ...
	meanfmri_nii,wmeanfmri_nii,fwddef_nii] = prep_files(inp)

cerseg_nii = prep(inp.cerseg_niigz,'cerseg',inp.out_dir);
wcerseg_nii = prep(inp.wcerseg_niigz,'wcerseg',inp.out_dir);
removegm_nii = prep(inp.removegm_niigz,'removegm',inp.out_dir);
keepgm_nii = prep(inp.keepgm_niigz,'keepgm',inp.out_dir);
meanfmri_nii = prep(inp.meanfmri_niigz,'meanfmri',inp.out_dir);
wmeanfmri_nii = prep(inp.wmeanfmri_niigz,'wmeanfmri',inp.out_dir);
fwddef_nii = prep(inp.fwddef_niigz,'y_fwddef',inp.out_dir);


function nii = prep(niigz,name,out_dir)

copyfile(niigz,fullfile(out_dir,[name '.nii.gz']));
gunzip(fullfile(out_dir,[name '.nii.gz']));
delete(fullfile(out_dir,[name '.nii.gz']));
nii = fullfile(out_dir,[name '.nii']);
