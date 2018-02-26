function [ ] = AnalyseTraceFile( W, H )
% GEN CLEAN TRACE FILE : grep -v "="  TraceEnc.txt | grep -v "\-\-" | grep -v NAL | grep -v nuh | grep -v nal | grep -v BITS > TraceEnc_clean.txt

RED(1)=76; RED(2)=84; RED(3)=255;
GREEN(1)=149; GREEN(2)=43; GREEN(3)=21;
BLUE(1)=29; BLUE(2)=255; BLUE(3)=107;
BLACK(1)=0; BLACK(2)=128; BLACK(3)=128;
WHITE(1)=255; WHITE(2)=128; WHITE(3)=128;
CYAN(1)=194; CYAN(2)=162; CYAN(3)=26;
YELLOW(1)=225; YELLOW(2)=0; YELLOW(3)=148;

%W=176;
%H=144;
BW = zeros(H,W);
BW(:,:) = 128;
[Y,U,V]=yuv_import('rec.yuv',[W H],1,0,'YUV420_8');

Yframe(:,:)=Y{1};
Uframe(:,:)=BW;
Vframe(:,:)=BW;

[num code null1 value null2] = textread('TraceEnc_clean.txt', '%d %s %s %s %d', 'bufsize', 5000000);
clear null1
clear null2

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

pixel_counter_intra = zeros(4,1); % 64 32 16 8
pixel_counter_inter = zeros(4,1); % 64 32 16 8
pixel_counter_inter_me_mode = zeros(4,8,4); % CU_SIZE / PART_MODE / PART_IDX
pixel_counter_inter_mrg_mode = zeros(4,8,4);
pixel_counter_inter_gt_mode = zeros(4,8,4);
pixel_counter_multiplier = zeros(4,8,4); %  / PART_MODE / PART_IDX

