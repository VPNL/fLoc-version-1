function drawFixation(windowPtr,center,color)
% Draws round fixation marker in the center of the window by superimposing
% vertical and horizontal bars.
% Written by KGS Lab
% Edited by AS 8/2014

% find center of window
centerX = center(1);
centerY = center(2);

% draw horizontal bar
Screen('FillRect', windowPtr, color, [centerX-3 centerY-2 centerX+3 centerY+2]);

% draw vertical bar
Screen('FillRect', windowPtr, color, [centerX-2 centerY-3 centerX+2 centerY+3]);

end