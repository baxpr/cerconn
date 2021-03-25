#!/usr/bin/env bash
#
# Main pipeline

echo Running ${0}

# Initialize defaults (will be changed later if passed as options)
export project=UNK_PROJ
export subject=UNK_SUBJ
export session=UNK_SESS
export scan=UNK_SCAN
export refimg_nii=avg152T1.nii
export src_dir=/opt/cerconn/src
export matlab_dir=/opt/cerconn/bin
export magick_dir=/usr/bin
export mcr_dir=/usr/local/MATLAB/MATLAB_Runtime/v97
export out_dir=/OUTPUTS

# Parse options
while [[ $# -gt 0 ]]
do
	key="$1"
	case $key in
		--project)
			export project="$2"; shift; shift ;;
		--subject)
			export subject="$2"; shift; shift ;;
		--session)
			export session="$2"; shift; shift ;;
		--scan)
			export scan="$2"; shift; shift ;;
		--cerseg_niigz)
			export cerseg_niigz="$2"; shift; shift ;;
		--wcerseg_niigz)
			export wcerseg_niigz="$2"; shift; shift ;;
		--removegm_niigz)
			export removegm_niigz="$2"; shift; shift ;;
		--keepgm_niigz)
			export keepgm_niigz="$2"; shift; shift ;;
		--meanfmri_niigz)
			export meanfmri_niigz="$2"; shift; shift ;;
		--wmeanfmri_niigz)
			export wmeanfmri_niigz="$2"; shift; shift ;;
		--wmt1_niigz)
			export wmt1_niigz="$2"; shift; shift ;;
		--fwddef_niigz)
			export fwddef_niigz="$2"; shift; shift ;;
		--refimg_nii)
			export refimg_nii="$2"; shift; shift ;;
		--fwhm)
			export fwhm="$2"; shift; shift ;;
		--out_dir)
			export out_dir="$2"; shift; shift ;;
		--src_dir)
			export src_dir="$2"; shift; shift ;;
		--fsl_dir)
			export fsl_dir="$2"; shift; shift ;;
		--magick_dir)
			export magick_dir="$2"; shift; shift ;;
		*)
			echo Unknown input "${1}"; shift ;;
	esac
done


# Date stamp
export thedate=$(date)


# Inputs report
echo "${project} ${subject} ${session} ${scan}"
echo ${thedate}


# FSL setup
. ${FSLDIR}/etc/fslconf/fsl.sh


# SPM processing
"${matlab_dir}"/run_spm12.sh "${mcr_dir}" function cerconn \
	cerseg_niigz "${cerseg_niigz}" \
	wcerseg_niigz "${wcerseg_niigz}" \
	removegm_niigz "${removegm_niigz}" \
	keepgm_niigz "${keepgm_niigz}" \
	meanfmri_niigz "${meanfmri_niigz}" \
	wmeanfmri_niigz "${wmeanfmri_niigz}" \
	wmt1_niigz "${wmt1_niigz}" \
	fwddef_niigz "${fwddef_niigz}" \
	refimg_nii "${refimg_nii}" \
	fwhm "${fwhm}" \
	out_dir "${out_dir}" \
	project "${project}" \
	subject "${subject}" \
	session "${session}" \
	scan "${scan}" \
	fsl_dir "${fsl_dir}" \
	magick_dir "${magick_dir}" \
	src_dir "${src_dir}"

# PDF and outputs org. PDF not run from within matlab due to fsleyes xvfb issues
make_pdf.sh
organize_outputs.sh


echo "Processing complete!"
