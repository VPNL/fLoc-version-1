function stimseq = makeorder_fLoc(nruns,task)
% Generates stimulus sequences, scripts, and parfiles for specified number
% of functional localizer runs.
% 
% INPUTS
% nruns: number of counterbalanced stimulus sequences to generate
% task: 1 (1-back), 2 (2-back), or 3 (oddball detection)
% 
% OUTPUTS
% stimseq: data structure containing trial information
% Sperarate script files for each run of the experiment
% 
% AS 8/2015

%% EXPERIMENTAL PARAMETERS
% scanner and task parameters (modifiable)
TR = 2; % fMRI TR (must be a factor of block duration in secs)
repfreq = 1/3; % proportion of blocks with task probe
% stimulus categories (2 per condition)
cats = {'word' 'number'; ...
    'body' 'limb'; ...
    'adult' 'child'; ...
    'corridor' 'house'; ...
    'car' 'instrument'}';
ncats = numel(cats); % number of stimulus categories
nconds = length(cats)+1; % number of conditions including baseline
tasks = {'1back' '2back' 'oddball'}; % task names
% presentation and design parameters (do not change)
norders = 2; % number of counterbalanced condition orders per run
stimperblock = 8; % number of stimuli per block
stimdur = .5; % stimulus presentation duration (secs)
nblocks = 3+norders*nconds^2; % number of blocks per run including padding
ntrials = nblocks*stimperblock; % number of trials
nstim = 144; % number of stimuli per subcategory
% force TR to be a factor of block duration
if rem(stimperblock*stimdur,TR)
    TR = stimperblock*stimdur;
end
% balance frequency of stimulus repetition or oddbals across image sets
repfreq = round(repfreq*norders*nconds/2)/(norders*nconds/2);

%% GENERATE STIMULUS SEQUENCES
% initialzie stimulus sequence data structure
stimseq.block = [];
stimseq.onset = [];
stimseq.cond = [];
stimseq.task = [];
stimseq.img = {};
% randomize order of stimulus numbers for each category
for c = 1:ncats
    for r = 1:ceil(nruns/3)
        stimnums(nstim*(r-1)+1:nstim*(r-1)+nstim,c) = shuffle(1:nstim);
    end
end
catcnt = zeros(c,1);
% create stimulus sequence data structure
for r = 1:nruns
    % order of conditions with baseline padding blocks
    condorder = [0; 2*(makeorder(nconds,norders*nconds)-1); 0; 0];
    % alternate between subcategories in each condition
    for c = 2:2:ncats
        ind = find(condorder==c);
        condorder(ind(2:2:end)) = condorder(ind(2:2:end))-1;
    end
    % psuedorandomly select blocks for task
    repblocks = zeros(length(condorder),1);
    for c = 1:ncats
        ind = shuffle(find(condorder==c));
        repblocks(ind(1:round(1/repfreq):end)) = 1;
    end
    % generate image sequence without repetitions or oddballs
    for b = 1:nblocks
        if condorder(b) == 0
            imgmat(1:stimperblock,b) = {'blank'};
        else
            for i = 1:stimperblock
                catcnt(condorder(b)) = catcnt(condorder(b))+1;
                imgmat{i,b} = strcat(cats{condorder(b)},'-',num2str(stimnums(catcnt(condorder(b)),condorder(b))),'.jpg');
            end
        end
    end
    % insert repetitions or oddballs
    taskmatch = zeros(stimperblock,nblocks);
    for b = 1:nblocks
        if repblocks(b) == 1
            if task == 2
                repimg = randi(4)+3;
                taskmatch(repimg,b) = 1;
                imgmat(repimg,b) = imgmat(repimg-2,b);
            elseif task == 3
                repimg = randi(6)+1;
                taskmatch(repimg,b) = 1;
                imgmat(repimg,b) = {strcat('scrambled-',num2str(randi(144)),'.jpg')};
            else
                repimg = randi(5)+2;
                taskmatch(repimg,b) = 1;
                imgmat(repimg,b) = imgmat(repimg-1,b);
            end
        else
        end
    end
    % fill in data structure
    stimseq(r).block = reshape(repmat(1:nblocks,stimperblock,1),[],1);
    stimseq(r).onset = 0:stimdur:ntrials*stimdur-stimdur;
    stimseq(r).cond = reshape(repmat(condorder',8,1),[],1);
    stimseq(r).task = reshape(taskmatch,[],1);
    stimseq(r).img = reshape(imgmat,[],1);
end

%% WRITE SCRIPT AND PARAMETER FILES
% header lines
cnames = strcat(cats(1:end-1),{', '});
cnames = [cnames{:}];
header1 = ['fLoc: ' cnames 'and ' cats{end} ' '];
header2 = ['Number of temporal frames per run (given TR = ' num2str(TR) ' secs): ',num2str(nblocks*stimperblock*stimdur/TR),' '];
header3 = ['Total # of runs: ',num2str(nruns),' '];
header5 = 'Block      Onset     Category      TaskMatch     Image';
footer = '*** END SCRIPT ***';
% write separate script file for each run
for r = 1:nruns
    fid = fopen(strcat('script_fLoc_',tasks{task},'_run',num2str(r)),'w');
    fprintf(fid,'%s\n',header1);
    fprintf(fid,'%s\n',header2);
    fprintf(fid,'%s\n\n',header3);
    fprintf(fid,'%s\n',['*** RUN ',num2str(r),' ***']);
    fprintf(fid,'%s\n',header5);
    for t = 1:ntrials
        fprintf(fid,'%i \t %f \t %i \t %i \t %s \n',...
            stimseq(r).block(t),... % write trial block
            stimseq(r).onset(t),... % write trial onset time
            stimseq(r).cond(t),... % write trial condition
            stimseq(r).task(t),... % write trial task
            stimseq(r).img{t}); % write trial image name
    end
    fprintf(fid,'%s',footer);
    fclose(fid);
end
% write separate parfile for each run
for r = 1:nruns
    writeParfile_fLoc(strcat('script_fLoc_',tasks{task},'_run',num2str(r)),TR,stimperblock,stimdur);
end

end
