#!/bin/bash

totalBits="$(grep "BITS" TraceEnc.txt | awk '{print $4}' | awk '{s+=$1} END {print s}')"

# general flags
splitCuFlagBits="$(grep "BITS" TraceEnc.txt | grep "split_cu_flag" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
splitCuFlagCount="$(grep "split_cu_flag " TraceEnc.txt | wc -l)"

# pred mode INTRA / INTER
predModeFlagBits="$(grep "BITS" TraceEnc.txt | grep "pred_mode_flag" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
predModeFlagCount="$(grep "pred_mode_flag " TraceEnc.txt | wc -l)"
predModeFlag0Count="$(grep "pred_mode_flag " TraceEnc.txt | grep ": 0" | wc -l)"
predModeFlag1Count="$(grep "pred_mode_flag " TraceEnc.txt | grep ": 1" | wc -l)"

# intra modes
remIntraLumaPredModeBits="$(grep "BITS" TraceEnc.txt | grep "rem_intra_luma_pred_mode"  | awk '{print $4}' | awk '{s+=$1} END {print s}')"
remIntraLumaPredModeCount="$(grep "rem_intra_luma_pred_mode " TraceEnc.txt | wc -l)"
for i in {0..34}
do
        remIntraLumaPredModeUsage[$i]="$(grep "rem_intra_luma_pred_mode " TraceEnc.txt | grep ": $i" | wc -l)"
done
# inter modes
mvpL0FlagBits="$(grep "BITS" TraceEnc.txt | grep "mvp_l0_flag" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
mvpL0FlagCount="$(grep "mvp_l0_flag " TraceEnc.txt | wc -l)"
partModeBits="$(grep "BITS" TraceEnc.txt | grep "part_mode" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
partModeCount="$(grep "part_mode " TraceEnc.txt | wc -l)"
for i in {0..7} 
do
	partModeUsage[$i]="$( grep "part_mode " TraceEnc.txt | grep ": $i" | wc -l)"
done
cuSkipFlagBits="$(grep "BITS" TraceEnc.txt | grep "cu_skip_flag" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
cuSkipFlagCount="$(grep "cu_skip_flag " TraceEnc.txt | wc -l)"
mergeFlagBits="$(grep "BITS" TraceEnc.txt | grep "merge_flag"  | awk '{print $4}' | awk '{s+=$1} END {print s}')"
mergeFlagCount="$(grep "merge_flag " TraceEnc.txt | wc -l)"
mergeIdxBits="$(grep "BITS" TraceEnc.txt | grep "merge_idx" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
mergeIdxCount="$(grep "merge_idx " TraceEnc.txt | wc -l)"
for i in {0..4} 
do
        mergeIdxUsage[$i]="$(grep "merge_idx " TraceEnc.txt | grep ": $i" | wc -l)"
