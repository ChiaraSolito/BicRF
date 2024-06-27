function jaccard_sim = run_multipleHeight(sname,fname,num, depth)
% [jaccard_mean, jaccard_std] = run_singleExperiment(sname,fname)
% 
% Run the same experiment on the defined dataset to obtain the jaccard mean
% and standard deviation

jaccard_sim = zeros(1,num);
rng('shuffle');

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
    
    rows = val.biclusters.x0.Y';
    rows = rows + 1;
    columns = val.biclusters.x0.X';
    columns = columns + 1;

    param = RFC_defaultParam;
    param.maxDepth = depth;
    rfc = RFC_RFtrain(data,param);
    CI = RFC_getRFClusInfo(data,rfc,param);

    [representation, feats, ~] = RFC_newRepresentation(CI, data);

    new_mat = RFC_getNewMatrix(representation, feats, num_feats);
    new_mat = new_mat(rows,columns);

    true_rep = ones(length(rows),length(columns));
    JJ = sum(new_mat & true_rep)/sum(new_mat | true_rep);
    jaccard_sim(i) = JJ;

end