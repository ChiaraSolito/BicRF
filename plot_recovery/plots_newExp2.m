%load jaccard_sims.mat
jaccard_means = zeros(2,2);
jaccard_stds = zeros(2,2);

%% PLOT 
for j=1:2
    name = names{j};
    
    jaccard_means(j,1) = mean(jaccard_sims1.(name));
    jaccard_stds(j,1) = std(jaccard_sims1.(name));

    jaccard_means(j,2) = mean(jaccard_sims2.(name));
    jaccard_stds(j,2) = std(jaccard_sims2.(name));

end


%%
labels = {'first bicluster', 'second bicluster'};
figure;
hBars = bar(labels,jaccard_means);
XTickLabel=names;
XTick=labels;
set(gca, 'XTick',XTick);
set(gca, 'XTickLabel', XTickLabel);
xlabel('Bicluster Type');
ylabel('Jaccard Similarity');
hold all;

for k = 1:2
    % get x positions per group
    xpos = hBars(k).XEndPoints;
    % draw errorbar
    errorbar(xpos, jaccard_means(:,k), jaccard_stds(:,k), 'LineStyle', 'none', ... 
        'Color', 'k', 'LineWidth', 1);
end

title('BarPlot Multiple Datasets');
legend({'first bicluster', 'second bicluster'})
% put in lower right
box off;
hold off;

%%
for j=1:2
    figure
    name = names{j};
    sim_size = zeros(10,2);
    sim_size(:,1) = jaccard_sims1.(name)(:);
    sim_size(:,2) = jaccard_sims2.(name)(:);
    
    b = boxplot(sim_size, labels);
    grid on
    xticks([1:2]);
    ylim([0.65 0.95])
    title([num2str(name) ' experiment']);
    %xticklabels(names);
    %leg = legend(b, names);
    %title(leg,'Bicluster type')
    %xlim([90 510])
    xlabel('Bicluster');
    ylabel('Jaccard Similarity');
    saveas(gcf,[num2str(name) '_boxplot_all.png']);
  
end
