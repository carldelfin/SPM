clear all;

% subject numbers go here (without _cb)
subjects = {'811' '816' '817' '819' '820' '830' '832' '833' '839' '840' '844' '847' '849' '855' '856'};

formatSpec = ('%f %f %f %f %f %f');

% current working directory, point to where subject folders are
% this should be set to pharma group folder, change as needed
cwd = '/Volumes/2TB/norment/pharma/scans/a';

for i = 1:numel(subjects);

% variable name of RP textfile
rp = ['rp_Rew' subjects{i} '#001.txt'];

cd(cwd)
savespec = [cwd, subjects{i}, '/rp'];
fid = fopen(fullfile(cwd, subjects{i}, 'rp', rp), 'rt');
rpp = textscan(fid, formatSpec);
fclose(fid);

R = [rpp{1,1}, rpp{1,2}, rpp{1,3}, rpp{1,4}, rpp{1,5}, rpp{1,6}];

cd(savespec);
save('multi_reg.mat', 'R'); % this file is for use in first level analysis 

end;
