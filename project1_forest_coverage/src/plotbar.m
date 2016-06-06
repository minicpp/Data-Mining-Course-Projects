cmap = hsv(7);
res = [0.8581 0.8907;	0.865 0.9101;	0.8487 0.9011;	0.6944 0.709;	0.7092 0.7372;	0.6983 0.7344];

bar(res);
set(gca,'XTickLabel', {'T1 tr', 'T10 tr', 'T100 tr', 'T1 tt', 'T10 tt' ,'T100 tt'});
legend('Max validation failed times = 6','Max validation failed times=256');