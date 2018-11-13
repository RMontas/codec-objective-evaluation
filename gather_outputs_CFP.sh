#!/bin/bash

# Title: gather_outputs.sh

# Inputs: REF main_dir 

## Description:
## gathers in two files all the bit and psnr values necessary to calculate BJM and generate RD curves
 
if [[ $1 == "4DLF_I01_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I02_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I03_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I04_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I05_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I06_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I07_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I08_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I09_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I10_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I11_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I12_YUV420_8" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi
if [[ $1 == "4DLF_PVS_I01_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I02_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I03_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I04_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I05_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I06_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I07_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I08_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I09_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I10_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I11_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I12_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_I01_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I02_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I03_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I04_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I05_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I06_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I07_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I08_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I09_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I10_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I11_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I12_YUV420_8" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_PVS_I01_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I02_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I03_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I04_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I05_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I06_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I07_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I08_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I09_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I10_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I11_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I12_YUV420_8" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_I01_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I02_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I03_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I04_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I05_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I06_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I07_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I08_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I09_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I10_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I11_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_I12_YUV444_10" ]]
then
        W=9376
        H=6512
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi
if [[ $1 == "4DLF_PVS_I01_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I02_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I03_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I04_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I05_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I06_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I07_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I08_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I09_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I10_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I11_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_PVS_I12_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_I01_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I02_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I03_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I04_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I05_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I06_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I07_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I08_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I09_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I10_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I11_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_I12_YUV444_10" ]]
then
        W=8128
        H=5648
        MIR=13
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=1
fi

if [[ $1 == "4DLF_13x13_PVS_I01_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I02_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I03_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I04_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I05_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I06_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I07_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I08_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I09_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I10_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I11_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_I12_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=2
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I01_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I02_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I03_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I04_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I05_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I06_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I07_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I08_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I09_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I10_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I11_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "4DLF_13x13_PVS_SCL_I12_YUV444_10" ]]
then
        W=632
        H=440
        MIR=${3}
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_13x13_YUV444_10bpp.yuv"
        metadata=""
        representation_type=3
fi

if [[ $1 == "1BIKES" ]]
then
        W=7728
        H=5368
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I01_Bikes__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "2DANGER" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I02_Danger_de_Mort__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "3FLOWERS" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I03_Flowers__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "4STONE" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I04_Stone_Pillars_Outside__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "5VESPA" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I05_Vespa__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "6ANKY" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I06_Ankylosaurus_&_Diplodocus_1__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "7DESKTOP" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I07_Desktop__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "8MAGNETS" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I08_Magnets_1__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "9FOUNTAIN" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I09_Fountain_&_Vincent_2__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "10FRIENDS" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I10_Friends_1__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "11COLOR" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I11_Color_Chart_1__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "12ISO" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I12_ISO_Chart_12__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "1BIKES_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
        REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I01_Bikes__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "2DANGER_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I02_Danger_de_Mort__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "3FLOWERS_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I03_Flowers__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "4STONE_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I04_Stone_Pillars_Outside__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "5VESPA_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I05_Vespa__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "6ANKY_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I06_Ankylosaurus_&_Diplodocus_1__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "7DESKTOP_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I07_Desktop__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "8MAGNETS_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I08_Magnets_1__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "9FOUNTAIN_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I09_Fountain_&_Vincent_2__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "10FRIENDS_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I10_Friends_1__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "11COLOR_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I11_Color_Chart_1__Decoded.mat"
        representation_type=0
fi

if [[ $1 == "12ISO_YUV444_10" ]]
then
        W=7728
        H=5368
        MIR=15
	REF="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_YUV444_10bpp.yuv"
        metadata="/home/rmonteiro/PhD/Sequences/EPFL/I12_ISO_Chart_12__Decoded.mat"
        representation_type=0
fi


dir=$(pwd)
cd /home/rmonteiro/PhD/Sequences/EPFL
if [ $# == 4 ]
then
for qp in 17 22 27 32 37 42
do
if [ -d ${dir}/$2/$1/$qp ]; then
if [ $4 == 1 ]
then
	echo "calcMetrics_YUV420_8bpp('${REF}','${dir}/$2/$1/$qp/rec.yuv',${representation_type},$H,$W,${MIR},'${metadata}','${dir}/$2/$1/${2}_avg_psnr_views.txt'); quit;"
	/usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "calcMetrics_YUV420_8bpp('${REF}','${dir}/$2/$1/$qp/rec.yuv',${representation_type},$H,$W,${MIR},'${metadata}','${dir}/$2/$1/${2}_'); quit;"
fi
if [ $4 == 2 ]
then
	echo "calcMetrics_YUV444_10bpp('${REF}','${dir}/$2/$1/$qp/rec.yuv',${representation_type},$H,$W,${MIR},'${metadata}','${dir}/$2/$1/${2}_avg_psnr_views.txt'); quit;"
        /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "calcMetrics_YUV444_10bpp('${REF}','${dir}/$2/$1/$qp/rec.yuv',${representation_type},$H,$W,${MIR},'${metadata}','${dir}/$2/$1/${2}_'); quit;"
fi
grep bits ${dir}/$2/$1/$qp/out_${1}_${qp}.txt | awk '{sum+=$12} END {print sum}' >> ${dir}/$2/$1/${2}_bits.txt # bits		
grep bits ${dir}/$2/$1/$qp/out_${1}_${qp}.txt | wc -l
fi
done
fi

if [ $# == 5 ] # Specific QP
then
qp=$5
if [ $4 == 1 ]
then
        echo "calcMetrics_YUV420_8bpp('${REF}','${dir}/$2/$1/$qp/rec.yuv',${representation_type},$H,$W,${MIR},'${metadata}','${dir}/$2/$1/${2}_avg_psnr_views.txt'); quit;"
        /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "calcMetrics_YUV420_8bpp('${REF}','${dir}/$2/$1/$qp/rec.yuv',${representation_type},$H,$W,${MIR},'${metadata}','${dir}/$2/$1/${2}_'); quit;"
fi
if [ $4 == 2 ]
then
        echo "calcMetrics_YUV444_10bpp('${REF}','${dir}/$2/$1/$qp/rec.yuv',${representation_type},$H,$W,${MIR},'${metadata}','${dir}/$2/$1/${2}_avg_psnr_views.txt'); quit;"
        /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash -r "calcMetrics_YUV444_10bpp('${REF}','${dir}/$2/$1/$qp/rec.yuv',${representation_type},$H,$W,${MIR},'${metadata}','${dir}/$2/$1/${2}_'); quit;"
fi
grep bits ${dir}/$2/$1/$qp/out_${1}_${qp}.txt | awk '{sum+=$12} END {print sum}' >> ${dir}/$2/$1/${2}_bits.txt # bits
fi
