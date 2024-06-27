function t = RFC_erttreetrain(Xdata,param,liv)
% t = RFC_erttreetrain(Xdata,param,liv)
%  
% train Extremely Randomized Trees
% P. Geurts et al: "Extremely randomized trees",
% Mach. Learn., 63 (1), 3–42, 2006. 
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%
% Xdata: [nxd]: n objects in a d-dimensional space

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
    %fss = randperm(length(allf));
    %fss = allf(fss(1:featsubset));
    % random feature
    %bestf = fss(randi(length(fss)));
    
    buoni = find(std(Xdata)~=0);
    a = randi(length(buoni));
    bestf = buoni(a);
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

