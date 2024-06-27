%% CLEAR SECTION
clear all
close all

JJ = zeros(10,1000);
labels = [1:10];
rng('shuffle');

%%

data = [];
data_row = [];
rows = zeros(1000,10);
columns = zeros(1000,10);

% sname = ['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/checkerboard/100x10/exlusivecolumns_' num2str(u) '_data.tsv'];
% fid = fopen(['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/checkerboard/100x10/exlusivecolumns_' num2str(u) '_bics.json']);

for i=0:99
    for j=0:9
        num = j + i*10;
        sname = ['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/checkerboard/' num2str(1) '/checkerboard_' num2str(num) '_data.tsv'];
        fid = fopen(['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/checkerboard/' num2str(1) '/checkerboard_' num2str(num) '_bics.json']);

        new_data = tsvread(sname);
        new_data = new_data(2:end, 2:end);

        raw = fread(fid,inf); 
        str = char(raw');
        fclose(fid); 
        val = jsondecode(str);

        new_rows = val.biclusters.x0.X';
        new_rows = new_rows + 1;
        new_columns = val.biclusters.x0.Y';
        new_columns = new_columns + 1;

        missing_row = setdiff([1:11], new_rows);
        missing_column = setdiff([1:11], new_columns);
        new_data(missing_row,:) = [];
        new_data(:,missing_column) = [];

        data_row = [data_row, new_data];
        idx = num + 1;
        rows(idx,:) = [1:10] + i*10;
        columns(idx,:) = [1:10] + j*10;
    end
    data = [data; data_row];
    data_row = [];
end
num_feats = size(data,2);
    % sname = ['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/checkerboard/' num2str(1) '/noiserows_data.tsv'];
    % fid = fopen(['/home/chiara/Documenti/chiaras_thesis/RFC_lib/new_templates/bic_10/checkerboard/' num2str(1) '/noiserows_bics.json']);
    % 
    % new_data = tsvread(sname);
    % new_data = new_data(2:end, 2:end);
    % num_feats = size(new_data,2);
    % 
    % raw = fread(fid,inf); 
    % str = char(raw'); 
    % fclose(fid); 
    % val = jsondecode(str);
    % 
    % new_rows = val.biclusters.x0.X';
    % new_rows = new_rows + 1;
    % new_columns = val.biclusters.x0.Y';
    % new_columns = new_columns + 1;
    % new_data(new_rows,:) = [];
    % new_data(:,new_columns) = [];
    % 
    % data = [data_row; new_data];
for u=1:10
    rng('shuffle');
    param = RFC_defaultParam;
    param.maxDepth = 5;
    rfc = RFC_RFtrain(data,param);
    CI = RFC_getRFClusInfo(data,rfc,param);
    
    [representation, feats, ~] = RFC_newRepresentation(CI, data);


    % data = tsvread(sname);
    % data = data(2:end, 2:end);
    % num_feats = size(data,2);
    % raw = fread(fid,inf); 
    % 
    % str = char(raw'); 
    % fclose(fid); 
    % val = jsondecode(str);


    for i=1:1000
    %     rows = val.biclusters.(['x' num2str(i)]).X';
    %     rows = rows + 1;
    %     columns = val.biclusters.(['x' num2str(i)]).Y';
    %     columns = columns + 1;
    % 
    %     idx = i + 1;
        new_rows = rows(i,:);
        new_columns = columns(i,:);
        new_mat = RFC_getNewMatrix(representation, feats, num_feats);
        new_mat = new_mat(new_rows,new_columns);
    
        true_rep = ones(length(new_rows),length(new_columns));
        JJ(u,i) = sum(new_mat & true_rep)/sum(new_mat | true_rep);
    end

end

%% get bicluster representation
%cmap = colormap(prism(100));
figure, imagesc(data)

% yposition = [1:100:1000];
% yticklabels([0:100:1000])
% 
% yposition = yposition - 0.5;
% yticks(yposition)
% 
% xposition = [1:10:100];
% xticklabels([0:10:100])
% 
% xposition = xposition - 0.5;
% xticks(xposition)

colorbar
title('Checkerboard biclusters')
ylabel('Objects')
xlabel('Features')
%saveas(gcf,'./results/final_thesis/multiple_biclusters/checkerboard/dataset.png');

%% VISUALIZE ORIGINAL BICLUSTER IN ORIGINAL MATRIX
cmap = colormap(prism(1000));
figure
%figure,imagesc(data);
%colorbar
%colormap default
title('True Biclusters')
ylabel('Objects')
xlabel('Features')
grid on
%colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', '#D95319', '#EDB120', '#7E2F8E'};
for i=1:1000
    for o = rows(i,:)
       y = i + o - 0.5;
       h = 1;
       for f = columns(i,:)
           x = f - 0.5;
           w = 1;
           rectangle('Position',[x y w h],'EdgeColor',cmap(i,:))
       end
    end
end
xlim([0 100])
ylim([0 1000])
set(gca, 'YDir','reverse')
saveas(gcf,'./results/final_thesis/multiple_biclusters/checkerboard/true_bicluster.png');

%%
save('./results/final_thesis/multiple_biclusters/checkerboard/10RF/10RF.mat');
