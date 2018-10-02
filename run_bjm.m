%% bitrate_flag 0 -> all qps

function [] = run_bjm(R1,PSNR1,R2,PSNR2,output_name, bitrate_flag) % 1:REF 2:COMP

fid1 = fopen(R1,'r');
fid2 = fopen(PSNR1,'r');
fid3 = fopen(R2,'r');
fid4 = fopen(PSNR2,'r');
v_R1 = textscan(fid1, '%f', 'delimiter', '\t', 'treatAsEmpty', {'MAX'},'EmptyValue', 1500);
v_PSNR1 = textscan(fid2, '%f', 'delimiter', '\t', 'treatAsEmpty', {'MAX'},'EmptyValue', 1500);
v_R2 = textscan(fid3, '%f', 'delimiter', '\t', 'treatAsEmpty', {'MAX'},'EmptyValue', 1500);
v_PSNR2 = textscan(fid4, '%f', 'delimiter', '\t', 'treatAsEmpty', {'MAX'},'EmptyValue', 1500);

if bitrate_flag == 1
dsnr = bjontegaard2((v_R1{1}(1:4)),(v_PSNR1{1}(1:4)),(v_R2{1}(1:4)),(v_PSNR2{1}(1:4)),'dsnr');
rate = bjontegaard2((v_R1{1}(1:4)),(v_PSNR1{1}(1:4)),(v_R2{1}(1:4)),(v_PSNR2{1}(1:4)),'rate');
elseif bitrate_flag == 2 % special: 17 22 32 27
dsnr = bjontegaard2((v_R1{1}(1:4)),(v_PSNR1{1}(1:4)),([v_R2{1}(1:2);v_R2{1}(4:5)]),([v_PSNR2{1}(1:2);v_PSNR2{1}(4:5)]),'dsnr');
rate = bjontegaard2((v_R1{1}(1:4)),(v_PSNR1{1}(1:4)),([v_R2{1}(1:2);v_R2{1}(4:5)]),([v_PSNR2{1}(1:2);v_PSNR2{1}(4:5)]),'rate');
elseif bitrate_flag == 3
dsnr = bjontegaard2((v_R1{1}(end-3:end)),(v_PSNR1{1}(end-3:end)),(v_R2{1}(end-3:end)),(v_PSNR2{1}(end-3:end)),'dsnr');
rate = bjontegaard2((v_R1{1}(end-3:end)),(v_PSNR1{1}(end-3:end)),(v_R2{1}(end-3:end)),(v_PSNR2{1}(end-3:end)),'rate');
else
disp(v_R1{1}(:))
disp(v_R2{1}(:))
disp(v_PSNR1{1}(:))
disp(v_PSNR2{1}(:))

dsnr = bjontegaard2((v_R1{1}(1:end)),(v_PSNR1{1}(1:end)),(v_R2{1}(1:end)),(v_PSNR2{1}(1:end)),'dsnr');
rate = bjontegaard2((v_R1{1}(1:end)),(v_PSNR1{1}(1:end)),(v_R2{1}(1:end)),(v_PSNR2{1}(1:end)),'rate');
end

fidOUT = fopen(output_name,'w');
fprintf(fidOUT, '%f\n%f',dsnr,rate);
fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);
fclose(fidOUT);

end
