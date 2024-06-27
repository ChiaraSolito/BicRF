%% CLEAR SECTION
clear all
close all

tic;
rng('default');
nclus = 2;
%% DATA GENERATION
% % Construct bicluster matrix
sname = './templates';
data = RFC_generateData(sname,100,100,0);

real_bicluster = data([25:75],[25:75]);
%plot data matrix
figure, imagesc(data)
colorbar
title('Dataset Illustrative 1')
xlabel('Features')
ylabel('Objects')


%% CONSTRUCT RFC
param = RFC_defaultParam;
param.maxDepth = 5;
rfc = RFC_RFtrain(data,param);
CI = RFC_getRFClusInfo(data,rfc,param);

%% GET TREE IMAGE 
tree = rfc.trees{1};
p = [];
root = 0;
tests = [];
ids = [];

[ids, p, tests] = tree_struct(ids, p, root, tests, tree);

treeplot(p);
[x,y] = treelayout(p);
for i=1:length(p)
    text(x(i),y(i)+0.05,num2str(ids(i)))
end
%% POST-PROCESSING: get representation
objnum = size(data,1);
[representation, feats, thetas] = RFC_newRepresentation(CI, data);

figure, imagesc(representation)
colorbar
title('Obtained representation')
yposition = 1:objnum;
yposition = yposition - 0.5;
yticks(yposition)
yticklabels(1:objnum)

xposition = 1:length(feats);
xposition = xposition - 0.5;
xticks(xposition)
labels = [];
for i=1:length(feats)
    if i==1 | feats(i) ~= feats(i-1)
        new_label = ['f' num2str(feats(i))];
        new_label = string(new_label);
        labels = [labels, new_label];
    else
        labels = [labels, ''];
    end
end
xticklabels(labels)

xlabel('Features intervals')
ylabel('Objects')

%% GET BICLUSTER
% thr = 0.5 if noise = 0
% thr = 0.28 if noise = 0.5 or 1
% thr = 0.2 if noise = 2
% thr = 0.17 if noise = 3
[final_objects,final_features,similarities] = RFC_getBiclus_v4(representation, objnum, feats,0.5);

%% VISUALIZE BICLUSTER IN ORIGINAL MATRIX
figure, imagesc(data)
for o = final_objects
   y = o - 0.5;
   h = 1;
   for f = final_features
       x = f - 0.5;
       w = 1;
       rectangle('Position',[x y w h],'EdgeColor','r')
   end
end
colorbar
title('Bicluster with Random Forest')
ylabel('Objects')
xlabel('Features')

purity_RF = purity(final_features,final_objects,[25:75],[25:75]);
inverse_RF = inverse_purity(final_features,final_objects,[25:75],[25:75]);

%%
toc