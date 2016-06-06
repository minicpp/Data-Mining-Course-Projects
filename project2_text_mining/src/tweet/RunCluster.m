function [ output_args ] = RunCluster( sparseFile, textFile, tagName )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fprintf('\n run for %s \n', tagName);
%%
Sparse=load(sparseFile);
Sparse(:,1) = Sparse(:,1) + 1;
Sparse(:,2) = Sparse(:,2) + 1;
H = spconvert(Sparse);

%%
[U, S, V] = svds(H);
VS = V(randperm(size(V,1),1000),:);
Result = ClusterAnalyze(V, 2000, 1, 20, 100);
%%
figure;
plot(Result(:,1),Result(:,2),'r*--');
xlabel(strcat('Number of clusters for ',tagName)) % x-axis label
ylabel(strcat('The mean Silhouette value for ',tagName)) % y-axis label

%%
[C,I] = max(Result(:,2));
fprintf('\n Best number of cluster is %d\n', I);
opts = statset('MaxIter',300,'UseParallel',true);
[IDX,C] = kmeans(V,I,'Distance','cosine','Options', opts);

%%
vs = V(:,[1 2]);
figure;
hold on;
cmap = hsv(I); 
for j=1:size(vs,1)
    plot([0,vs(j,1)],[0,vs(j,2)],'-', 'color', cmap(IDX(j),:));    
end

hold off;
xlabel(strcat('First dimension of  ',tagName)) % x-axis label
ylabel(strcat('Second dimension of  ',tagName)) % y-axis label

%%
fileID = fopen(textFile);
tline = fgets(fileID);
textCell = cell(1,length(IDX));
count = 1;
while ischar(tline)
    textCell{count} = tline;
    tline = fgets(fileID);
    count = count + 1;
end
fclose(fileID);

%%
selectedIndex = GetRandomIndex(IDX, I, 50);
textIndex = zeros(I,50);
countIndex = ones(I,1);
for i=1:length(selectedIndex)
    index = selectedIndex(i);
    jj = IDX(index);
    textIndex( jj, countIndex(jj) ) = index;
    countIndex(jj) = countIndex(jj) + 1;
end
countIndex = countIndex - 1;
fprintf('\n');
 for i=1:I
     fprintf('\nGroup %d:\n',i);
     for jj=1:countIndex(i)
         fprintf('%d: %s',textIndex(i,jj), textCell{textIndex(i,jj)});
     end
 end
 

end

