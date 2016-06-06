data = importForestFile('train.csv', 2, 15121);
test = importForestTestfile('test.csv', 2, 565893);
test_sample = test(:, 2:55);

%%train model
cover_type_N = 7;
training_sample_size = size(data,1);
observe_sample = data(:, 2:55);
observe_target = zeros(training_sample_size,cover_type_N);
observe_target_index = sub2ind(size(observe_target),1:training_sample_size,data(:,56)');
observe_target(  observe_target_index  ) = 1;
observe_sample = observe_sample';
observe_target = observe_target';

rng('shuffle');
net = patternnet(69);
%%
%
net.divideFcn = @mydivide;

[net,tr]=train(net, observe_sample, observe_target,'useParallel','no');
%%
%
testSample = observe_sample(:,tr.testInd);
testSample_Actual_Target = observe_target(:,res(jj).tr.testInd);
testSample_Net_Target = res(jj).net(testSample);
plotconfusion(testSample_Actual_Target,testSample_Net_Target);
