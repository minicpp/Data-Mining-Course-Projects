%%
tic
x = load('dataset.mat');
x = x.dataset;
toc
%%
% for ii=40:200
%     res = struct('net',{},'tr',{},'rate',{});
%     for jj=1:30
%         fprintf('Running at %d,%d\n',ii,jj);
%         rng('shuffle');
%         net = patternnet(ii);        
%         [net,tr]=train(net, x.trSample, x.trTarget,'useParallel','yes');
%         res(jj).net = net;
%         res(jj).tr = tr;
%         
%         testSample = x.trSample(:,tr.testInd);
%         testSample_Actual_Target = x.trTarget(:,tr.testInd);
%         testSample_Net_Target = net(testSample);        
%         c = confusion(testSample_Actual_Target,testSample_Net_Target);
%         res(jj).rate = 1-c;
%         fprintf('%d,%d Precision = %f\n', ii, jj, res(jj).rate);
%     end
%     save(sprintf('net_%d.mat',ii), 'res');
%     clearvars res;
% end

rng('shuffle');
%parpool(24);
%net = patternnet(92,'trainbr'); 
net = patternnet(92,'trainbr'); 
net.divideFcn = '';
% net.divideFcn = 'dividerand';
% net.divideParam.trainRatio = 0.8;
% net.divideParam.valRatio = 0.2;
% net.divideParam.testRatio = 0;
net.trainParam.showWindow=false;
net.trainParam.showCommandLine = true;
net.trainParam.show = 1;
net.trainParam.goal = 0.0382;
net.trainParam.min_grad = 2e-5;
net.trainParam.epochs = 500;
[net,tr]=train(net, x.trSample, x.trTarget,'useParallel','yes', ...
    'CheckpointFile','cp.mat','CheckpointDelay', 10);
save('net92_br.mat','net','tr');
%delete(gcp)
% resTarget = net(x.trSample);
% plotconfusion(x.trTarget, resTarget);
% 
% %%
% %
% resTarget = net(x.testSample);
% plotconfusion(x.testTarget, resTarget);