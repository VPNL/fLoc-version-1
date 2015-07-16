function Trials = readScript_fLoc(script)
% Reads information from script file and outputs results in trials data
% structure containing information about block number, stimulus onset,
% condition, image repetition (for 2-back task), and image.
% AS 8/2014

% initialize trial data structure
Trials.block = [];
Trials.onset = [];
Trials.cond = [];
Trials.task = [];
Trials.img = {};

% open script file
fid = fopen(script);

% skip header lines
for l = 1:6
    skipText = fgetl(fid);
end

% read in trial inforamtion
cnt = 1;
blocknum = fscanf(fid,'%s',1);
while ~isempty(blocknum) && strncmp('*',blocknum,1) == 0
    Trials.block(cnt) = str2num(blocknum);
    Trials.onset(cnt) = fscanf(fid,'%f',1);
    Trials.cond(cnt) = fscanf(fid,'%d',1);
    Trials.task(cnt) = fscanf(fid,'%i',1);
    Trials.img{cnt} = fscanf(fid,'%s',1);
    skipLine = fgetl(fid);
    cnt = cnt+1;
    blocknum = fscanf(fid,'%s',1);
end

% close script file
fclose(fid);

end