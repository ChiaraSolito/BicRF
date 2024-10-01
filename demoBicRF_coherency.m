%% CLEAR SECTION
clear all
close all

addpath(genpath('/home/chiara/Documenti/chiaras_thesis/BicRF/'));
rng('default');
nclus = 2;
names = {'constant','columnconstant','rowconstant','scaling', 'shifting', 'orderpreserving'};
thrs=[0.5, 0.4, 0.28, 0.2, 0.17];

%% 
for n=1:length(names)
    name = names{n};
    purity_RF = zeros(10,5);
    inverse_RF = zeros(10,5);
    opt = -1;
    best_metric = -1;

    for i=0:9
        
        %% PROCESS DATA
        sname = ['path_to_dataset/' name '/obj_1000/feat_100/' name '_1000x100_' num2str(i) '_data.tsv'];
        fid = fopen(['path_to_dataset/' name '/obj_1000/feat_100/' name '_1000x100_' num2str(i) '_bics.json']);
        metrics_file = ['path_to_metrics_storage/'];
    
        data = tsvread(sname);
        data = data(2:end, 2:end);
        num_feats = size(data,2);
        
        raw = fread(fid,inf); 
        str = char(raw'); 
        fclose(fid); 
        val = jsondecode(str);
        
        rows = val.biclusters.(['x0']).Y';
        rows = rows + 1;
        columns = val.biclusters.(['x0']).X';
        columns = columns + 1;
    
        %% CONSTRUCT RFC
        param = RFC_defaultParam;
        param.maxDepth = 5;
        rfc = RFC_RFtrain(data,param);
        CI = RFC_getRFClusInfo(data,rfc,param);
        
        %% POST-PROCESSING: get representation
        objnum = size(data,1);
        [representation, feats, thetas] = RFC_newRepresentation(CI, data);
        
        %% GET BICLUSTER
        % try different thresholds and save each result
        for t=1:length(thrs)
            thr = thrs(t);
            [final_features,final_objects,similarities] = RFC_getBiclus_v4(representation, objnum, feats,thr);
        
            purity_RF(i+1,t) = purity(final_features,final_objects,columns,rows);
            inverse_RF(i+1,t) = inverse_purity(final_features,final_objects,columns,rows);

            metric = mean([purity_RF(i+1,t),inverse_RF(i+1,t)]);
            if metric > best_metric
                best_metric = metric;
                opt = thr;
            end

        end

        %% PLOT CHANGES IN METIRCS WITH THRESHOLD
        % figure(1)
        % plot(purity_RF(:,i+1));
        % xlabel('Thresholds');
        % xticks(1:5)
        % xticklabels(num2cell(thrs))
        % ylabel('Purity')
        % title(['Dataset ' num2str(i)])
        % saveas(gcf,['Purity_' num2str(i) '.png']);
        % 
        % figure(2)
        % plot(inverse_RF(:,i+1))
        % xlabel('Thresholds')
        % xticks(1:5)
        % xticklabels(num2cell(thrs))
        % ylabel('Inverse Purity');
        % title(['Dataset ' num2str(i)])
        % saveas(gcf,['InversePurity_' num2str(i) '.png']);
        % close all
    
    end

    for t=1:length(thrs)
        thr = thrs(t);
        metrics = zeros(10,3);
        metrics(:,1) = 0:9;
        metrics(:,2) = purity_RF(:,t);
        metrics(:,3) = inverse_RF(:,t);
        if opt == thr
            csvwrite([metrics_file num2str(thr*100) '_opt.csv'],metrics);
        else
            csvwrite([metrics_file num2str(thr*100) '.csv'],metrics);
        end
    end

end