for cu_size = 1 : 4
    for part_mode = 1 : 8
        if part_mode == 1
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
        % draw CTU
        if x > 0
            if y > 0
                Yframe(y : y + size , x ) = BLUE(1);
                Uframe(y : y + size , x ) = BLUE(2);
                Vframe(y : y + size , x ) = BLUE(3);
            else
                Yframe(1 : y + size , x ) = BLUE(1);
                Uframe(1 : y + size , x ) = BLUE(2);
                Vframe(1 : y + size , x ) = BLUE(3);
            end
        end
        if y > 0
            if x > 0
                Yframe(y , x : x + size) = BLUE(1);
                Uframe(y , x : x + size) = BLUE(2);
                Vframe(y , x : x + size) = BLUE(3);
            else
                Yframe(y , 1 : x + size) = BLUE(1);
                Uframe(y , 1 : x + size) = BLUE(2);
                Vframe(y , 1 : x + size) = BLUE(3);
            end
        end
        if size > 8
            while isempty(strmatch(code{l}, 'split_cu_flag') )
                if strmatch(code{l}, 'log2CbSize')
                    size = str2num(value{l});
                end
                l = l + 1;
                if l >= length(code)
                    break
                end
            end
            if l >= length(code)
                break
            end
            split_flag = str2num(value{l}); % split_flag
        else
            split_flag = 0;
        end
        if split_flag == 0
            while isempty(strmatch(code{l}, 'cu_skip_flag') )
                l = l + 1;
                if l >= length(code)
                    break
                end
            end
            if l >= length(code)
                break
            end
            cu_skip_flag = str2num(value{l}); % cu_skip_flag
            if cu_skip_flag == 0
                while isempty(strmatch(code{l}, 'pred_mode_flag') )
                    l = l + 1;
                    if l >= length(code)
                        break
                    end
                end
                if l >= length(code)
                    break
                end
                pred_mode_flag = str2num(value{l}); % pred_mode_flag
                if pred_mode_flag == 1 % INTRA
                    intra_mode_counter_per_ctu_size(log2(size)-2) = intra_mode_counter_per_ctu_size(log2(size)-2) + 1;
                    pixel_counter_intra(log2(size)-2) = pixel_counter_intra(log2(size)-2) + 1;
                    % draw intra shade
                    for h = 1:size-1
                        for w = 1:size-1
                            Uframe(y+h,x+w)=RED(2);
                            Vframe(y+h,x+w)=RED(3);
                        end
                    end
                else % INTER
                    % draw inter shade
                    %                     for h = 1:size-1
                    %                         for w = 1:size-1
                    %                             Uframe(y+h,x+w)=CYAN(2);
                    %                             Vframe(y+h,x+w)=CYAN(3);
                    %                         end
                    %                     end
                    
                    inter_mode_counter_per_ctu_size(log2(size)-2) = inter_mode_counter_per_ctu_size(log2(size)-2) + 1;
                    pixel_counter_inter(log2(size)-2) = pixel_counter_inter(log2(size)-2) + 1;
                    part_mode = str2num(value{l+1}); % part_mode
                    part_mode_counter(part_mode + 1) = part_mode_counter(part_mode + 1) + 1;
                    if part_mode == 0
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            for h = 1:size-1
                                for w = 1:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                for h = 1:size-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                    end
                    if part_mode == 1  % 2N x N horizontal
                        if x > 0
                            Yframe(y + size/2 , x : x + size) = RED(1);
                            Uframe(y + size/2 , x : x + size) = RED(2);
                            Vframe(y + size/2 , x : x + size) = RED(3);
                        else
                            Yframe(y + size/2 , 1 : x + size) = RED(1);
                            Uframe(y + size/2 , 1 : x + size) = RED(2);
                            Vframe(y + size/2 , 1 : x + size) = RED(3);
                        end
                        
                        % first part part_mode 1
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            for h = 1:size/2-1
                                for w = 1:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size/2-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                for h = 1:size/2-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        % second part part_mode 1
                        l = l + 1;
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            for h = 1+size/2:size-1
                                for w = 1:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1+size/2:size-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                for h = 1+size/2:size-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                    end
                    if part_mode == 2 % N x 2N vertical
                        if y > 0
                            Yframe(y : y + size , x + size/2) = RED(1);
                            Uframe(y : y + size , x + size/2) = RED(2);
                            Vframe(y : y + size , x + size/2) = RED(3);
                        else
                            Yframe(1 : y + size , x + size/2) = RED(1);
                            Uframe(1 : y + size , x + size/2) = RED(2);
                            Vframe(1 : y + size , x + size/2) = RED(3);
                        end
                        % first part part_mode 2
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            for h = 1:size-1
                                for w = 1:size/2-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size-1
                                    for w = 1:size/2-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                for h = 1:size-1
                                    for w = 1:size/2-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        % Second part
                        l = l + 1;
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            for h = 1:size-1
                                for w = 1+size/2:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size-1
                                    for w = 1+size/2:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                for h = 1:size-1
                                    for w = 1+size/2:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                    end
                    if part_mode == 3 % N x N
                        if x > 0
                            Yframe(y + size/2 , x : x + size) = RED(1);
                            Uframe(y + size/2 , x : x + size) = RED(2);
                            Vframe(y + size/2 , x : x + size) = RED(3);
                        else
                            Yframe(y + size/2 , 1 : x + size) = RED(1);
                            Uframe(y + size/2 , 1 : x + size) = RED(2);
                            Vframe(y + size/2 , 1 : x + size) = RED(3);
                        end
                        if y > 0
                            Yframe(y : y + size , x + size/2) = RED(1);
                            Uframe(y : y + size , x + size/2) = RED(2);
                            Vframe(y : y + size , x + size/2) = RED(3);
                        else
                            Yframe(1 : y + size , x + size/2) = RED(1);
                            Uframe(1 : y + size , x + size/2) = RED(2);
                            Vframe(1 : y + size , x + size/2) = RED(3);
                        end
                        % first part part_mode 3
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            for h = 1:size/2-1
                                for w = 1:size/2-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size/2-1
                                    for w = 1:size/2-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                for h = 1:size/2-1
                                    for w = 1:size/2-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        l = l + 1;
                        % 2nd part part_mode 3
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                                                    pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            for h = 1:size/2-1
                                for w = size/2+1:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size/2-1
                                    for w = size/2+1:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                for h = 1:size/2-1
                                    for w = size/2+1:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        l = l + 1;
                        % 3rd part part_mode 3
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag  
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 3) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 3) + 1;
                            for h = size/2+1:size-1
                                for w = 1:size/2-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 3) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 3) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = size/2+1:size-1
                                    for w = 1:size/2-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 3) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 3) + 1;
                                for h = size/2+1:size-1
                                    for w = 1:size/2-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        l = l + 1;
                        % 4th part part_mode 3
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 4) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 4) + 1;
                            for h = 1:size/2-1
                                for w = size/2+1:size-1:size/2-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 4) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 4) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size/2-1
                                    for w = size/2+1:size-1:size/2-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 4) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 4) + 1;
                                for h = 1:size/2-1
                                    for w = size/2+1:size-1:size/2-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        l = l + 1;
                    end
                    if part_mode == 4 % 2N x N/2 + 2N x 3N/2
                        if x > 0
                            Yframe(y + size/4 , x : x + size) = YELLOW(1);
                            Uframe(y + size/4 , x : x + size) = YELLOW(2);
                            Vframe(y + size/4 , x : x + size) = YELLOW(3);
                        else
                            Yframe(y + size/4 , 1 : x + size) = YELLOW(1);
                            Uframe(y + size/4 , 1 : x + size) = YELLOW(2);
                            Vframe(y + size/4 , 1 : x + size) = YELLOW(3);
                        end
                        % first part part_mode 4
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            for h = 1:size/4-1
                                for w = 1:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size/4-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                for h = 1:size/4-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        % second part part_mode 4
                        l = l + 1;
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            for h = 1+size/4:size-1
                                for w = 1:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1+size/4:size-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                for h = 1+size/4:size-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                    elseif part_mode == 5 % 2N x 3N/2 + 2N x N/2
                        if x > 0
                            Yframe(y + 3*size/4 , x : x + size) = YELLOW(1);
                            Uframe(y + 3*size/4 , x : x + size) = YELLOW(2);
                            Vframe(y + 3*size/4 , x : x + size) = YELLOW(3);
                        else
                            Yframe(y + 3*size/4 , 1 : x + size) = YELLOW(1);
                            Uframe(y + 3*size/4 , 1 : x + size) = YELLOW(2);
                            Vframe(y + 3*size/4 , 1 : x + size) = YELLOW(3);
                        end
                        % first part part_mode 5
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            for h = 1:3*size/4-1
                                for w = 1:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:3*size/4-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                for h = 1:3*size/4-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        % second part part_mode 5
                        l = l + 1;
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            for h = 1+3*size/4:size-1
                                for w = 1:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1+3*size/4:size-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                for h = 1+3*size/4:size-1
                                    for w = 1:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                    elseif part_mode == 6 % N/2 x 2N + 3N/2 x 2N
                        if y > 0
                            Yframe(y : y + size , x + size/4) = YELLOW(1);
                            Uframe(y : y + size , x + size/4) = YELLOW(2);
                            Vframe(y : y + size , x + size/4) = YELLOW(3);
                        else
                            Yframe(1 : y + size , x + size/4) = YELLOW(1);
                            Uframe(1 : y + size , x + size/4) = YELLOW(2);
                            Vframe(1 : y + size , x + size/4) = YELLOW(3);
                        end
                        % first part part_mode 6
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            for h = 1:size-1
                                for w = 1:size/4-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size-1
                                    for w = 1:size/4-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                for h = 1:size-1
                                    for w = 1:size/4-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        % Second part part_mode 7
                        l = l + 1;
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            for h = 1:size-1
                                for w = 1+size/4:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size-1
                                    for w = 1+size/4:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                for h = 1:size-1
                                    for w = 1+size/4:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                    elseif part_mode == 7 % 3N/2 x 2N + N/2 x 2N
                        if y > 0
                            Yframe(y : y + size , x + 3*size/4) = YELLOW(1);
                            Uframe(y : y + size , x + 3*size/4) = YELLOW(2);
                            Vframe(y : y + size , x + 3*size/4) = YELLOW(3);
                        else
                            Yframe(1 : y + size , x + 3*size/4) = YELLOW(1);
                            Uframe(1 : y + size , x + 3*size/4) = YELLOW(2);
                            Vframe(1 : y + size , x + 3*size/4) = YELLOW(3);
                        end
                        % first part part_mode 2
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 1) + 1;
                            for h = 1:size-1
                                for w = 1:3*size/4-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size-1
                                    for w = 1:3*size/4-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 1) + 1;
                                for h = 1:size-1
                                    for w = 1:3*size/4-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                        % Second part
                        l = l + 1;
                        while isempty(strmatch(code{l}, 'merge_flag') )
                            l = l + 1;
                            if l >= length(code)
                                break
                            end
                        end
                        if l >= length(code)
                            break
                        end
                        merge_flag = str2num(value{l}); % merge_flag
                        if merge_flag % draw MRG shade
                            pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_mrg_mode(log2(size)-2, part_mode + 1, 2) + 1;
                            for h = 1:size-1
                                for w = 1+3*size/4:size-1
                                    Uframe(y+h,x+w)=CYAN(2);
                                    Vframe(y+h,x+w)=CYAN(3);
                                end
                            end
                        else % draw ME shade
                            if str2num(value{l+7}) % gt_flag
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_gt_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                gt_mode_counter_per_part_mode(part_mode + 1) = gt_mode_counter_per_part_mode(part_mode + 1) +1;
                                for h = 1:size-1
                                    for w = 1+3*size/4:size-1
                                        Uframe(y+h,x+w)=BLUE(2);
                                        Vframe(y+h,x+w)=BLUE(3);
                                    end
                                end
                            else
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) = ...
                                pixel_counter_inter_me_mode(log2(size)-2, part_mode + 1, 2) + 1;
                                for h = 1:size-1
                                    for w = 1+3*size/4:size-1
                                        Uframe(y+h,x+w)=YELLOW(2);
                                        Vframe(y+h,x+w)=YELLOW(3);
                                    end
                                end
                            end
                        end
                    end
                    
                end
            else
                % draw skip shade
                for h = 1:size-1
                    for w = 1:size-1
                        Uframe(y+h,x+w)=GREEN(2);
                        Vframe(y+h,x+w)=GREEN(3);
                    end
                end
            end
        end
    end
    l = l + 1;
