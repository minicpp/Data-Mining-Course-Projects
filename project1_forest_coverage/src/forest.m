%%
% load data
data = importForestFile('train.csv', 2, 15121);
%test = importForestTestfile('test.csv', 2, 565893);

%%
% init data
cover_type_N = 7;
training_sample_size = size(data,1);
observe_sample = data(:, 2:55);
observe_target = zeros(training_sample_size,cover_type_N);
observe_target_index = sub2ind(size(observe_target),1:training_sample_size,data(:,56)');
observe_target(  observe_target_index  ) = 1;
observe_sample = observe_sample';
observe_target = observe_target';
%%
%
myCluster = parcluster('local');
delete(myCluster.Jobs);
for ii=40:59
    res = struct('net',{},'tr',{},'rate',{});
    for jj=1:10
        fprintf('Running at %d,%d\n',ii,jj);
        rng('shuffle');
        net = patternnet(ii);
        
        net.divideFcn = 'dividerand';
        net.divideParam.trainRatio = 0.5;
        net.divideParam.valRatio = 0.25;
        net.divideParam.testRatio = 0.25;
        
        [net,tr]=train(net, observe_sample, observe_target,'useParallel','yes');
        res(jj).net = net;
        res(jj).tr = tr;
        
        testSample = observe_sample(:,tr.testInd);
        testSample_Actual_Target = observe_target(:,tr.testInd);
        testSample_Net_Target = net(testSample);
        
        c = confusion(testSample_Actual_Target,testSample_Net_Target);
        res(jj).rate = 1-c;
    end
    save(sprintf('net_%d.mat',ii), 'res');
    clearvars res;
end

%%
%
