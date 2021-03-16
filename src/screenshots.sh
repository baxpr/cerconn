#!/usr/bin/env bash

# Axial slices at MNI -20  5  30  55 

# FSL init
#PATH=${FSLDIR}/bin:${PATH}
#. ${FSLDIR}/etc/fslconf/fsl.sh

# Work in output directory
#cd ${OUTDIR}

thedate=$(date)

for slice in -85 -75 -65 -55 -45 -35 ; do
	fsleyes render -of cor_${slice}.png \
		--scene ortho --worldLoc 0 ${slice} -35 --displaySpace world --size 600 600 --yzoom 1000 \
		--layout horizontal --hideCursor --hideLabels --hidex --hidez \
		${INDIR}/wmeanadfmri --overlayType volume \
		${INDIR}/Buckner_7Networks --overlayType label --lut random --outline --outlineWidth 3
done


# Create atlas space conn map views
for roi in 001 002 003 004 005 006 007 ; do
	for slice in -20 5 30 55 ; do
		fsleyes render -of ax_${roi}_${slice}.png \
			--scene ortho --worldLoc 0 0 ${slice} --displaySpace world --size 600 600 \
			--layout horizontal --hideCursor --hideLabels --hidex --hidey \
			${INDIR}/wmt1 --overlayType volume \
			SCONNMAP_REMOVEGM_MNI/swZ_removegm_${roi} --overlayType volume --displayRange 3 10 \
			--useNegativeCmap --cmap red-yellow --negativeCmap blue-lightblue
	done
done


# Combine
montage \
	-mode concatenate cor_*.png \
	-tile 2x -trim -quality 100 -background black -gravity center \
	-border 20 -bordercolor black page_cor.png

for roi in 001 002 003 004 005 006 007 ; do
	montage \
		-mode concatenate ax_${roi}*.png \
		-tile 2x -trim -quality 100 -background black -gravity center \
		-border 20 -bordercolor black page_${roi}.png
done

info_string="$PROJECT $SUBJECT $SESSION $SCAN"
convert -size 2600x3365 xc:white \
	-gravity center \( page_cor.png -resize 2400x \) -composite \
	-gravity North -pointsize 48 -annotate +0+100 \
	"Cerebellar segmentation (Buckner7) over mean fMRI" \
	-gravity SouthEast -pointsize 48 -annotate +100+100 "${thedate}" \
	-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
	page_cor.png

for roi in 001 002 003 004 005 006 007 ; do
	convert -size 2600x3365 xc:white \
		-gravity center \( page_${roi}.png -resize 2000x \) -composite \
		-gravity North -pointsize 48 -annotate +0+100 \
		"Connectivity map for ROI ${roi}" \
		-gravity SouthEast -pointsize 48 -annotate +100+100 "${thedate}" \
		-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
		page_${roi}.png
done

convert page_cor.png page_0*.png cerconn.pdf
