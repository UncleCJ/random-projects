#!/bin/bash

#
# Bash script to scale down batches of pictures.
#
# Requires ImageMagick to be installed
#
# by Carl-Johan Sveningsson <cj.sveningsson@gmail.com>
#    August 2007
#    December 2010
# 
# This script is adapted to scale pictures suitable
# for our picture frame, which will want no axis to be
# larger than 1024x600
# 
# This is really my ugly hack, don't trust it. Also it 
# over-writes the original picture
#
# Execute for example like:
#   find . -iname "*.jpg" -exec picframe_scale.sh "{}" \;
# 

sInFilename=$1; echo "$sInFilename"

pxDefaultMaxWidth=1024
pxDefaultMaxHeight=600

pxMaxWidth=${2:-$pxDefaultMaxWidth}
pxMaxHeigh=${3:-$pxDefaultMaxHeight}

frameRatio=$(( $pxMaxWidth*100/$pxMaxHeigh ))

# September 2008 St.Louis 063.JPG JPEG 3872x2592 3872x2592+0+0 8-bit DirectClass 3.713MB 0.000u 0:00.000
sGeometry=$(identify "${sInFilename}" | sed -E 's/^.*([^0-9]|^)([0-9]+x[0-9]+).*$/\2/')
pxWidth=$(echo ${sGeometry} | cut -d 'x' -f 1); echo pxWidth: $pxWidth
pxHeight=$(echo ${sGeometry} | cut -d 'x' -f 2); echo pxHeight: $pxHeight

pictureRatio=$(( $pxWidth*100/$pxHeight )); echo pictureRatio: $pictureRatio

if [[ "$pxWidth" -gt "$pxMaxWidth" ]] || \
   [[ "$pxHeight" -gt "$pxMaxHeigh" ]]; then # We only scale down, not up
	if [[ "$pictureRatio" -gt "$frameRatio" ]]; then
		echo "   Picture is wider than frame: $pictureRatio"
		convert -quality 85 -geometry ${pxMaxWidth}x "${sInFilename}" "${sInFilename}"
	else 
		echo "   Picture is higher than frame: $pictureRatio"
		convert -quality 85 -geometry x${pxMaxHeigh} "${sInFilename}" "${sInFilename}"
	fi
else
	echo "   Too small, won't resize"
fi
