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
    
    refimg_nii        Filename of existing image for geometry reference ('avg152T1.nii','mask_ICV.nii')
    fwhm              Smoothing kernel for connectivity maps, in mm
    out_dir           Output directory

*Info for PDF report title if run on XNAT*
    
    project
    subject
    session
    scan

*For testing only*
    
    fsl_dir            Location of FSL installation
    magick_dir         Location of ImageMagick binaries
    src_dir            Location of pipeline shell scripts


## Outputs

    ROIS      Seed ROI images in native fMRI geometry (eroded and non-eroded) and list of ROI labels
    
    EROIS     Eroded seed ROI images in native T1 geometry
    
    FMRIMASK  Native fMRI space mask used to exclude voxels without fMRI signal from seeds
    
    CONNMAP   Connectivity maps for the seed ROIs. There are a number of different types:
    
           R_*        Pearson correlation
           Z_*        Fisher Z transform of Pearson correlation
           pR_*       Partial correlation conditioning on the the other seeds
           pZ_*       Fisher transform of the partial correlation
      
           *E*        Indicates eroded seed ROIs (no E indicates uneroded ROIs)
              
           REMOVEGM   Mean gray matter removed during preprocessing
           KEEPGM     Mean gray matter retained during preprocessing
      
           _MNI       Indicates MNI space images (no _MNI indicates native space)
    
    SCONNMAP  Smoothed connectivity maps. As above.
    
    CONNMAT   Connectivity matrices for seed ROIs. As above.

