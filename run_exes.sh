#!/bin/bash

# Title: run_exes.sh

# Inputs: main_dir_name SEQ flag_original_HEVC

## Description:
## Runs all executables generated by "gen_dirs_and_exes.sh" using the defined directory structure. 
## The flag_original_HEVC defines the configuration file that is being used .

CFG="/home/rmonteiro/PhD/jctvc-hm/cfg/3DHencoder_intra_main.cfg"
CFG_HEVC_ORIG="/home/rmonteiro/PhD/hm-16.5/cfg/encoder_intra_main.cfg"
CFG_HEVC_INTER_P="/home/rmonteiro/PhD/hm-16.5/cfg/encoder_lowdelay_P_main.cfg"
#CFG_HEVC_INTER_B="/home/rmonteiro/PhD/hm-16.5/cfg/encoder_lowdelay_main.cfg"
CFG_HEVC_INTER_B="/home/rmonteiro/PhD/hm-16.9/cfg/encoder_lowdelay_main.cfg"
CFG_HEVC_ALL_INTRA="/home/rmonteiro/PhD/hm-16.5/cfg/encoder_lowdelay_P_main_ALL_INTRA.cfg"

CFG_HEVC_REXT_INTER_B="/home/rmonteiro/PhD/hm-16.9/cfg/encoder_lowdelay_main_rext.cfg"

FO=0

if [ $2 == "PT150_FAST" ]
then
        W=176
        H=144
        MIR=28
        SEQ="/home/rmonteiro/PhD/Sequences/Fast/PlaneAndToy_176x144_frame150.yuv"
fi

if [ $2 == "LAURA" ]
then
	W=7240
	H=5432
	MIR=75
	SEQ="/home/rmonteiro/PhD/Sequences/Georgiev/Laura_7240x5432_25p.yuv"
fi

if [ $2 == "SEAGULL" ]
then
        W=7240
        H=5432
        MIR=75
        SEQ="/home/rmonteiro/PhD/Sequences/Georgiev/Seagull_7240x5432_25p.yuv"
fi

if [ $2 == "DS" ]
then
	W=2880
	H=1620
	MIR=38
	SEQ="/home/rmonteiro/PhD/Sequences/DemichelisSpark/DemichelisSpark_2880x1620_25p.yuv"
fi

if [ $2 == "DC" ]
then
        W=2880
        H=1620
        MIR=38
	SEQ="/home/rmonteiro/PhD/Sequences/DemichelisCut/DemichelisCut_2880x1620_25p.yuv"
fi

if [ $2 == "PT0" ]
then
	W=1920
	H=1088
	MIR=28
	SEQ="/home/rmonteiro/PhD/Sequences/PlaneAndToy/PlaneAndToy_1920x1088_25p.yuv"
fi

if [ $2 == "PT150" ]
then
        W=1920
        H=1088
        MIR=28
        SEQ="/home/rmonteiro/PhD/Sequences/PlaneAndToy/PlaneAndToy_1920x1088_25p.yuv"
	FO=150
fi

if [ $2 == "LAURA_RECT" ]
then
        W=7200
        H=5400
        MIR=75
        SEQ="/home/rmonteiro/PhD/Sequences/RENDERING_RESULTS_Q-PEL/RenderingResults_Laura/arrayMIraster_Laura_7200x5400.yuv"
fi

if [ $2 == "SEAGULL_RECT" ]
then
        W=7200
        H=5400
        MIR=75
        SEQ="/home/rmonteiro/PhD/Sequences/RENDERING_RESULTS_Q-PEL/RenderingResults_Seagull/arrayMIraster_Seagull_7200x5400.yuv"
fi

if [ $2 == "DS_RECT" ]
then
        W=2850
        H=1558
        MIR=38
        SEQ="/home/rmonteiro/PhD/Sequences/DemichelisSpark/rect_Demichelis_spark_2850x1558_150frames.yuv"
fi

