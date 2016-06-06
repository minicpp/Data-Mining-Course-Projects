%%
clc;clear;
tic
x = load('dataset.mat');
x = x.dataset;
toc
%%
features=[64, 73];
for kk=features
    trainingTarget = x.trTarget;
    if kk==54
        trainingSample = x.trSample;
    elseif kk == 64
        trainingSample = x.trSampleEx;
    else
        trainingSample = x.trSampleEx2;
    end
    for ii=180:20:220
        res = struct('net',{},'tr',{},'rate',{});
        for jj=1:50
            fprintf('Running at %d:%d,%d\n',kk,ii,jj);
            rng('shuffle');
            net = patternnet(ii);
            net.divideFcn = 'dividerand';
            net.divideParam.trainRatio = 0.8;
            net.divideParam.valRatio = 0.2;
            net.divideParam.testRatio = 0;
            net.trainParam.max_fail = 128;            
            net.trainParam.show = 50;
            net.inputs{1}.processFcns={'removeconstantrows'};
            [net,tr]=train(net, trainingSample, trainingTarget,'useParallel','yes');
            fprintf('net input features:%d\n', net.inputs{1}.size);
            SS = net.inputs{1}.processedRange;
            res(jj).net = net;
            res(jj).tr = tr;
            target = net(trainingSample);
            c = confusion(trainingTarget,target);
            res(jj).rate = 1-c;
            fprintf('%d:%d,%d Precision = %f\n',kk, ii, jj, res(jj).rate);
            toc
        end
        save(sprintf('net%d_%d.mat',kk,ii), 'res');
        clearvars res;
    end
end