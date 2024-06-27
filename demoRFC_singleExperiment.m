%% CLEAR SECTION
clear all
close all

tic;
rng('default');
nclus = 2;
%% DATA GENERATION
% % Construct bicluster matrix
sname = ['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/randomlyoverlapping/randomlyoverlapping_' num2str(0) '_data.tsv'];
fid = fopen(['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/randomlyoverlapping/randomlyoverlapping_' num2str(0) '_bics.json']);

data = tsvread(sname);
data = data(2:end, 2:end);
num_feats = size(data,2);

raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

rows = zeros(10,10);
columns = zeros(10,10);

%%
for i=0:9
    new_rows = val.biclusters.(['x' num2str(i)]).X';
    new_rows = new_rows + 1;
    new_columns = val.biclusters.(['x' num2str(i)]).Y';
    new_columns = new_columns + 1;
    idx = i + 1;
    rows(idx,:) = new_rows;
    columns(idx,:) = new_columns;
end

% %%
% missing_row = [];
% missing_column = [];
% 
% count_row = zeros(110,1);
% count_column = zeros(110,1);
% 
% for i=1:110
%     count_row(i) = sum(missing_rows(:) == i);
%     count_column(i) = sum(missing_columns(:) == i);
%     if count_row(i) == 10
%         missing_row(end + 1) = i;
%     end
%     if count_column(i) == 10
%         missing_column(end + 1) = i;
%     end
% end
% 
% %%
% data(missing_row',:) = [];
% data(:,missing_column') = [];

%%
%plot data matrix
figure, imagesc(data)
colorbar
title('Dataset')
xlabel('Features')
ylabel('Objects')

yposition = [1:10:100];
yticklabels([0:10:100])

yposition = yposition - 0.5;
yticks(yposition)
%% CONSTRUCT RFC
param = RFC_defaultParam;
param.maxDepth = 5;
rfc = RFC_RFtrain(data,param);
CI = RFC_getRFClusInfo(data,rfc,param);

%% GET TREE IMAGE 
%tree = rfc.trees{1};
%p = [];
%root = 0;
%tests = [];
%ids = [];

%[ids, p, tests] = tree_struct(ids, p, root, tests, tree);

%treeplot(p);
%[x,y] = treelayout(p);
%for i=1:length(p)
%    text(x(i),y(i)+0.05,num2str(ids(i)))
%end

%% POST-PROCESSING: get representation
objnum = size(data,1);
[representation, feats, thetas] = RFC_newRepresentation(CI, data);


figure, imagesc(representation)
colorbar
title('Obtained representation')
%yposition = 1:objnum;
%yposition = yposition - 0.5;
%yticks(yposition)
%yticklabels(1:objnum)

%xposition = 1:length(feats);
%xposition = xposition - 0.5;
%xticks(xposition)
%xticklabels(feats)

%labels = [];
%for i=1:length(feats)
%    new_label = ['f' num2str(feats(i)) '>' num2str(thetas(i))];
%    new_label = string(new_label);
%    labels = [labels, new_label];
%end
%xticklabels(labels)

xlabel('Features intervals')
ylabel('Objects')

%% GET BICLUSTER
% thr = 0.5 if noise = 0
% thr = 0.28 if noise = 0.5 or 1
% thr = 0.2 if noise = 2
% thr = 0.17 if noise = 3
[final_features,final_objects,similarities] = RFC_getBiclus_v4(representation, objnum, feats,0.11);

%% VISUALIZE FOUND BICLUSTER IN ORIGINAL MATRIX
figure, imagesc(data)
for o = final_features
   y = o - 0.5;
   h = 1;
   for f = final_objects
       x = f - 0.5;
       w = 1;
       rectangle('Position',[x y w h],'EdgeColor','r')
   end
end
colorbar
title('Bicluster with Random Forest')
ylabel('Objects')
xlabel('Features')

%% VISUALIZE ORIGINAL BICLUSTER IN ORIGINAL MATRIX
figure, imagesc(data)
for o = columns
   y = o - 0.5;
   h = 1;
   for f = rows
       x = f - 0.5;
       w = 1;
       rectangle('Position',[x y w h],'EdgeColor','r')
   end
end
colorbar
title('True Bicluster')
ylabel('Objects')
xlabel('Features')

%%
purity_RF = purity(final_features,final_objects,columns,rows);
inverse_RF = inverse_purity(final_features,final_objects,columns,rows);

%%
toc