end

pixel_counter_total = W * H ;
pixel_counter_intra_total = 100 * (pixel_counter_intra(1) * 8^2 +pixel_counter_intra(2) * 16^2 ...
+ pixel_counter_intra(3) * 32^2 + pixel_counter_intra(4) * 64^2) / pixel_counter_total ;
pixel_counter_inter_total = 100 * (pixel_counter_inter(1) * 8^2 +pixel_counter_inter(2) * 16^2 ...
+ pixel_counter_inter(3) * 32^2 + pixel_counter_inter(4) * 64^2) / pixel_counter_total ;

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
        end
    end
end

pixel_counter_inter_me_total = 100 * sum(sum(sum(pixel_counter_inter_me_mode))) / pixel_counter_total;
pixel_counter_inter_mrg_total = 100 * sum(sum(sum(pixel_counter_inter_mrg_mode))) / pixel_counter_total;
pixel_counter_inter_gt_total = 100 * sum(sum(sum(pixel_counter_inter_gt_mode))) / pixel_counter_total;

Yframe2 = Yframe(1:H,1:W);
Uframe2 = Uframe(1:H,1:W);
Vframe2 = Vframe(1:H,1:W);

for h = 1:H
    for w = 1:W
        if (mod(h,64) == 0) ||  (mod(w,64) == 0)
            Yframe2(h,w) = GREEN(1);
            Uframe2(h,w) = GREEN(2);
            Vframe2(h,w) = GREEN(3);
        end
    end
