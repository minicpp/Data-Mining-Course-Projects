%%
% load data
data = importForestFile('test_sov.csv', 2, 565893);
cover_type_N = 7;
training_sample_size = size(data,1);
observe_target = zeros(training_sample_size,cover_type_N);
observe_target_index = sub2ind(size(observe_target),1:training_sample_size,data(:,56)');
observe_target(  observe_target_index  ) = 1;
observe_target = observe_target';
%%
% init data
SS_net = InitTopNetworks(100, 10, 99);
final_res = TopNetworksRun(SS_net, 'test_sov.csv',565893,0);
c = confusion(observe_target,final_res);
plotconfusion(observe_target,final_res);    
fprintf('Accuracy:%f\n', 1-c);
%%
%write data to test res file
% [C,I] = max(final_res);
% test_res=[data(:,1),I'];
% csvwrite_with_headers('test_res.csv',test_res , {'Id','Cover_Type'});
