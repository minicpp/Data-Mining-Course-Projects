%%
tic
x = load('dataset.mat');
x = x.dataset;
toc
%%
net=selforgmap([20,20]);
net.trainParam.showWindow=false;
net.trainParam.showCommandLine = true;
net.trainParam.show = 1;
net.trainParam.epochs =   2;
[net,tr]=train(net,x.sample);
toc
fprintf('\nfinish train\n');
%%
% res = struct('net',{},'tr',{});
% res(1).net = net;
% res(1).tr = tr;
save('som20_20.mat','net','tr','-v7.3');
toc
fprintf('\nfinish save\n');

