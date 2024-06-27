function rfc = RFC_ertRFtrain(Xdata,param)
% rfc = RFC_ertRFtrain(Xdata,param)
% 
% train forest with Extremely Randomized Trees
% P. Geurts et al: "Extremely randomized trees",
% Mach. Learn., 63 (1), 3–42, 2006.
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%
% Xdata: [nxd]: n objects in a d-dimensional space

global idn
[n,d] = size(Xdata);

if param.maxDepth == 0
    % automatic depth
    param.maxDepth = ceil(log2(n));
end
if param.sampling<=1
    % fraction
    psi = round(n*param.sampling);
else
    % number
    psi = param.sampling;
    if psi> n
        psi = n;
    end
end
i = 1;
if param.verbose, fprintf('Training \n'); end
while (i<=param.ntrees)
    % step 1: random sampling of a subset
    aa = randperm(n);
    bt = aa(1:psi);
    btx = Xdata(bt,:);
    % featfraction: select only a subset for training
    nf = max(1,round(d*param.featfraction));
    fss = randperm(d);
    fss = fss(1:nf);
    param.allf = fss;
    % step 2: train tree
    if (mod(i,10) == 0) || (i == 1) || (i == param.ntrees), if param.verbose, fprintf('Tree %d/%d\n',i,param.ntrees); end; end
    idn = 1;
    t1 = RFC_erttreetrain(btx,param,1);
    rfc.trees{i} = t1;
    rfc.dep(i) = t1.maxdepth;
    i = i+1;
    
end
rfc.param = param;
