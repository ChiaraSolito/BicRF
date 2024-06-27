function CI = RFC_getRFClusInfo(Xdata,rfc,param)
% CI = RFC_getClusInfo(Xdata,rfc,param)
%
% extract info for clustering
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%
% Xdata: [nxd]: n objects in a d-dimensional space
% rfc is the trained forest

nT = length(rfc.trees);
for tt = nT:-1:1
    t = rfc.trees{tt};
    CI(tt)  = RFC_getTreeClusInfo(Xdata,t,param);
end
