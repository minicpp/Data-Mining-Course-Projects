%%
tic
dataset = load('dataset.mat');
dataset = dataset.dataset;

res = load('som_20_20.mat');
%res = res.res;
toc

%%
net = res.net;
y=net(dataset.trSample);

%%
[ind, n] = vec2ind(y);
[target, m] = vec2ind(dataset.trTarget);

%%
searchTable = zeros(400, 7);

for ii=1:length(target)
    groupID = ind(ii);
    treeType = target(ii);
    val = searchTable(groupID, treeType);
    searchTable(groupID, treeType) = val + 1;
end

%%
[v,classTable] = max(searchTable,[],2);
y = net(dataset.testSample);
[ind, n] = vec2ind(y);

%%
testTarget = zeros(7, length(ind));
for ii=1:length(ind)
    groupID = ind(ii);
    classID = classTable(groupID);
    testTarget(classID, ii) = 1;
end

%%
c = confusion(dataset.testTarget, testTarget);
figure;
plotconfusion(dataset.testTarget, testTarget);    
fprintf('Accuracy:%f\n', 1-c);

