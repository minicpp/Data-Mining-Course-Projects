%%
%
minIndex = 40;
maxIndex = 200;
prefix='nnet\nnet';
step = 1;
feature=73;
sizePerNet = 30;
CC = zeros(sizePerNet,length(minIndex:step:maxIndex));
count = 1;
for ii=minIndex:step:maxIndex
    %filename = sprintf('%s%d_%d',prefix,feature,ii)
    filename = sprintf('%s_%d',prefix,ii);
    [nets,rates,netSize]=LoadNetsFile(filename);
    CC(:, count) = rates;
    count = count + 1;
end

%%
figure;
boxplot(CC,minIndex:step:maxIndex);
xlabel('Number of hidden nodes');
ylabel('precision');
[C, I]=max(CC(:));
[x,y] = ind2sub(size(CC),I);
fprintf('\n max model(%f): nodes:%d, index:%d\n', C, (y-1)*step+minIndex, x);

%%
figure;
s1 = mean(CC);
s3 = smoothwindow(3, mean(CC));
s5 = smoothwindow(5, mean(CC));
plot(minIndex:step:maxIndex,s1,'g-+', ...
    minIndex+2*step:step:maxIndex,s3,'b--o', ...
    minIndex+4*step:step:maxIndex, s5,'c:*');
legend({'Averge','3-Elements moving average','5-Elements moving average'});
xlabel('Number of hidden nodes');
ylabel('Average precision');