done
# SS
mvdL0XBits="$(grep "BITS" TraceEnc.txt | grep "mvdL0\[0\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..1024} # SR 128 
do
	vect=$(expr $i - 512)
        mvdL0XUsage[$i]="$( grep "mvdL0\[0\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
mvdL0YBits="$(grep "BITS" TraceEnc.txt | grep "mvdL0\[1\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..1024} # SR 128 
do
        vect=$(expr $i - 512)
        mvdL0YUsage[$i]="$( grep "mvdL0\[1\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
# GT
gtFlagBits="$(grep "BITS" TraceEnc.txt | grep "GTFLAG" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
mvGT0XBits="$(grep "BITS" TraceEnc.txt | grep "mvGT0\[0\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..32} # NSS=5  
do
        vect=$(expr $i - 16)
        mvGT0XUsage[$i]="$( grep "mvGT0\[0\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
mvGT0YBits="$(grep "BITS" TraceEnc.txt | grep "mvGT0\[1\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..32} # NSS=5  
do
        vect=$(expr $i - 16)
        mvGT0YUsage[$i]="$( grep "mvGT0\[1\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
mvGT1XBits="$(grep "BITS" TraceEnc.txt | grep "mvGT1\[0\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..32} # NSS=5  
do
        vect=$(expr $i - 16)
        mvGT1XUsage[$i]="$( grep "mvGT1\[0\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
mvGT1YBits="$(grep "BITS" TraceEnc.txt | grep "mvGT1\[1\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..32} # NSS=5  
do
        vect=$(expr $i - 16)
        mvGT1YUsage[$i]="$( grep "mvGT1\[1\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
mvGT2XBits="$(grep "BITS" TraceEnc.txt | grep "mvGT2\[0\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..32} # NSS=5  
do
        vect=$(expr $i - 16)
        mvGT2XUsage[$i]="$( grep "mvGT2\[0\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
mvGT2YBits="$(grep "BITS" TraceEnc.txt | grep "mvGT2\[1\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..32} # NSS=5  
do
        vect=$(expr $i - 16)
        mvGT2YUsage[$i]="$( grep "mvGT2\[1\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
mvGT3XBits="$(grep "BITS" TraceEnc.txt | grep "mvGT3\[0\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..32} # NSS=5  
do
        vect=$(expr $i - 16)
        mvGT3XUsage[$i]="$( grep "mvGT3\[0\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
mvGT3YBits="$(grep "BITS" TraceEnc.txt | grep "mvGT3\[1\]" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
for i in {0..32} # NSS=5  
do
        vect=$(expr $i - 16)
        mvGT3YUsage[$i]="$( grep "mvGT3\[1\] " TraceEnc.txt | grep ": $vect" | wc -l)"
done
ssBits="$(grep "BITS" TraceEnc.txt | grep "mvdL0" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
ssCount="$(grep "GTFLAG " TraceEnc.txt | wc -l)"
gtBits="$(grep "BITS" TraceEnc.txt | grep "mvGT" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
gtFlag0Count="$(grep "GTFLAG " TraceEnc.txt | grep ": 0" | wc -l)"
gtFlag1Count="$(grep "GTFLAG " TraceEnc.txt | grep ": 1" | wc -l)"

#residue coding
coeffNxNBits="$(grep "BITS" TraceEnc.txt | grep "CoeffNxN" | awk '{print $4}' | awk '{s+=$1} END {print s}')"
coeffNxNCount="$(grep "BITS" TraceEnc.txt | grep "CoeffNxN" | wc -l)"

echo "Total bits considered: $totalBits"
echo ""
echo "NAME: COUNT BITS (DESC) USAGE"
echo "Split CU Flags: $splitCuFlagCount $splitCuFlagBits"
echo "Prediction Mode Flag: $predModeFlagCount $predModeFlagBits (0: INTER| 1: INTRA): $predModeFlag0Count $predModeFlag1Count"
printf "Intra Mode: %s %s " "$remIntraLumaPredModeCount" "$remIntraLumaPredModeBits" 
printf "(0: PLANAR| 1: DC| 2:34: DIR| 10: HOR| 26: VER): "
for i in {0..34}
do
printf "%s " "${remIntraLumaPredModeUsage[$i]}"
done
echo ""
echo "Inter Mode"
echo "Motion Vector Predictor L0 Flag: $mvpL0FlagCount $mvpL0FlagBits"
printf "Partition Mode: %s %s (0: 2Nx2N| 1: 2NxN| 2: Nx2N| 3: NxN| 4: 2NxnU| 5: 2NxnD| 6: nLx2N| 7: nRx2N): " "$partModeCount" "$partModeBits"
for i in {0..7}
do
printf "%s " "${partModeUsage[$i]}"
done
echo ""
echo "CU Skip Flag: $cuSkipFlagCount $cuSkipFlagBits"
echo "Merge Flag: $mergeFlagCount $mergeFlagBits"
printf "Merge Index: %s %s (0: L| 1: A| 2: AL| 3: MIL| 4: MIA): " "$mergeIdxCount" "$mergeIdxBits"
for i in {0..4}
do
printf "%s " "${mergeIdxUsage[$i]}"
done
echo ""
echo "Self-Similarity"
printf "Motion Vector Difference L0 X: %s %s (-512:512): " "$ssCount" "$mvdL0XBits"
for i in {0..1024}
do
printf "%s " "${mvdL0XUsage[$i]}"
done
echo ""
printf "Motion Vector Difference L0 Y: %s %s (-512:512): " "$ssCount" "$mvdL0YBits"
for i in {0..1024}
do
printf "%s " "${mvdL0YUsage[$i]}"
done
echo ""
echo "Geometric Transforms"
echo "GT Flag: $gtFlag1Count $gtFlagBits"
printf "GT Vector 0 X: %s %s (-16:16): " "$gtFlag1Count" "$mvGT0XBits"
for i in {0..32}
do
printf "%s " "${mvGT0XUsage[$i]}"
done
echo ""
printf "GT Vector 0 Y: %s %s (-16:16): " "$gtFlag1Count" "$mvGT0YBits"
for i in {0..32}
do
printf "%s " "${mvGT0YUsage[$i]}"
done
echo ""
printf "GT Vector 1 X: %s %s (-16:16): " "$gtFlag1Count" "$mvGT1XBits"
for i in {0..32}
do
printf "%s " "${mvGT1XUsage[$i]}"
done
echo ""
printf "GT Vector 1 Y: %s %s (-16:16): " "$gtFlag1Count" "$mvGT1YBits"
for i in {0..32}
do
printf "%s " "${mvGT1YUsage[$i]}"
done
echo ""
printf "GT Vector 2 X: %s %s (-16:16): " "$gtFlag1Count" "$mvGT2XBits"
for i in {0..32}
do
printf "%s " "${mvGT2XUsage[$i]}"
done
echo ""
printf "GT Vector 2 Y: %s %s (-16:16): " "$gtFlag1Count" "$mvGT2YBits"
for i in {0..32}
do
printf "%s " "${mvGT2YUsage[$i]}"
done
echo ""
printf "GT Vector 3 X: %s %s (-16:16): " "$gtFlag1Count" "$mvGT3XBits"
for i in {0..32}
do
printf "%s " "${mvGT3XUsage[$i]}"
done
echo ""
printf "GT Vector 3 Y: %s %s (-16:16): " "$gtFlag1Count" "$mvGT3YBits"
for i in {0..32}
do
printf "%s " "${mvGT3YUsage[$i]}"
done
echo ""
echo "Summary SS+GT"
echo "SS: $ssCount $ssBits"
echo "GT: $gtFlag1Count $gtBits"
echo "Residue Coding"
echo "Coef NxN: $coeffNxNCount $coeffNxNBits"

