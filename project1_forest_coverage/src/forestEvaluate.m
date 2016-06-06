%%
% load data
rng(1);
data = importForestFile('train.csv', 2, 15121);
%test = importForestTestfile('test.csv', 2, 565893);

%%
% init data
cover_type_N = 7;
training_sample_size = size(data,1);
observe_sample = data(:, 2:55);
observe_target = zeros(training_sample_size,cover_type_N);
observe_target_index = sub2ind(size(observe_target),1:training_sample_size,data(:,56)');
observe_target(  observe_target_index  ) = 1;
observe_sample = observe_sample';
observe_target = observe_target';

%%
%
minIndex = 10;
maxIndex = 99;
SizePerSample = 10;
CC = zeros(maxIndex-minIndex+1,SizePerSample);
for ii=minIndex:maxIndex
    ii
    S = load(sprintf('net_%d.mat', ii));
    res = S.res;
    for jj=1:SizePerSample        
        CC(ii-minIndex+1,jj) = res(jj).rate; 
    end
end

%%

boxplot(CC',10:99);
xlabel('Number of hidden nodes');
ylabel('precision');
[x,y] = ind2sub(size(CC),I);
fprintf('\n max model(%f): [%d,%d] ---> [%d,%d]\n', C, x, y, x+minIndex-1,y);

%%
figure;
%%
s1 = mean(CC');
s3 = smoothwindow(3, mean(CC'));
s5 = smoothwindow(5, mean(CC'));
s10 = smoothwindow(10, mean(CC'));
plot(1:length(s1),s1,'g-+', 3: (length(s3)+2),s3,'b--o', 5:(length(s5)+4), s5,'c:*', 10:(length(s10)+9), s10,'m-.d');
legend({'Averge','3-Elements moving average','5-Elements moving average','10-Elements movign average'});
xlabel('Number of hidden nodes');
ylabel('Average precision');
