clear all;

% current working directory, 'onsets_{subjectnumber}.mat' are placed here
cwd = ('/Users/delfin/ ... /Onsets/');

% NOTE TO SELF:
% redo with complete list of subjects
subjects = {'811' '816' '817' '819' '820' '830' '832' '833' '839' '840' '844' '847' '849' '855' '856'};

formatSpec = '%8.6f\n';
cd(cwd)

for i = 1:numel(subjects)
    
matFileName = ['onsets_' subjects{i} '.mat'];
load(matFileName);

mkdir(subjects{i});

base = fopen(fullfile(cwd, subjects{i}, 'on_base.txt'), 'w');
fprintf(base,formatSpec,sots{1,1});
fclose(base);

rew = fopen(fullfile(cwd, subjects{i}, 'on_rew.txt'), 'w');
fprintf(rew,formatSpec,sots{1,2});
fclose(rew);

neut = fopen(fullfile(cwd, subjects{i}, 'on_neut.txt'), 'w');
fprintf(neut,formatSpec,sots{1,3});
fclose(neut);

end
