function rfc = RFC_RFtrain(Xdata,param)
% rfc = RFC_RFtrain(Xdata,param)
% train a RF using options in param
% 
% Random Forest Clustering library
% (c) Manuele Bicego 2021
% 
% Xdata: [nxd]: n objects in a d-dimensional space


switch param.typeTree
    case 1
        % 1: binary class tree with sampled negative points
        % first step: sampling new points from marginals
        [n,d] = size(Xdata);
        neg_class = zeros(n,d);
        for i = 1:d
            yy = Xdata(:,i);
            neg_class(:,i) = yy(randi(n,n,1));
        end
        newdata = [Xdata;neg_class];
        lab = [ones(n,1); ones(n,1)*2];
        rfc = RFC_classRFtrain(newdata,lab,param);
    
    case 2
        % 2: Extremely Random Tree 
        rfc = RFC_ertRFtrain(Xdata,param);
    case 3
        % 3: Renyii Tree
    case 4
        % 4: Gaussian Density Tree
    case 5
        rfc = RFC_ertRFtrain_BICLUS(Xdata,param);
end

