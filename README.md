# cerconn: cerebellar functional connectivity maps

Seed regions are the Buckner 7 set as produced by cersuit pipeline. Four sets are computed: with 
and without removal of the mean gray matter signal by regression; with and without erosion of the
seed ROIs with a 1-voxel radius spherical kernel. Both bivariate Pearson correlation and partial
correlation with respect to the other seed regions are computed.

## Inputs

*From cersuit_v2 cerebellar segmentation pipeline*

    cerseg_niigz      Native space Buckner7 segmentation, ATLASES_NATIVE iw_Buckner_7Networks_u_a_c_rt1_seg1.nii.gz
    wcerseg_niigz     Atlas space Buckner7 segmentation, ATLASES_SUIT Buckner_7Networks.nii.gz

*From CAT12, e.g. cat12_ss2p0_v2 pipeline*

    wmt1_niigz        MNI space bias corrected T1, BIAS_NORM
    fwddef_niigz      Forward deformation from native to MNI, DEF_FWD
	

*From connectivity preprocessing pipeline connprep_v2*

    removegm_niigz    Native space with mean gray signal removed, FILTERED_REMOVEGM_NATIVE
    keepgm_niigz      Native space with mean gray signal kept, FILTERED_KEEPGM_NATIVE
    meanfmri_niigz    Native space mean fmri, MEAN_FMRI_NATIVE
    wmeanfmri_niigz   MNI space mean fmri, MEAN_FMRI_MNI


*Other options*

    fwhm              Smoothing kernel for connectivity maps, in mm
    out_dir           Output directory


## Outputs

