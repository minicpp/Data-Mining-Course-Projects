apple=[13296,14095,14108,15064,12782,11626,10750,9251,12543,10423,10235];
google = [7480, 8339,8557,9204,8268,9193,9823,5554,9537,7416,7722];
microsoft=[3301, 4843,5338,5904,4506,6138,3744,3768,3117,1724,1939];
michigan=[1069,1301,1550,1882,1230,1044,1030,1031,1207,1882,1144];
comet=[445, 2696,74446,14856,5358,4165,993,205,235,135,163];
date=[1 2 3 4 5 6 7 8 9 10 11];


semilogy(date,apple,'-o',date,google,'--+',date,microsoft,':*',date,michigan,'-.x',date,comet,'-s');
legend({'#apple','#google','#microsoft','#michigan','#cometlanding'});
xlabel('11 days from Nov 7 to Nov 17') % x-axis label
ylabel('Number of tweets with logarithmic scale') % y-axis label