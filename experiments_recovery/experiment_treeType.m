%% 
num = 10;
objs = {'1000', '5000', '10000', '20000'};
feats =  {'100', '200', '300', '400', '500', '750', '1000'};
labels = [100, 200, 300, 400, 500, 750, 1000];
colors = {'r', [0.4660 0.6740 0.1880], 'b', [0.9290 0.6940 0.1250], [0.3010 0.7450 0.9330], 'm'};

%%
tic
jaccard_sims.tree_1 = struct(['obj_' objs{1}], zeros(length(feats),10), ['obj_' objs{2}], zeros(length(feats),10), ['obj_' objs{3}], zeros(length(feats),10), ['obj_' objs{4}], zeros(length(feats),10));
jaccard_sims.tree_2 = struct(['obj_' objs{1}], zeros(length(feats),10), ['obj_' objs{2}], zeros(length(feats),10), ['obj_' objs{3}], zeros(length(feats),10), ['obj_' objs{4}], zeros(length(feats),10));

%%
for treeType = 1:2
    for l=3:4
        obj = objs{l};
        for j=1:length(feats)
            feat = feats{j};
            sname = ['./templates/bic_50/constant/obj_' obj '/feat_' feat '/constant_' obj 'x' feat];
            fname = ['./templates/bic_50/constant/obj_' obj '/feat_' feat '/constant_' obj 'x' feat];
    
            jaccard_sims.(['tree_' num2str(treeType)]).(['obj_' obj])(j,:) = run_multipleForests(sname,fname,num,treeType);
        end
    end
end
save treeType

toc