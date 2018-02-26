function [ ] = AnalyseTraceFile_v2( W, H, NSymbols, AAC_TYPE )
% GEN CLEAN TRACE FILE : grep -v "="  TraceEnc.txt | grep -v "\-\-" | grep -v NAL | grep -v nuh | grep -v nal > TraceEnc_clean.txt

% AAC_TYPE 0 - CABAC, 1-1E8Symb, 2-1E4Symb, 3-1E1Symb, 4-4E4Symb, 5-4E8Symb
% 6-8E8Symb

set(gcf,'Visible','off');
RED(1)=76; RED(2)=84; RED(3)=255;
GREEN(1)=149; GREEN(2)=43; GREEN(3)=21;
BLUE(1)=29; BLUE(2)=255; BLUE(3)=107;
BLACK(1)=0; BLACK(2)=128; BLACK(3)=128;
WHITE(1)=255; WHITE(2)=128; WHITE(3)=128;
CYAN(1)=194; CYAN(2)=162; CYAN(3)=26;
YELLOW(1)=225; YELLOW(2)=0; YELLOW(3)=148;
DO_NOT_DRAW(1)=0; DO_NOT_DRAW(2)=0; DO_NOT_DRAW(3)=0;

INTRA_BLOCK_COLOR = DO_NOT_DRAW;
INTER_BLOCK_COLOR = DO_NOT_DRAW;
SKIP_BLOCK_COLOR = GREEN;
MERGE_BLOCK_COLOR = CYAN;
HOP_BLOCK_COLOR = BLUE;
LOP_BLOCK_COLOR = YELLOW;

CTU_SHAPE_COLOR = RED;
CU_SHAPE_COLOR = RED;
PU_SYM_PART_COLOR = RED;
PU_ASYM_PART_COLOR = RED;

lim_gt_vect_64x64 = 64;
lim_gt_vect_32x32 = 32;
lim_gt_vect_16x16 = 16;
lim_gt_vect_8x8 = 8;
TOP = 100;

%W=176;
%H=144;
BW = zeros(H,W);
BW(:,:) = 128;
[Y,U,V]=yuv_import('rec.yuv',[W H],1,0,'YUV420_8');

Yframe(:,:)=Y{1};
Uframe(:,:)=BW;
Vframe(:,:)=BW;

[code value] = textread('TraceEnc_clean.txt', '%*d %s %*s %s %*d', 'bufsize', 10000000);

x=0;
y=0;
l=1;
aux=1;

intra_mode_counter_per_ctu_size = zeros(4,1);
inter_mode_counter_per_ctu_size = zeros(4,1); % 64 32 16 8
me_mode_counter_per_part_mode = zeros(8,1);
mrg_mode_counter_per_part_mode = zeros(8,1);
gt_mode_counter_per_part_mode = zeros(8,1);
part_mode_counter = zeros(8,1);

%% PIXEL COUNTERS
pixel_counter_intra = zeros(4,1); % 64 32 16 8
pixel_counter_inter = zeros(4,1); % 64 32 16 8
pixel_counter_inter_me_mode = zeros(4,8,4); % CU_SIZE / PART_MODE / PART_IDX
pixel_counter_inter_mrg_mode = zeros(4,8,4);
pixel_counter_inter_gt_mode = zeros(4,8,4);
pixel_counter_inter_skip_mode = zeros(4,8,4);
pixel_counter_multiplier = zeros(4,8,4); % CU_SIZE / PART_MODE / PART_IDX
%% BIT COUNTERS (GLOBAL)
gt_flag_counter = 0;
gt_flag_1_counter = 0;
gt_flag_bit_counter = 0;
gt_vect0_bit_couter = 0;
gt_vect1_bit_couter = 0;
gt_vect2_bit_couter = 0;
gt_vect3_bit_couter = 0;
%% BITS COUNTERS (PER CU SIZE)
gt_bits_per_cu_size = zeros(4,1);
gt_flag_1_per_cu_size = zeros(4,1);
%% STATS (GLOBAL)
gt_vect0_x = 0; gt_vect0_y = 0;
gt_vect1_x = 0; gt_vect1_y = 0;
gt_vect2_x = 0; gt_vect2_y = 0;
gt_vect3_x = 0; gt_vect3_y = 0;
gt_flag_value = 0;
gtIdx=1;
gt_vect0_bits = 0; 
gt_vect1_bits = 0; 
gt_vect2_bits = 0; 
gt_vect3_bits = 0; 
%% STATS (PER CU SIZE)
gt_vect0_x_per_cu(4,1) = 0; gt_vect0_y_per_cu(4,1) = 0;
gt_vect1_x_per_cu(4,1) = 0; gt_vect1_y_per_cu(4,1) = 0;
gt_vect2_x_per_cu(4,1) = 0; gt_vect2_y_per_cu(4,1) = 0;
gt_vect3_x_per_cu(4,1) = 0; gt_vect3_y_per_cu(4,1) = 0;
gt_flag_value_per_cu(4,1) = 0;
gtIdxCu=zeros(4,1)+1;
%%

for cu_size = 1 : 4
    for part_mode = 1 : 8
        if part_mode == 1 % 2N x 2N
            pixel_counter_multiplier(cu_size, part_mode, 1)=2^(cu_size+2) * 2^(cu_size+2);
        elseif part_mode == 2
            pixel_counter_multiplier(cu_size, part_mode, 1)=2^(cu_size+2) * 2^(cu_size+2) / 2;
            pixel_counter_multiplier(cu_size, part_mode, 2)=2^(cu_size+2) * 2^(cu_size+2) / 2;
        elseif part_mode == 3
            pixel_counter_multiplier(cu_size, part_mode, 1)=2^(cu_size+2) * 2^(cu_size+2) / 2;
            pixel_counter_multiplier(cu_size, part_mode, 2)=2^(cu_size+2) * 2^(cu_size+2) / 2;
        elseif part_mode == 4
            pixel_counter_multiplier(cu_size, part_mode, 1)=2^(cu_size+2) * 2^(cu_size+2) / 4;
            pixel_counter_multiplier(cu_size, part_mode, 2)=2^(cu_size+2) * 2^(cu_size+2) / 4;
            pixel_counter_multiplier(cu_size, part_mode, 3)=2^(cu_size+2) * 2^(cu_size+2) / 4;
            pixel_counter_multiplier(cu_size, part_mode, 4)=2^(cu_size+2) * 2^(cu_size+2) / 4;
        elseif part_mode == 5
            pixel_counter_multiplier(cu_size, part_mode, 1)=2^(cu_size+2) * 2^(cu_size+2) /4 ;
            pixel_counter_multiplier(cu_size, part_mode, 2)=2^(cu_size+2) * 2^(cu_size+2) *3/4 ;
        elseif part_mode == 6
            pixel_counter_multiplier(cu_size, part_mode, 1)=2^(cu_size+2) * 2^(cu_size+2) *3/4 ;
            pixel_counter_multiplier(cu_size, part_mode, 2)=2^(cu_size+2) * 2^(cu_size+2) /4 ;
        elseif part_mode == 7
            pixel_counter_multiplier(cu_size, part_mode, 1)=2^(cu_size+2) * 2^(cu_size+2) /4 ;
            pixel_counter_multiplier(cu_size, part_mode, 2)=2^(cu_size+2) * 2^(cu_size+2) *3/4 ;
        elseif part_mode == 8
            pixel_counter_multiplier(cu_size, part_mode, 1)=2^(cu_size+2) * 2^(cu_size+2) *3/4 ;
            pixel_counter_multiplier(cu_size, part_mode, 2)=2^(cu_size+2) * 2^(cu_size+2) /4 ;
        end
    end
end


