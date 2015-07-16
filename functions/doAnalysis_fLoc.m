function theData = doAnalysis_fLoc(theSubject,data,waitDur,viewTime)
% Computes the proportion of 2-back repetitions detected within a given
% time window and the number of false alarms for a given run.
% INPUTS
% theSubject: subject data structure
% data: raw keypress data
% waitDur: time to wait for response
% viewTime: stimulus presentation duration
% AS 8/2014

data.resp = [];
data.nreps = [];
data.hits = [];
data.falseAlarms = [];
data.propHit = [];

% identify trials with a response
for t = 1:length(data.keys)
    if strcmp(data.keys{t},'noanswer')
        data.resp(t) = 0;
    else
        data.resp(t) = 1;
    end
end

% specify time windows for hits
correctResp = zeros(length(data.keys),1);
repIndex = find(theSubject.trials.task);
nreps = length(repIndex);
for t = 1:nreps
    for i = 1:waitDur/viewTime
        correctResp(repIndex(t)+i-1) = 1;
    end
end
data.nreps = nreps;

% calculate proportion of hits
hitCnt = 0;
cnt = 0;
for i = 1:nreps
    cnt = cnt+1;
    if sum(data.resp(repIndex(i):repIndex(i)+waitDur/viewTime-1)) >= 1
        hitCnt = hitCnt+1;
    else
    end
end
data.hits = hitCnt;
data.propHit = hitCnt/nreps;

% count number of false alarms
faCnt = 0;
for t = 1:length(data.keys)
    if correctResp(t) == 0 && data.resp(t) == 1
        faCnt = faCnt+1;
    else
    end
end
data.falseAlarms = faCnt;

% store analyzed data
theData = data;

end