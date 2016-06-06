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

%%Generate new features here
%1. Vertical distance is negative or positive
vertSignFeature = ones(1,sampleSize);
vertDist = observeSample(5,:);
idx = find(vertDist<0);
vertSignFeature(idx)=-1;

%2. Elevation - verticalDistanceToWater
elevation = observeSample(1,:);
eleSubVertFeature = elevation - vertDist;
%3. Elevation - horizontal_Distance_To_Hydrology*0.2
horzDist = observeSample(4,:);
eleSubHorzFeature = elevation - horzDist.*0.2;
%4. Total distance
distFeature = (vertDist.^2 + horzDist.^2).^0.5;
%5,6. HorzWater + HorzFire and abs(HorzWater -  HorzFire) 
horzFire = observeSample(10,:);
distWaterFireAbsFeature = abs(horzDist - horzFire);
distWaterFireFeature = horzDist + horzFire;
%7,8. HorzWater + HorzRoad and abs(HorzWater - HorzRoad)
horzRoad = observeSample(6,:);
distWaterRoadAbsFeature = abs(horzDist - horzRoad);
distWaterRoadFeature = horzDist + horzRoad;
%9,10 HorzRoad + HorzFire and abs(HorzRoad - HorzFire)
distRoadFireAbsFeature = abs(horzFire - horzRoad);
distRoadFireFeature = horzFire + horzRoad;
%11 Random Hillshade 3pm which are 0
hillShade3pm = observeSample(9,:);
hillShade3pmExFeature = hillShade3pm;
idx = find(hillShade3pmExFeature == 0);
maxV = max(hillShade3pmExFeature);
rng(1989);
hillShade3pmExFeature(idx) = floor(maxV.* rand(1,length(idx)));
hillShade3pm = hillShade3pmExFeature;
%observeSample(9,:) = hillShade3pm;
%12 hillShade9am to noon distance
%13 hillShadenon to 3pm distance
%14 hillShade9am to 3pm distance
hillShade9am = observeSample(7,:);
hillShadeNoon = observeSample(8,:);
hillShade9toNFeature = (hillShade9am.^2 + hillShadeNoon.^2).^0.5;
hillShadeNto3Feature = (hillShade3pm.^2 + hillShadeNoon.^2).^0.5;
hillShade9to3Feature = (hillShade9am.^2 + hillShade3pm.^2).^0.5;
%15 16 hillShad9am to aspect abs and addition
aspect = observeSample(2,:);
hillShade9toSAbsFeature = abs(hillShade9am - aspect);
hillShade9toSFeature = hillShade9am + aspect;
%17 18 hillShadNoon to aspect abs and addition
hillShadeNtoSAbsFeature = abs(hillShadeNoon - aspect);
hillShadeNtoSFeature = hillShadeNoon + aspect;
%19 20 hillShad3pm to aspect abs and addition
hillShade3toSAbsFeature = abs(hillShade3pm - aspect);
hillShade3toSFeature = hillShade3pm + aspect;

newFeatures=[vertSignFeature; eleSubVertFeature; eleSubHorzFeature; ...
    distFeature; distWaterFireFeature; distWaterFireAbsFeature; ...
    distWaterRoadFeature; distWaterRoadAbsFeature; ...
    distRoadFireFeature; distRoadFireAbsFeature];


newFeatures2=[vertSignFeature; eleSubVertFeature; eleSubHorzFeature; ...
    distFeature; distWaterFireFeature; distWaterFireAbsFeature; ...
    distWaterRoadFeature; distWaterRoadAbsFeature; ...
    distRoadFireFeature; distRoadFireAbsFeature; ...
    hillShade9toNFeature; hillShadeNto3Feature;hillShade9to3Feature; ...
    hillShade9toSAbsFeature; hillShade9toSFeature;...
    hillShadeNtoSAbsFeature; hillShadeNtoSFeature; ...
    hillShade3toSAbsFeature; hillShade3toSFeature];


newFeatures = mapminmax(newFeatures,-1,1);
newFeatures2 = mapminmax(newFeatures2,-1,1);

%part 1 is continues features
%scaled to [-1,1]
observeSampleFeaturePart1=observeSample([1:10],:);
%part 2 is binary features
%scaled to [0, 1]
observeSampleFeaturePart2=observeSample([11:54],:);
[newObserveSampleFeaturePart1,ps]=mapminmax(observeSampleFeaturePart1,-1,1);
newObserveSampleFeaturePart2=mapminmax(observeSampleFeaturePart2,0,1);

newObserveSample = [newObserveSampleFeaturePart1; ...
    newObserveSampleFeaturePart2];
%%
%
dataset = struct('sample',newObserveSample,'target',observeTarget,...
    'sampleEx', [newObserveSample;newFeatures], ...
    'sampleEx2',[newObserveSample;newFeatures2], ...
    'trSample',newObserveSample(:,1:15120), ...
    'trSampleEx',[newObserveSample(:,1:15120);newFeatures(:,1:15120)], ...
    'trSampleEx2',[newObserveSample(:,1:15120);newFeatures2(:,1:15120)], ...
    'trTarget',observeTarget(:,1:15120), ...
    'testSample', newObserveSample(:,15121:581012), ...
    'testSampleEx',[newObserveSample(:,15121:581012); newFeatures(:,15121:581012)], ...
    'testSampleEx2',[newObserveSample(:,15121:581012); newFeatures2(:,15121:581012)], ...
    'testTarget', observeTarget(:,15121:581012));

save('datasetOrg.mat','dataset');