while l <= length(code)
    curr_code = code{l};
    if strmatch(curr_code, 'x0')
        x = str2num(value{l});          % x0
        y = str2num(value{l+1});        % x1
        size = str2num(value{l+2});     % log2Cbsize
        [Yframe, Uframe, Vframe] = drawCU(size, [y x], Yframe, Uframe, Vframe, CU_SHAPE_COLOR);
        if size > 8
            [l, split_flag, size]=lookForNext2(code, value, 'split_cu_flag', l);
            if l >= length(code)
                break
            end
        else
            split_flag = 0;
        end
        if split_flag == 0
            [l, cu_skip_flag]=lookForNext(code, value, 'cu_skip_flag', l);
            if cu_skip_flag == 0
                [l, pred_mode_flag]=lookForNext(code, value, 'pred_mode_flag', l);
                if pred_mode_flag == 1 % INTRA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    intra_mode_counter_per_ctu_size(log2(size)-2) = intra_mode_counter_per_ctu_size(log2(size)-2) + 1;
                    pixel_counter_intra(log2(size)-2) = pixel_counter_intra(log2(size)-2) + 1;
                    [Uframe, Vframe]=drawBlock([size size], [y x], [1 1],Uframe, Vframe, INTRA_BLOCK_COLOR);
                else % INTER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    inter_mode_counter_per_ctu_size(log2(size)-2) = inter_mode_counter_per_ctu_size(log2(size)-2) + 1;
                    pixel_counter_inter(log2(size)-2) = pixel_counter_inter(log2(size)-2) + 1;
                    [l, part_mode]=lookForNext(code, value, 'part_mode', l);
                    %part_mode = str2num(value{l+1}); % part_mode
                    part_mode_counter(part_mode + 1) = part_mode_counter(part_mode + 1) + 1;
                    if part_mode == 0 % 2N x 2N %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            [Uframe, Vframe]=drawBlock([size size], [y x], [1 1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1 1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                                
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1 1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdx = gtIdx + 1;
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                    end
                    if part_mode == 1  % 2N x N horizontal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [Yframe, Uframe, Vframe] = drawPU_Hor([size/2 size], [y x], Yframe, Uframe, Vframe, PU_SYM_PART_COLOR);
                        % first part part_mode 1
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            [Uframe, Vframe]=drawBlock([size/2 size], [y x], [1,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size/2 size], [y x], [1,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                [Uframe, Vframe]=drawBlock([size/2 size], [y x], [1,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        % second part part_mode 1
                        l = l + 1;
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            [Uframe, Vframe]=drawBlock([size size], [y x], [1+size/2,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1+size/2,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1+size/2,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                    end
                    if part_mode == 2 % N x 2N vertical %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [Yframe, Uframe, Vframe] = drawPU_Ver([size size/2], [y x], Yframe, Uframe, Vframe, PU_SYM_PART_COLOR);
                        % first part part_mode 2
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            [Uframe, Vframe]=drawBlock([size size/2], [y x], [1,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size/2], [y x], [1,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                [Uframe, Vframe]=drawBlock([size size/2], [y x], [1,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        % Second part
                        l = l + 1;
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+size/2], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+size/2], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+size/2], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                    end
                    if part_mode == 3 % N x N %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [Yframe, Uframe, Vframe] = drawPU_Hor([size/2 size], [y x], Yframe, Uframe, Vframe, PU_SYM_PART_COLOR);
                        [Yframe, Uframe, Vframe] = drawPU_Ver([size size/2], [y x], Yframe, Uframe, Vframe, PU_SYM_PART_COLOR);
                        % first part part_mode 3
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            [Uframe, Vframe]=drawBlock([size/2 size/2], [y x], [1,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size/2 size/2], [y x], [1,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                 gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                [Uframe, Vframe]=drawBlock([size/2 size/2], [y x], [1,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        l = l + 1;
                        % 2nd part part_mode 3
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            [Uframe, Vframe]=drawBlock([size/2 size], [y x], [1,size/2+1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size/2 size], [y x], [1,size/2+1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                [Uframe, Vframe]=drawBlock([size/2 size], [y x], [1,size/2+1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        l = l + 1;
                        % 3rd part part_mode 3
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 3) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 3) + 1;
                            [Uframe, Vframe]=drawBlock([size size/2], [y x], [size/2+1,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 3) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 3) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size/2], [y x], [size/2+1,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 3) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 3) + 1;
                                [Uframe, Vframe]=drawBlock([size size/2], [y x], [size/2+1,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        l = l + 1;
                        % 4th part part_mode 3
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 4) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 4) + 1;
                            [Uframe, Vframe]=drawBlock([size size], [y x], [size/2+1,size/2+1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 4) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 4) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [size/2+1,size/2+1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 4) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 4) + 1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [size/2+1,size/2+1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        l = l + 1;
                    end
                    if part_mode == 4 % 2N x N/2 + 2N x 3N/2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [Yframe, Uframe, Vframe] = drawPU_Hor([size/4 size], [y x], Yframe, Uframe, Vframe, PU_ASYM_PART_COLOR);
                        % first part part_mode 4
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            [Uframe, Vframe]=drawBlock([size/4 size], [y x], [1,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size/4 size], [y x], [1,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                [Uframe, Vframe]=drawBlock([size/4 size], [y x], [1,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        % second part part_mode 4
                        l = l + 1;
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            [Uframe, Vframe]=drawBlock([size size], [y x], [1+size/4,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1+size/4,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1+size/4,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                    elseif part_mode == 5 % 2N x 3N/2 + 2N x N/2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [Yframe, Uframe, Vframe] = drawPU_Hor([3*size/4 size], [y x], Yframe, Uframe, Vframe, PU_ASYM_PART_COLOR);
                        % first part part_mode 5
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            [Uframe, Vframe]=drawBlock([3*size/4 size], [y x], [1,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([3*size/4 size], [y x], [1,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                [Uframe, Vframe]=drawBlock([3*size/4 size], [y x], [1,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        % second part part_mode 5
                        l = l + 1;
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            [Uframe, Vframe]=drawBlock([size size], [y x], [1+3*size/4,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1+3*size/4,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1+3*size/4,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                    elseif part_mode == 6 % N/2 x 2N + 3N/2 x 2N %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [Yframe, Uframe, Vframe] = drawPU_Ver([size size/4], [y x], Yframe, Uframe, Vframe, PU_ASYM_PART_COLOR);
                        % first part part_mode 6
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            [Uframe, Vframe]=drawBlock([size size/4], [y x], [1,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size/4], [y x], [1,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                [Uframe, Vframe]=drawBlock([size size/4], [y x], [1,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        % Second part part_mode 7
                        l = l + 1;
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+size/4], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+size/4], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+size/4], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
%                                 gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
%                                 gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                    elseif part_mode == 7 % 3N/2 x 2N + N/2 x 2N %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [Yframe, Uframe, Vframe] = drawPU_Ver([size 3*size/4], [y x], Yframe, Uframe, Vframe, PU_ASYM_PART_COLOR);
                        % first part part_mode 2
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            [Uframe, Vframe]=drawBlock([size 3*size/4], [y x], [1,1], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size 3*size/4], [y x], [1,1], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                [Uframe, Vframe]=drawBlock([size 3*size/4], [y x], [1,1], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
                                %gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                                %gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                                %gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                                %gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                        % Second part
                        l = l + 1;
                        [l, merge_flag]=lookForNext(code, value, 'merge_flag', l);
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+3*size/4], Uframe, Vframe, MERGE_BLOCK_COLOR);
                        else % draw ME shade
                            gt_flag_counter = gt_flag_counter + 1;
                            [l, gt_flag]=lookForNext(code, value, 'GT_FLAG', l);
                            gt_flag_value(gtIdx) = gt_flag;
                            gt_flag_value_per_cu(log2(size)-2,gtIdxCu(log2(size)-2)) = gt_flag;
                            if gt_flag % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+3*size/4], Uframe, Vframe, HOP_BLOCK_COLOR);
                                gt_vect0_bit_couter = gt_vect0_bit_couter + str2num(value{l+10});
                                gt_vect1_bit_couter = gt_vect1_bit_couter + str2num(value{l+11});
                                gt_vect2_bit_couter = gt_vect2_bit_couter + str2num(value{l+12});
                                gt_vect3_bit_couter = gt_vect3_bit_couter + str2num(value{l+13});
                                gt_vect0_bits(gtIdx) = str2num(value{l+10});
                                gt_vect1_bits(gtIdx) = str2num(value{l+11}); 
                                gt_vect2_bits(gtIdx) = str2num(value{l+12}); 
                                gt_vect3_bits(gtIdx) = str2num(value{l+13}); 
                                gt_bits_per_cu_size(log2(size)-2) = gt_bits_per_cu_size(log2(size)-2) + ...
                                    str2num(value{l+10}) + str2num(value{l+11}) + str2num(value{l+12}) + str2num(value{l+13});
                                gt_flag_1_per_cu_size(log2(size)-2) = gt_flag_1_per_cu_size(log2(size)-2) + 1;
                                gt_flag_1_counter = gt_flag_1_counter + 1;
                                gt_vect0_x(gtIdx) = str2num(value{l+2}); gt_vect0_y(gtIdx) = str2num(value{l+3});
                                gt_vect1_x(gtIdx) = str2num(value{l+4}); gt_vect1_y(gtIdx) = str2num(value{l+5});
                                gt_vect2_x(gtIdx) = str2num(value{l+6}); gt_vect2_y(gtIdx) = str2num(value{l+7});
                                gt_vect3_x(gtIdx) = str2num(value{l+8}); gt_vect3_y(gtIdx) = str2num(value{l+9});
                                gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+2}); gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+3});
                                gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+4}); gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+5});
                                gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+6}); gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+7});
                                gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+8}); gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = str2num(value{l+9});
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                    pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                [Uframe, Vframe]=drawBlock([size size], [y x], [1,1+3*size/4], Uframe, Vframe, LOP_BLOCK_COLOR);
                                gt_vect0_x(gtIdx) = 0; gt_vect0_y(gtIdx) = 0;
                                gt_vect1_x(gtIdx) = 0; gt_vect1_y(gtIdx) = 0;
                                gt_vect2_x(gtIdx) = 0; gt_vect2_y(gtIdx) = 0;
                                gt_vect3_x(gtIdx) = 0; gt_vect3_y(gtIdx) = 0;
                                gt_vect0_bits(gtIdx) = 0;
                                gt_vect1_bits(gtIdx) = 0;
                                gt_vect2_bits(gtIdx) = 0; 
                                gt_vect3_bits(gtIdx) = 0;
                                %gt_vect0_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect0_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                                %gt_vect1_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect1_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                                %gt_vect2_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect2_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                                %gt_vect3_x_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0; gt_vect3_y_per_cu(log2(size)-2, gtIdxCu(log2(size)-2)) = 0;
                            end
                            gtIdx = gtIdx + 1;
                            gt_flag_bit_counter = gt_flag_bit_counter + str2num(value{l+1});
                            gtIdxCu(log2(size)-2) = gtIdxCu(log2(size)-2) + 1;
                        end
                    end
                    
                end
            else % SKIP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                inter_mode_counter_per_ctu_size(log2(size)-2) = inter_mode_counter_per_ctu_size(log2(size)-2) + 1;
                    pixel_counter_inter(log2(size)-2) = pixel_counter_inter(log2(size)-2) + 1;
                pixel_counter_inter_skip_mode(log2(size)-2, 1, 1) = ...
                    pixel_counter_inter_skip_mode(log2(size)-2, 1, 1) + 1;
                [Uframe, Vframe]=drawBlock([size size], [y x], [1,1], Uframe, Vframe, SKIP_BLOCK_COLOR);
            end
        end
    end
    l = l + 1;
end

pixel_counter_total = W * H ;
pixel_counter_intra_total =  (pixel_counter_intra(1) * 8^2 +pixel_counter_intra(2) * 16^2 ...
    + pixel_counter_intra(3) * 32^2 + pixel_counter_intra(4) * 64^2) ;
pixel_counter_inter_total =  (pixel_counter_inter(1) * 8^2 +pixel_counter_inter(2) * 16^2 ...
    + pixel_counter_inter(3) * 32^2 + pixel_counter_inter(4) * 64^2) ;

for cu_size = 1 : 4
    for part_mode = 1 : 8
        for part_idx = 1 : 4
            pixel_counter_inter_me_mode(cu_size, part_mode, part_idx) = ...
                pixel_counter_inter_me_mode(cu_size, part_mode, part_idx) * ...
                pixel_counter_multiplier(cu_size, part_mode, part_idx);
            pixel_counter_inter_mrg_mode(cu_size, part_mode, part_idx) = ...
                pixel_counter_inter_mrg_mode(cu_size, part_mode, part_idx) * ...
                pixel_counter_multiplier(cu_size, part_mode, part_idx);
            pixel_counter_inter_gt_mode(cu_size, part_mode, part_idx) = ...
                pixel_counter_inter_gt_mode(cu_size, part_mode, part_idx) * ...
                pixel_counter_multiplier(cu_size, part_mode, part_idx);
            pixel_counter_inter_skip_mode(cu_size, part_mode, part_idx) = ...
                pixel_counter_inter_skip_mode(cu_size, part_mode, part_idx) * ...
                pixel_counter_multiplier(cu_size, part_mode, part_idx);
        end
    end
end

pixel_counter_inter_me_total = sum(sum(sum(pixel_counter_inter_me_mode)));
pixel_counter_inter_mrg_total = sum(sum(sum(pixel_counter_inter_mrg_mode))) ;
pixel_counter_inter_gt_total = sum(sum(sum(pixel_counter_inter_gt_mode))) ;
pixel_counter_inter_skip_total = sum(sum(sum(pixel_counter_inter_skip_mode))) ;

pixel_counter_inter_me_64x64 = sum(sum(pixel_counter_inter_me_mode(4,:,:)));
pixel_counter_inter_me_32x32 = sum(sum(pixel_counter_inter_me_mode(3,:,:)));
pixel_counter_inter_me_16x16 = sum(sum(pixel_counter_inter_me_mode(2,:,:)));
pixel_counter_inter_me_8x8 = sum(sum(pixel_counter_inter_me_mode(1,:,:)));
pixel_counter_inter_mrg_64x64 = sum(sum(pixel_counter_inter_mrg_mode(4,:,:)));
pixel_counter_inter_mrg_32x32 = sum(sum(pixel_counter_inter_mrg_mode(3,:,:)));
pixel_counter_inter_mrg_16x16 = sum(sum(pixel_counter_inter_mrg_mode(2,:,:)));
pixel_counter_inter_mrg_8x8 = sum(sum(pixel_counter_inter_mrg_mode(1,:,:)));
pixel_counter_inter_skip_64x64 = sum(sum(pixel_counter_inter_skip_mode(4,:,:)));
pixel_counter_inter_skip_32x32 = sum(sum(pixel_counter_inter_skip_mode(3,:,:)));
pixel_counter_inter_skip_16x16 = sum(sum(pixel_counter_inter_skip_mode(2,:,:)));
pixel_counter_inter_skip_8x8 = sum(sum(pixel_counter_inter_skip_mode(1,:,:)));
pixel_counter_inter_gt_64x64 = sum(sum(pixel_counter_inter_gt_mode(4,:,:)));
pixel_counter_inter_gt_32x32 = sum(sum(pixel_counter_inter_gt_mode(3,:,:)));
pixel_counter_inter_gt_16x16 = sum(sum(pixel_counter_inter_gt_mode(2,:,:)));
pixel_counter_inter_gt_8x8 = sum(sum(pixel_counter_inter_gt_mode(1,:,:)));
pixel_counter_64x64 = (pixel_counter_intra(4) + pixel_counter_inter(4)) * 64^2;
pixel_counter_32x32 = (pixel_counter_intra(3) + pixel_counter_inter(3)) * 32^2;
pixel_counter_16x16 = (pixel_counter_intra(2) + pixel_counter_inter(2)) * 16^2;
pixel_counter_8x8 = (pixel_counter_intra(1) + pixel_counter_inter(1)) * 8^2;
pixel_counter_intra_64x64 = pixel_counter_intra(4) * 64^2;
pixel_counter_intra_32x32 = pixel_counter_intra(3) * 32^2;
pixel_counter_intra_16x16 = pixel_counter_intra(2) * 16^2;
pixel_counter_intra_8x8 = pixel_counter_intra(1) * 8^2;
pixel_counter_inter_64x64 = pixel_counter_inter(4) * 64^2;
pixel_counter_inter_32x32 = pixel_counter_inter(3) * 32^2;
pixel_counter_inter_16x16 = pixel_counter_inter(2) * 16^2;
pixel_counter_inter_8x8 = pixel_counter_inter(1) * 8^2;

Yframe2 = Yframe(1:H,1:W);
Uframe2 = Uframe(1:H,1:W);
Vframe2 = Vframe(1:H,1:W);

for h = 1:H
    for w = 1:W
        if (mod(h,64) == 0) ||  (mod(w,64) == 0)
            Yframe2(h,w) = CTU_SHAPE_COLOR(1);
            Uframe2(h,w) = CTU_SHAPE_COLOR(2);
            Vframe2(h,w) = CTU_SHAPE_COLOR(3);
        end
    end
end

Y{1} = Yframe2;
U{1} = Uframe2;
V{1} = Vframe2;

yuv_export(Y,U,V,'AnalyseTrace_output_image.yuv',1,'w')

% disp('pixel_counter')
% disp(pixel_counter_total)
% disp(pixel_counter_intra_total)
% disp(pixel_counter_inter_total)
% disp(pixel_counter_inter_me_total)
% disp(pixel_counter_inter_mrg_total)
% disp(pixel_counter_inter_gt_total)
% disp(pixel_counter_inter_skip_total)
% disp('8x8 16x16 32x32 64x64')
% disp(pixel_counter_intra')
% disp(pixel_counter_inter')
% disp('CTU size 8x8')
% disp(pixel_counter_inter_me_mode(1,:,:))
% disp(pixel_counter_inter_mrg_mode(1,:,:))
% disp(pixel_counter_inter_gt_mode(1,:,:))
% disp(pixel_counter_inter_skip_mode(1,:,:))
% disp('CTU size 16x16')
% disp(pixel_counter_inter_me_mode(2,:,:))
% disp(pixel_counter_inter_mrg_mode(2,:,:))
% disp(pixel_counter_inter_gt_mode(2,:,:))
% disp(pixel_counter_inter_skip_mode(2,:,:))
% disp('CTU size 32x32')
% disp(pixel_counter_inter_me_mode(3,:,:))
% disp(pixel_counter_inter_mrg_mode(3,:,:))
% disp(pixel_counter_inter_gt_mode(3,:,:))
% disp(pixel_counter_inter_skip_mode(3,:,:))
% disp('CTU size 64x64')
% disp(pixel_counter_inter_me_mode(4,:,:))
% disp(pixel_counter_inter_mrg_mode(4,:,:))
% disp(pixel_counter_inter_gt_mode(4,:,:))
% disp(pixel_counter_inter_skip_mode(4,:,:))

gt_vect_bit_counter = gt_vect0_bit_couter+gt_vect1_bit_couter+gt_vect2_bit_couter+gt_vect3_bit_couter;
gt_flag_bit_per_flag = gt_flag_bit_counter / gt_flag_counter;
gt_vect_bit_per_flag_1 = gt_vect_bit_counter / gt_flag_1_counter;
gt_vect_bit_per_flag_1_per_cu_size = gt_bits_per_cu_size ./ gt_flag_1_per_cu_size;

%% BITS 
fprintf('NUM of GT_FLAG\t%d\n',gt_flag_counter);
fprintf('NUM of GT_FLAG=1\t%d\n',gt_flag_1_counter);
fprintf('BITS GT_FLAG\t%d\n',gt_flag_bit_counter);
fprintf('BITS GT_FLAG per flag\t%.2f\n',gt_flag_bit_per_flag);
fprintf('BITS GT_VECT\t%d\n',gt_vect_bit_counter);
fprintf('BITS GT_VECT per GT_FLAG=1\t%.2f\n',gt_vect_bit_per_flag_1);
fprintf('BITS GT_VECT for 64x64 CUs\t%d\n',gt_bits_per_cu_size(4));
fprintf('BITS GT_VECT for 32x32 CUs\t%d\n',gt_bits_per_cu_size(3));
fprintf('BITS GT_VECT for 16x16 CUs\t%d\n',gt_bits_per_cu_size(2));
fprintf('BITS GT_VECT for 8x8 CUs\t%d\n',gt_bits_per_cu_size(1));
fprintf('BITS GT_VECT per GT_FLAG=1 for 64x64 CUs\t%.2f\n',gt_vect_bit_per_flag_1_per_cu_size(4));
fprintf('BITS GT_VECT per GT_FLAG=1 for 32x32 CUs\t%.2f\n',gt_vect_bit_per_flag_1_per_cu_size(3));
fprintf('BITS GT_VECT per GT_FLAG=1 for 16x16 CUs\t%.2f\n',gt_vect_bit_per_flag_1_per_cu_size(2));
fprintf('BITS GT_VECT per GT_FLAG=1 for 8x8 CUs\t%.2f\n',gt_vect_bit_per_flag_1_per_cu_size(1));

%% STATS (pixel)
fprintf('\nPIXELS TOTAL\t%d\t(100%%)\n',pixel_counter_total);
fprintf('PIXELS INTRA\t%d\t(%.2f%%)\n',pixel_counter_intra_total, 100*pixel_counter_intra_total/pixel_counter_total);
fprintf('PIXELS INTER\t%d\t(%.2f%%)\n',pixel_counter_inter_total, 100*pixel_counter_inter_total/pixel_counter_total);
fprintf('PIXELS INTER SKIP\t%d\t(%.2f%%)\n',pixel_counter_inter_skip_total, 100*pixel_counter_inter_skip_total/pixel_counter_total);
fprintf('PIXELS INTER ME\t%d\t(%.2f%%)\n',pixel_counter_inter_me_total, 100*pixel_counter_inter_me_total/pixel_counter_total);
fprintf('PIXELS INTER MRG\t%d\t(%.2f%%)\n',pixel_counter_inter_mrg_total, 100*pixel_counter_inter_mrg_total/pixel_counter_total);
fprintf('PIXELS INTER GT\t%d\t(%.2f%%)\n',pixel_counter_inter_gt_total, 100*pixel_counter_inter_gt_total/pixel_counter_total);

fprintf('\nPIXELS TOTAL 64x64 CUs\t%d\t(%.2f%%)\n',pixel_counter_64x64, 100 *pixel_counter_64x64 / pixel_counter_total);
fprintf('PIXELS INTRA\t%d\t(%.2f%%)\n',pixel_counter_intra_64x64, 100*pixel_counter_intra_64x64/pixel_counter_64x64);
fprintf('PIXELS INTER\t%d\t(%.2f%%)\n',pixel_counter_inter_64x64, 100*pixel_counter_inter_64x64/pixel_counter_64x64);
fprintf('PIXELS INTER SKIP\t%d\t(%.2f%%)\n',pixel_counter_inter_skip_64x64, 100*pixel_counter_inter_skip_64x64/pixel_counter_64x64);
fprintf('PIXELS INTER ME\t%d\t(%.2f%%)\n',pixel_counter_inter_me_64x64, 100*pixel_counter_inter_me_64x64/pixel_counter_64x64);
fprintf('PIXELS INTER MRG\t%d\t(%.2f%%)\n',pixel_counter_inter_mrg_64x64, 100*pixel_counter_inter_mrg_64x64/pixel_counter_64x64);
fprintf('PIXELS INTER GT\t%d\t(%.2f%%)\n',pixel_counter_inter_gt_64x64, 100*pixel_counter_inter_gt_64x64/pixel_counter_64x64);

fprintf('\nPIXELS TOTAL 32x32 CUs\t%d\t(%.2f%%)\n',pixel_counter_32x32, 100 *pixel_counter_32x32 / pixel_counter_total);
fprintf('PIXELS INTRA\t%d\t(%.2f%%)\n',pixel_counter_intra_32x32, 100*pixel_counter_intra_32x32/pixel_counter_32x32);
fprintf('PIXELS INTER\t%d\t(%.2f%%)\n',pixel_counter_inter_32x32, 100*pixel_counter_inter_32x32/pixel_counter_32x32);
fprintf('PIXELS INTER SKIP\t%d\t(%.2f%%)\n',pixel_counter_inter_skip_32x32, 100*pixel_counter_inter_skip_32x32/pixel_counter_32x32);
fprintf('PIXELS INTER ME\t%d\t(%.2f%%)\n',pixel_counter_inter_me_32x32, 100*pixel_counter_inter_me_32x32/pixel_counter_32x32);
fprintf('PIXELS INTER MRG\t%d\t(%.2f%%)\n',pixel_counter_inter_mrg_32x32, 100*pixel_counter_inter_mrg_32x32/pixel_counter_32x32);
fprintf('PIXELS INTER GT\t%d\t(%.2f%%)\n',pixel_counter_inter_gt_32x32, 100*pixel_counter_inter_gt_32x32/pixel_counter_32x32);

fprintf('\nPIXELS TOTAL 16x16 CUs\t%d\t(%.2f%%)\n',pixel_counter_16x16, 100 *pixel_counter_16x16 / pixel_counter_total);
fprintf('PIXELS INTRA\t%d\t(%.2f%%)\n',pixel_counter_intra_16x16, 100*pixel_counter_intra_16x16/pixel_counter_16x16);
fprintf('PIXELS INTER\t%d\t(%.2f%%)\n',pixel_counter_inter_16x16, 100*pixel_counter_inter_16x16/pixel_counter_16x16);
fprintf('PIXELS INTER SKIP\t%d\t(%.2f%%)\n',pixel_counter_inter_skip_16x16, 100*pixel_counter_inter_skip_16x16/pixel_counter_16x16);
fprintf('PIXELS INTER ME\t%d\t(%.2f%%)\n',pixel_counter_inter_me_16x16, 100*pixel_counter_inter_me_16x16/pixel_counter_16x16);
fprintf('PIXELS INTER MRG\t%d\t(%.2f%%)\n',pixel_counter_inter_mrg_16x16, 100*pixel_counter_inter_mrg_16x16/pixel_counter_16x16);
fprintf('PIXELS INTER GT\t%d\t(%.2f%%)\n',pixel_counter_inter_gt_16x16, 100*pixel_counter_inter_gt_16x16/pixel_counter_16x16);

fprintf('\nPIXELS TOTAL 8x8 CUs\t%d\t(%.2f%%)\n',pixel_counter_8x8, 100 *pixel_counter_8x8 / pixel_counter_total);
fprintf('PIXELS INTRA\t%d\t(%.2f%%)\n',pixel_counter_intra_8x8, 100*pixel_counter_intra_8x8/pixel_counter_8x8);
fprintf('PIXELS INTER\t%d\t(%.2f%%)\n',pixel_counter_inter_8x8, 100*pixel_counter_inter_8x8/pixel_counter_8x8);
fprintf('PIXELS INTER SKIP\t%d\t(%.2f%%)\n',pixel_counter_inter_skip_8x8, 100*pixel_counter_inter_skip_8x8/pixel_counter_8x8);
fprintf('PIXELS INTER ME\t%d\t(%.2f%%)\n',pixel_counter_inter_me_8x8, 100*pixel_counter_inter_me_8x8/pixel_counter_8x8);
fprintf('PIXELS INTER MRG\t%d\t(%.2f%%)\n',pixel_counter_inter_mrg_8x8, 100*pixel_counter_inter_mrg_8x8/pixel_counter_8x8);
fprintf('PIXELS INTER GT\t%d\t(%.2f%%)\n',pixel_counter_inter_gt_8x8, 100*pixel_counter_inter_gt_8x8/pixel_counter_8x8);

% top N GTs
different_gt = 1;
gt_rank (1,1) = gt_vect0_x(1);
gt_rank (2,1) = gt_vect0_y(1);
gt_rank (3,1) = gt_vect1_x(1);
gt_rank (4,1) = gt_vect1_y(1);
gt_rank (5,1) = gt_vect2_x(1);
gt_rank (6,1) = gt_vect2_y(1);
gt_rank (7,1) = gt_vect3_x(1);
gt_rank (8,1) = gt_vect3_y(1);
gt_usage(1) = 0;
for i = 1 : length(gt_vect0_x)
  match = 0;
  for r = 1 : different_gt
    if gt_vect0_x(i) == gt_rank(1,r) &&  gt_vect0_y(i) == gt_rank(2,r) &&  gt_vect1_x(i) == gt_rank(3,r) &&  gt_vect1_y(i) == gt_rank(4,r) && ...
        gt_vect2_x(i) == gt_rank(5,r) &&  gt_vect2_y(i) == gt_rank(6,r) &&  gt_vect3_x(i) == gt_rank(7,r) &&  gt_vect3_y(i) == gt_rank(8,r)
      gt_usage(r) = gt_usage(r) + 1;
      match = 1;
    end
  end 
  if match == 0
    different_gt = different_gt + 1;
    gt_rank (1,different_gt) = gt_vect0_x(i);
    gt_rank (2,different_gt) = gt_vect0_y(i);
    gt_rank (3,different_gt) = gt_vect1_x(i);
    gt_rank (4,different_gt) = gt_vect1_y(i);
    gt_rank (5,different_gt) = gt_vect2_x(i);
    gt_rank (6,different_gt) = gt_vect2_y(i);
    gt_rank (7,different_gt) = gt_vect3_x(i);
    gt_rank (8,different_gt) = gt_vect3_y(i);
    gt_usage(different_gt) = 1;
  end
end

[a top_usage]=sort(gt_usage,'descend');
for i = 1 : different_gt
  gt_rank_top(1,i) = gt_rank(1,top_usage(i)); 
  gt_rank_top(2,i) = gt_rank(2,top_usage(i));
  gt_rank_top(3,i) = gt_rank(3,top_usage(i));
  gt_rank_top(4,i) = gt_rank(4,top_usage(i));
  gt_rank_top(5,i) = gt_rank(5,top_usage(i));
  gt_rank_top(6,i) = gt_rank(6,top_usage(i));
  gt_rank_top(7,i) = gt_rank(7,top_usage(i));
  gt_rank_top(8,i) = gt_rank(8,top_usage(i));
end

fprintf('GT RANK\n')
for i = 1:different_gt
  toWrite = strcat(num2str(i),'.\t');
  for j = 1:8
    toWrite = strcat(toWrite,num2str(gt_rank_top(j,i)),'\t');
  end 
  toWrite = strcat(toWrite, '\t', num2str(gt_usage(top_usage(i))) ,'\n');  
  fprintf(toWrite);
end

hist_gt_vect_0_64x64(1:lim_gt_vect_64x64*2+1,1:lim_gt_vect_64x64*2+1)=0;
hist_gt_vect_0_32x32(1:lim_gt_vect_32x32*2+1,1:lim_gt_vect_32x32*2+1)=0;
hist_gt_vect_0_16x16(1:lim_gt_vect_16x16*2+1,1:lim_gt_vect_16x16*2+1)=0;
hist_gt_vect_0_8x8(1:lim_gt_vect_8x8*2+1,1:lim_gt_vect_8x8*2+1)=0;
hist_gt_vect_1_64x64(1:lim_gt_vect_64x64*2+1,1:lim_gt_vect_64x64*2+1)=0;
hist_gt_vect_1_32x32(1:lim_gt_vect_32x32*2+1,1:lim_gt_vect_32x32*2+1)=0;
hist_gt_vect_1_16x16(1:lim_gt_vect_16x16*2+1,1:lim_gt_vect_16x16*2+1)=0;
hist_gt_vect_1_8x8(1:lim_gt_vect_8x8*2+1,1:lim_gt_vect_8x8*2+1)=0;
hist_gt_vect_2_64x64(1:lim_gt_vect_64x64*2+1,1:lim_gt_vect_64x64*2+1)=0;
hist_gt_vect_2_32x32(1:lim_gt_vect_32x32*2+1,1:lim_gt_vect_32x32*2+1)=0;
hist_gt_vect_2_16x16(1:lim_gt_vect_16x16*2+1,1:lim_gt_vect_16x16*2+1)=0;
hist_gt_vect_2_8x8(1:lim_gt_vect_8x8*2+1,1:lim_gt_vect_8x8*2+1)=0;
hist_gt_vect_3_64x64(1:lim_gt_vect_64x64*2+1,1:lim_gt_vect_64x64*2+1)=0;
hist_gt_vect_3_32x32(1:lim_gt_vect_32x32*2+1,1:lim_gt_vect_32x32*2+1)=0;
hist_gt_vect_3_16x16(1:lim_gt_vect_16x16*2+1,1:lim_gt_vect_16x16*2+1)=0;
hist_gt_vect_3_8x8(1:lim_gt_vect_8x8*2+1,1:lim_gt_vect_8x8*2+1)=0;

for i = 1:length(gt_vect0_x_per_cu(4,:))
    for y = -lim_gt_vect_64x64 : lim_gt_vect_64x64
        for x = -lim_gt_vect_64x64 : lim_gt_vect_64x64
            if gt_vect0_y_per_cu(4,i) == y && gt_vect0_x_per_cu(4,i) == x
                hist_gt_vect_0_64x64(y+lim_gt_vect_64x64+1, x+lim_gt_vect_64x64+1) = ...
                    hist_gt_vect_0_64x64(y+lim_gt_vect_64x64+1, x+lim_gt_vect_64x64+1) + 1 ;
            end
            if gt_vect1_y_per_cu(4,i) == y && gt_vect1_x_per_cu(4,i) == x
                hist_gt_vect_1_64x64(y+lim_gt_vect_64x64+1, x+lim_gt_vect_64x64+1) = ...
                    hist_gt_vect_1_64x64(y+lim_gt_vect_64x64+1, x+lim_gt_vect_64x64+1) + 1 ;
            end
            if gt_vect2_y_per_cu(4,i) == y && gt_vect2_x_per_cu(4,i) == x
                hist_gt_vect_2_64x64(y+lim_gt_vect_64x64+1, x+lim_gt_vect_64x64+1) = ...
                    hist_gt_vect_2_64x64(y+lim_gt_vect_64x64+1, x+lim_gt_vect_64x64+1) + 1 ;
            end
            if gt_vect3_y_per_cu(4,i) == y && gt_vect3_x_per_cu(4,i) == x
                hist_gt_vect_3_64x64(y+lim_gt_vect_64x64+1, x+lim_gt_vect_64x64+1) = ...
                    hist_gt_vect_3_64x64(y+lim_gt_vect_64x64+1, x+lim_gt_vect_64x64+1) + 1 ;
            end
        end
    end
end
for i = 1:length(gt_vect0_x_per_cu(3,:))
    for y = -lim_gt_vect_32x32 : lim_gt_vect_32x32
        for x = -lim_gt_vect_32x32 : lim_gt_vect_32x32
            if gt_vect0_y_per_cu(3,i) == y && gt_vect0_x_per_cu(3,i) == x
                hist_gt_vect_0_32x32(y+lim_gt_vect_32x32+1, x+lim_gt_vect_32x32+1) = ...
                    hist_gt_vect_0_32x32(y+lim_gt_vect_32x32+1, x+lim_gt_vect_32x32+1) + 1 ;
            end
            if gt_vect1_y_per_cu(3,i) == y && gt_vect1_x_per_cu(3,i) == x
                hist_gt_vect_1_32x32(y+lim_gt_vect_32x32+1, x+lim_gt_vect_32x32+1) = ...
                    hist_gt_vect_1_32x32(y+lim_gt_vect_32x32+1, x+lim_gt_vect_32x32+1) + 1 ;
            end
            if gt_vect2_y_per_cu(3,i) == y && gt_vect2_x_per_cu(3,i) == x
                hist_gt_vect_2_32x32(y+lim_gt_vect_32x32+1, x+lim_gt_vect_32x32+1) = ...
                    hist_gt_vect_2_32x32(y+lim_gt_vect_32x32+1, x+lim_gt_vect_32x32+1) + 1 ;
            end
            if gt_vect3_y_per_cu(3,i) == y && gt_vect3_x_per_cu(3,i) == x
                hist_gt_vect_3_32x32(y+lim_gt_vect_32x32+1, x+lim_gt_vect_32x32+1) = ...
                    hist_gt_vect_3_32x32(y+lim_gt_vect_32x32+1, x+lim_gt_vect_32x32+1) + 1 ;
            end
        end
    end
end
for i = 1:length(gt_vect0_x_per_cu(2,:))
    for y = -lim_gt_vect_16x16 : lim_gt_vect_16x16
        for x = -lim_gt_vect_16x16 : lim_gt_vect_16x16
            if gt_vect0_y_per_cu(2,i) == y && gt_vect0_x_per_cu(2,i) == x
                hist_gt_vect_0_16x16(y+lim_gt_vect_16x16+1, x+lim_gt_vect_16x16+1) = ...
                    hist_gt_vect_0_16x16(y+lim_gt_vect_16x16+1, x+lim_gt_vect_16x16+1) + 1 ;
            end
            if gt_vect1_y_per_cu(2,i) == y && gt_vect1_x_per_cu(2,i) == x
                hist_gt_vect_1_16x16(y+lim_gt_vect_16x16+1, x+lim_gt_vect_16x16+1) = ...
                    hist_gt_vect_1_16x16(y+lim_gt_vect_16x16+1, x+lim_gt_vect_16x16+1) + 1 ;
            end
            if gt_vect2_y_per_cu(2,i) == y && gt_vect2_x_per_cu(2,i) == x
                hist_gt_vect_2_16x16(y+lim_gt_vect_16x16+1, x+lim_gt_vect_16x16+1) = ...
                    hist_gt_vect_2_16x16(y+lim_gt_vect_16x16+1, x+lim_gt_vect_16x16+1) + 1 ;
            end
            if gt_vect3_y_per_cu(2,i) == y && gt_vect3_x_per_cu(2,i) == x
                hist_gt_vect_3_16x16(y+lim_gt_vect_16x16+1, x+lim_gt_vect_16x16+1) = ...
                    hist_gt_vect_3_16x16(y+lim_gt_vect_16x16+1, x+lim_gt_vect_16x16+1) + 1 ;
            end
        end
    end
end
for i = 1:length(gt_vect0_x_per_cu(1,:))
    for y = -lim_gt_vect_8x8 : lim_gt_vect_8x8
        for x = -lim_gt_vect_8x8 : lim_gt_vect_8x8
            if gt_vect0_y_per_cu(1,i) == y && gt_vect0_x_per_cu(1,i) == x
                hist_gt_vect_0_8x8(y+lim_gt_vect_8x8+1, x+lim_gt_vect_8x8+1) = ...
                    hist_gt_vect_0_8x8(y+lim_gt_vect_8x8+1, x+lim_gt_vect_8x8+1) + 1 ;
            end
            if gt_vect1_y_per_cu(1,i) == y && gt_vect1_x_per_cu(1,i) == x
                hist_gt_vect_1_8x8(y+lim_gt_vect_8x8+1, x+lim_gt_vect_8x8+1) = ...
                    hist_gt_vect_1_8x8(y+lim_gt_vect_8x8+1, x+lim_gt_vect_8x8+1) + 1 ;
            end
            if gt_vect2_y_per_cu(1,i) == y && gt_vect2_x_per_cu(1,i) == x
                hist_gt_vect_2_8x8(y+lim_gt_vect_8x8+1, x+lim_gt_vect_8x8+1) = ...
                    hist_gt_vect_2_8x8(y+lim_gt_vect_8x8+1, x+lim_gt_vect_8x8+1) + 1 ;
            end
            if gt_vect3_y_per_cu(1,i) == y && gt_vect3_x_per_cu(1,i) == x
                hist_gt_vect_3_8x8(y+lim_gt_vect_8x8+1, x+lim_gt_vect_8x8+1) = ...
                    hist_gt_vect_3_8x8(y+lim_gt_vect_8x8+1, x+lim_gt_vect_8x8+1) + 1 ;
            end
        end
    end
end

hist_gt_ind_vect_64x64 = cat(1,cat(2,hist_gt_vect_0_64x64,hist_gt_vect_1_64x64),cat(2,hist_gt_vect_3_64x64,hist_gt_vect_2_64x64));
hist_gt_ind_vect_32x32 = cat(1,cat(2,hist_gt_vect_0_32x32,hist_gt_vect_1_32x32),cat(2,hist_gt_vect_3_32x32,hist_gt_vect_2_32x32));
hist_gt_ind_vect_16x16 = cat(1,cat(2,hist_gt_vect_0_16x16,hist_gt_vect_1_16x16),cat(2,hist_gt_vect_3_16x16,hist_gt_vect_2_16x16));
hist_gt_ind_vect_8x8 = cat(1,cat(2,hist_gt_vect_0_8x8,hist_gt_vect_1_8x8),cat(2,hist_gt_vect_3_8x8,hist_gt_vect_2_8x8));
surf(hist_gt_ind_vect_64x64);view(0,90);print('hist_gt_ind_vect_64x64','-dpng');
surf(hist_gt_ind_vect_32x32);view(0,90);print('hist_gt_ind_vect_32x32','-dpng');
surf(hist_gt_ind_vect_16x16);view(0,90);print('hist_gt_ind_vect_16x16','-dpng');
surf(hist_gt_ind_vect_8x8);view(0,90);print('hist_gt_ind_vect_8x8','-dpng');

%% ENTROPY OPTIONS

if AAC_TYPE>0
    if AAC_TYPE == 1
        % calc global probability
       % gt_symbol_usage = zeros(NSymbols, 1) + 1;
%         SHIFT = ((NSymbols + 1) / 2); % not minus 1 because matlab uses > 0 idx
%         for i = 1 : length(gt_vect0_x)
%             if gt_flag_value(i)
%                 current_symbol = gt_vect0_x(i) + SHIFT;
%                 gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
%                 current_symbol = gt_vect0_y(i) + SHIFT;
%                 gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
%                 current_symbol = gt_vect1_x(i) + SHIFT;
%                 gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
%                 current_symbol = gt_vect1_y(i) + SHIFT;
%                 gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
%                 current_symbol = gt_vect2_x(i) + SHIFT;
%                 gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
%                 current_symbol = gt_vect2_y(i) + SHIFT;
%                 gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
%                 current_symbol = gt_vect3_x(i) + SHIFT;
%                 gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
%                 current_symbol = gt_vect3_y(i) + SHIFT;
%                 gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
%             end
%         end 
        % calc symbol probability
        %symbol_probability = gt_symbol_usage / (NSymbols + 1 + gt_flag_1_counter * 8);
        %entropyGT = 0;
        % calc entropy
%         for s = 1:NSymbols
%             entropyGT = entropyGT + (symbol_probability(s)) * log2(1/symbol_probability(s));
%         end
        % calc current probability
%         gt_symbol_usage = zeros(NSymbols, 1) + 1;
%         current_total_number = NSymbols;
%         symbol_probability = zeros(length(gt_vect0_x), NSymbols) + 1/NSymbols; % uniform init prob
%         accEntropyGT = zeros(NSymbols + 1 + gt_flag_1_counter * 8, 1);
%         accEntropyGT(1) = log2(NSymbols);
%         for i = 1 : length(gt_vect0_x)
%             if gt_flag_value(i)
%                 [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(gt_vect0_x(i) + SHIFT, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols);
%                 [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(gt_vect0_y(i) + SHIFT, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols);
%                 [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(gt_vect1_x(i) + SHIFT, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols);
%                 [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(gt_vect1_y(i) + SHIFT, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols);
%                 [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(gt_vect2_x(i) + SHIFT, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols);
%                 [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(gt_vect2_y(i) + SHIFT, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols);
%                 [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(gt_vect3_x(i) + SHIFT, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols);
%                 [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(gt_vect3_y(i) + SHIFT, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols);
%             end
%         end
        % gen array with the bits / current symbol;
        bitsPerSymbolAAC = zeros(gt_flag_1_counter,1);
        accBitsAAC = 0;
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC = accBitsAAC + gt_vect0_bits(i) / 2;
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect0_bits(i) / 2;
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect1_bits(i) / 2;
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect1_bits(i) / 2;
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect2_bits(i) / 2;
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect2_bits(i) / 2;
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect3_bits(i) / 2;
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect3_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        bitsPerSymbolAAC_1Enc_8Symb_per_GT = bitsPerSymbolAAC;
        clear bitsPerSymbolAAC;
        save('bitsPerSymbolAAC_1Enc_8Symb_per_GT.mat','bitsPerSymbolAAC_1Enc_8Symb_per_GT');
        plot(bitsPerSymbolAAC_1Enc_8Symb_per_GT);xlabel('Encoded symbols');ylabel('Bits/Symbol');
        title('AAC (1 Enc, 8 Symb/GT)');
        legend('Enc 0');
        xlim([1 current_total_number-1]); ylim([0 log2(NSymbols)+1]);
        print('bitsPerSymbolAAC_1Enc_8Symb_per_GT','-dpng');
    end
    if AAC_TYPE == 2
        % gen array with the bits / current symbol;
        bitsPerSymbolAAC = zeros(gt_flag_1_counter,1);
        accBitsAAC = 0;
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC = accBitsAAC + gt_vect0_bits(i);
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect1_bits(i);
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect2_bits(i);
%                 bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect3_bits(i);
                bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        bitsPerSymbolAAC_1Enc_4Symb_per_GT = bitsPerSymbolAAC;
        clear bitsPerSymbolAAC;
        save('bitsPerSymbolAAC_1Enc_4Symb_per_GT.mat','bitsPerSymbolAAC_1Enc_4Symb_per_GT');
        plot(bitsPerSymbolAAC_1Enc_4Symb_per_GT);xlabel('Encoded symbols');ylabel('Bits/Symbol');
        title('AAC (1 Enc, 4 Symb/GT)');
        legend('Enc 0');
        xlim([1 current_total_number-1]); ylim([0 log2(NSymbols)+1]);
        print('bitsPerSymbolAAC_1Enc_4Symb_per_GT','-dpng');
    end
    if AAC_TYPE == 3 % 1 Enc 1 S / GT
        % gen array with the bits / current symbol;
        bitsPerSymbolAAC = zeros(gt_flag_1_counter,1);
        accBitsAAC = 0;
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC = accBitsAAC + gt_vect0_bits(i);
                bitsPerSymbolAAC(current_total_number) = accBitsAAC / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        bitsPerSymbolAAC_1Enc_1Symb_per_GT = bitsPerSymbolAAC;
        clear bitsPerSymbolAAC;
        save('bitsPerSymbolAAC_1Enc_1Symb_per_GT.mat','bitsPerSymbolAAC_1Enc_1Symb_per_GT');
        plot(bitsPerSymbolAAC_1Enc_1Symb_per_GT);xlabel('Encoded symbols');ylabel('Bits/Symbol');
        title('AAC (1 Enc, 1 Symb/GT)');
        legend('Enc 0');
        xlim([1 current_total_number-1]); ylim([0 log2(NSymbols)+1]);
        print('bitsPerSymbolAAC_1Enc_1Symb_per_GT','-dpng');
    end
    if AAC_TYPE == 4 % 4 Enc 4 S/GT
        % gen array with the bits / current symbol;
        bitsPerSymbolAAC = zeros(gt_flag_1_counter,4);
        accBitsAAC = zeros(4,1);
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC(1) = accBitsAAC(1) + gt_vect0_bits(i);
                bitsPerSymbolAAC(current_total_number,1) = accBitsAAC(1) / current_total_number;
                accBitsAAC(2) = accBitsAAC(2) + gt_vect1_bits(i);
                bitsPerSymbolAAC(current_total_number,2) = accBitsAAC(2) / current_total_number;
                accBitsAAC(3) = accBitsAAC(3) + gt_vect2_bits(i);
                bitsPerSymbolAAC(current_total_number,3) = accBitsAAC(3) / current_total_number;
                accBitsAAC(4) = accBitsAAC(4) + gt_vect3_bits(i);
                bitsPerSymbolAAC(current_total_number,4) = accBitsAAC(4) / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        save('bitsPerSymbolAAC_4Enc_4Symb_per_GT.mat','bitsPerSymbolAAC');
        plot(bitsPerSymbolAAC(:,1));xlabel('Encoded symbols');ylabel('Bits/Symbol');
        hold on; plot(bitsPerSymbolAAC(:,2)); plot(bitsPerSymbolAAC(:,3)); plot(bitsPerSymbolAAC(:,4)); hold off;
        title('AAC (4 Enc, 4 Symb/GT)');
        legend('Enc 0', 'Enc 1', 'Enc 2', 'Enc 3');
        xlim([1 current_total_number-1]); ylim([0 log2(NSymbols)+1]);
        print('bitsPerSymbolAAC_4Enc_4Symb_per_GT','-dpng');
        % global 
        bitsPerSymbolAACGlobal = zeros(gt_flag_1_counter,1);
        accBitsAAC = 0;
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC = accBitsAAC + gt_vect0_bits(i);
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect1_bits(i);
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect2_bits(i);
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect3_bits(i);
                bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        bitsPerSymbolAAC_4Enc_4Symb_per_GT_global = bitsPerSymbolAACGlobal;
        clear bitsPerSymbolAACGlobal;
        save('bitsPerSymbolAAC_4Enc_4Symb_per_GT_global.mat','bitsPerSymbolAAC_4Enc_4Symb_per_GT_global');
    end
    if AAC_TYPE == 5 % 4 Enc 8 S/GT
        % gen array with the bits / current symbol;
        bitsPerSymbolAAC = zeros(gt_flag_1_counter*2,4);
        accBitsAAC = zeros(4,1);
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC(1) = accBitsAAC(1) + gt_vect0_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,1) = accBitsAAC(1) / current_total_number;
                accBitsAAC(2) = accBitsAAC(2) + gt_vect1_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,2) = accBitsAAC(2) / current_total_number; 
                accBitsAAC(3) = accBitsAAC(3) + gt_vect2_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,3) = accBitsAAC(3) / current_total_number;
                accBitsAAC(4) = accBitsAAC(4) + gt_vect3_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,4) = accBitsAAC(4) / current_total_number;
                current_total_number = current_total_number + 1;
                accBitsAAC(1) = accBitsAAC(1) + gt_vect0_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,1) = accBitsAAC(1) / current_total_number;
                accBitsAAC(2) = accBitsAAC(2) + gt_vect1_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,2) = accBitsAAC(2) / current_total_number;
                accBitsAAC(3) = accBitsAAC(3) + gt_vect2_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,3) = accBitsAAC(3) / current_total_number;
                accBitsAAC(4) = accBitsAAC(4) + gt_vect3_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,4) = accBitsAAC(4) / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        save('bitsPerSymbolAAC_4Enc_8Symb_per_GT.mat','bitsPerSymbolAAC');
        plot(bitsPerSymbolAAC(:,1));xlabel('Encoded symbols');ylabel('Bits/Symbol');
        hold on; plot(bitsPerSymbolAAC(:,2)); plot(bitsPerSymbolAAC(:,3)); plot(bitsPerSymbolAAC(:,4)); hold off;
        title('AAC (4 Enc, 8 Symb/GT)');
        legend('Enc 0', 'Enc 1', 'Enc 2', 'Enc 3');
        xlim([1 current_total_number-1]); ylim([0 log2(NSymbols)+1]);
        print('bitsPerSymbolAAC_4Enc_8Symb_per_GT','-dpng');
        % global
        bitsPerSymbolAACGlobal = zeros(gt_flag_1_counter,1);
        accBitsAAC = 0;
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC = accBitsAAC + gt_vect0_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect0_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect1_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect1_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect2_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect2_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect3_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect3_bits(i) / 2;
                bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        bitsPerSymbolAAC_4Enc_8Symb_per_GT_global = bitsPerSymbolAACGlobal;
        clear bitsPerSymbolAACGlobal;
        save('bitsPerSymbolAAC_4Enc_8Symb_per_GT_global.mat','bitsPerSymbolAAC_4Enc_8Symb_per_GT_global');
    end
    if AAC_TYPE == 6 % 8 Enc 8 S/GT
        % gen array with the bits / current symbol;
        bitsPerSymbolAAC = zeros(gt_flag_1_counter,8);
        accBitsAAC = zeros(8,1);
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC(1) = accBitsAAC(1) + gt_vect0_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,1) = accBitsAAC(1) / current_total_number;
                accBitsAAC(2) = accBitsAAC(2) + gt_vect1_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,2) = accBitsAAC(2) / current_total_number;
                accBitsAAC(3) = accBitsAAC(3) + gt_vect2_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,3) = accBitsAAC(3) / current_total_number;
                accBitsAAC(4) = accBitsAAC(4) + gt_vect3_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,4) = accBitsAAC(4) / current_total_number;
                accBitsAAC(5) = accBitsAAC(5) + gt_vect0_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,5) = accBitsAAC(5) / current_total_number;
                accBitsAAC(6) = accBitsAAC(6) + gt_vect1_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,6) = accBitsAAC(6) / current_total_number;
                accBitsAAC(7) = accBitsAAC(7) + gt_vect2_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,7) = accBitsAAC(7) / current_total_number;
                accBitsAAC(8) = accBitsAAC(8) + gt_vect3_bits(i) / 2;
                bitsPerSymbolAAC(current_total_number,8) = accBitsAAC(8) / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        save('bitsPerSymbolAAC_8Enc_8Symb_per_GT.mat','bitsPerSymbolAAC');
        plot(bitsPerSymbolAAC(:,1));xlabel('Encoded symbols');ylabel('Bits/Symbol');
        hold on; plot(bitsPerSymbolAAC(:,2)); plot(bitsPerSymbolAAC(:,3)); plot(bitsPerSymbolAAC(:,4));
        plot(bitsPerSymbolAAC(:,5)); plot(bitsPerSymbolAAC(:,6)); plot(bitsPerSymbolAAC(:,7)); plot(bitsPerSymbolAAC(:,8));hold off;
        title('AAC (8 Enc, 8 Symb/GT)');
        legend('Enc 0', 'Enc 1', 'Enc 2', 'Enc 3','Enc 4', 'Enc 5', 'Enc 6', 'Enc 7');
        xlim([1 current_total_number-1]); ylim([0 log2(NSymbols)+1]);
        print('bitsPerSymbolAAC_8Enc_8Symb_per_GT','-dpng');
        % global
        bitsPerSymbolAACGlobal = zeros(gt_flag_1_counter,1);
        accBitsAAC = 0;
        current_total_number = 1;
        for i = 1 : length(gt_vect0_x)
            if gt_flag_value(i)
                accBitsAAC = accBitsAAC + gt_vect0_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect0_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect1_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect1_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect2_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect2_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect3_bits(i) / 2;
%                 bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
%                 current_total_number = current_total_number + 1;
                accBitsAAC = accBitsAAC + gt_vect3_bits(i) / 2;
                bitsPerSymbolAACGlobal(current_total_number) = accBitsAAC / current_total_number;
                current_total_number = current_total_number + 1;
            end
        end
        bitsPerSymbolAAC_8Enc_8Symb_per_GT_global = bitsPerSymbolAACGlobal;
        clear bitsPerSymbolAACGlobal;
        save('bitsPerSymbolAAC_8Enc_8Symb_per_GT_global.mat','bitsPerSymbolAAC_8Enc_8Symb_per_GT_global');
    end
else % CABAC
    % gen array with the bits / current symbol;
    bitsPerSymbolCABAC_8Symb_per_GT = zeros(gt_flag_1_counter,1);
    accBitsCABAC = 0;
    current_total_number = 1;
    for i = 1 : length(gt_vect0_x)
        if gt_flag_value(i)
            accBitsCABAC = accBitsCABAC + gt_vect0_bits(i) / 2;
            %bitsPerSymbolCABAC_8Symb_per_GT(current_total_number) = accBitsCABAC / current_total_number;
            %current_total_number = current_total_number + 1;
            accBitsCABAC = accBitsCABAC + gt_vect0_bits(i) / 2;
            %bitsPerSymbolCABAC_8Symb_per_GT(current_total_number) = accBitsCABAC / current_total_number;
            %current_total_number = current_total_number + 1;
            accBitsCABAC = accBitsCABAC + gt_vect1_bits(i) / 2;
            %bitsPerSymbolCABAC_8Symb_per_GT(current_total_number) = accBitsCABAC / current_total_number;
            %current_total_number = current_total_number + 1;
            accBitsCABAC = accBitsCABAC + gt_vect1_bits(i) / 2;
            %bitsPerSymbolCABAC_8Symb_per_GT(current_total_number) = accBitsCABAC / current_total_number;
            %current_total_number = current_total_number + 1;
            accBitsCABAC = accBitsCABAC + gt_vect2_bits(i) / 2;
            %bitsPerSymbolCABAC_8Symb_per_GT(current_total_number) = accBitsCABAC / current_total_number;
            %current_total_number = current_total_number + 1;
            accBitsCABAC = accBitsCABAC + gt_vect2_bits(i) / 2;
            %bitsPerSymbolCABAC_8Symb_per_GT(current_total_number) = accBitsCABAC / current_total_number;
            %current_total_number = current_total_number + 1;
            accBitsCABAC = accBitsCABAC + gt_vect3_bits(i) / 2;
            %bitsPerSymbolCABAC_8Symb_per_GT(current_total_number) = accBitsCABAC / current_total_number;
            %current_total_number = current_total_number + 1;
            accBitsCABAC = accBitsCABAC + gt_vect3_bits(i) / 2;
            bitsPerSymbolCABAC_8Symb_per_GT(current_total_number) = accBitsCABAC / current_total_number;
            current_total_number = current_total_number + 1;
        end
    end
    %save('bitsPerSymbolCABAC_1Symb_per_GT.mat',bitsPerSymbolCABAC_1Symb_per_GT);
    %save('bitsPerSymbolCABAC_4Symb_per_GT.mat',bitsPerSymbolCABAC_4Symb_per_GT);
    save('bitsPerSymbolCABAC_8Symb_per_GT.mat','bitsPerSymbolCABAC_8Symb_per_GT');
    plot(bitsPerSymbolCABAC_8Symb_per_GT);xlabel('Encoded symbols');ylabel('Bits/Symbol');
    title('CABAC (1 Enc, 8 Symb/GT approx.)');
    legend('Enc 0');
    xlim([1 current_total_number-1]); ylim([0 log2(NSymbols)+1]);
    print('bitsPerSymbolCABAC_8Symb_per_GT','-dpng');
end


% min_norm = min([gt_vect0_x gt_vect0_y gt_vect1_x gt_vect1_y gt_vect2_x gt_vect2_y gt_vect3_x gt_vect3_y]);
% max_norm = max([gt_vect0_x gt_vect0_y gt_vect1_x gt_vect1_y gt_vect2_x gt_vect2_y gt_vect3_x gt_vect3_y]);
% norm_gt_vect0_x = (gt_vect0_x - min_norm) / ( max_norm - min_norm );
% norm_gt_vect0_y = (gt_vect0_y - min_norm) / ( max_norm - min_norm );
% norm_gt_vect1_x = (gt_vect1_x - min_norm) / ( max_norm - min_norm );
% norm_gt_vect1_y = (gt_vect1_y - min_norm) / ( max_norm - min_norm );
% norm_gt_vect2_x = (gt_vect2_x - min_norm) / ( max_norm - min_norm );
% norm_gt_vect2_y = (gt_vect2_y - min_norm) / ( max_norm - min_norm );
% norm_gt_vect3_x = (gt_vect3_x - min_norm) / ( max_norm - min_norm );
% norm_gt_vect3_y = (gt_vect3_y - min_norm) / ( max_norm - min_norm );
% for cu = 1 : 4
%     %if isempty(gt_vect0_x_per_cu(cu,:)) == 0
%         min_norm(cu) = min([gt_vect0_x_per_cu(cu,:) gt_vect0_y_per_cu(cu,:) gt_vect1_x_per_cu(cu,:) gt_vect1_y_per_cu(cu,:) ...
%             gt_vect2_x_per_cu(cu,:) gt_vect2_y_per_cu(cu,:) gt_vect3_x_per_cu(cu,:) gt_vect3_y_per_cu(cu,:)]);
%         max_norm(cu) = max([gt_vect0_x_per_cu(cu,:) gt_vect0_y_per_cu(cu,:) gt_vect1_x_per_cu(cu,:) gt_vect1_y_per_cu(cu,:) ...
%             gt_vect2_x_per_cu(cu,:) gt_vect2_y_per_cu(cu,:) gt_vect3_x_per_cu(cu,:) gt_vect3_y_per_cu(cu,:)]);
%         if min_norm(cu) ~= max_norm(cu)
%             norm_gt_vect0_x_per_cu(cu,:) = (gt_vect0_x_per_cu(cu,:) - min_norm(cu)) / ( max_norm(cu) - min_norm(cu) );
%             norm_gt_vect0_y_per_cu(cu,:) = (gt_vect0_y_per_cu(cu,:) - min_norm(cu)) / ( max_norm(cu) - min_norm(cu) );
%             norm_gt_vect1_x_per_cu(cu,:) = (gt_vect1_x_per_cu(cu,:) - min_norm(cu)) / ( max_norm(cu) - min_norm(cu) );
%             norm_gt_vect1_y_per_cu(cu,:) = (gt_vect1_y_per_cu(cu,:) - min_norm(cu)) / ( max_norm(cu) - min_norm(cu) );
%             norm_gt_vect2_x_per_cu(cu,:) = (gt_vect2_x_per_cu(cu,:) - min_norm(cu)) / ( max_norm(cu) - min_norm(cu) );
%             norm_gt_vect2_y_per_cu(cu,:) = (gt_vect2_y_per_cu(cu,:) - min_norm(cu)) / ( max_norm(cu) - min_norm(cu) );
%             norm_gt_vect3_x_per_cu(cu,:) = (gt_vect3_x_per_cu(cu,:) - min_norm(cu)) / ( max_norm(cu) - min_norm(cu) );
%             norm_gt_vect3_y_per_cu(cu,:) = (gt_vect3_y_per_cu(cu,:) - min_norm(cu)) / ( max_norm(cu) - min_norm(cu) );
%         else
%             norm_gt_vect0_x_per_cu(cu,:) = 0;
%             norm_gt_vect0_y_per_cu(cu,:) = 0;
%             norm_gt_vect1_x_per_cu(cu,:) = 0;
%             norm_gt_vect1_y_per_cu(cu,:) = 0;
%             norm_gt_vect2_x_per_cu(cu,:) = 0;
%             norm_gt_vect2_y_per_cu(cu,:) = 0;
%             norm_gt_vect3_x_per_cu(cu,:) = 0;
%             norm_gt_vect3_y_per_cu(cu,:) = 0;
%         end
%     %end
% end

% for cu = 1:4
% figure,
% subplot(8,8,1),
% plot(gt_vect0_x_per_cu(cu,:), gt_vect0_x_per_cu(cu,:),'o'), title('x0 vs x0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,2),
% plot(gt_vect0_x_per_cu(cu,:), gt_vect0_y_per_cu(cu,:),'o'), title('x0 vs y0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,3),
% plot(gt_vect0_x_per_cu(cu,:), gt_vect1_x_per_cu(cu,:),'o'), title('x0 vs x1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,4),
% plot(gt_vect0_x_per_cu(cu,:), gt_vect1_y_per_cu(cu,:),'o'), title('x0 vs y1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,5),
% plot(gt_vect0_x_per_cu(cu,:), gt_vect2_x_per_cu(cu,:),'o'), title('x0 vs x2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,6),
% plot(gt_vect0_x_per_cu(cu,:), gt_vect2_y_per_cu(cu,:),'o'), title('x0 vs y2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,7),
% plot(gt_vect0_x_per_cu(cu,:), gt_vect3_x_per_cu(cu,:),'o'), title('x0 vs x3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,8),
% plot(gt_vect0_x_per_cu(cu,:), gt_vect3_y_per_cu(cu,:),'o'), title('x0 vs y3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% 
% subplot(8,8,9),
% plot(gt_vect0_y_per_cu(cu,:), gt_vect0_x_per_cu(cu,:),'o'), title('y0 vs x0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,10),
% plot(gt_vect0_y_per_cu(cu,:), gt_vect0_y_per_cu(cu,:),'o'), title('y0 vs y0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,11),
% plot(gt_vect0_y_per_cu(cu,:), gt_vect1_x_per_cu(cu,:),'o'), title('y0 vs x1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,12),
% plot(gt_vect0_y_per_cu(cu,:), gt_vect1_y_per_cu(cu,:),'o'), title('y0 vs y1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,13),
% plot(gt_vect0_y_per_cu(cu,:), gt_vect2_x_per_cu(cu,:),'o'), title('y0 vs x2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,14),
% plot(gt_vect0_y_per_cu(cu,:), gt_vect2_y_per_cu(cu,:),'o'), title('y0 vs y2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,15),
% plot(gt_vect0_y_per_cu(cu,:), gt_vect3_x_per_cu(cu,:),'o'), title('y0 vs x3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,16),
% plot(gt_vect0_y_per_cu(cu,:), gt_vect3_y_per_cu(cu,:),'o'), title('y0 vs y3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% 
% subplot(8,8,17),
% plot(gt_vect1_x_per_cu(cu,:), gt_vect0_x_per_cu(cu,:),'o'), title('x1 vs x0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,18),
% plot(gt_vect1_x_per_cu(cu,:), gt_vect0_y_per_cu(cu,:),'o'), title('x1 vs y0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,19),
% plot(gt_vect1_x_per_cu(cu,:), gt_vect1_x_per_cu(cu,:),'o'), title('x1 vs x1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,20),
% plot(gt_vect1_x_per_cu(cu,:), gt_vect1_y_per_cu(cu,:),'o'), title('x1 vs y1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,21),
% plot(gt_vect1_x_per_cu(cu,:), gt_vect2_x_per_cu(cu,:),'o'), title('x1 vs x2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,22),
% plot(gt_vect1_x_per_cu(cu,:), gt_vect2_y_per_cu(cu,:),'o'), title('x1 vs y2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,23),
% plot(gt_vect1_x_per_cu(cu,:), gt_vect3_x_per_cu(cu,:),'o'), title('x1 vs x3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,24),
% plot(gt_vect1_x_per_cu(cu,:), gt_vect3_y_per_cu(cu,:),'o'), title('x1 vs y3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% 
% subplot(8,8,25),
% plot(gt_vect1_y_per_cu(cu,:), gt_vect0_x_per_cu(cu,:),'o'), title('y1 vs x0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,26),
% plot(gt_vect1_y_per_cu(cu,:), gt_vect0_y_per_cu(cu,:),'o'), title('y1 vs y0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,27),
% plot(gt_vect1_y_per_cu(cu,:), gt_vect1_x_per_cu(cu,:),'o'), title('y1 vs x1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,28),
% plot(gt_vect1_y_per_cu(cu,:), gt_vect1_y_per_cu(cu,:),'o'), title('y1 vs y1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,29),
% plot(gt_vect1_y_per_cu(cu,:), gt_vect2_x_per_cu(cu,:),'o'), title('y1 vs x2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,30),
% plot(gt_vect1_y_per_cu(cu,:), gt_vect2_y_per_cu(cu,:),'o'), title('y1 vs y2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,31),
% plot(gt_vect1_y_per_cu(cu,:), gt_vect3_x_per_cu(cu,:),'o'), title('y1 vs x3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,32),
% plot(gt_vect1_y_per_cu(cu,:), gt_vect3_y_per_cu(cu,:),'o'), title('y1 vs y3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% 
% subplot(8,8,33),
% plot(gt_vect2_x_per_cu(cu,:), gt_vect0_x_per_cu(cu,:),'o'), title('x2 vs x0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,34),
% plot(gt_vect2_x_per_cu(cu,:), gt_vect0_y_per_cu(cu,:),'o'), title('x2 vs y0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,35),
% plot(gt_vect2_x_per_cu(cu,:), gt_vect1_x_per_cu(cu,:),'o'), title('x2 vs x1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,36),
% plot(gt_vect2_x_per_cu(cu,:), gt_vect1_y_per_cu(cu,:),'o'), title('x2 vs y1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,37),
% plot(gt_vect2_x_per_cu(cu,:), gt_vect2_x_per_cu(cu,:),'o'), title('x2 vs x2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,38),
% plot(gt_vect2_x_per_cu(cu,:), gt_vect2_y_per_cu(cu,:),'o'), title('x2 vs y2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,39),
% plot(gt_vect2_x_per_cu(cu,:), gt_vect3_x_per_cu(cu,:),'o'), title('x2 vs x3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,40),
% plot(gt_vect2_x_per_cu(cu,:), gt_vect3_y_per_cu(cu,:),'o'), title('x2 vs y3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% 
% subplot(8,8,41),
% plot(gt_vect2_y_per_cu(cu,:), gt_vect0_x_per_cu(cu,:),'o'), title('y2 vs x0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,42),
% plot(gt_vect2_y_per_cu(cu,:), gt_vect0_y_per_cu(cu,:),'o'), title('y2 vs y0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,43),
% plot(gt_vect2_y_per_cu(cu,:), gt_vect1_x_per_cu(cu,:),'o'), title('y2 vs x1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,44),
% plot(gt_vect2_y_per_cu(cu,:), gt_vect1_y_per_cu(cu,:),'o'), title('y2 vs y1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,45),
% plot(gt_vect2_y_per_cu(cu,:), gt_vect2_x_per_cu(cu,:),'o'), title('y2 vs x2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,46),
% plot(gt_vect2_y_per_cu(cu,:), gt_vect2_y_per_cu(cu,:),'o'), title('y2 vs y2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,47),
% plot(gt_vect2_y_per_cu(cu,:), gt_vect3_x_per_cu(cu,:),'o'), title('y2 vs x3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,48),
% plot(gt_vect2_y_per_cu(cu,:), gt_vect3_y_per_cu(cu,:),'o'), title('y2 vs y3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% 
% subplot(8,8,49),
% plot(gt_vect3_x_per_cu(cu,:), gt_vect0_x_per_cu(cu,:),'o'), title('x3 vs x0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,50),
% plot(gt_vect3_x_per_cu(cu,:), gt_vect0_y_per_cu(cu,:),'o'), title('x3 vs y0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,51),
% plot(gt_vect3_x_per_cu(cu,:), gt_vect1_x_per_cu(cu,:),'o'), title('x3 vs x1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,52),
% plot(gt_vect3_x_per_cu(cu,:), gt_vect1_y_per_cu(cu,:),'o'), title('x3 vs y1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,53),
% plot(gt_vect3_x_per_cu(cu,:), gt_vect2_x_per_cu(cu,:),'o'), title('x3 vs x2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,54),
% plot(gt_vect3_x_per_cu(cu,:), gt_vect2_y_per_cu(cu,:),'o'), title('x3 vs y2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,55),
% plot(gt_vect3_x_per_cu(cu,:), gt_vect3_x_per_cu(cu,:),'o'), title('x3 vs x3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,56),
% plot(gt_vect3_x_per_cu(cu,:), gt_vect3_y_per_cu(cu,:),'o'), title('x3 vs y3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% 
% subplot(8,8,57),
% plot(gt_vect3_y_per_cu(cu,:), gt_vect0_x_per_cu(cu,:),'o'), title('y3 vs x0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,58),
% plot(gt_vect3_y_per_cu(cu,:), gt_vect0_y_per_cu(cu,:),'o'), title('y3 vs y0'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,59),
% plot(gt_vect3_y_per_cu(cu,:), gt_vect1_x_per_cu(cu,:),'o'), title('y3 vs x1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,60),
% plot(gt_vect3_y_per_cu(cu,:), gt_vect1_y_per_cu(cu,:),'o'), title('y3 vs y1'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,61),
% plot(gt_vect3_y_per_cu(cu,:), gt_vect2_x_per_cu(cu,:),'o'), title('y3 vs x2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,62),
% plot(gt_vect3_y_per_cu(cu,:), gt_vect2_y_per_cu(cu,:),'o'), title('y3 vs y2'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,63),
% plot(gt_vect3_y_per_cu(cu,:), gt_vect3_x_per_cu(cu,:),'o'), title('y3 vs x3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% subplot(8,8,64),
% plot(gt_vect3_y_per_cu(cu,:), gt_vect3_y_per_cu(cu,:),'o'), title('y3 vs y3'), xlim([-(2^(cu+2)-1) (2^(cu+2)-1)]), ylim([-(2^(cu+2)-1) (2^(cu+2)-1)]);
% end 
end

% function [accEntropyGT, gt_symbol_usage, current_total_number, symbol_probability] = calcAccuEntropy(current_symbol, gt_symbol_usage, current_total_number, symbol_probability, accEntropyGT, NSymbols)
% 
% %current_symbol = symbol + SHIFT;
% gt_symbol_usage(current_symbol) = gt_symbol_usage(current_symbol) + 1;
% %gt_symbol_usage(((NSymbols + 1) / 2)) = 1; % not minus 1 because matlab uses > 0 idx
% current_total_number = current_total_number + 1;
% symbol_probability(current_total_number,:) = gt_symbol_usage / current_total_number;
% % calc accumulated entropy
% for s = 1:NSymbols
%     accEntropyGT(current_total_number) = accEntropyGT(current_total_number) + (symbol_probability(current_total_number,s)) * log2(1/symbol_probability(current_total_number,s));
% end
%                 
% end


function [Uframe, Vframe] = drawBlock(finalPointPU, initPointCU, initPointPU, Uframe, Vframe, color)

if sum(color)
    for h = initPointPU(1):finalPointPU(1)-1
        for w = initPointPU(2):finalPointPU(2)-1
            Uframe(initPointCU(1)+h,initPointCU(2)+w)=color(2);
            Vframe(initPointCU(1)+h,initPointCU(2)+w)=color(3);
        end
    end
end

end

function [Yframe, Uframe, Vframe] = drawCU(size, initPointCU, Yframe, Uframe, Vframe, color)

if sum(color)
    if initPointCU(2) > 0
        if initPointCU(1) > 0
            Yframe(initPointCU(1) : initPointCU(1) + size , initPointCU(2) ) = color(1);
            Uframe(initPointCU(1) : initPointCU(1) + size , initPointCU(2) ) = color(2);
            Vframe(initPointCU(1) : initPointCU(1) + size , initPointCU(2) ) = color(3);
        else
            Yframe(1 : initPointCU(1) + size , initPointCU(2) ) = color(1);
            Uframe(1 : initPointCU(1) + size , initPointCU(2) ) = color(2);
            Vframe(1 : initPointCU(1) + size , initPointCU(2) ) = color(3);
        end
    end
    if initPointCU(1) > 0
        if initPointCU(2) > 0
            Yframe(initPointCU(1) , initPointCU(2) : initPointCU(2) + size) = color(1);
            Uframe(initPointCU(1) , initPointCU(2) : initPointCU(2) + size) = color(2);
            Vframe(initPointCU(1) , initPointCU(2) : initPointCU(2) + size) = color(3);
        else
            Yframe(initPointCU(1) , 1 : initPointCU(2) + size) = color(1);
            Uframe(initPointCU(1) , 1 : initPointCU(2) + size) = color(2);
            Vframe(initPointCU(1) , 1 : initPointCU(2) + size) = color(3);
        end
    end
end

end

function [Yframe, Uframe, Vframe] = drawPU_Hor(size, initPointPU, Yframe, Uframe, Vframe, color)
if sum(color)
    if initPointPU(2) > 0
        Yframe(initPointPU(1) + size(1) , initPointPU(2) : initPointPU(2) + size(2)) = color(1);
        Uframe(initPointPU(1) + size(1) , initPointPU(2) : initPointPU(2) + size(2)) = color(2);
        Vframe(initPointPU(1) + size(1) , initPointPU(2) : initPointPU(2) + size(2)) = color(3);
    else
        Yframe(initPointPU(1) + size(1) , 1 : initPointPU(2) + size(2)) = color(1);
        Uframe(initPointPU(1) + size(1) , 1 : initPointPU(2) + size(2)) = color(2);
        Vframe(initPointPU(1) + size(1) , 1 : initPointPU(2) + size(2)) = color(3);
    end
end
end

function [Yframe, Uframe, Vframe] = drawPU_Ver(size, initPointPU, Yframe, Uframe, Vframe, color)
if sum(color)
    if initPointPU(1) > 0
        Yframe(initPointPU(1) : initPointPU(1) + size(1) , initPointPU(2) + size(2)) = color(1);
        Uframe(initPointPU(1) : initPointPU(1) + size(1) , initPointPU(2) + size(2)) = color(2);
        Vframe(initPointPU(1) : initPointPU(1) + size(1) , initPointPU(2) + size(2)) = color(3);
    else
        Yframe(1 : initPointPU(1) + size(1), initPointPU(2) + size(2)) = color(1);
        Uframe(1 : initPointPU(1) + size(1), initPointPU(2) + size(2)) = color(2);
        Vframe(1 : initPointPU(1) + size(1), initPointPU(2) + size(2)) = color(3);
    end
end
end

function [l, flag] = lookForNext (code, value, str, l)
flag =0;
while isempty(strmatch(code{l}, str) )
    l = l + 1;
    if l >= length(code)
        return
    end
end
if l >= length(code)
    return
end
flag = str2num(value{l});

end

function [l, flag, size] = lookForNext2 (code, value, str, l)

size = 8;
flag = 0;
while isempty(strmatch(code{l}, str) )
    if strmatch(code{l}, 'log2CbSize')
        size = str2num(value{l});
    end
    l = l + 1;
    if l >= length(code)
        return
    end
end
if l >= length(code)
    return
end
flag = str2num(value{l});

end
