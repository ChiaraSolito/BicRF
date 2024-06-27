function [jaccard_sim1, jaccard_sim2] = run_multipleForests_multipleBic(sname,fname,num)
% [jaccard_mean, jaccard_std] = run_singleExperiment(sname,fname)
% 
% Run the same experiment on the defined dataset to obtain the jaccard mean
% and standard deviation
jaccard_sim1 = zeros(1,num);
jaccard_sim2 = zeros(1,num);

%% 
%sposta questa parte dentro il for e modifica l'indice per selezionare
%diversi dataset

%% EXPERIMENTS

for i = 1 : num
    
    idx = i - 1;
    n_sname = [sname '_' num2str(idx) '_data.tsv'];
    n_fname = [fname '_' num2str(idx) '_bics.json'];
    data = tsvread(n_sname);
    data = data(2:end, 2:end);
    num_feats = size(data,2);
    
    fid = fopen(n_fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    val = jsondecode(str);
    
    rows1 = val.biclusters.x0.Y';
    rows1 = rows1 + 1;
    columns1 = val.biclusters.x0.X';
    columns1 = columns1 + 1;
    
    rows2 = val.biclusters.x1.Y';
    rows2 = rows2 + 1;
    columns2 = val.biclusters.x1.X';
    columns2 = columns2 + 1;

    param = RFC_defaultParam;
    param.maxDepth = 5;
    rfc = RFC_RFtrain(data,param);
    CI = RFC_getRFClusInfo(data,rfc,param);

    [representation, feats, ~] = RFC_newRepresentation(CI, data);

    new_mat1 = RFC_getNewMatrix(representation, feats, num_feats);
    new_mat1 = new_mat1(rows1,columns1);

    true_rep1 = ones(length(rows1),length(columns1));
    JJ1 = sum(new_mat1 & true_rep1)/sum(new_mat1 | true_rep1);
    jaccard_sim1(i) = JJ1;

    new_mat2 = RFC_getNewMatrix(representation, feats, num_feats);
    new_mat2 = new_mat2(rows2,columns2);

    true_rep2 = ones(length(rows2),length(columns2));
    JJ2 = sum(new_mat2 & true_rep2)/sum(new_mat2 | true_rep2);
    jaccard_sim2(i) = JJ2;

end