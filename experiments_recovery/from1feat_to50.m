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
for n=1:length(names)
    name = names{n};
    jaccard_sims(1).(name) = struct(['obj_' objs{1}], zeros(length(feats),10), ['obj_' objs{2}], zeros(length(feats),10), ['obj_' objs{3}], zeros(length(feats),10)); %['obj_' objs{4}], zeros(length(feats),10));
    for l=1:length(objs)
        obj = objs{l};
        for j=1:length(feats)
            feat = feats{j};
            fname = ['/home/chiara/Documenti/chiaras_thesis/BicRF/templates/bic_50/' name '/obj_' obj '/feat_' feat '/' name '_' obj 'x' feat];
            parfor i = 1 : num
            
                idx = i - 1;
                start_name = [fname '_' num2str(idx) '_flip1_rep.txt'];
                final_name = [fname '_' num2str(idx) '_flip1_rep.txt'];

                %add part to read the representation
                data = readtable(final_name, 'ReadVariableNames', true, 'ReadRowNames',true);

                feats = data.Properties.VariableNames;
                new_feats=arrayfun(@a(2)),feats,'uni',0);
                newStr = 

                %%%% DA COMMITTARE QUELLO CHE C'È A CASA
            
                %sampler = randsample(length(feats),ceil(length(feats)/2));
                %for index=sampler
                %   representation(:,index) = ~representation(:,index);
                %end
            
                header = arrayfun(@(a)['y' num2str(a)],feats,'uni',0);
                writematrix(header,'names.csv');
                names = readtable('names.csv', 'ReadVariableNames', true);
                names_cell = names.Properties.VariableNames;
                labels = [1:1:obj_num];
                
                T = array2table(representation, 'VariableNames',names_cell,'RowNames',BB);
                writetable(T,final_name,'WriteVariableNames',true,'WriteRowNames',true);
                
                new_mat = RFC_getNewMatrix(representation, feats, num_feats);
                new_mat = new_mat(rows,columns);
                jaccard_sim(i) = sum(new_mat & true_rep)/sum(new_mat | true_rep);


    
            end
        end
    end
end