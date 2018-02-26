#!/bin/bash

# Title: gen_results_codecs_and_representation.sh 

# Inputs: SEQ_main_dir_MY main_dir_MY SEQ_main_dir_REF main_dir_REF bitrates_flag type_of_psnr

## Description:
## runs matlab script BJM
## runs python script RD Curves
## diff to gen_results.sh -> this one accepts specific sequences from the reference and MY, therefore it allows the comparison of different representations for different/equal codecs

if [ $6 == 0 ] # GLOBAL PSNR
then
	mkdir res_${1}_${2}_vs_${3}_${4}
	/usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "run_bjm('${2}/${1}/${2}_bits.txt','$2/$1/${2}_psnr.txt','$4/$3/${4}_bits.txt','$4/$3/${4}_psnr.txt','res_${1}_${2}_vs_${3}_${4}/bjm.txt', $5); quit;"
	mkdir res_rd_curves_${1}_${2}_vs_${3}_${4}
fi

if [ $6 == 1 ] # AVG PSNR Y (views)
then
        mkdir res_PSNR_Y_${1}_${2}_vs_${3}_${4}
        /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "run_bjm('${2}/${1}/${2}_bits.txt','$2/$1/${2}_avg_psnr_y.txt','$4/$3/${4}_bits.txt','$4/$3/${4}_avg_psnr_y.txt','res_PSNR_Y_${1}_${2}_vs_${3}_${4}/bjm.txt', $5); quit;"
        mkdir res_rd_curves_PSNR_Y_${1}_${2}_vs_${3}_${4}
fi

if [ $6 == 2 ] # AVG PSNR YUV (views)
then
        mkdir res_PSNR_YUV_${1}_${2}_vs_${3}_${4}
        /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "run_bjm('${2}/${1}/${2}_bits.txt','$2/$1/${2}_avg_psnr_yuv.txt','$4/$3/${4}_bits.txt','$4/$3/${4}_avg_psnr_yuv.txt','res_PSNR_YUV_${1}_${2}_vs_${3}_${4}/bjm.txt', $5); quit;"
        mkdir res_rd_curves_PSNR_YUV_${1}_${2}_vs_${3}_${4}
fi

echo "python run_RD_curves_codecs_and_representation.py $1 $2 $3 $4 $6"
python run_RD_curves_codecs_and_representation.py $1 $2 $3 $4 $6


