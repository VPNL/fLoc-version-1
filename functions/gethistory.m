function hist = gethistory(theorder)
% Assumes single column input where each row is a condition and computes
% the number of times a given condition is preceded by all others.
% Written by KGS Lab
% Edited by AS 8/2014

[numtrials j] = size(theorder);
[numconds j] = size(unique(theorder));
hist = zeros(numconds, numconds);
for n = 2:numtrials  
	hist(theorder(n), theorder(n-1)) = hist(theorder(n), theorder(n-1))+1;
end

end