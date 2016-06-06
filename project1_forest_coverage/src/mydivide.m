function [trainInd,valInd,testInd] = mydivide(Q,trainRatio,valRatio,testRatio)

trainInd = 1:100;
valInd=101:200;
testInd=201:300;