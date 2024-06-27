%% 

names = {'constant','columnconstant','rowconstant','scaling', 'shifting', 'orderpreserving'};
num = 10;
objs = {'1000', '5000', '10000', '20000'};
%feats =  {'100','200','300','400','500', '750', '1000'};
feats =  {'500', '750', '1000'};
labels = [1000, 5000, 10000, 20000];
tree_szs = [5, 6, 7, 8];
%colors = {'r', [0.4660 0.6740 0.1880], 'b', [0.9290 0.6940 0.1250], [0.3010 0.7450 0.9330], 'm'};
%jaccard_sims = struct();

%%
tic
jaccard_sims.tree_5 = struct(['obj_' objs{1}], zeros(length(feats),10), ['obj_' objs{2}], zeros(length(feats),10), ['obj_' objs{3}], zeros(length(feats),10), ['obj_' objs{4}], zeros(length(feats),10));
jaccard_sims.tree_6 = struct(['obj_' objs{1}], zeros(length(feats),10), ['obj_' objs{2}], zeros(length(feats),10), ['obj_' objs{3}], zeros(length(feats),10), ['obj_' objs{4}], zeros(length(feats),10));
jaccard_sims.tree_7 = struct(['obj_' objs{1}], zeros(length(feats),10), ['obj_' objs{2}], zeros(length(feats),10), ['obj_' objs{3}], zeros(length(feats),10), ['obj_' objs{4}], zeros(length(feats),10));
jaccard_sims.tree_8 = struct(['obj_' objs{1}], zeros(length(feats),10), ['obj_' objs{2}], zeros(length(feats),10), ['obj_' objs{3}], zeros(length(feats),10), ['obj_' objs{4}], zeros(length(feats),10));
%%
for t = 1:1
    tree_sz = tree_szs(t);
    for l=1:2
        obj = objs{l};
        for j=1:length(feats)
            feat = feats{j};
            sname = ['./templates/bic_50/constant/obj_' obj '/feat_' feat '/constant_' obj 'x' feat];
            fname = ['./templates/bic_50/constant/obj_' obj '/feat_' feat '/constant_' obj 'x' feat];
    
            jaccard_sims.(['tree_' num2str(tree_sz)]).(['obj_' obj])(j,:) = run_multipleForests(sname,fname,num,tree_sz);
            save jaccard_sims
        end
    end
end
toc