end

Y{1} = Yframe2;
U{1} = Uframe2;
V{1} = Vframe2;

yuv_export(Y,U,V,'AnalyseTrace_output_image.yuv',1,'w')

disp('pixel_counter')
disp(pixel_counter_total)
disp(pixel_counter_intra_total)
disp(pixel_counter_inter_total)
disp(pixel_counter_inter_me_total)
disp(pixel_counter_inter_mrg_total)
disp(pixel_counter_inter_gt_total)
disp('8x8 16x16 32x32 64x64')
disp(pixel_counter_intra')
disp(pixel_counter_inter')
disp('CTU size 8x8')
disp(pixel_counter_inter_me_mode(1,:,:))
disp(pixel_counter_inter_mrg_mode(1,:,:))
disp(pixel_counter_inter_gt_mode(1,:,:))
disp('CTU size 16x16')
disp(pixel_counter_inter_me_mode(2,:,:))
disp(pixel_counter_inter_mrg_mode(2,:,:))
disp(pixel_counter_inter_gt_mode(2,:,:))
disp('CTU size 32x32')
disp(pixel_counter_inter_me_mode(3,:,:))
disp(pixel_counter_inter_mrg_mode(3,:,:))
disp(pixel_counter_inter_gt_mode(3,:,:))
disp('CTU size 64x64')
disp(pixel_counter_inter_me_mode(4,:,:))
disp(pixel_counter_inter_mrg_mode(4,:,:))
disp(pixel_counter_inter_gt_mode(4,:,:))

end

