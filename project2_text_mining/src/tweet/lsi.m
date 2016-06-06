hashtag={'#apple_sparse.txt','#google_sparse.txt','#microsoft_sparse.txt','#michigan_sparse.txt','#cometlanding_sparse.txt'}
hashtag2={'#apple','#google','#microsoft','#michigan','#cometlanding'}

for i=1:5
    Sparse=load(hashtag{i});
    Sparse(:,1) = Sparse(:,1) + 1;
    Sparse(:,2) = Sparse(:,2) + 1;
    H = spconvert(Sparse);
    fprintf('%s\n',hashtag{i});
    tic
    [U, S, V] = svds(H);
        
    %vs = V(randperm(size(V,1),1000),[1 2])
    vs = V(:,[1 2]);
    figure;
    for j=1:size(vs,1)
        plot([0,vs(j,1)],[0,vs(j,2)]);
        hold on;        
    end
    xlabel(strcat('First dimension of  ',hashtag2{i})) % x-axis label
    ylabel(strcat('Second dimension of  ',hashtag2{i})) % y-axis label
    hold off;   
end