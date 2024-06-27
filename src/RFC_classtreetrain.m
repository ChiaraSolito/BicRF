function t = RFC_classtreetrain(Xdata,lab,param,liv)
% t = RFC_classtreetrain(Xdata,lab,param,liv)
%  
% train classic classification tree
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%
% Xdata: [nxd]: n objects in a d-dimensional space

global idn

[n,d] = size(Xdata);
allf = param.allf;
if param.featsubset == 0
    featsubset = length(param.allf);
else
    featsubset = param.featsubset;
end
fss = randperm(length(allf));
fss = allf(fss(1:featsubset));
t.idn = idn;
t.liv = liv;

% criterion at node
Rt = RFC_classtreevalue(lab,param.crit);

stopsplit = 0;
if liv > param.maxDepth
    % max length
    stopsplit = 1;
elseif n == 1
    % leave with one element
    stopsplit = 1;
elseif length(unique(lab)) == 1
    % all elements of the same class
    stopsplit = 1;
elseif (size(unique(Xdata(:,fss),'rows'),1) == 1) 
    % all elements equal
    stopsplit = 1;
else
    bestdiff = -inf; 
    bestf = []; 
    bestt = []; 
    bestj = []; 
    bestI = [];
    for i=fss
        % sort the data along feature i:
        [xi,I] = sort(Xdata(:,i));
        % tmpx = newdata(objs(I),:);
        tmplab = lab(I);
        % run over all possible splits:
        % every split should involve at least two points
        for j=1:n-1
            splitest = (xi(j) ~= xi(j+1));
            % skip equal points
            if splitest
                RtL = RFC_classtreevalue(tmplab(1:j),param.crit);
                nl = length([1:j]);
                RtR = RFC_classtreevalue(tmplab(j+1:end),param.crit);
                nr = length([j+1:n]);
                %diff = Rt - nr*RtR - nl*RtL;
                diff = Rt - nr*RtR/(nr+nl) - nl*RtL/(nr+nl);
                if diff > bestdiff
                    bestdiff = diff;
                    bestf = i;
                    bestj = j;
                    bestt = mean(xi(j:j+1));
                    bestI = I;
                end
            end
        end
    end
end

if stopsplit
    % leave
    t.l = [];
    t.r = [];
    t.sizet = n;
    t.nleaves = 1;
    t.lab = lab;
    t.maxdepth = liv;
    t.Mgain = 0;
    t.nInternals = 0;
    t.maxidn = idn;
else
    t.bestf = bestf;
    t.bestt = bestt;
    t.Mgain = bestdiff;
    idn = idn+1;
    t.l = RFC_classtreetrain(Xdata(bestI(1:bestj),:),lab(bestI(1:bestj)),param,liv+1);
    idn = idn+1;
    t.r = RFC_classtreetrain(Xdata(bestI(bestj+1:end),:),lab(bestI(bestj+1:end)),param,liv+1);
    t.sizet = size(Xdata,1);
    t.nleaves = t.l.nleaves + t.r.nleaves; % due foglie, una radice
    t.maxdepth = max(t.l.maxdepth,t.r.maxdepth);
    t.nInternals = t.l.nInternals + t.r.nInternals +1;
    t.maxidn = max( t.l.maxidn, t.r.maxidn);
end













