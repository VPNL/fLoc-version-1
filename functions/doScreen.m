function [w,center,gray] = doScreen
% Opens a fullscreen window, sets text properties, and hides the cursor.
% Written by KGS Lab
% Edited by AS 8/2014

% open window and find center
[w,rect] = Screen('OpenWindow',0);
center = [rect(3) rect(4)]/2;

% set text properties
gray = 128;
Screen('TextFont',w, 'Times');
Screen('TextSize',w,24);
Screen('FillRect', w, gray);

% hide cursor
HideCursor;

end