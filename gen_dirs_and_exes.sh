#!/bin/bash

# Title: gen_dirs_and_exes.sh

# Inputs: main_dir_name SEQ exe_dir

## Description: 
## generates directory structure and executables to run HEVC tests:
### main_dir:
#### SEQ:
##### QP0:
###### output_files
###### exe
##### QP1:
###### output_files
###### exe
##### QPx:
##### ...

declare -a std=("LAURA" "SEAGULL" "PT0" "PT150" "DS" "DC")
declare -a std_rect=("LAURA_RECT" "SEAGULL_RECT" "PT0_RECT" "PT150_RECT" "DS_RECT" "DC_RECT")
declare -a epfl=("1BIKES" "2DANGER" "3FLOWERS" "4STONE" "5VESPA" "6ANKY" "7DESKTOP" "8MAGNETS" "9FOUNTAIN" "10FRIENDS" "11COLOR" "12ISO")
declare -a epfl_yuv444_10=("1BIKES_YUV444_10" "2DANGER_YUV444_10" "3FLOWERS_YUV444_10" "4STONE_YUV444_10" "5VESPA_YUV444_10" "6ANKY_YUV444_10" "7DESKTOP_YUV444_10" "8MAGNETS_YUV444_10" "9FOUNTAIN_YUV444_10" "10FRIENDS_YUV444_10" "11COLOR_YUV444_10" "12ISO_YUV444_10")
declare -a fast=("PT150_FAST")
declare -a epfl_4dlf_yuv420_8=("4DLF_I01_YUV420_8" "4DLF_I02_YUV420_8" "4DLF_I03_YUV420_8" "4DLF_I04_YUV420_8" "4DLF_I05_YUV420_8" "4DLF_I06_YUV420_8" "4DLF_I07_YUV420_8" "4DLF_I08_YUV420_8" "4DLF_I09_YUV420_8" "4DLF_I10_YUV420_8" "4DLF_I11_YUV420_8" "4DLF_I12_YUV420_8")
declare -a epfl_4dlf_pvs_yuv420_8=("4DLF_PVS_I01_YUV420_8" "4DLF_PVS_I02_YUV420_8" "4DLF_PVS_I03_YUV420_8" "4DLF_PVS_I04_YUV420_8" "4DLF_PVS_I05_YUV420_8" "4DLF_PVS_I06_YUV420_8" "4DLF_PVS_I07_YUV420_8" "4DLF_PVS_I08_YUV420_8" "4DLF_PVS_I09_YUV420_8" "4DLF_PVS_I10_YUV420_8" "4DLF_PVS_I11_YUV420_8" "4DLF_PVS_I12_YUV420_8")
declare -a epfl_4dlf_13x13_yuv420_8=("4DLF_13x13_I01_YUV420_8" "4DLF_13x13_I02_YUV420_8" "4DLF_13x13_I03_YUV420_8" "4DLF_13x13_I04_YUV420_8" "4DLF_13x13_I05_YUV420_8" "4DLF_13x13_I06_YUV420_8" "4DLF_13x13_I07_YUV420_8" "4DLF_13x13_I08_YUV420_8" "4DLF_13x13_I09_YUV420_8" "4DLF_13x13_I10_YUV420_8" "4DLF_13x13_I11_YUV420_8" "4DLF_13x13_I12_YUV420_8")
declare -a epfl_4dlf_13x13_yuv444_10=("4DLF_13x13_I01_YUV444_10" "4DLF_13x13_I02_YUV444_10" "4DLF_13x13_I03_YUV444_10" "4DLF_13x13_I04_YUV444_10" "4DLF_13x13_I05_YUV444_10" "4DLF_13x13_I06_YUV444_10" "4DLF_13x13_I07_YUV444_10" "4DLF_13x13_I08_YUV444_10" "4DLF_13x13_I09_YUV444_10" "4DLF_13x13_I10_YUV444_10" "4DLF_13x13_I11_YUV444_10" "4DLF_13x13_I12_YUV444_10")
declare -a epfl_4dlf_13x13_pvs_yuv420_8=("4DLF_13x13_PVS_I01_YUV420_8" "4DLF_13x13_PVS_I02_YUV420_8" "4DLF_13x13_PVS_I03_YUV420_8" "4DLF_13x13_PVS_I04_YUV420_8" "4DLF_13x13_PVS_I05_YUV420_8" "4DLF_13x13_PVS_I06_YUV420_8" "4DLF_13x13_PVS_I07_YUV420_8" "4DLF_13x13_PVS_I08_YUV420_8" "4DLF_13x13_PVS_I09_YUV420_8" "4DLF_13x13_PVS_I10_YUV420_8" "4DLF_13x13_PVS_I11_YUV420_8" "4DLF_13x13_PVS_I12_YUV420_8")
declare -a epfl_4dlf_13x13_pvs_yuv444_10=("4DLF_13x13_PVS_I01_YUV444_10" "4DLF_13x13_PVS_I02_YUV444_10" "4DLF_13x13_PVS_I03_YUV444_10" "4DLF_13x13_PVS_I04_YUV444_10" "4DLF_13x13_PVS_I05_YUV444_10" "4DLF_13x13_PVS_I06_YUV444_10" "4DLF_13x13_PVS_I07_YUV444_10" "4DLF_13x13_PVS_I08_YUV444_10" "4DLF_13x13_PVS_I09_YUV444_10" "4DLF_13x13_PVS_I10_YUV444_10" "4DLF_13x13_PVS_I11_YUV444_10" "4DLF_13x13_PVS_I12_YUV444_10")

mkdir $1 

if [ $2 == "STD" ] 
then

for i in "${std[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
	mkdir $1/$i/$qp
	cp $3/TAppEncoderStatic $1/$i/$qp
	cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi
 
if [ $2 == "STD_RECT" ]
then

for i in "${std_rect[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
	cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL" ]
then

for i in "${epfl[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
	cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL_YUV444_10" ]
then

for i in "${epfl_yuv444_10[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL_4DLF_YUV420_8" ]
then    

for i in "${epfl_4dlf_yuv420_8[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL_4DLF_YUV444_10" ]
then

for i in "${epfl_4dlf_yuv444_10[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL_4DLF_PVS_YUV420_8" ]
then

for i in "${epfl_4dlf_pvs_yuv420_8[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL_4DLF_13x13_YUV420_8" ]
then

for i in "${epfl_4dlf_13x13_yuv420_8[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL_4DLF_13x13_YUV444_10" ]
then

for i in "${epfl_4dlf_13x13_yuv444_10[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL_4DLF_13x13_PVS_YUV420_8" ]
then

for i in "${epfl_4dlf_13x13_pvs_yuv420_8[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "EPFL_4DLF_13x13_PVS_YUV444_10" ]
then

for i in "${epfl_4dlf_13x13_pvs_yuv444_10[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi



if [ $2 == "FAST" ]
then

for i in "${fast[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
	cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi

if [ $2 == "ALL" ]
then
for i in "${std[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
for i in "${fast[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
for i in "${epfl[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
for i in "${std_rect[@]}"
do
mkdir $1/$i
for qp in 22 27 32 37
do
        mkdir $1/$i/$qp
        cp $3/TAppEncoderStatic $1/$i/$qp
        cp $3/TAppDecoderStatic $1/$i/$qp
done
done
fi


