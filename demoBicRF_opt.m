%% CLEAR SECTION
clear all
close all

addpath(genpath('/home/chiara/Documenti/chiaras_thesis/BicRF/'));
rng('default');
nclus = 2;
purity_RF = zeros(5);
inverse_RF = zeros(5);

%% DATA PROCESSING
sname = ['/home/chiara/Documenti/chiaras_thesis/BicRF/templates/bic_50/constant/obj_1000/feat_100/constant_1000x100_0_data.tsv'];
fid = fopen(['/home/chiara/Documenti/chiaras_thesis/BicRF/templates/bic_50/constant/obj_1000/feat_100/constant_1000x100_0_bics.json']);
metrics_file = ['/home/chiara/Documenti/chiaras_thesis/algorithms_biclustering/results/nonbinary/constant/results_bicRF'];

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

%% CONSTRUCT RFC
param = RFC_defaultParam;
param.maxDepth = 5;
rfc = RFC_RFtrain(data,param);
CI = RFC_getRFClusInfo(data,rfc,param);

%% POST-PROCESSING: get representation
opt = -1;
best_metric = -1;
best_purity = 0;
best_inverse = 0;
objnum = size(data,1);
[representation, feats, thetas] = RFC_newRepresentation(CI, data);

%% BICRF
thrs=[0.5, 0.4, 0.28, 0.2, 0.17];
for t=1:5
    thr = thrs(t);
    [final_features,final_objects,similarities] = RFC_getBiclus_v4(representation, objnum, feats, thr);

    purity_RF(t) = purity(final_features,final_objects,columns,rows);
    inverse_RF(t) = inverse_purity(final_features,final_objects,columns,rows);
    
    metric = mean([purity_RF(t),inverse_RF(t)]);
    if metric > best_metric
        opt = thr;
        best_metric = metric;
        best_purity = purity_RF(t);
        best_inverse = inverse_RF(t);
    end
    
end

metrics = zeros(10,3);
metrics(:,1) = 0:9;
metrics(:,2) = best_purity;
metrics(:,3) = best_inverse;
csvwrite([metrics_file 'opt.csv'],metrics);

