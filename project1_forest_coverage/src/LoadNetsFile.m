function [ nets, rates, netSize ] = LoadNetsFile( filename, dsort )
% parameter: filename
%output: nets, rates, netSize
if nargin <2
    dsort = 0;
end
file = load(filename);
res = file.res;
netSize = length(res);
rates = zeros(netSize,1);
nets = cell(netSize,1);

for ii=1:netSize
    rates(ii) = res(ii).rate;
end

if dsort ~= 0
    [B,I] = sort(rates,'descend');
    rates = B;
    for ii=1:netSize
        nets{ii} = res(I(ii)).net;
    end
else
    for ii=1:netSize
        nets{ii} = res(ii).net;
    end
end


end

