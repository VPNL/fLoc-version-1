function k = getKeyboardNumber
% Checks to make sure that the laptop keyboard is used in case another
% device connected at the scanner also has the usageName Keyboard
% (keyboardID should be set to the productID of the native keyboard).
% Written by KGS Lab
% Edited by AS 8/2014

% change to productID number of native keyboard
keyboardID = 594;

k = 0;
d = PsychHID('Devices');

for n = 1:length(d)
    if (d(n).productID == keyboardID) & strcmp(d(n).usageName,'Keyboard');
        k = n;
        break
    end
end

if k == 0
    fprintf(['\nKeyboard not found.\n']);
end

end