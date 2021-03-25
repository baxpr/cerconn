#!/usr/bin/env bash

echo Organizing outputs

cd "${out_dir}"

mkdir FMRIMASK
gzip fmrimask.nii
mv fmrimask.nii.gz FMRIMASK

mkdir ROIS
gzip rcerseg_masked.nii rcerseg_masked_eroded.nii
mv rcerseg_masked.nii.gz rcerseg_masked_eroded.nii.gz roi-labels.csv ROIS

mkdir EROIS
gzip rcerseg_eroded.nii
mv rcerseg_eroded.nii.gz EROIS

gzip *.nii
gzip */*.nii
