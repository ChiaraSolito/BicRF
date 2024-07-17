
addpath(genpath('/home/chiara/Documenti/chiaras_thesis/BicRF/'));
name = ['rowconstant'];
num = 10;
objs = {'10000','20000'};
feats =  {'500', '750', '1000'};

for l=1:length(objs)
    obj = objs{l};
    for j=1:length(feats);
        feat = feats{j};
        sname = ['/home/chiara/Documenti/chiaras_thesis/BicRF/templates/bic_50/' name '/obj_' obj '/feat_' feat '/' name '_' obj 'x' feat];
        fname = ['/home/chiara/Documenti/chiaras_thesis/BicRF/templates/bic_50/' name '/obj_' obj '/feat_' feat '/' name '_' obj 'x' feat];
        
        num_obj = str2num(obj);
        labels = [1:1:num_obj];
        BB=arrayfun(@(a)['x' num2str(a)],labels,'uni',0);
        for i = 1 : num
            idx = i - 1;
            final_name = [sname '_' num2str(idx) '_rep.txt'];
            t = readtable(final_name, 'ReadVariableNames', true);
            names = t.Properties.VariableNames;
            if strcmp(names(1,1),'Var1')
                t.Var1=[];
                names = t.Properties.VariableNames;
            end
            
            new_names = strrep(names,'x', 'y');
            t.Properties.RowNames = BB;
            final_table = renamevars(t,names,new_names);
            writetable(final_table,final_name,'WriteVariableNames',true,'WriteRowNames',true)
        end
    end
end

