%%
% load data
%data = importForestFile('train.csv', 2, 15121);
 data = importForestFile('test.csv', 2, 565893);
% training_sample_size = size(data,1);
% observe_target = zeros(training_sample_size,cover_type_N);
% observe_target_index = sub2ind(size(observe_target),1:training_sample_size,data(:,56)');
% observe_target(  observe_target_index  ) = 1;
% observe_target = observe_target';
%test = importForestTestfile('test.csv', 2, 565893);
%test_sample = test(:, 2:55);
%%
% init data

SS_net = InitTopNetworks(100, 10, 99);

final_res = TopNetworksRun(SS_net, 'test.csv',565893, 0);
%c = confusion(observe_target,final_res)
%1-c
%%
%write data to test res file
[C,I] = max(final_res);
test_res=[data(:,1),I'];
csvwrite_with_headers('test_res.csv',test_res , {'Id','Cover_Type'});
