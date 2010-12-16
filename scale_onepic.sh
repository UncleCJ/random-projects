#!/bin/bash

#
# Bash script to scale down batches of pictures.
#
# Requires ImageMagick to be installed
#
# by Carl-Johan Sveningsson <cj.sveningsson@gmail.com>
#    August 2007
#

pxMaxMajorAxis=$1
sInFilename=$2
sOutDir=$3

sPwd=`pwd`

#DEBUG
echo sPwd=${sPwd}

# echo $pxMaxMajorAxis $sInFilename $sOutDir

sOutFilename=${sOutDir}/${sInFilename}

#DEBUG
echo ${sOutFilename}

exit 1

sGeometry=`identify ${sInFilename} | cut -d ' ' -f 3`
pxWidth=`echo ${sGeometry} | cut -d '+' -f 1 | cut -d 'x' -f 1`
pxHeight=`echo ${sGeometry} | cut -d '+' -f 1 | cut -d 'x' -f 2`

if [[ ${pxWidth} -gt ${pxHeight} ]]; then
	sOrientation="LANDSCAPE"
else
	sOrientation="PORTRAIT"
fi

echo "${sInFilename} is ${pxWidth} wide and ${pxHeight} high, thus is ${sOrientation}"

if [[ ${sOrientation} = "LANDSCAPE" ]]; then
	if [[ ${pxWidth} -gt ${pxMaxMajorAxis} ]]; then
		convert -quality 85 -geometry ${pxMaxMajorAxis}x "${sInFilename}" "${sOutFilename}"
		touch -r "${sInFilename}" "${sOutFilename}"
	else
		cp -p "${sInFilename}" "${sOutFilename}"
	fi
# ${sOrientation} = "PORTRAIT"
else
	if [[ ${pxHeight} -gt ${pxMaxMajorAxis} ]]; then
		convert -quality 85 -geometry x${pxMaxMajorAxis} "${sInFilename}" "${sOutFilename}"
		touch -r "${sInFilename}" "${sOutFilename}"
	else
		cp -p "${sInFilename}" "${sOutFilename}"
	fi
fi