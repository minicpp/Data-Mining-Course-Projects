function [  ] = RunNNForestFunc( f54Index, f64Index, f73Index, ...
    sampleSize, maxFail, prefix, datasetfile, bParallel, sizeCore )
%Training Neural Network
%   INPUT:
%       f54Index: hidden nodes array for 54 features;
%       f64Index: hidden nodes array for 64 features;
%       f73Index: hidden nodes array for 73 features;
%       sampleSize: the testing times for each Neural Network;
%       maxFail: training validation times for early stop;
%       prefix: file prefix string;
%       datasetfile: file name string of dataset
%       bParallel: 0 or 1. run in parallel (default is parallel=1)
%       sizeCore: how many cores to use (0 uses default profile)
%   OUTPU: NULL

%%
useParallel = 'yes';
if nargin == 8
    if bParallel == 0
        useParallel = 'no';
    end
elseif nargin == 9  %init parpool
    if bParallel == 0
        useParallel = 'no';
    else
        if sizeCore > 0
            poolobj = gcp('nocreate');
            if isempty(poolobj)
                parpool(sizeCore);
            else
                poolsize = poolobj.NumWorkers;
                if poolsize ~= sizeCore
                    delete(poolobj);
                    parpool(sizeCore);
                end
            end
        end
    end
end
tic
x = load(datasetfile);
x = x.dataset;
toc
%%
features=[54 64 73];
for kk=features
    trainingTarget = x.trTarget;
    if kk==54
        iiIndex = f54Index;
        trainingSample = x.trSample;
    elseif kk == 64
        iiIndex = f64Index;
        trainingSample = x.trSampleEx;
    else
        iiIndex = f73Index;
        trainingSample = x.trSampleEx2;
    end
    for ii=iiIndex
        res = struct('net',{},'tr',{},'rate',{});
        for jj=1:sampleSize
            fprintf('Running at %d:%d,%d/%d; Maxfail:%d\n',kk,ii,jj, ...
                sampleSize,maxFail);
            rng('shuffle');
            net = patternnet(ii);
            net.divideFcn = 'dividerand';
            net.divideParam.trainRatio = 0.8;
            net.divideParam.valRatio = 0.2;
            net.divideParam.testRatio = 0;
            net.trainParam.max_fail = maxFail;
            net.trainParam.show = 50;
            net.trainParam.showWindow = 0;
            net.trainParam.showCommandLine = 1;
            net.inputs{1}.processFcns={'removeconstantrows'};
            [net,tr]=train(net, trainingSample, trainingTarget, ...
                'useParallel',useParallel);
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
        save(sprintf('%s@v%d@f%d_%d.mat',prefix,maxFail,kk,ii), 'res');
        clearvars res;
    end
end

end

