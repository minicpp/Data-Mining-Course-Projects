function [rates,index ] = RankNNRun( netArray,topN,test,target, mode, bfigure)
% TopNNRun
% INPUT:
% netArray, the nets; topN, selected nets; test: test set;
% target: target set
% mode: 1 is rounding (default), 0 is not rounding for output
% OUTPUT:  rate is precision, final_res is target
if(nargin < 5)
    mode = 1;
    bfigure = 0;
elseif nargin < 6
    bfigure = 0;
end
sampleLength = size(test,2);
netSize = topN;
%testTarget = zeros(7,sampleLength,netSize);
testTarget = zeros(7,sampleLength);
rates = zeros(netSize,1);
%parfor i=1:netSize
finalRes = testTarget;
for i=1:netSize
    fprintf('Run on network %d/%d; ',i,netSize);
    testRes = netArray{i}(test);
    [C,I] = max(testRes);
    if mode ~= 1    %if mode is not 1, we convert result to 0 or 1
        testRes(:) = 0;
        I = sub2ind(size(testRes),I, 1:size(testRes,2));
        testRes(I) = 1;
    end
    testTarget = testTarget + testRes;
    [C,I] = max(testTarget);
    finalRes(:) = 0;
    I = sub2ind(size(finalRes),I, 1:size(finalRes,2));
    finalRes(I) = 1;
    rates(i) = 1- confusion(target, finalRes);
    fprintf(' precision: %f\n', rates(i));
end
if bfigure ~= 0
    plot(1:netSize, rates, 'b-o');
end
[rates,index] = sort(rates,'descend')
% final_res =  sum(testTarget,3);
end

