clear all
close all

addpath(genpath('/home/chiara/Documenti/chiaras_thesis/BicRF/'));
names = {'constant','columnconstant','rowconstant','scaling', 'shifting', 'orderpreserving'};
num = 10;
%objs = {'1000', '5000', '10000', '20000'};
objs = {'20000'};
features =  {'100','200','300','400','500', '750', '1000'};
colors = {'r', [0.4660 0.6740 0.1880], 'b', [0.9290 0.6940 0.1250], [0.3010 0.7450 0.9330], 'm'};
jaccard_sims = struct();

%%
for n=1:length(names)
    name = names{n};
    %jaccard_sims(1).(name) = struct(['obj_' objs{1}], zeros(length(features),10), ['obj_' objs{2}], zeros(length(features),10), ['obj_' objs{3}], zeros(length(features),10), ['obj_' objs{4}], zeros(length(features),10));
    jaccard_sims(1).(name).(['obj_' objs{1}]) = zeros(length(features),10);
    for l=1:length(objs)
        obj = objs{l};
        for j=1:length(features)
            feat_name = features{j};
            jaccard_sim = zeros(1,num);
            for i = 1 : num
                idx = i - 1;
                fname = ['/home/chiara/Documenti/chiaras_thesis/BicRF/flipped_rep/bic_50/' name '/obj_' obj '/feat_' feat_name '/' name '_' obj 'x' feat_name '_' num2str(idx) '_flip1_rep.txt'];
                n_sname = ['/home/chiara/Documenti/chiaras_thesis/BicRF/templates/bic_50/' name '/obj_' obj '/feat_' feat_name '/' name '_' obj 'x' feat_name '_' num2str(idx) '_bics.json'];
               
                %read original bicluster
                fid = fopen(n_sname); 
                raw = fread(fid,inf); 
                str = char(raw'); 
                fclose(fid); 
                val = jsondecode(str);
                
                rows = val.biclusters.x0.X';
                rows = rows + 1;
                columns = val.biclusters.x0.Y';
                columns = columns + 1;

                %read saved representation
                data = readtable(fname, 'ReadVariableNames', true, 'ReadRowNames',true);
                representation = table2array(data);
                num_feats = str2double(feat_name);

                %get feats from header
                header = data.Properties.VariableNames;
                feats=cellfun(@(x) str2double(extractBetween(x,'y','_')),header);
                
                %convert the converted median feat
                % indexes = zeros(1,num_feats);
                % for f=1:num_feats
                %     finder = find(feats == f);
                %     if ~isempty(finder)
                %      id_first = finder(1);
                %      counter = sum(feats==f);
                %      indexes(f) = id_first - 1 + ceil(counter/2);
                %     end
                % end
                % 
                % for k=indexes
                %      if k ~= 0
                %          representation(:,k) = ~representation(:,k);
                %     end
                % end
                % 
                % %convert randomly 50% of features
                % sampler = randsample(length(feats),ceil(length(feats)/2));
                % for index=sampler
                %    representation(:,index) = ~representation(:,index);
                % end
                
                %calculate the jaccard distance
                new_mat = RFC_getNewMatrix(representation, feats, num_feats);
                new_mat = new_mat(rows,columns);
                true_rep = ones(length(rows),length(columns));
                jaccard_sim(i) = sum(new_mat & true_rep)/sum(new_mat | true_rep);

            end
            jaccard_sims.(name).(['obj_' obj])(j,:) = jaccard_sim;
        end
    end
end