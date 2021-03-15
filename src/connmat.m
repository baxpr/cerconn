function [R,Z] = connmat(data,out_dir,tag)

R = corr(data);
Z = atanh(R) * sqrt(size(data,1)-3);

csvwrite(fullfile(out_dir,['R_' tag '.csv']), R);
csvwrite(fullfile(out_dir,['Z_' tag '.csv']), Z);

