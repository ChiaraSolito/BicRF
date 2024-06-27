num_rep = 10;
jaccard_means = zeros(num_rep,1);
jaccard_stDS = zeros(num_rep,1);

for i=1:num_rep
    jaccard_means(i) = mean(JJ(i,:));
    jaccard_stDS(i) = std(JJ(i,:));
end

%%
figure
cmap = colormap(jet(num_rep));
h = zeros(num_rep);
for i=1:num_rep
    hold on
    h(i) = plot([1:1000],JJ(i,:),'Color',cmap(i,:));
    hold off
    grid on
end
ylim([0.5 1.0]);
%legend('dataset 1', 'dataset 2','dataset 3', 'dataset 4', 'dataset 5', 'dataset 6', 'dataset 7', 'dataset 8', 'dataset 9', 'dataset 10')
legend('forest 1', 'forest 2','forest 3', 'forest 4', 'forest 5', 'forest 6', 'forest 7', 'forest 8', 'forest 9', 'forest 10')
sgtitle('10 biclusters over 10 forests (1 dataset)')
xlabel('Biclusters');
ylabel('Jaccard Similarity');
saveas(gcf,'./results/final_thesis/multiple_biclusters/checkerboard/10RF/plot_10RF.png');

%%
figure
plot(jaccard_means);
ylim([0.5 1.0]);
sgtitle('Mean over 1000 biclusters for 10 forests (1 dataset)')
xlabel('Forests');
ylabel('Jaccard Similarity');
saveas(gcf,'./results/final_thesis/multiple_biclusters/checkerboard/10RF/mean_10RF.png');

%%
figure
boxplot(JJ');
grid on
xlabel('Datasets');
ylim([0.75 1.05])
ylabel('Jaccard Similarity');
title('10 biclusters over 10 datasets');
saveas(gcf,'./results/final_thesis/multiple_biclusters/nonoverlapping_2bics/10x10_25x25/10DS/other_boxplot_10DS.png');


%%
figure
cmap = colormap(jet(num_rep));
h = zeros(num_rep);
for i=1:num_rep
    hold on
    h(i) = plot([1:1000],JJ(i,:),'Color',cmap(i,:));
    hold off
    grid on
end
ylim([0.5 1.0]);
%legend('dataset 1', 'dataset 2','dataset 3', 'dataset 4', 'dataset 5', 'dataset 6', 'dataset 7', 'dataset 8', 'dataset 9', 'dataset 10')
legend('forest 1', 'forest 2','forest 3', 'forest 4', 'forest 5', 'forest 6', 'forest 7', 'forest 8', 'forest 9', 'forest 10')
sgtitle('10 biclusters over 10 forests (1 dataset)')
xlabel('Biclusters');
ylabel('Jaccard Similarity');
saveas(gcf,'./results/final_thesis/multiple_biclusters/checkerboard/10RF/plot_10RF.png');


%%
num_rep = 10;
jaccard_means_10x10 = zeros(num_rep,1);
jaccard_means_25x25 = zeros(num_rep,1);
jaccard_means_rows = zeros(num_rep,1);
jaccard_means_columns = zeros(num_rep,1);
jaccard_means_check = zeros(num_rep,1);
jaccard_means_overlapping = zeros(num_rep,1); 

for i=1:num_rep
    jaccard_means_10x10(i) = mean(JJ_10x10(i,:));
    jaccard_means_25x25(i) = mean(JJ_25x25(i,:));
    jaccard_means_rows(i) = mean(JJ_rows(i,:));
    jaccard_means_columns(i) = mean(JJ_columns(i,:));
    jaccard_means_check(i) = mean(JJ_check(i,:));
    jaccard_means_overlapping(i) = mean(JJ_overlapping(i,:));
end

figure
plot(jaccard_means_10x10);
hold on
plot(jaccard_means_25x25);
hold off
hold on
plot(jaccard_means_rows);
hold off
hold on
plot(jaccard_means_columns);
hold off
hold on
plot(jaccard_means_check);
hold off
hold on
plot(jaccard_means_overlapping);
hold off

legend('10x10 non overlapping', '25x25 non overlapping','exclusive rows', 'exclusive columns', 'checkerboard', 'arbitrarly overlapping')


ylim([0.5 1.0]);
sgtitle('Mean over 10 forests')
xlabel('Forests');
ylabel('Jaccard Similarity');
