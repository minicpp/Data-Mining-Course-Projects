function [ output_args ] = InitNNTopNetworks( topN, minIndex, maxIndex )
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
% 
% data = importForestFile('train.csv', 2, 15121);
% 
% %%
% % init data
% cover_type_N = 7;
% training_sample_size = size(data,1);
% observe_sample = data(:, 2:55);
% observe_target = zeros(training_sample_size,cover_type_N);
% observe_target_index = sub2ind(size(observe_target),1:training_sample_size,data(:,56)');
% observe_target(  observe_target_index  ) = 1;
% observe_sample = observe_sample';
% observe_target = observe_target';

%%
%
SizePerSample = 30;
CC = zeros(maxIndex-minIndex+1,SizePerSample);

fprintf('\n Running...');
for ii=minIndex:maxIndex
    fprintf('.%d.',ii);
    if mod(ii,15) == 0
        fprintf('\n');
    end
    S = load(sprintf('nnet/nnet_%d.mat', ii));
    res = S.res;
    for jj=1:SizePerSample
        CC(ii-minIndex+1,jj) = S.res(jj).rate;
    end
end
fprintf('\n');
[sortedValues, sortIndex] = sort(CC(:),'descend');
[x,y] = ind2sub(size(CC),sortIndex);

output_args = struct('net',{},'rate',{});
for ii=1:topN
    S = load(sprintf('nnet/nnet_%d.mat', x(ii)+minIndex-1));
    %S.res(y(ii)).net;
    output_args(ii).net = S.res(y(ii)).net;
    output_args(ii).rate = S.res(y(ii)).rate;
    fprintf('%d:%f\n',cell2mat(S.res(y(ii)).net.layers(1).dimensions), output_args(ii).rate);
end
fprintf('...Finish\n');
end

