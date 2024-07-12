function jaccard_sim = run_multipleDatasets(sname,num, obj_num)
% [jaccard_mean, jaccard_std] = run_singleExperiment(sname,fname)
% 
% Run the same experiment on the defined dataset to obtain the jaccard mean
% and standard deviation

jaccard_sim = zeros(1,num);
rng('shuffle');

%% EXPERIMENTS

parfor i = 1 : num

    idx = i - 1;
    final_name = [fname '_' num2str(idx) '_flip1_rep.txt'];
    n_sname = [sname '_' num2str(idx) '_data.tsv'];
    n_fname = [sname '_' num2str(idx) '_bics.json'];

    data = tsvread(n_sname);
    data = data(2:end, 2:end);
    num_feats = size(data,2);
    
    fid = fopen(n_fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    val = jsondecode(str);
    
    rows = val.biclusters.x0.X';
    rows = rows + 1;
    columns = val.biclusters.x0.Y';
    columns = columns + 1;

    param = RFC_defaultParam;
    param.maxDepth = 5;
    rfc = RFC_RFtrain(data,param);
    CI = RFC_getRFClusInfo(data,rfc,param);
    true_rep = ones(length(rows),length(columns));

    [representation, feats, ~] = RFC_newRepresentation(CI, data);
    
    for k=1:length(feats)
        count=sum(feats==feats(k));
        index = ceil(count/2);
        representation(:,index + k) = ~representation(:,index + k);
        k = k + count;
    end

    %sampler = randsample(length(feats),ceil(length(feats)/2));
    %for index=sampler
    %   representation(:,index) = ~representation(:,index);
    %end

    header = arrayfun(@(a)['y' num2str(a)],feats,'uni',0);
    writematrix(header,'names.csv');
    names = readtable('names.csv', 'ReadVariableNames', true);
    names_cell = names.Properties.VariableNames;
    labels = [1:1:obj_num];
    BB=arrayfun(@(a)['x' num2str(a)],labels,'uni',0);
    T = array2table(representation, 'VariableNames',names_cell,'RowNames',BB);
    writetable(T,final_name,'WriteVariableNames',true,'WriteRowNames',true);
    
    new_mat = RFC_getNewMatrix(representation, feats, num_feats);
    new_mat = new_mat(rows,columns);
    jaccard_sim(i) = sum(new_mat & true_rep)/sum(new_mat | true_rep);

end