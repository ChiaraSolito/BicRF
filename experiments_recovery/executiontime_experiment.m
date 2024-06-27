%%
objs = {'1000', '5000', '10000', '20000'};
n_feats =  {'50','100','200','300','400','500', '750', '1000'};
labels = [1000, 5000, 10000, 20000];
colors = {'r', [0.4660 0.6740 0.1880], 'b', [0.9290 0.6940 0.1250], [0.3010 0.7450 0.9330], 'm'};
jaccard_sims = struct(['obj_' objs{1}], zeros(length(n_feats),10), ['obj_' objs{2}], zeros(length(n_feats),10), ['obj_' objs{3}], zeros(length(n_feats),10), ['obj_' objs{4}], zeros(length(n_feats),10));
for l=1:length(objs)
    obj = objs{l};
    for j=1:length(n_feats)
        feat = n_feats{j};
        sname = ['./templates/bic_10/constant/obj_' obj '/feat_' feat '/constant_' obj 'x' feat '_0_data.tsv'];
        fname = ['./templates/bic_10/constant/obj_' obj '/feat_' feat '/constant_' obj 'x' feat '_0_bics.json'];

        tic
        data = tsvread(sname);
        data = data(2:end, 2:end);
        num_feats = size(data,2);
        
        fid = fopen(fname); 
        raw = fread(fid,inf); 
        str = char(raw'); 
        fclose(fid); 
        val = jsondecode(str);
        
        rows = val.biclusters.x0.Y';
        rows = rows + 1;
        columns = val.biclusters.x0.X';
        columns = columns + 1;

        rng('shuffle');
        param = RFC_defaultParam;
        param.maxDepth = 5;
        rfc = RFC_RFtrain(data,param);
        CI = RFC_getRFClusInfo(data,rfc,param);
    
        [representation, feats, ~] = RFC_newRepresentation(CI, data);
    
        new_mat = RFC_getNewMatrix(representation, feats, num_feats);
        new_mat = new_mat(columns,rows);
    
        true_rep = ones(length(columns),length(rows));
        JJ = sum(new_mat & true_rep)/sum(new_mat | true_rep);

        jaccard_sims.(['obj_' obj])(j) = toc;
         
    end
end

%%
save jaccard_sims

%%
obj_labels = {['obj ' objs{1}], ['obj ' objs{2}], ['obj ' objs{3}], ['obj ' objs{4}]};
h = zeros(8,1);
for o=1:4
    obj = objs{o};
    hold on
    h(j) = plot(labels,jaccard_sims.(['obj_' obj])(:,1),'Color',colors{o});
    hold off
end

title('Time of execution');
grid on
xticks(labels);
xticklabels(labels);
xlabel('Number of features');
ylabel('Time of execution');
legend(obj_labels);
saveas(gcf,'exec_time.png');