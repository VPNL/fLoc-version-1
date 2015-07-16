function runme(nruns,startRun)
% Prompts experimenter for session information and executes functional
% localizer experiment used to define regions in high-level visual cortex
% selective to written characters, body parts, faces, and places. 
% 
% INPUTS (optional)
% nruns: total number of runs to execute sequentially (default is 3 runs)
% startRun: run number to start with if interrupted (default is run 1)
% 
% STIMULUS CATEGORIES (2 subcategories for each stimulus condition)
% Written characters
%     1 = word:  English psueudowords (3-6 characters long; see Glezer et al., 2009)
%     2 = number: whole numbers (3-6 characters long)
% Body parts
%     3 = body: headless bodies in variable poses
%     4 = limb: hands, arms, feet, and legs in various poses and orientations
% Faces
%     5 = adult: adults faces
%     6 = child: child faces
% Places
%     7 = corridor: views of indoor corridors placed aperature
%     8 = house: houses and buildings isolated from background
% Objects
%     9 = car: motor vehicles with 4 wheels
%     10 = instrument: string instruments
% Baseline = 0
%
% EXPERIMENTAL DESIGN
% Run duration: 5 min + countdown (12 sec by default)
% Block duration: 4 sec (8 images shown sequentially for 500 ms each)
% Task: 1 or 2-back image repetition detection or odddball detection
% 6 conditions counterbalanced (5 stimulus conditions + baseline condition)
% 12 blocks per condition (alternating between subcategories)
%
% Version 2.0 8/2015
% Anthony Stigliani (astiglia@stanford.edu)
% Department of Psychology, Stanford University

%% SET DEFUALTS
if ~exist('nruns','var')
    nruns = 3;
end
if ~exist('startRun','var')
    startRun = 1;
end
if startRun > nruns
    error('startRun cannot be greater than nruns')
end

%% SET PATHS
path.baseDir = pwd; addpath(path.baseDir);
path.fxnsDir = fullfile(path.baseDir,'functions'); addpath(path.fxnsDir);
path.scriptDir = fullfile(path.baseDir,'scripts'); addpath(path.scriptDir);
path.dataDir = fullfile(path.baseDir,'data'); addpath(path.dataDir);
path.stimDir = fullfile(path.baseDir,'stimuli'); addpath(path.stimDir);

%% COLLECT SESSION INFORMATION
% initialize subject data structure
subject.name = {};
subject.date = {};
subject.experiment = 'fLoc';
subject.task = -1;
subject.scanner = -1;
subject.script = {};
% collect subject info and experimental parameters
subject.name = input('Subject initials : ','s');
subject.name = deblank(subject.name);
subject.date = date;
while ~ismember(subject.task,[1 2 3])
    subject.task = input('Task (1 = 1-back, 2 = 2-back, 3 = oddball) : ');
end
while ~ismember(subject.scanner,[0 1])
    subject.scanner = input('Trigger scanner? (0 = no, 1 = yes) : ');
end

%% GENERATE STIMULUS SEQUENCES
if startRun == 1
    % create subject script directory
    cd(path.scriptDir);
    makeorder_fLoc(nruns,subject.task);
    subScriptDir = [subject.name '_' subject.date '_' subject.experiment];
    mkdir(subScriptDir);
    % create subject data directory
    cd(path.dataDir);
    subDataDir = [subject.name '_' subject.date '_' subject.experiment];
    mkdir(subDataDir);
    % prepare to exectue experiment
    cd(path.baseDir);
    sprintf(['\n' num2str(nruns) ' runs will be exectued.\n']);
end
tasks = {'1back' '2back' 'oddball'};

%% EXECUTE EXPERIMENTS AND SAVE DATA FOR EACH RUN
for r = startRun:nruns
    % execute this run of experiment
    subject.script = ['script_' subject.experiment '_' tasks{subject.task} '_run' num2str(r)];
    sprintf(['\nRun ' num2str(r) '\n']);
    WaitSecs(1);
    [theSubject theData] = et_run_fLoc(path,subject);
    % save data for this run
    cd(path.dataDir); cd(subDataDir);
    saveName = [theSubject.name '_' theSubject.date '_' theSubject.experiment '_' tasks{subject.task} '_run' num2str(r)];
    save(saveName,'theData','theSubject')
    cd(path.baseDir);
end

%% BACKUP SCRIPT AND PARAMTER FILES FOR THIS SESSION
for r = 1:nruns
    cd(path.scriptDir);
    movefile(['script_' subject.experiment '_' tasks{subject.task} '_run' num2str(r)],subScriptDir);
    cd(path.dataDir);
    movefile(['script_' subject.experiment '_' tasks{subject.task} '_run' num2str(r) '_' subject.date '.par'],subScriptDir);
end
cd(path.baseDir);

end