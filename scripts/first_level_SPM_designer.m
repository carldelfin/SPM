% ================================================================================
% 
%   This is the FIRST LEVEL ANALYSIS script.
%
%   Onsets are in separate textfiles for each subject,
%   RP regressors are in one .mat file for each subject,
%   see onset and RP scripts for instructions on how to create these files.
%
%   This scripts builds the fMRI model design, estimates the model,
%   and creates two contrasts for each subject:
%   CON_1 is motivation > neutral,
%   CON_2 is neutral > motivation.
%
%   NOTE. Motivation used is NEGATIVE motivation only,
%   see methods section in manuscript.
% 
% ================================================================================

%%
clear all;

spm_jobman('initcfg');

% specify onset textfiles (no need to change if following onset script)
onbase = 'on_base.txt';
onrew = 'on_rew.txt';
onneut = 'on_neut.txt';

%%
% ================================================================================

% subjects are listed here, script runs separate groups for regular 
% and counterbalanced, if needed, combine both

% uncomment and rerun script for each group

% ARIPIPRAZOLE:
%
% regular: 
% subjects = {'811' '816' '817' '819' '820' '830' '832' '833'};
%
% counterbalanced:
% subjects = {'839' '840' '844' '847' '849' '855' '856'};
%
% HALOPERIDOL:
%
% Regular: 
% subjects = {'810' '812' '813' '814' '818' '822' '823' '827'};
%
% counterbalanced:
% subjects = {'836' '837' '845' '851' '852' '853' '857' '858'};
%
% PLACEBO:
%
% regular: 
% subjects = {'801' '803' '805' '806' '807' '808' '824' '825' '829' '835'};
%
% counterbalanced:
% subjects = {'835' '838' '842' '843' '846' '848' '850' '854' '859'};
%
% ================================================================================

%%
% this is the current working directory, change according to group:
cwd = '/Users/ ... /pharma/scans/p/';

cd(cwd)

spm('defaults','fMRI')

% ================================================================================

% looping over subjects begins here

    for i=1:numel(subjects)

        clear matlabbatch

%-----------------------------------------------------------------------
% job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(fullfile(cwd, subjects{i},'Firstlevel'));

% specify units for design and interscan interval:
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
%%
% specify where to find scans and what they are named
% script assumes that swREW files are located in separate 'sw' folder:
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(spm_select('ExtFPList', fullfile(cwd, subjects{i}, 'sw'), '^.*\.nii'));
%%
% specify onsets, DO NOT forget to change duration according to group,
% if this script is used for other subjects
%%
% baseline onset:
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
% reward (i.e. motivated) onset:
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
% neutral onset:
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
% specify RP (multiple regressors) file:
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
% estimate model, locate SPM.mat file:
matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(cwd, subjects{i}, 'Firstlevel', 'SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%%
% create contrasts for each subject, locate the now estimated SPM.mat:
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

%% run batch

spm_jobman('run',matlabbatch);

    end
