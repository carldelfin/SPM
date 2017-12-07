
clear all;

% SUBJECTS NUMBERS GO HERE (WITHOUT _CB)
subjects={'811' '816' '817' '819' '820' '830' '832' '833' '839' '840' '844' '847' '849' '855' '856'};

formatSpec = ('%f %f %f %f %f %f');

% CURRENT WORKING DIRECTORY > SPECIFIES WER SUBJECTS' FOLDERS ARE
cwd = '/Users/delfin/Documents/Research/NORMENT/Pharma_Ny/Ariprip/'; % Main directory


for i=1:numel(subjects);

% VARIABLE NAME OF RP TEXTFILE
rp = ['rp_Rew' subjects{i} '#001.txt'];
  
    
cd(cwd)
savespec = [cwd, subjects{i}, '/rp'];
fid = fopen(fullfile(cwd, subjects{i}, 'rp', rp), 'rt');
rpp = textscan(fid, formatSpec);
fclose(fid);

R = [rpp{1,1}, rpp{1,2}, rpp{1,3}, rpp{1,4}, rpp{1,5}, rpp{1,6}];

cd(savespec);
save('multi_reg.mat', 'R'); % THIS IS OUTPUT FOR USE IN FIRST LEVEL ANALYSIS 

end;
