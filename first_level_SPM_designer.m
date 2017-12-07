% ================================================================================
% =
% =     FIRST LEVEL ANALYSIS SCRIPT.
% =     ONSETS ARE IN SEPARATE TEXTFILES FOR EACH SUBJECT.
% =     RP REGRESSORS ARE IN ONE .MAT FILE FOR EACH SUBJECT.
% =     SEE ONSET AND RP SCRIPTS ON HOW TO CREATE THESE.
% =     THIS SCRIPT BUILDS THE FMRI MODEL DESGIN, ESTIMATES THE MODEL,
% =     AND CREATES TWO CONTRASTS FOR EACH SUBJECT:
% =     CON_1 IS MOTVATION > NEUTRAL, CON_2 IS NEUTRAL > MOTIVATION
% =     THE MOTVIATION USED IS NEGATIVE MOTIVATION ONLY, 
% =     SEE METHODS SECTION IN MANUSCRIPT.
% =
% ================================================================================
%%
clear all;

spm_jobman('initcfg');

% SPECIFY ONSET TEXTFILES (NO NEED TO CHANGE IF FOLLOWING ONSET SCRIPT)
onbase = 'on_base.txt';
onrew = 'on_rew.txt';
onneut = 'on_neut.txt';
%%
% ================================================================================

% SUBJECTS ARE LISTED HERE. SCRIPT NOW RUNS GROUPS SEPARATE FOR REGULAR 
% AND COUNTERBALANCED, IF NEEDED JUST COMBINE BOTH

% ARIPIPRAZOLE SUBJECTS:
%
% Regular: 
% subjects={'811' '816' '817' '819' '820' '830' '832' '833'};
%
% Counterbalanced:
% subjects={'839' '840' '844' '847' '849' '855' '856'};
%
% HALDOL SUBJECTS:
%
% Regular: 
% subjects={'810' '812' '813' '814' '818' '822' '823' '827'};
%
% Counterbalanced:
% subjects={'836' '837' '845' '851' '852' '853' '857' '858'};
%
% PLACEBO SUBJECTS:
%
% Regular: 
% subjects={'801' '803' '805' '806' '807' '808' '824' '825' '829' '835'};
%
% Counterbalanced:
subjects={'835' '838' '842' '843' '846' '848' '850' '854' '859'};
%
% ================================================================================
%%
% THIS IS THE CURRENT WORKING DIRECTORY, CHANGE ACCORDING TO GROUP:
cwd = '/Users/delfin/Documents/NORMENT/pharma/scans/placebo/';

cd(cwd)

spm('defaults','fMRI')

% ================================================================================

% LOOPING OVER SUBJECTS BEGINS HERE:

    for i=1:numel(subjects)

        clear matlabbatch

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(fullfile(cwd, subjects{i},'Firstlevel'));

% SPECIFIES UNITS FOR DESIGN AND INTERSCAN INTERVAL:
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
%%
% SPECIFIES WHERE TO FIND SCANS AND WHAT THEY ARE NAMED
% SCRIPT NOW ASSUMES THAT swREW FILES ARE LOCATED IN SEPARATE 'sw' FOLDER:
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(spm_select('ExtFPList', fullfile(cwd, subjects{i}, 'sw'), '^.*\.nii'));
%%
% SPECIFIES ONSETS, DO NOT FORGET TO CHANGE DURATION ACCORDING TO GROUP IF
% YOU USE THIS SCRIPT FOR OTHER SUBJECTS
%%
% BASELINE ONSET:
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Baseline';

fid = fopen(fullfile(cwd, subjects{1}, 'Behavioural', onbase), 'rt');
on_b = textscan(fid, '%f');
on_b = on_b{:};
fclose(fid);

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = on_b;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 14;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
%%
% REWARD (OR MOTIVATED) ONSET:
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Reward';

fid = fopen(fullfile(cwd, subjects{1}, 'Behavioural', onrew), 'rt');
on_r = textscan(fid, '%f');
on_r = on_r{:};
fclose(fid);

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = on_r;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 28;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
%%
% NEUTRAL ONSET:
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Neutral';

fid = fopen(fullfile(cwd, subjects{1}, 'Behavioural', onneut), 'rt');
on_n = textscan(fid, '%f');
on_n = on_n{:};
fclose(fid);

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = on_n;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 28;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
%%
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
%%
% SPECIFIES RP (MULTIPLE REGRESSORS) FILE:
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {fullfile(cwd, subjects{i}, 'rp', 'multi_reg.mat')};
%%
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
%%
% ESTIMATES THE MODEL, LOCATES SPM.MAT FILE:
matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(cwd, subjects{i}, 'Firstlevel', 'SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%%
% CREATES CONTRASTS FOR EACH SUBJECTS, LOCATES THE NOW ESTIMATED SPM.MAT:
matlabbatch{3}.spm.stats.con.spmmat = {fullfile(cwd, subjects{i}, 'Firstlevel', 'SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Rew>Neut';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [0 1 -1 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Neut>Rew';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 -1 1 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Rew_only';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 1 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Neut_only';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [0 0 1 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

%% Run batch

spm_jobman('run',matlabbatch);

    end
    