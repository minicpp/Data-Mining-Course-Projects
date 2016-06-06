%%
tic
x = load('dataset.mat');
x = x.dataset;
toc
%%
for ii=40:200
    res = struct('net',{},'tr',{},'rate',{});
    for jj=1:30
        fprintf('Running at %d,%d\n',ii,jj);
        rng('shuffle');
        
        net = patternnet(ii);        
        net.divideFcn = 'dividerand';
        net.divideParam.trainRatio = 0.8;
        net.divideParam.valRatio = 0.2;
        net.divideParam.testRatio = 0;
        
        %this statement is extremely important
        %it can increase the precision significantly to exceed 70%
        %in test sets and exceed 80% in training sets
        net.inputs{1}.processFcns={'removeconstantrows'};
        
        [net,tr]=train(net, x.trSample, x.trTarget,'useParallel','yes');
        res(jj).net = net;
        res(jj).tr = tr;
        
        testSample = x.trSample(:,tr.testInd);
        testSample_Actual_Target = x.trTarget(:,tr.testInd);
        
        target = net(x.trSample);
        c = confusion(x.trTarget,target);
        
        %testSample_Net_Target = net(testSample);        
        %c = confusion(testSample_Actual_Target,testSample_Net_Target);
        res(jj).rate = 1-c;
        fprintf('%d,%d Precision = %f\n', ii, jj, res(jj).rate);
    end
    save(sprintf('net_%d.mat',ii), 'res');
    clearvars res;
end