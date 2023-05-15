#!/bin/bash
id=$(xinput list | grep AT | grep -Po '(?<=id=)[0-9]{2}')
echo $id
if [ $(xinput list | grep Mec --count) -eq 0 ]; then
	reattach $id $3
else
	xinput float $id
fi
	

