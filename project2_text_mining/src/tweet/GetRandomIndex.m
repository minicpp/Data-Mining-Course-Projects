function [selectedIndex] = GetRandomIndex(centroid, k, sampleSize)
    uniqueCentroid = 0;
    arraySize = length(centroid);
    while uniqueCentroid ~= k
        selectedIndex = randperm(arraySize, sampleSize);
        selectedCentroid = centroid(selectedIndex);
        uniqueCentroid = unique(selectedCentroid);
        uniqueCentroid = length(uniqueCentroid);
    end
end