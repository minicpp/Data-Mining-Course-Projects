sparse=0.00001;
for i=1:10    
    R=sprand(100000,100000,sparse);    
    fprintf('build matrix\n')
    fprintf('run %f\n',sparse);
    tic
        [a,b,c]=svds(R);
    toc
    sparse=sparse + 0.00002;
end

%%
ct=[ 6.62 6.00 11.213133  8.36 9.383135 10.152371 16.09  19.732706 14.067867 21.806021]
cx=zeros(1,10);
sparse=0.00001;
for i=1:10
    cx(i) = sparse;
    sparse=sparse + 0.00002;
end
bar(ct);
xlabel('Density of sparse matrix 100000 x 100000') % x-axis label
ylabel('Time consumption of SVD operation (second)') % y-axis label
set(gca,'XTickLabel', {'0.001%', '0.003%', '0.005%', '0.007%', '0.009%' ,'0.011%','0.013%', ...,
    '0.015%', '0.0017%','0.0019%'});

%%


%%
hashtag={'#apple_sparse.txt','#google_sparse.txt','#microsoft_sparse.txt','#michigan_sparse.txt','#cometlanding_sparse.txt'}
for i=1:5
    Sparse=load(hashtag{i});
    Sparse(:,1) = Sparse(:,1) + 1;
    Sparse(:,2) = Sparse(:,2) + 1;
    H = spconvert(Sparse);
    fprintf('%s\n',hashtag{i});
    tic
    [U, S, V] = svds(H);
    toc
end

%%
type=1:5;

ct=[0.891558 0.666217 0.202874 0.102223 1.820644];
bar(ct);
xlabel('The SVD time consumption for each result') % x-axis label
ylabel('Time consumption (second)') % y-axis label
set(gca,'XTickLabel', {'#apple', '#google', '#microsoft', '#michigan', '#cometlanding'});

%%
cc=[67899*36715, 52348*32638, 20037*13828, 9644*13151, 94669*32663];
bar(cc,'r');
xlabel('Hashtags') % x-axis label
ylabel('Number of elements for each matrix') % y-axis label

%%
set(gca,'XTickLabel', {'#apple', '#google', '#microsoft', '#michigan', '#cometlanding'});
cs=[0.0249 0.0239 0.0565 0.0609 0.0220];
bar(cs,'g');
xlabel('Hashtags') % x-axis label
ylabel('Density (%)') % y-axis label
set(gca,'XTickLabel', {'#apple', '#google', '#microsoft', '#michigan', '#cometlanding'});
