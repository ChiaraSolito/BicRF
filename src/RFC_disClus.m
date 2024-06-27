function T = RFC_disClus(DD,nclus,c)
% T = RFC_disClus(DD,nclus,c)
% cluster the matrix DD with a distance-based clustering method
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%
% DD: [nxn]: dissimilarity matrix betweeb n objects
% nclus: number of cluster
% c: one of the following methods
% 1,2,3: Spectral Clustering
%      1 - Unnormalized
%      2 - Normalized according to Shi and Malik (2000)
%      3 - Normalized according to Jordan and Weiss (2002)
% 4    : Affinity Propagation
% 5-8  : Hierarchical Clustering
%      5 - HC single link
%      6 - HC complete link
%      7 - HC average link
%      8 - HC ward link

DD=DD.*not(eye(size(DD)));

%fprintf('Clustering method: %d \n',c)

switch c
    case {1,2,3}
        % Spectral clustering
        % code by: %   Author: Ingo Buerk
        ninitKM = 20;
        SPsigma = 1;
        W = exp(-DD.^2 ./ (2*SPsigma^2));
        [T, L, U,sumD] = SpectralClustering(W, nclus, c,ninitKM);
    case 4
        % 4 - Affinity Propagation
        % code by authors (http://psi.toronto.edu/)
        %
        Sim = -DD;
        [idx,netsim,dpsim,expref,pref]=apclusterK(Sim,nclus,0);
        fou = unique(idx);
        T = zeros(size(idx));
        for i = 1:length(fou)
            T(idx==fou(i)) = i;
        end
    case {5,6,7,8}
        % 5 - HC single link
        % 6 - HC complete link
        % 7 - HC average link
        % 8 - HC ward link
        
        Y = squareform(DD);
        if c== 5
            Z = linkage(Y,'single');
        elseif c==6
            Z = linkage(Y,'complete');
        elseif c==7
            Z = linkage(Y,'average');
        elseif c==8
            Z = linkage(Y,'ward');
        end
        T = cluster(Z,'maxclust',nclus);
end
