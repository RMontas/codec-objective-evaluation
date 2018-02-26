#!/bin/bash

# Title: run_exes.sh

# Inputs: main_dir_name flag

declare -a std=("LAURA" "SEAGULL" "PT0" "PT150" "DS" "DC")
declare -a std_rect=("LAURA_RECT" "SEAGULL_RECT" "PT0_RECT" "PT150_RECT" "DS_RECT" "DC_RECT")
declare -a epfl=("1BIKES" "2DANGER" "3FLOWERS" "4STONE" "5VESPA" "6ANKY" "7DESKTOP" "8MAGNETS" "9FOUNTAIN" "10FRIENDS" "11COLOR" "12ISO")
declare -a fast=("PT150_FAST")

if [ flag == "ALL" ]
then
for i in "${std[@]}"
do
for qp in 22 27 32 37
do
       # cp $2 $1/$i/$qp
	cd $1/$i/$qp
	./TAppDecoderStatic -b bitstream -o rec_dec.yuv
	echo "${i} ${qp}" >> ../../diff_dec_enc.txt 
	diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
	cd ../../../
done
done

for i in "${std_rect[@]}"
do
for qp in 22 27 32 37
do
	#cp $2 $1/$i/$qp
        cd $1/$i/$qp
        ./TAppDecoderStatic -b bitstream -o rec_dec.yuv
	echo "${i} ${qp}" >> ../../diff_dec_enc.txt
	diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
        cd ../../../
done
done

for i in "${epfl[@]}"
do
for qp in 22 27 32 37
do
        #cp $2 $1/$i/$qp
        cd $1/$i/$qp
        ./TAppDecoderStatic -b bitstream -o rec_dec.yuv
	echo "${i} ${qp}" >> ../../diff_dec_enc.txt
	diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
        cd ../../../
done
done

for i in "${fast[@]}"
do
for qp in 22 27 32 37
do
        #cp $2 $1/$i/$qp
        cd $1/$i/$qp
        ./TAppDecoderStatic -b bitstream -o rec_dec.yuv
	echo "${i} ${qp}" >> ../../diff_dec_enc.txt
	diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
        cd ../../../
done
done
fi 

if [ flag != "ALL" ]
then
if [ flag == "STD" ]
then
for i in "${std[@]}"
do
for qp in 22 27 32 37
do
       # cp $2 $1/$i/$qp
        cd $1/$i/$qp
        ./TAppDecoderStatic -b bitstream -o rec_dec.yuv
        echo "${i} ${qp}" >> ../../diff_dec_enc.txt 
        diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
        cd ../../../
done
done
elif [ flag == "RECT" ]
then
for i in "${std_rect[@]}"
do
for qp in 22 27 32 37
do
        #cp $2 $1/$i/$qp
        cd $1/$i/$qp
        ./TAppDecoderStatic -b bitstream -o rec_dec.yuv
        echo "${i} ${qp}" >> ../../diff_dec_enc.txt
        diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
        cd ../../../
done
done
elif [ flag == "EPFL" ]
then
for i in "${epfl[@]}"
do
for qp in 22 27 32 37
do
        #cp $2 $1/$i/$qp
        cd $1/$i/$qp
        ./TAppDecoderStatic -b bitstream -o rec_dec.yuv
        echo "${i} ${qp}" >> ../../diff_dec_enc.txt
        diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
        cd ../../../
done
done
elif [ flag == "FAST" ]
then
for i in "${fast[@]}"
do
for qp in 22 27 32 37
do
        #cp $2 $1/$i/$qp
        cd $1/$i/$qp
        ./TAppDecoderStatic -b bitstream -o rec_dec.yuv
        echo "${i} ${qp}" >> ../../diff_dec_enc.txt
        diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
        cd ../../../
done
done
else
for qp in 22 27 32 37
do
        #cp $2 $1/$i/$qp
        cd $1/$2/$qp
        ./TAppDecoderStatic -b bitstream -o rec_dec.yuv
        echo "${2} ${qp}" >> ../../diff_dec_enc.txt
        diff rec_dec.yuv rec.yuv >> ../../diff_dec_enc.txt
        cd ../../../
done

fi
fi


