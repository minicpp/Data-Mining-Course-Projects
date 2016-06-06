[nets64, rates64] = InitTopNetworks(14, 40:20:220, 'net@v128@f64', 50);

%%
[rates,indexes]=RankNNRun( nets64, 14,dataset.trSampleEx,dataset.trTarget, 1,1)

%%
[rate64tr,finalRes]=TopNNRun( nets64, indexes(1),dataset.testSampleEx,dataset.testTarget, 1);
[C,I] = max(finalRes);
%%
%testRes=[15121:581012;I];
%csvwrite_with_headers('test_res.csv',testRes' , {'Id','Cover_Type'});