if [ $2 == "DC_RECT" ]
then
        W=2850
        H=1558
        MIR=38
        SEQ="/home/rmonteiro/PhD/Sequences/DemichelisCut/rect_Demichelis_cut_2850x1558_150frames.yuv"
fi

if [ $2 == "PT0_RECT" ]
then
        W=1904
        H=1064
        MIR=28
        SEQ="/home/rmonteiro/PhD/Sequences/PlaneAndToy/rect_planeToyFrame500to749_1904x1064_rotated_180.yuv"
fi

if [ $2 == "PT150_RECT" ]
then
        W=1904
        H=1064
        MIR=28
        SEQ="/home/rmonteiro/PhD/Sequences/PlaneAndToy/rect_planeToyFrame500to749_1904x1064_rotated_180.yuv"
        FO=150
fi

if [ $2 == "1BIKES" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I01_Bikes.yuv"
fi

if [ $2 == "2DANGER" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I02_Danger_de_Mort.yuv"
fi

if [ $2 == "3FLOWERS" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I03_Flowers.yuv"
fi

if [ $2 == "4STONE" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I04_Stone_Pillars_Outside.yuv"
fi

if [ $2 == "5VESPA" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I05_Vespa.yuv"
fi

if [ $2 == "6ANKY" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I06_Ankylosaurus_&_Diplodocus_1.yuv"
fi

if [ $2 == "7DESKTOP" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I07_Desktop.yuv"
fi

if [ $2 == "8MAGNETS" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I08_Magnets_1.yuv"
fi

if [ $2 == "9FOUNTAIN" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I09_Fountain_&_Vincent_2.yuv"
fi

if [ $2 == "10FRIENDS" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I10_Friends_1.yuv"
fi

if [ $2 == "11COLOR" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I11_Color_Chart_1.yuv"
fi

if [ $2 == "12ISO" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/pre_gen_lenslet/YUV420_8bpp/I12_ISO_Chart_12.yuv"
fi

if [ $2 == "4DLF_I01_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I02_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I03_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I04_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I05_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I06_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I07_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I08_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I09_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I10_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I11_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_I12_YUV420_8" ]
then
        W=9376
        H=6512
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I01_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I01_Bikes__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I02_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I02_Danger_de_Mort__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I03_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I03_Flowers__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I04_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I04_Stone_Pillars_Outside__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I05_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I05_Vespa__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I06_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I06_Ankylosaurus_&_Diplodocus_1__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I07_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I07_Desktop__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I08_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I08_Magnets_1__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I09_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I09_Fountain_&_Vincent_2__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I10_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I10_Friends_1__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I11_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I11_Color_Chart_1__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_PVS_I12_YUV420_8" ]
then
        W=632
        H=440
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I12_ISO_Chart_12__Decoded_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I01_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I01_Bikes__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I02_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I02_Danger_de_Mort__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I03_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I03_Flowers__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I04_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I04_Stone_Pillars_Outside__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I05_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I05_Vespa__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I06_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I06_Ankylosaurus_&_Diplodocus_1__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I07_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I07_Desktop__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I08_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I08_Magnets_1__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I09_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I09_Fountain_&_Vincent_2__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I10_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I10_Friends_1__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I11_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I11_Color_Chart_1__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_I12_YUV420_8" ]
then
        W=8128
        H=5648
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_MI/I12_ISO_Chart_12__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I01_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I01_Bikes__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I02_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I02_Danger_de_Mort__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I03_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I03_Flowers__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I04_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I04_Stone_Pillars_Outside__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I05_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I05_Vespa__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I06_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I06_Ankylosaurus_&_Diplodocus_1__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I07_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I07_Desktop__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I08_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I08_Magnets_1__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I09_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I09_Fountain_&_Vincent_2__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I10_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I10_Friends_1__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I11_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I11_Color_Chart_1__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I12_YUV420_8" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I12_ISO_Chart_12__Decoded_13x13_YUV420_8bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I01_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I01_Bikes__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I02_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I02_Danger_de_Mort__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I03_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I03_Flowers__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I04_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I04_Stone_Pillars_Outside__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I05_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I05_Vespa__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I06_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I06_Ankylosaurus_&_Diplodocus_1__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I07_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I07_Desktop__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I08_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I08_Magnets_1__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I09_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I09_Fountain_&_Vincent_2__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I10_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I10_Friends_1__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I11_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I11_Color_Chart_1__Decoded_13x13_YUV444_10bpp.yuv"
fi

if [ $2 == "4DLF_13x13_PVS_I12_YUV444_10" ]
then
        W=632
        H=440
        MIR=13
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/4DLF_PVS/I12_ISO_Chart_12__Decoded_13x13_YUV444_10bpp.yuv"
fi

for qp in 22 27 32 37
do
	cd $1/$2/$qp 
	if [ $3 == 0 ] # HEVC-SS based
	then
       		./TAppEncoderStatic -c $CFG -i $SEQ -f 1 -mi 1 -mir $MIR -fr 25 -fs $FO -wdt $W -hgt $H -q $qp -sr 128 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt &
	fi
	if [ $3 == 1 ] # HEVC Intra
	then
		./TAppEncoderStatic -c $CFG_HEVC_ORIG -i $SEQ -f 1 -fr 25 -fs $FO -wdt $W -hgt $H -q $qp -sr 128 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt &
	fi
	if [ $3 == 5 ] # HEVC-SS based series
        then
                ./TAppEncoderStatic -c $CFG -i $SEQ -f 1 -mi 1 -mir $MIR -fr 25 -fs $FO -wdt $W -hgt $H -q $qp -sr 128 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt
        fi
	if [ $3 == 2 ] # HEVC Inter P
        then
                ./TAppEncoderStatic -c $CFG_HEVC_INTER_P -i $SEQ -fr 25 -fs $FO -f $4 -wdt $W -hgt $H -q $qp -sr 128 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt &
        fi
	if [ $3 == 3 ] # HEVC All Intra
        then
                ./TAppEncoderStatic -c $CFG_HEVC_ALL_INTRA -i $SEQ -fr 25 -fs $FO -f $4 -wdt $W -hgt $H -q $qp -sr 128 -ip 1 -g 1 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt &
        fi
	if [ $3 == 4 ] # HEVC Inter B
        then
                ./TAppEncoderStatic -c $CFG_HEVC_INTER_B -i $SEQ -fr 25 -fs $FO -f $4 -wdt $W -hgt $H -q $qp -sr 128 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt &
        fi
	if [ $3 == 6 ] # HEVC Inter B YUV444_10 (!search window 64!)
        then
                ./TAppEncoderStatic -c $CFG_HEVC_REXT_INTER_B -i $SEQ -fr 25 -fs $FO -f $4 -wdt $W -hgt $H -q $qp -sr 64 --InputChromaFormat=444 --ChromaFormatIDC=444 --InputBitDepth=10 --OutputBitDepth=10 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt &
        fi

	cd ../../../
done

if [ $3 -ge 7 ]
then
	#cd $1/$2/$4
	#./TAppEncoderStatic -c $CFG -i $SEQ -f 1 -mi 1 -mir $MIR -fr 25 -fs $FO -wdt $W -hgt $H -q $4 -sr 128 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${3}.txt &
	#./TAppEncoderStatic -c $CFG_HEVC_ORIG -i $SEQ -f 1 -fr 25 -fs $FO -wdt $W -hgt $H -q $4 -sr 128 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt &
	cd $1/$2/$6
	./TAppEncoderStatic -c $CFG_HEVC_INTER_P -i $SEQ -f 1 -fr 25 -fs $FO -f $4 -wdt $W -hgt $H -q $6 -sr 128 --ConformanceMode 1 --ConformanceWindowMode 1 &> out_${2}_${qp}.txt &
	cd ../../../
fi
