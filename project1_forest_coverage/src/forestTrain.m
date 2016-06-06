%% load data
%
dataset = load('dataset.mat');
dataset = dataset.dataset;

%% build net
%
net = patternnet(120);
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0.199;
net.divideParam.testRatio = 0.001;
net.inputs{1}.processFcns={'removeconstantrows'};
net.trainParam.showWindow=0;
[net,tr]=train(net, dataset.trSample, dataset.trTarget,'useParallel','yes');

%% evaluate
%
testTarget = net(dataset.testSample);

c = confusion(dataset.testTarget,testTarget);
rate = 1-c