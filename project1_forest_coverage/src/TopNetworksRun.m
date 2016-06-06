function [ final_res ] = TopNetworksRun( netArray,filename,rows,flag )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%565893
if flag == 0
    test = importForestTestfile(filename, 2, rows);
    test_sample = test(:, 2:55)';
else
    test = importForestAllfile(filename, 1, rows);
    test_sample = test(:, 1:54)';
end
sample_length = size(test_sample,2);
netSize = length(netArray);
test_target = zeros(7,sample_length,netSize);

parfor i=1:netSize
    fprintf('Run on network %d/%d\n',i,netSize);
    test_res = zeros(7,sample_length);
    test_res = netArray(i).net(test_sample);
    [C,I] = max(test_res);
    test_res(:) = 0;
    I = sub2ind(size(test_res),I, 1:size(test_res,2));
    test_res(I) = 1;
    test_target(:,:,i) = test_res;
end

final_res =  sum(test_target,3);
[C,I] = max(final_res);
final_res(:) = 0;
I = sub2ind(size(final_res),I, 1:size(final_res,2));
final_res(I) = 1;
end

