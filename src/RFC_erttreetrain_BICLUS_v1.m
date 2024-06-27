function t = RFC_erttreetrain_BICLUS(Xdata,param,liv)
% t = RFC_erttreetrain(Xdata,param,liv)
%  
% train Extremely Randomized Trees
% P. Geurts et al: "Extremely randomized trees",
% Mach. Learn., 63 (1), 3–42, 2006. 
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%

global idn

n = size(Xdata,1);
allf = param.allf;
if param.featsubset == 0
    featsubset = length(param.allf);
else
    featsubset = param.featsubset;
end
t.idn = idn;
t.liv = liv;

% criterion at node
stopsplit = 0;
if liv > param.maxDepth
    % max length
    stopsplit = 1;
elseif n == 1
    % leave with one element
    stopsplit = 1;
% elseif (size(unique(data(objs,allf),'rows'),1) == 1) 
%     % all elements equal
%     stopsplit = 1;
elseif length(find(std(Xdata)~=0)) == 0
    % all elements equal
    stopsplit = 1;
else
    
    % selezione migliore feature
    feat_var = zeros(length(allf),1);
    for i=allf
        [xi,bestI] = sort(Xdata(:,i));
        
        %matrice featprob length(fss) X Numoggetti(n) - 1
        variances = zeros(length(xi),1);
        for j=1:n-1
            splitest = (xi(j) ~= xi(j+1));
            % skip equal points
            if splitest
                % calcolo varianza 
                variances(j) = min(var(xi(1:j)),var(xi(j+1:end)));
            end
        end
        feat_var(i) = min(variances(variances > 0));
    end
    
    % faccio la media per riga
    mean_var =  mean(feat_var,2);
    % fature migliore = min(media)
    bestf = find(mean_var == min(mean_var(mean_var > 0)),1);

    % random pick of splitting value
    [xi,bestI] = sort(Xdata(:,bestf));
    th = xi(1) + (xi(end) - xi(1))*rand;
    a = find(xi>th);
    if isempty(a)
        % all equal -> just split in the middle
        bestj = round(length(xi)/2);
    else
        bestj = a(1)-1;
    end
    bestt = th;%mean(xi(bestj:bestj+1));

    

end

if stopsplit
    % leave
    t.l = [];
    t.r = [];
    t.sizet = n;
    t.nleaves = 1;
    t.maxdepth = liv;
    t.Mgain = 0;
    t.nInternals = 0;
    t.maxidn = idn;
else
    t.bestf = bestf;
    t.bestt = bestt;
    t.Mgain = 1;
    idn = idn+1;
    t.l = RFC_erttreetrain(Xdata(bestI(1:bestj),:),param,liv+1);
    idn = idn+1;
    t.r = RFC_erttreetrain(Xdata(bestI(bestj+1:end),:),param,liv+1);
    t.sizet = n;
    t.nleaves = t.l.nleaves + t.r.nleaves; % due foglie, una radice
    t.maxdepth = max(t.l.maxdepth,t.r.maxdepth);
    t.nInternals = t.l.nInternals + t.r.nInternals +1;
    t.maxidn = max( t.l.maxidn, t.r.maxidn);
end

