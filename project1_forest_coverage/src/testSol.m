%% Get result of test from origional data set
% Generate test data set with solution
test = importForestTestfile('test.csv', 2, 565893);
covtype = importForestAllfile('covtype.csv', 1, 581012);
target = covtype(:,55);
target(1:15120) = [];
test = [test,target];
dlmwrite('test_sov.csv', test,'-append','delimiter',',','precision','%d');