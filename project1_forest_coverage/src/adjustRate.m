%%
dataset = load('dataset.mat');
dataset = dataset.dataset

%
for ii=40:200
    %saveRes = struct('net',{},'tr',{},'rate',{});
    S = load(sprintf('nnet/nnet_%d.mat', ii));
    res = S.res;
    for jj=1:30
        target = res(jj).net(dataset.trSample);
        c = confusion(dataset.trTarget,target);
        res(jj).rate= 1-c;
    end
    save(sprintf('nnet/nnet_%d.mat', ii),'res');
    fprintf('finish %d\n',ii);
end