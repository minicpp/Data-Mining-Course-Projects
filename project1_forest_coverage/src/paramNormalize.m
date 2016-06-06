%%
% load data
data = importForestAllfile('covtype.csv', 1, 581012);
coverTypeN = 7;
sampleSize = size(data,1);
observeTarget = zeros(sampleSize,coverTypeN);
observeTargetIndex = sub2ind(size(observeTarget),1:sampleSize,data(:,55)');
observeTarget(  observeTargetIndex  ) = 1;
observeTarget = observeTarget';

observeSample = data(:, 1:54);
observeSample = observeSample';

observeSampleFeaturePart1=observeSample([1:10],:);
observeSampleFeaturePart2=observeSample([11:54],:);
%%
%
newObserveSampleFeaturePart1=mapminmax(observeSampleFeaturePart1,-1,1);
newObserveSampleFeaturePart2=mapminmax(observeSampleFeaturePart2,0,1);

newObserveSample = [newObserveSampleFeaturePart1; ...
    newObserveSampleFeaturePart2];

%%
%
dataset = struct('sample',newObserveSample,'target',observeTarget,...
    'trSample',newObserveSample(:,1:15120), ...
    'trTarget',observeTarget(:,1:15120), ...
    'testSample', newObserveSample(:,15121:581012), ...
    'testTarget', observeTarget(:,15121:581012));

save('dataset.mat','dataset');
