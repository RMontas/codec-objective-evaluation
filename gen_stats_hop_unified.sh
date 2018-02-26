#!/bin/bash

# Title: gen_stats.sh

# Inputs: main_dir_name SEQ


declare -a std=("LAURA" "SEAGULL" "PT0" "PT150" "DS" "DC")
declare -a std_rect=("LAURA_RECT" "SEAGULL_RECT" "PT0_RECT" "PT150_RECT" "DS_RECT" "DC_RECT")
declare -a epfl=("")
declare -a fast=("PT150_FAST")

if [ $2 == "STD" ]
then
for i in "${std[@]}"
do
if [ $i == "LAURA" ]
then
        W=7240
        H=5432
        MIR=75
        SEQ="/home/rmonteiro/PhD/Sequences/Georgiev/Laura_7240x5432_25p.yuv"
fi

if [ $i == "SEAGULL" ]
then
        W=7240
        H=5432
        MIR=75
        SEQ="/home/rmonteiro/PhD/Sequences/Georgiev/Seagull_7240x5432_25p.yuv"
fi

if [ $i == "DS" ]
then
        W=2880
        H=1620
        MIR=38
        SEQ="/home/rmonteiro/PhD/Sequences/DemichelisSpark/DemichelisSpark_2880x1620_25p.yuv"
fi

if [ $i == "DC" ]
then
        W=2880
        H=1620
        MIR=38
        SEQ="/home/rmonteiro/PhD/Sequences/DemichelisCut/DemichelisCut_2880x1620_25p.yuv"
fi

if [ $i == "PT0" ]
then
        W=1920
        H=1088
        MIR=28
        SEQ="/home/rmonteiro/PhD/Sequences/PlaneAndToy/PlaneAndToy_1920x1088_25p.yuv"
fi

if [ $i == "PT150" ]
then
        W=1920
        H=1088
        MIR=28
        SEQ="/home/rmonteiro/PhD/Sequences/PlaneAndToy/PlaneAndToy_1920x1088_25p.yuv"
        FO=150
fi

for qp in 22 27 32 37
do
if [ -f "$1/$i/$qp/TraceEnc.txt" ]; then
grep -v "="  $1/$i/$qp/TraceEnc.txt | grep -v "\-\-" | grep -v NAL | grep -v nuh | grep -v nal | grep -v BITS > $1/$i/$qp/TraceEnc_clean.txt
cp AnalyseTraceFile_HOP_unified.m $1/$i/$qp
cp yuv_export.m $1/$i/$qp
cp yuv_import.m $1/$i/$qp
cd $1/$i/$qp
/usr/local/MATLAB/R2015a/bin/matlab -nodesktop -nosplash -r "AnalyseTraceFile_HOP_unified(${W},${H});quit;" > outMATLAB.txt
cd ../../../
fi
done
done

elif [ $2 == "FAST" ]
then
for i in "${fast[@]}"
do
if [ $i == "PT150_FAST" ]
then
        W=176
        H=144
        MIR=28
        SEQ="/home/rmonteiro/PhD/Sequences/Fast/PlaneAndToy_176x144_frame150.yuv"
fi
for qp in 22 27 32 37
do
if [ -f "$1/$i/$qp/TraceEnc.txt" ]; then
grep -v "="  $1/$i/$qp/TraceEnc.txt | grep -v "\-\-" | grep -v NAL | grep -v nuh | grep -v nal | grep -v BITS > $1/$i/$qp/TraceEnc_clean.txt
cp AnalyseTraceFile_HOP_unified.m $1/$i/$qp
cp yuv_export.m $1/$i/$qp
cp yuv_import.m $1/$i/$qp
cd $1/$i/$qp
/usr/local/MATLAB/R2015a/bin/matlab -nodesktop -nosplash -r "AnalyseTraceFile_HOP_unified(${W},${H});quit;" > outMATLAB.txt
cd ../../../
fi
done
done
else
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
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I01_Bikes.yuv"
fi

if [ $2 == "2DANGER" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I02_Danger_de_Mort.yuv"
fi

if [ $2 == "3FLOWERS" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I03_Flowers.yuv"
fi

if [ $2 == "4STONE" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I04_Stone_Pillars_Outside.yuv"
fi

if [ $2 == "5VESPA" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I05_Vespa.yuv"
fi

if [ $2 == "6ANKY" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I06_Ankylosaurus_&_Diplodocus_1.yuv"
fi
if [ $2 == "7DESKTOP" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I07_Desktop.yuv"
fi

if [ $2 == "8MAGNETS" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I08_Magnets_1.yuv"
fi

if [ $2 == "9FOUNTAIN" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I09_Fountain_&_Vincent_2.yuv"
fi

if [ $2 == "10FRIENDS" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I10_Friends_1.yuv"
fi

if [ $2 == "11COLOR" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I11_Color_Chart_1.yuv"
fi

if [ $2 == "12ISO" ]
then
        W=7728
        H=5368
        MIR=15
        SEQ="/home/rmonteiro/PhD/Sequences/EPFL/I12_ISO_Chart_12.yuv"
fi
for qp in 22 27 32 37
do
if [ -f "$1/$2/$qp/TraceEnc.txt" ]; then
grep -v "="  $1/$2/$qp/TraceEnc.txt | grep -v "\-\-" | grep -v NAL | grep -v nuh | grep -v nal | grep -v BITS > $1/$2/$qp/TraceEnc_clean.txt
cp AnalyseTraceFile_HOP_unified.m $1/$2/$qp
cp yuv_export.m $1/$2/$qp
cp yuv_import.m $1/$2/$qp
cd $1/$2/$qp
/usr/local/MATLAB/R2015a/bin/matlab -nodesktop -nosplash -r "AnalyseTraceFile_HOP_unified(${W},${H});quit;" > outMATLAB.txt
cd ../../../
fi
done

fi
