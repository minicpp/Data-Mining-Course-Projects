%%
clc;
clear;
dataset = load('dataset');
dataset = dataset.dataset;

%%
[nets64, rates64] = InitTopNetworks(100, 40:20:220, 'net@v128@f64', 50);
[rates,indexes]=RankNNRun( nets64, 100,dataset.trSampleEx,dataset.trTarget, 1,1)
[rate64tr,finalRes]=TopNNRun( nets64, indexes(1),dataset.testSampleEx,dataset.testTarget, 1);
[C,I] = max(finalRes);
%%



%%
[nets54, rates54] = InitTopNetworks(100, 40:20:220, 'net@v128@f54', 50);
[nets64, rates64] = InitTopNetworks(100, 40:20:220, 'net@v128@f64', 50);
[nets73, rates73] = InitTopNetworks(100, 40:20:220, 'net@v128@f73', 50);

%%
rate54tr1=TopNNRun( nets54, 1,dataset.trSample,dataset.trTarget, 1);
rate64tr1=TopNNRun( nets64, 1,dataset.trSampleEx,dataset.trTarget, 1);
rate73tr1=TopNNRun( nets73, 1,dataset.trSampleEx2,dataset.trTarget, 1);

%%
rate54tr10=TopNNRun( nets54, 10,dataset.trSample,dataset.trTarget, 1);
rate64tr10=TopNNRun( nets64, 10,dataset.trSampleEx,dataset.trTarget, 1);
rate73tr10=TopNNRun( nets73, 10,dataset.trSampleEx2,dataset.trTarget, 1);

%%
rate54tr100=TopNNRun( nets54, 100,dataset.trSample,dataset.trTarget, 1);
rate64tr100=TopNNRun( nets64, 100,dataset.trSampleEx,dataset.trTarget, 1);
rate73tr100=TopNNRun( nets73, 100,dataset.trSampleEx2,dataset.trTarget, 1);

%%
rate54tt1=TopNNRun( nets54, 1,dataset.testSample,dataset.testTarget, 1);
rate64tt1=TopNNRun( nets64, 1,dataset.testSampleEx,dataset.testTarget, 1);
rate73tt1=TopNNRun( nets73, 1,dataset.testSampleEx2,dataset.testTarget, 1);

%%
rate54tt10=TopNNRun( nets54, 10,dataset.testSample,dataset.testTarget, 1);
rate64tt10=TopNNRun( nets64, 10,dataset.testSampleEx,dataset.testTarget, 1);
rate73tt10=TopNNRun( nets73, 10,dataset.testSampleEx2,dataset.testTarget, 1);

%%
rate54tt100=TopNNRun( nets54, 100,dataset.testSample,dataset.testTarget, 1);

%%
rate64tt100=TopNNRun( nets64, 100,dataset.testSampleEx,dataset.testTarget, 1);

%%
rate73tt100=TopNNRun( nets73, 100,dataset.testSampleEx2,dataset.testTarget, 1);

%%
[nets54_256, rates54_256] = InitTopNetworks(100, 40:20:220, 'net@v256@f54', 50);

%%
rate54_256tr1=TopNNRun( nets54_256, 1,dataset.trSample,dataset.trTarget, 1);
rate54_256tr10=TopNNRun( nets54_256, 10,dataset.trSample,dataset.trTarget, 1);
rate54_256tr100=TopNNRun( nets54_256, 100,dataset.trSample,dataset.trTarget, 1);

%%
rate54_256tt1=TopNNRun( nets54_256, 1,dataset.testSample,dataset.testTarget, 1);
rate54_256tt10=TopNNRun( nets54_256, 10,dataset.testSample,dataset.testTarget, 1);
rate54_256tt100=TopNNRun( nets54_256, 100,dataset.testSample,dataset.testTarget, 1);

%%
[nets54_6, rates54_6] = InitTopNetworks(100, 40:20:220, 'net@v6@f54', 50);

%%
rates54_6tr1=TopNNRun( nets54_6, 1,dataset.trSample,dataset.trTarget, 1);
rates54_6tr10=TopNNRun( nets54_6, 10,dataset.trSample,dataset.trTarget, 1);
rates54_6tr100=TopNNRun( nets54_6, 100,dataset.trSample,dataset.trTarget, 1);

%%
rates54_6tt1=TopNNRun( nets54_6, 1,dataset.testSample,dataset.testTarget, 1);
rates54_6tt10=TopNNRun( nets54_6, 10,dataset.testSample,dataset.testTarget, 1);
rates54_6tt100=TopNNRun( nets54_6, 100,dataset.testSample,dataset.testTarget, 1);

%%
[nets54, rates54] = InitTopNetworks(100, 40:1:200, 'nnet\\nnet', 30);

%%
dataset = load('datasetOrg');
dataset = dataset.dataset;

%%
rates54_6tr1=TopNNRun( nets54, 1,dataset.trSample,dataset.trTarget, 1);
rates54_6tr10=TopNNRun( nets54, 10,dataset.trSample,dataset.trTarget, 1);
rates54_6tr100=TopNNRun( nets54, 100,dataset.trSample,dataset.trTarget, 1);

rates54_6tt1=TopNNRun( nets54, 1,dataset.testSample,dataset.testTarget, 1);
rates54_6tt10=TopNNRun( nets54, 10,dataset.testSample,dataset.testTarget, 1);
rates54_6tt100=TopNNRun( nets54, 100,dataset.testSample,dataset.testTarget, 1);