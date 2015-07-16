function getKey(key,laptopKey)
% Waits until user presses the key specified in first argument.
% Written by KGS Lab
% Edited by AS 8/2014

while 1
    while 1
        [keyIsDown,secs,keyCode] = KbCheck(laptopKey);
        if keyIsDown
            break
        end
    end
    pressedKey = KbName(keyCode);
    if ismember(key,pressedKey)
        break
    end
end

end