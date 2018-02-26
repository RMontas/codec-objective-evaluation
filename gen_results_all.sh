#!/bin/bash

# Title: gen_results.sh

# Inputs: SEQ main_dir_MY main_dir_REF0 main_dir_REF1 flag_ref bitrates_flag

## Description:
## runs matlab script BJM
## runs python script RD Curves
declare -a arr=("1BIKES" "2DANGER" "3FLOWERS" "4STONE" "5VESPA" "6ANKY" "7DESKTOP" "8MAGNETS" "9FOUNTAIN" "10FRIENDS" "11COLOR" "12ISO")

for i in "${arr[@]}"
do
echo $i
mkdir res_${i}_${3}_vs_${2}
#/usr/local/MATLAB/R2015a/bin/matlab -nodesktop -nosplash -r "run_bjm('${3}/${i}/${3}_bits.txt','$3/$i/${3}_psnr.txt','$2/$i/${2}_bits.txt','$2/$i/${2}_psnr.txt','res_${i}_${3}_vs_${2}/bjm.txt');quit;"
if [ $5 == 1 ]
then
	mkdir res_${i}_${4}_vs_${2}
	/usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "run_bjm('${3}/${i}/${3}_bits.txt','${3}/${i}/${3}_psnr.txt','${2}/${i}/${2}_bits.txt','${2}/${i}/${2}_psnr.txt','res_${i}_${3}_vs_${2}/bjm.txt', $6); run_bjm('$4/$i/${4}_bits.txt','$4/$i/${4}_psnr.txt','$2/$i/${2}_bits.txt','$2/$i/${2}_psnr.txt','res_${i}_${4}_vs_${2}/bjm.txt', $6); run_bjm('$3/$i/${3}_bits.txt','$3/$i/${3}_psnr.txt','$4/$i/${4}_bits.txt','$4/$i/${4}_psnr.txt','res_${i}_${3}_vs_${4}/bjm.txt', $6); quit;"
	mkdir res_${i}_${3}_vs_${4}
	#/usr/local/MATLAB/R2015a/bin/matlab -nodesktop -nosplash -r "run_bjm('$3/$i/${3}_bits.txt','$3/$i/${3}_psnr.txt','$4/$i/${4}_bits.txt','$4/$i/${4}_psnr.txt','res_${i}_${3}_vs_${4}/bjm.txt');quit;"
fi

if [ $5 == 1 ]
then
	mkdir res_rd_curves_${i}_${3}_vs_${2}_vs_${4}
else
	mkdir res_rd_curves_${i}_${3}_vs_${2}
fi
python run_RD_curves.py $i $2 $3 $4 $5
done




