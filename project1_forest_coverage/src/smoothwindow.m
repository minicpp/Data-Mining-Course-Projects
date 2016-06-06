function [ res ] = smoothwindow( window, data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
data_length = length(data);
res = zeros(1,data_length-window+1);
count = 1;
for ii=window:data_length
    block_data = data( (ii+1-window) : ii);
    mean_block = mean(block_data);
    res(count) = mean_block;
    count = count + 1;
end

end

