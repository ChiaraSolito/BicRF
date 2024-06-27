function param = RFC_defaultParam
% param = RFC_defaultParam
% set default params
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%
% Default parameters
% ------------------
% param.typeTree = 1;
% % 1: binary class tree with sampled negative points
% % 2: Extremely Random Tree 
% % 3: Renyii Tree (not implemented yet)
% % 4: Gaussian Density Tree (not implemented yet)
% %
% % Isolation tree: set typeTree = 2  and sampling = 128
% ------------------
% param.featsubset = 0;
% % featsubset: number of features used to select the best pruning
% % 0: all predictors
% % different than option.featfraction 
% -------------------
% param.featfraction = 0.5;
% % the fraction of features used to build each tree
% -------------------
% param.ntrees = 100;
% % number of trees
% -------------------
% param.sampling = 0.5;
% % if less than 1 -> the fraction of objects used to build each tree
% % if larger than 1 -> the number of objects used to build each tree
% ------------------
% param.maxDepth = inf;
% % maxDEpth: max depth of the tree
% % 0 --> means ceil(log2(size(training of x))
% ------------------
% param.verbose = 1; 
% % show progress
% ------------------
% % Specific parameters for specific methods
% param.crit = 'gini'; % criterion for splitting in classification tree
% param.renyiK = 3; % renyiK: K in the renyi entropy computation.
% (good range 3-5)
% param.minLeafSize = 10; % minimun number of points
% param.reg = 0.0000001; % regularization coeffcient for covariance computation
% ------------------
% Distance for clustering
% param.dist = 3;
%   1 -> Shi et al., J. Comput. Graph. Statist., 15(1), 118-138, 2006.
%   2 -> v2 of Zhu et al CVPR, 1450–1457, 2014
%   3 -> v3 of Zhu et al CVPR, 1450–1457, 2014
%   4 -> Ting et al, SIGKDD, 1205–1214, 2016
%   5 -> RatioRF
%   6 -> Ayral et al, Ayral et al, Data Mining & Knowledge Discovery 2020


% Default parameters
% ------------------
param.typeTree = 1;
% 1: binary class tree
% 2: Extremely Random Tree 
% 3: Gaussian Density Tree
% 4: Renyii Tree
%
% E.g. Isolation tree: set typeTree = 2 and sampling = 128
% ------------------
param.featsubset = 0;
% featsubset: number of features used to select the best pruning
% 0: all predictors
% different than option.featfraction 
% -------------------
param.featfraction = 0.5;
% the fraction of features used to build each tree
% -------------------
param.ntrees = 100;
% number of trees
% -------------------
param.sampling = 0.5;
% if less than 1 -> the fraction of objects used to build each tree
% if larger than 1 -> the number of objects used to build each tree


% ------------------
param.maxDepth = inf;
% maxDEpth: max depth of the tree
% 0 --> means ceil(log2(size(training of x))
% ------------------
param.verbose = 1; 
% show progress
% ------------------
% Specific parameters for specific methods
param.crit = 'gini'; % criterion for splitting in classification tree
param.renyiK = 3; % renyiK: K in the renyi entropy computation.
% (good range 3-5)
param.minLeafSize = 10; % minimun number of points
param.reg = 0.0000001; % regularization coeffcient for covariance computation
% ------------------
% param.dist = distance computed from RF
%   1 -> Shi et al., J. Comput. Graph. Statist., 15(1), 118-138, 2006.
%   2 -> v2 of Zhu et al CVPR, 1450–1457, 2014
%   3 -> v3 of Zhu et al CVPR, 1450–1457, 2014
%   4 -> Ting et al, SIGKDD, 1205–1214, 2016
%   5 -> RatioRF
%   6 -> Ayral et al, Ayral et al, Data Mining & Knowledge Discovery 2020
param.dist = 5;
