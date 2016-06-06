function [ Result ] = ClusterAnalyze( V,sampleSize, lowk, highk, counts )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Result = zeros(highk-lowk+1, 2);
tres = zeros(1,counts);
fprintf('\n');
opts = statset('MaxIter',300,'UseParallel',true);
for k=lowk:highk
    centroid = kmeans(V,k,'Distance','cosine','Options', opts);
    fprintf('k=%d',k);
    parfor  ii=1:counts
        selectedIndex = GetRandomIndex(centroid, k, sampleSize);
        selectedV = V(selectedIndex,:);
        selectCentroid = centroid(selectedIndex);    
        s = silhouette(selectedV, selectCentroid,'cosine');
        tres(ii) = mean(s);
        fprintf('.');
    end
    fprintf('\n');
    Result(k-lowk+1,:) = [k mean(tres)];
end
end

