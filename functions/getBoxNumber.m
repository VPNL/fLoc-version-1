function deviceNumber = getBoxNumber
% Checks connected USB devices and returns the device number corresponding
% to the scanner button box (buttonBoxID should be set the the productID of
% the button box used locally).
% Written by KGS Lab
% Edited by AS 8/2014

% change to productID number of local button box
buttonBoxID = 8;

deviceNumber = 0;
d = PsychHID('Devices');

for n = 1:length(d)
    if (d(n).productID == buttonBoxID) && (strcmp(d(n).usageName,'Keyboard'))
        deviceNumber = n;
    end
end

if deviceNumber == 0
    fprintf(['\nButton box not found.\n']);
end

end