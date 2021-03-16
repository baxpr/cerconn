function [R,Z] = connmat(data,out_dir,tag)

out_dir = [out_dir filesep 'CONNMAT_' upper(tag)];
mkdir(out_dir);

% Bivariate Pearson correlation
R = corr(data);
Z = atanh(R) * sqrt(size(data,1)-3);

csvwrite(fullfile(out_dir,['R_' tag '.csv']), R);
csvwrite(fullfile(out_dir,['Z_' tag '.csv']), Z);


% Partial correlation w.r.t. all other ROIs
pR = partialcorr(data);
pZ = atanh(pR) * sqrt(size(data,1)-3);

csvwrite(fullfile(out_dir,['pR_' tag '.csv']), pR);
csvwrite(fullfile(out_dir,['pZ_' tag '.csv']), pZ);
