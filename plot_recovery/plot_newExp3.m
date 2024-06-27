jaccard_means = zeros(4,2,7);
jaccard_stds = zeros(4,2,7);

for o=1:length(objs)
    obj = objs{o};
    for t=1:2
        for s=1:length(feats)
            jaccard_means(o,t,s) = mean(jaccard_sims.(['tree_' num2str(t)]).(['obj_' obj])(s,:));
            jaccard_stds(o,t,s) = std(jaccard_sims.(['tree_' num2str(t)]).(['obj_' obj])(s,:));
        end
    end
end

%%
names = {'tree_5','tree_6','tree_7','tree_8'};
figure
for o=1:4
    obj = objs{o};
    subplot(2,2,o)
    h = zeros(1,6);
    for j=1:4
        hold on
        mean_to_plot = reshape(jaccard_means(o,j,:),1,[]);
        h(j) = plot(labels,mean_to_plot,'Color',colors{j});
        hold off
    end
    title(['Number of objects: ' obj]);
    grid on
    xticks(labels);
    xticklabels(labels);
    xlim([495 1005])
    ylim([0.15 1.0])
    xlabel('Number of features');
    ylabel('Jaccard Similarity');
end
leg = legend(names);
sgtitle('Mean over ten generated datasets with different tree sizes')
saveas(gcf,'10bicconstant_experiment.png');

%%
jaccard_means = zeros(2,2,3);
jaccard_stds = zeros(2,2,3);

for o=1:2
    obj = objs{o};
    for t=1:2
        for s=1:3
            jaccard_means(o,t,s) = mean(jaccard_sims.(['tree_' num2str(t)]).(['obj_' obj])(s,:));
            jaccard_stds(o,t,s) = std(jaccard_sims.(['tree_' num2str(t)]).(['obj_' obj])(s,:));
        end
    end
end

%%
names = {'Binary trees','ERTs'};
figure
for o=1:length(objs)
    obj = objs{o};
    subplot(2,2,o)
    h = zeros(1,3);
    for j=1:2
        hold on
        mean_to_plot = reshape(jaccard_means(o,j,:),1,[]);
        h(j) = plot(labels,mean_to_plot,'Color',colors{j});
        hold off
    end
    title(['Number of objects: ' obj]);
    grid on
    xticks(labels);
    xticklabels(labels);
    xlim([95 1005])
    ylim([0.15 1.0])
    xlabel('Number of features');
    ylabel('Jaccard Similarity');
end
leg = legend(names);
sgtitle('Mean over ten generated datasets with different tree types')
saveas(gcf,'treeType_experiment.png');