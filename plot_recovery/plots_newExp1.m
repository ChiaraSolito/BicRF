%load jaccard_sims.mat
jaccard_means = zeros(4,6,7);
jaccard_stds = zeros(4,6,7);

for o=1:length(objs)
    obj = objs{o};
    for j=1:length(names)
        name = names{j};
        for s = 1:7
            jaccard_means(o,j,s) = mean(jaccard_sims.(name).(['obj_' obj])(s,:));
            jaccard_stds(o,j,s) = std(jaccard_sims.(name).(['obj_' obj])(s,:));
        end
        % figure
        % mean_to_plot = reshape(jaccard_means(o,j,:),1,[]);
        % plot(labels,mean_to_plot,'Color',colors{j});
        % hold on
        % std_to_plot = reshape(jaccard_stds(o,j,:),1,[]);
        % fill([labels, flip(labels)], [mean_to_plot + std_to_plot, flip(mean_to_plot - std_to_plot)], colors{j} ,'FaceAlpha',0.3,'LineStyle',"--",'EdgeColor',colors{j});
        % hold off
        % title(['Num objs: ' obj ', Bicluster type: ' names{j}]);
        % xticks(labels); 
        % xticklabels(labels);
        % xlim([95 1005]);
        % ylim([0.6 1.0])
        % legend('Mean','Std');
        % grid on
        % xlabel('Number of features');
        % ylabel('Jaccard Similarity');
        %saveas(gcf,[names{j} '_' obj '.eps']);
       
    end
end
%%
figure
tcl = tiledlayout(2,2);
for o=1:length(objs)
    obj = objs{o};
    nexttile(tcl)
    h = zeros(1,6);
    for j=1:length(names)
        name = names{j};
        hold on
        mean_to_plot = reshape(jaccard_means(o,j,:),1,[]);
        h(j) = plot(labels,mean_to_plot,'Color',colors{j},'LineWidth',3);
        hold off
    end
    title(['Number of objects: ' obj]);
    grid on
    xticks(labels);
    xticklabels(labels);
    xlim([45 1005])
    ylim([0 1.0])
    xlabel('Number of features');
    ylabel('Jaccard Similarity');
end
leg = legend(h, names);
leg.Layout.Tile = 'East';
sgtitle('Mean over ten generated forests')
fontsize(16,"points")
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
print('bic10_10RF.eps','-depsc');

%%
figure
for o=1:4
    obj = objs{o};
    subplot(2,2,o)
    e = zeros(1,6);
    for j=1:6
        hold on
        mean_to_plot = reshape(jaccard_means(o,j,:),1,[]);
        std_to_plot = reshape(jaccard_stds(o,j,:),1,[]);
        e(j) = errorbar(labels, mean_to_plot, std_to_plot,'Color',colors{j});
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
leg = legend(e, names);
sgtitle('Mean over ten generated datasets')
fontsize(16,"points")
saveas(gcf,'mean_std_all.eps');

%%
for o = 1:length(objs)
    obj = objs{o};
    for j=1:length(feats)
        figure
        fontsize(25,"points")
        size = feats{j};
        sim_size = zeros(10,6);
        for i=1:6
            name = names{i};
            sim_size(:,i) = jaccard_sims.(name).(['obj_' obj])(j,:);
        end
        b = boxplot(sim_size, names);
        grid on
        xticks([1:6]);
        ylim([0 1.0])
        title([num2str(size) ' features']);
        %xticklabels(names);
        %leg = legend(b, names);
        %title(leg,'Bicluster type')
        %xlim([90 510])
        xlabel('Bicluster type');
        ylabel('Jaccard Similarity');
        fontsize(25,"points")
        set(findobj(gca,'type','line'),'linew',3)
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
        print([num2str(size) num2str(obj) '_boxplot.eps'],'-depsc');

    end
end

%%
jaccard_total = zeros(10,4,6);
for j=1:6
    name = names{j};
    for i=1:4
        jaccard_total(:,i,j) = jaccard_sims.(name)(i,:)';
    end
end


boxPlot3D(jaccard_total)
xlabel('Tree Height');
xticklabels(labels);
ylabel('Bicluster type');
yticks([1,2,3,4,5,6]);
yticklabels(names);
zlabel('Jaccard Similarity');
title('3D Box Multiple Forests');
saveas(gcf,'boxplot_final.png');


%%
figure;
for o=1:4
    obj = objs{o};
    subplot(2,2,o)
    new_means = reshape(jaccard_means(o,:,:),6,7);
    hBars = bar(labels,new_means);
    ylim([0 1.0]);
    xlim([0 1050]);
    XTickLabel=labels;
    XTick=labels;
    set(gca, 'XTick',XTick);
    set(gca, 'XTickLabel', XTickLabel);
    title(['Number of objects: ' obj]);
    xlabel('Number of features');
    ylabel('Jaccard Similarity');
    hold all;
    
    for k = 1:6
        % get x positions per group
        mean_to_plot = reshape(jaccard_means(o,k,:),1,[]);
        std_to_plot = reshape(jaccard_stds(o,k,:),1,[]);
        xpos = hBars(k).XEndPoints;
        % draw errorbar
        errorbar(xpos, mean_to_plot, std_to_plot, 'LineStyle', 'none', ... 
            'Color', 'k', 'LineWidth', 1);
    end
end
sgtitle('BarPlot Multiple Datasets');
legend(names)
% put in lower right
box off;
hold off;