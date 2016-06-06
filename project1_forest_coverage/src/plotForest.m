data_tree = struct('elevation',{},'aspect',{},'slope',{},'h_dist_water',{},'v_dist_water',{}, ...
    'h_to_road',{},'hill_9',{},'hill_n',{},'hill_3',{},'h_fire',{},'wild',{},'soil',{},'target',{});

data = importForestFile('train.csv', 2, 15121);
data_tree(1).elevation = data(:,2);
data_tree(1).aspect = data(:,3);
data_tree(1).slope = data(:,4);
data_tree(1).h_dist_water = data(:,5);
data_tree(1).v_dist_water = data(:,6);
data_tree(1).h_to_road = data(:,7);
data_tree(1).hill_9 = data(:,8);
data_tree(1).hill_n = data(:,9);
data_tree(1).hill_3 = data(:,10);
data_tree(1).h_fire = data(:,11);
[data_wild_v, data_wild_i] = max(data(:,12:15),[],2);
data_tree(1).wild = data_wild_i;
[data_soil_v,data_soil_i] = max(data(:,16:55),[],2);
data_tree(1).soil = data_soil_i;
data_target = data(:,56);

feature_block = [data_tree(1).elevation, data_tree(1).aspect, data_tree(1).slope, data_tree(1).h_dist_water, data_tree(1).v_dist_water,...
    data_tree(1).h_to_road, data_tree(1).hill_9, data_tree(1).hill_n, data_tree(1).hill_3, data_tree(1).h_fire,...
    data_tree(1).wild, data_tree(1).soil];
%%
cmap = hsv(7);
colorDraw = zeros(length(data_tree(1).h_dist_water),3);
for ii=1:7
    data_color_set = find(data_target == ii);
    colorDraw(data_color_set,1) = cmap(ii,1);
    colorDraw(data_color_set,2) = cmap(ii,2);
    colorDraw(data_color_set,3) = cmap(ii,3);
end

%%
feature9 = feature_block(:,7) - 185;
featureN = feature_block(:,8) - 185;
r = (feature9.^2 + featureN.^2).^0.5;
deg = asind( feature9./r  );

%%
scatter(deg,r, 10,colorDraw,'filled');

%%
figure;
data_type_dis = zeros(7,1);
for ii=1:7
    data_type_dis(ii) = sum(data_target==ii);
end
b = bar(data_type_dis);
ch = get(b,'children');

set(ch,'FaceVertexCData',cmap);
tree = ['Spruce/Fir';'Lodgepole Pine';'Ponderosa Pine';'Cottonwood/Willow';'Aspen';'Douglas-fir';'Krummholz'];
%set(gca,'XTickLabel',tree);


%%
feature_size = size(feature_block,2);
feature_text = {'Elevation'; 'Aspect';'Slope'; 'Hz\_Dist\_To\_Hyd';'Vc\_Dist\_To\_Hyd';...
    'Hz\_Dist\_To\_Rd';'Hillshade\_9am';'Hillshade\_noon';'Hillshade\_3pm';'Hz\_Dist\_To\_Fire';...
    'Wilder';'Soil';'Cover\_Type'};

%count = 0;
count = 0;
for ii=1: (feature_size-1)
    
    for jj=(ii+1): feature_size
        
        count_mod = mod(count,6);
        if count_mod == 0
            %savefig(H, sprintf('figure%d.fig',count));
            figure;
        end
        
        count = count + 1;
        fprintf('count:%d\n',count);
        count_mod = count_mod + 1;
        
        subplot(2,3,count_mod);
        scatter(feature_block(:,ii), feature_block(:,jj), 10,colorDraw,'filled');
        xlabel(feature_text{ii});
        ylabel(feature_text{jj});
        title(sprintf('%s vs %s', feature_text{ii},feature_text{jj} ));
        %count = count + 1;
    end
end


% figure;
%
% scatter(data_tree(1).h_dist_water, abs(data_tree(1).v_dist_water));
