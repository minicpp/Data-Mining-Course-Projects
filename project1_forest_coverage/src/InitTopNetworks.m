function [ output_args, rates ] = InitTopNetworks( topN, index, prefix, samplesPerNet )
% %UNTITLED Summary of this function goes here
% topN: number of selected nets
% index: the array of index for files e.g. 40:20:220
% prefix: file prefix e.g. 'net54'
% samplesPerNet: number of tests for each configuration e.g. 50
% output: output_args is set of topN nets; rates is precision on training
% set.
%%
%
CC = zeros(length(index),samplesPerNet);

fprintf('\n Running...');
for ii=1:length(index)
    fprintf('.%d.',index(ii));
    if mod(ii,15) == 0
        fprintf('\n');
    end
    S = load(sprintf('%s_%d.mat',prefix, index(ii)));
    res = S.res;
    for jj=1:samplesPerNet
        CC(ii,jj) = S.res(jj).rate;
    end
end
fprintf('\n');
[sortedValues, sortIndex] = sort(CC(:),'descend');
[x,y] = ind2sub(size(CC),sortIndex);

output_args = cell(topN,1);
rates = zeros(topN,1);
for ii=1:topN
    loadIndex = index( x(ii) );
    S = load(sprintf('%s_%d.mat',prefix, loadIndex) );
    output_args{ii} = S.res(y(ii)).net;
    rates(ii) = S.res(y(ii)).rate;
    fprintf('[%d] %d-%d:%f\n',ii, S.res(y(ii)).net.inputs{1}.size, ...
        cell2mat(S.res(y(ii)).net.layers(1).dimensions), rates(ii));
end
fprintf('...Finish\n');
end

