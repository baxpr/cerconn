function cerconn(varargin)


%% Parse inputs
P = inputParser;

% From cersuit ATLASES_NATIVE 
addOptional(P,'cerseg_niigz','../INPUTS/iw_Buckner_7Networks_u_a_c_rt1_seg1.nii.gz');

% From connprep FILTERED_REMOVEGM_NATIVE, FILTERED_KEEPGM_NATIVE
addOptional(P,'removegm_niigz','../INPUTS/filtered_removegm_noscrub_nadfmri.nii.gz');
addOptional(P,'keepgm_niigz','../INPUTS/filtered_keepgm_noscrub_nadfmri.nii.gz');

% From connprep MEAN_FMRI_NATIVE
addOptional(P,'meanfmri_niigz','../INPUTS/meanadfmri.nii.gz');

% From cat12 DEF_FWD
addOptional(P,'fwddef_niigz','../INPUTS/y_fwddef.nii.gz');

% Reference image - must exist in the compiled executable
addOptional(P,'refimg_nii','mask_ICV.nii');

% Smoothing kernel in mm
addOptional(P,'fwhm','4');

% Output directory
addOptional(P,'out_dir','../OUTPUTS');

% Parse
parse(P,varargin{:});

% Show
disp(P.Results)


%% Process
cerconn_main(P.Results);


%% Exit
if isdeployed
	exit
end


