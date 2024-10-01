function   criticaldiagram(cd,ranks,labels)
k=length(ranks);
    tics = repmat((0:(k-1))/(k-1), 3, 1);

 
 
%figure; %set(gcf, 'Position', get(0, 'Screensize'));
clf
axis off
axis([-0.2 1.2 -20 140]);
axis xy
line(tics(:), repmat([100, 103, 100], 1, k), 'LineWidth', 1, 'Color', 'k');
line([0 0 0 cd/(k-1) cd/(k-1) cd/(k-1)], [113 111 112 112 111 113], 'LineWidth', 1, 'Color', 'k');
text(0, 118, ['CD=' num2str(round(cd,3))], 'FontSize', 12, 'HorizontalAlignment', 'left', 'Color', 'k');
 
for i=1:k

    text((i-1)/(k-1), 107, num2str(k-i+1), 'FontSize', 10, 'HorizontalAlignment', 'center');
end
 
% compute average ranks
[r,idx] = sort(ranks);
 
% compute statistically similar cliques
clique           = repmat(r,k,1) - repmat(r',1,k);
clique(clique<0) = realmax;
clique           = clique < cd;
 
for i=k:-1:2
    if all(clique(i-1,clique(i,:))==clique(i,clique(i,:)))
        clique(i,:) = 0;
    end
end
 
n                = sum(clique,2);
clique           = clique(n>1,:);
n                = size(clique,1);
 
%yanse={'b','g','y','m','r'};
% labels displayed on the right
for i=1:ceil(k/2)
   line([(k-r(i))/(k-1) (k-r(i))/(k-1) 1], [100 100-3*(n+1)-10*i 100-3*(n+1)-10*i],'Color','k');
   %text(1.2, 100 - 5*(n+1)- 10*i + 2, num2str(r(i)), 'FontSize', 10, 'HorizontalAlignment', 'right');
   text(1.02, 100 - 3*(n+1) - 10*i, labels{idx(i)}, 'FontSize', 12, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left');
end
 
% labels displayed on the left
for i=ceil(k/2)+1:k
   line([(k-r(i))/(k-1) (k-r(i))/(k-1) 0], [100 100-3*(n+1)-10*(k-i+1) 100-3*(n+1)-10*(k-i+1)],'Color','k');
   %text(-0.2, 100 - 5*(n+1) -10*(k-i+1)+2, num2str(r(i)), 'FontSize', 10, 'HorizontalAlignment', 'left');
   text(-0.02, 100 - 3*(n+1) -10*(k-i+1), labels{idx(i)}, 'FontSize', 12, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'right');
end
 
% group cliques of statistically similar classifiers
for i=1:size(clique,1)
   R = r(clique(i,:));
   %line([((k-min(R))/(k-1)) + 0.015 ((k - max(R))/(k-1)) - 0.015], [100-5*i 100-5*i], 'LineWidth', 1, 'Color', 'r');
   %line([0 0 0 cd/(k-1) cd/(k-1) cd/(k-1)], [113 111 112 112 111 113], 'LineWidth', 1, 'Color', 'r');
   line([((k-min(R))/(k-1)) ((k-min(R))/(k-1)) ((k-min(R))/(k-1)) ((k - max(R))/(k-1)) ((k - max(R))/(k-1)) ((k - max(R))/(k-1))], [100+2-5*i 100-2-5*i 100-5*i 100-5*i 100-2-5*i 100+2-5*i], 'LineWidth', 2, 'Color', 'r');
end
end