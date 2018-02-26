#!/bin/bash

# Title: gather_outputs.sh

# Inputs: SEQ main_dir

## Description:
## gathers in two files all the bit and psnr values necessary to calculate BJM and generate RD curves
 
for qp in 17 22 27 32 37 42
do
	if [ -f $2/$1/$qp/gtVectTmp  ]; then
		grep POC $2/$1/$qp/out_${1}_${qp}.txt | awk '{print $12}' > $2/$1/${2}_bits.tmp
		grep -B1 POC $2/$1/$qp/out_${1}_${qp}.txt | grep -v POC | awk '{print $11}' >> $2/$1/${2}_bits.tmp
		awk '{s+=$1} END {print s}' $2/$1/${2}_bits.tmp >> $2/$1/${2}_bits.txt # bits
		rm $2/$1/${2}_bits.tmp
	else
		grep POC $2/$1/$qp/out_${1}_${qp}.txt | awk '{print $12}' >> $2/$1/${2}_bits.txt # bits
	fi
        	grep POC $2/$1/$qp/out_${1}_${qp}.txt | awk '{print $15}' >> $2/$1/${2}_psnr.txt # psnr
done

