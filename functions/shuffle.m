function Y = shuffle(X)
% Randomly redorders cell and numeric arrays.
% Written by KGS Lab
% Edited by AS 8/2014

sz = size(X);
nElements = prod(sz);
[ignore,newOrder] = sort(rand(1,nElements));
Y = X(newOrder);
Y = reshape(Y,sz);

end
