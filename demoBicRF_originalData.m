%% CLEAR SECTION
clear all
close all
addpath(genpath('/home/chiara/Documenti/chiaras_thesis/BicRF/'));
rng('default');
nclus = 2;

%% READ DATA
sname = ['path_to_file.tsv'];
fid = fopen(['path_to_file.json']);

data = tsvread(sname);
data = data(2:end, 2:end);
num_feats = size(data,2);

raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

rows = val.biclusters.(['x0']).Y';
rows = rows + 1;
columns = val.biclusters.(['x0']).X';
columns = columns + 1;

%% PLOT ORIGINAL DATA
%plot data matrix
figure, imagesc(data)
colorbar
title('Toy Dataset')
xlabel('Features')
ylabel('Objects')


%% CONSTRUCT RFC
param = RFC_defaultParam;
param.maxDepth = 5;
rfc = RFC_RFtrain(data,param);
CI = RFC_getRFClusInfo(data,rfc,param);


%% POST-PROCESSING: get representation
objnum = size(data,1);
[representation, feats, thetas] = RFC_newRepresentation(CI, data);

figure, imagesc(representation)
colorbar
title('Obtained representation')
xlabel('Features intervals')
ylabel('Objects')

%% GET BICLUSTER
% thr = 0.5 if noise = 0
% thr = 0.28 if noise = 0.5 or 1
% thr = 0.2 if noise = 2
% thr = 0.17 if noise = 3
[final_objects,final_features,similarities] = RFC_getBiclus_v4(representation, objnum, feats, 0.5);

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

%% CALCULATE METRICS
purity_RF = purity(final_features,final_objects,[25:75],[25:75]);
inverse_RF = inverse_purity(final_features,final_objects,[25:75],[25:75]);
