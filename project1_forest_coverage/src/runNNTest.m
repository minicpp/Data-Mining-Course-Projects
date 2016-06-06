%%
x = load('dataset.mat');
x = x.dataset;

%%
res = load('net92_brRingo.mat');
%res = S.res(7);

%%
target = res.net(x.testSample);
c = confusion(x.testTarget,target);
rate = 1-c
plotconfusion(x.testTarget,target);

% %%
% nnBatch = InitNNTopNetworks(1, 40, 200);
% 
% %%
% target = TopNNRun(nnBatch,x.testSample,x.testTarget,0);
% c = confusion(x.testTarget,target);
% rate = 1-c
% plotconfusion(x.testTarget,target);