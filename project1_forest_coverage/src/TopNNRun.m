function [rate,final_res ] = TopNNRun( netArray,topN,test,target, mode)
% TopNNRun
% INPUT:
% netArray, the nets; topN, selected nets; test: test set;
% target: target set
% mode: 1 is rounding (default), 0 is not rounding for output
% OUTPUT:  rate is precision, final_res is target
if(nargin < 5)
    mode = 1;
end
sampleLength = size(test,2);
netSize = topN;
%testTarget = zeros(7,sampleLength,netSize);
testTarget = zeros(7,sampleLength);
%parfor i=1:netSize
for i=1:netSize
    fprintf('Run on network %d/%d\n',i,netSize);
    %testRes = zeros(7,sampleLength);
    testRes = netArray{i}(test);
    [C,I] = max(testRes);
    if mode ~= 1    %if mode is not 1, we convert result to 0 or 1
        testRes(:) = 0;
        I = sub2ind(size(testRes),I, 1:size(testRes,2));
        testRes(I) = 1;
    end
    testTarget = testTarget + testRes;
end

% final_res =  sum(testTarget,3);
final_res = testTarget;
[C,I] = max(final_res);
final_res(:) = 0;
I = sub2ind(size(final_res),I, 1:size(final_res,2));
final_res(I) = 1;
rate = 1- confusion(target, final_res);
end

