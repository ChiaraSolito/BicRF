%% CLEAR SECTION
clear all
close all

addpath('src/');
nclus = 10;
JJ = zeros(10,2);

for u=0:9
    
    sname = ['./new_templates/bic_10/exclusiverowsandcolumns/first_scenario/multiplebic/multiplebic_' num2str(u) '_data.tsv'];
    fname = ['./new_templates/bic_10/exclusiverowsandcolumns/first_scenario/multiplebic/multiplebic_' num2str(u) '_bics.json'];

    multiplebic = tsvread(sname);
    multiplebic = multiplebic(2:end, 2:end);
    num_feats1 = size(multiplebic,2);

    fid = fopen(fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    val = jsondecode(str);

    columns1 = val.biclusters.x0.Y';
    columns1 = columns1 + 1;
    rows1 = val.biclusters.x0.X';
    rows1 = rows1 + 1;

    [length_rows, length_columns] = size(multiplebic);

    %%
    sname = ['./new_templates/bic_10/exclusiverowsandcolumns/first_scenario/multiplebic2/10x10/multiplebic2_' num2str(u) '_data.tsv'];
    fname = ['./new_templates/bic_10/exclusiverowsandcolumns/first_scenario/multiplebic2/10x10/multiplebic2_' num2str(u) '_bics.json'];

    multiplebic2 = tsvread(sname);
    multiplebic2 = multiplebic2(2:end, 2:end);
    num_feats2 = size(multiplebic2,2);

    fid = fopen(fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    val = jsondecode(str);

    columns2 = val.biclusters.x0.Y';
    columns2 = columns2 + 1 + length_columns;
    rows2 = val.biclusters.x0.X';
    rows2 = rows2 + 1 + length_rows;

    columns = [columns1, columns2];
    rows = [rows1, rows2];

    %%
    sname = ['./new_templates/bic_10/exclusiverowsandcolumns/first_scenario/nobic/nobic_' num2str(u) '_data.tsv'];

    nobic = tsvread(sname);
    nobic = nobic(2:end, 2:end);

    %%
    sname = ['./new_templates/bic_10/exclusiverowsandcolumns/first_scenario/nobic2/nobic2_' num2str(u) '_data.tsv'];

    nobic2 = tsvread(sname);
    nobic2 = nobic2(2:end, 2:end);

    %% CONSTRUCT DATASET 

    data = [multiplebic nobic; nobic2 multiplebic2];
    num_feats = num_feats1 + num_feats2;
    % 
    % % plot data matrix
    % figure, imagesc(data)
    % colorbar
    % title('Dataset with 2 non-overlapping biclusters')
    % xlabel('Features')
    % ylabel('Objects')
    % saveas(gcf,'./results/final_thesis/multiple_biclusters/nonoverlapping_2bics/10x10_10x10/dataset.png');
    % % %% visualize bicluster
    % %%
    % figure, imagesc(data)
    % for o = rows1
    %    y = o - 0.5;
    %    h = 1;
    %    for f = columns1
    %        x = f - 0.5;
    %        w = 1;
    %        rectangle('Position',[x y w h],'EdgeColor','r')
    %    end
    % end
    % 
    % for o = rows2
    %    y = o - 0.5;
    %    h = 1;
    %    for f = columns2
    %        x = f - 0.5;
    %        w = 1;
    %        rectangle('Position',[x y w h],'EdgeColor','r')
    %    end
    % end
    % 
    % colorbar
    % title('Biclusters visualization')
    % ylabel('Objects')
    % xlabel('Features')
    % saveas(gcf,'./results/final_thesis/multiple_biclusters/nonoverlapping_2bics/10x10_10x10/biclusters.png');
    % sname = ['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/arbitrarlyoverlapping/arbitrarlyoverlapping_' num2str(u) '_data.tsv'];
    % fid = fopen(['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/arbitrarlyoverlapping/arbitrarlyoverlapping_' num2str(u) '_bics.json']);
    % data = tsvread(sname);
    % data = data(2:end, 2:end);
    % num_feats = size(data,2);
    % 
    % raw = fread(fid,inf); 
    % str = char(raw'); 
    % fclose(fid); 
    % val = jsondecode(str);
    % 
    % rows = zeros(10,10);
    % columns = zeros(10,10);
    % 
    % for i=0:9
    %     new_rows = val.biclusters.(['x' num2str(i)]).X';
    %     new_rows = new_rows + 1;
    %     new_columns = val.biclusters.(['x' num2str(i)]).Y';
    %     new_columns = new_columns + 1;
    %     idx = i + 1;
    %     rows(idx,:) = new_rows;
    %     columns(idx,:) = new_columns;
    % end

    rng('shuffle');
    param = RFC_defaultParam;
    param.maxDepth = 5;
    rfc = RFC_RFtrain(data,param);
    CI = RFC_getRFClusInfo(data,rfc,param);
    
    [representation, feats, ~] = RFC_newRepresentation(CI, data);

    id = u +1;
    % for i=1:10
    %     new_rows = rows(i,:);
    %     new_columns = columns(i,:);
    %     new_mat = RFC_getNewMatrix(representation, feats, num_feats);
    %     new_mat = new_mat(new_rows,new_columns);
    % 
    %     true_rep = ones(length(new_rows),length(new_columns));
    %     JJ(id,i) = sum(new_mat & true_rep)/sum(new_mat | true_rep);
    % end
    new_mat1 = RFC_getNewMatrix(representation, feats, num_feats);
    new_mat1 = new_mat1(rows1,columns1);

    true_rep1 = ones(length(rows1),length(columns1));
    JJ(id,1) = sum(new_mat1 & true_rep1)/sum(new_mat1 | true_rep1);

    new_mat2 = RFC_getNewMatrix(representation, feats, num_feats);
    new_mat2 = new_mat2(rows2,columns2);

    true_rep2 = ones(length(rows2),length(columns2));
    JJ(id,2) = sum(new_mat2 & true_rep2)/sum(new_mat2 | true_rep2);
    
end

%save('./results/final_thesis/multiple_biclusters/arbitrarlyoverlapping/10DS/10DS.mat');
save('./results/final_thesis/multiple_biclusters/nonoverlapping_2bics/10x10_10x10/AS2/10DS/10DS.mat');