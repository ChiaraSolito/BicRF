%%
clear all
close all

addpath(genpath('/home/chiara/Documenti/chiaras_thesis/BicRF/'));
names = {'constant','columnconstant','rowconstant','scaling', 'shifting', 'orderpreserving'};
num = 10;
objs = {'1000', '5000', '10000'};
feats =  {'100','200','300','400','500', '750', '1000'};
colors = {'r', [0.4660 0.6740 0.1880], 'b', [0.9290 0.6940 0.1250], [0.3010 0.7450 0.9330], 'm'};
jaccard_sims = struct();

%%
for i=1:length(names)
    name = names{i};
    jaccard_sims(1).(name) = struct(['obj_' objs{1}], zeros(length(feats),10), ['obj_' objs{2}], zeros(length(feats),10), ['obj_' objs{3}], zeros(length(feats),10)); %['obj_' objs{4}], zeros(length(feats),10));
    for l=1:length(objs)
        obj = objs{l};
        for j=1:length(feats)
            feat = feats{j};
            sname = ['/home/chiara/Documenti/chiaras_thesis/BicRF/templates/bic_50/' name '/obj_' obj '/feat_' feat '/' name '_' obj 'x' feat];
            fname = ['/home/chiara/Documenti/chiaras_thesis/BicRF/templates/bic_50/' name '/obj_' obj '/feat_' feat '/' name '_' obj 'x' feat];
            
            %converter(sname,fname,num, obj);
            jaccard_sims.(name).(['obj_' obj])(j,:) = run_multipleDatasets(sname,fname,num);
            %[jaccard1, jaccard2] = run_multipleDatasets_multipleBic(sname,fname,num);
            %jaccard_sims1.(name)(j,:) = jaccard1;
            %jaccard_sims2.(name)(j,:) = jaccard2;
             
        end
   end
end
toc

%%
save jaccard_flip1_10DS
%save jaccard_flip50_10DS
