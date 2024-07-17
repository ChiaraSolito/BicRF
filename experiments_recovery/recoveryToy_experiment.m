% Script to generate a synthetic toy dataset and calculate the
% representativness of the representation extracted from the Random Forest
% training

%% clear section
clear all
close all

addpath(genpath('/home/chiara/Documenti/chiaras_thesis/BicRF/'));
rng('default');
nclus = 2;
%% generate data
data = RFC_generateData(100,100,0);
real_bicluster = data([25:75],[25:75]);
num_feats = size(data,2);
rows = 25:75;
columns = 25:75;

%% plot data matrix
figure, imagesc(data)
colorbar
title('Toy Dataset')
xlabel('Features')
ylabel('Objects')

%% train the forest
param = RFC_defaultParam;
param.maxDepth = 5;
rfc = RFC_RFtrain(data,param);
CI = RFC_getRFClusInfo(data,rfc,param);
true_rep = ones(length(rows),length(columns));

%% extract the representation
[representation, feats, ~] = RFC_newRepresentation(CI, data);

indexes = zeros(1,num_feats);

% NEGATIVE OF 1 TEST PER FEAT
% for f=1:num_feats
%     finder = find(feats == f);
%     if ~isempty(finder)
%         id_first = finder(1);
%         counter = sum(feats==f);
%         indexes(f) = id_first - 1 + ceil(counter/2);
%     end
% end
% 
% for k=indexes
%     if k ~= 0
%         representation(:,k) = ~representation(:,k);
%     end
% end

% NEGATIVE OF 50% OF THE TESTS
sampler = randsample(length(feats),ceil(length(feats)/2));
for index=sampler
  representation(:,index) = ~representation(:,index);
end

figure, imagesc(representation)
colorbar
title('Obtained representation')

%% calculate jaccard positive
jaccard_sims = zeros(1,2);
new_mat = RFC_getNewMatrix(representation, feats, num_feats);
new_mat = new_mat(rows,columns);

jaccard_sim = sum(new_mat & true_rep)/sum(new_mat | true_rep);
figure, imagesc(new_mat)
colorbar
title('Jaccard')

% %% calculate jaccard
% negative_rep = ~representation;
% negative_mat = RFC_getNewMatrix(negative_rep, feats, num_feats);
% negative_mat = negative_mat(rows,columns);
% 
% figure, imagesc(negative_rep)
% colorbar
% title('Obtained representation')
% 
% jaccard_sim(2) = sum(new_mat & true_rep)/sum(new_mat | true_rep);
% figure, imagesc(negative_mat)
% colorbar
% title('Jaccard')