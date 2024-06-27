function info = RFC_getTreeClusInfo(Xdata,t,param)
% info = RFC_getTreeClusInfo(Xdata,t,param)
% 
% extract info for clustering (routine for a single tree)
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%
% Xdata: [nxd]: n objects in a d-dimensional space
% rfc is the trained forest
%
% info.b [n X Nnodes]; % ij -> result of test of node j on object i (1 true, 0, false) 
% info.beta [n X Nnodes]; %ij -> true if node j is in the path of object i
% info.theta [1 X Nnodes]; % j -> threshold of test node j
% info.feat [1 X Nnodes]; % j -> feature on which make the test
% info.lev  [1 X Nnodes]; % j -> level of node j
% info.leafid [n X 1]; % i -> idn of the leaf of object i
% info.depObj [n X 1]; % i -> depth of the leaf of object i
% info.depObjCn [n X 1]; % i -> depth of the leaf of object i plus
                       % c(n) as in Algorithm 3, step 2 of:
                       % Liu et al ICDM 2008

n=size(Xdata,1);

Nn = t.maxidn; % number of nodes
b = false(n,Nn); % ij -> result of test of node j on object i (1 true, 0, false) 
beta = false(n,Nn); %ij -> true if node j is in the path of object i
theta = zeros(1,Nn); % j -> threshold of test node j
feat = zeros(1,Nn); % j -> feature on which make the test
lev = zeros(1,Nn); % j -> level of node j
leafid = zeros(n,1); % i -> idn of the leaf of object i
depObj = zeros(n,1); % i -> depth of the leaf of object i
depObjCn = zeros(n,1); % i -> depth of the leaf of object i plus
                       % c(n) as in Algorithm 3, step 2 of:
                       % Liu et al ICDM 2008

% scanning tree
tovisit{1} = t;
neltr = zeros(1,Nn);
while (~isempty(tovisit))
    v = tovisit{1};
    id = v.idn;
    lev(id) = v.liv;
    neltr(id) = v.sizet;
     if ~isempty(v.l)
         theta(id) = v.bestt;
         feat(id) = v.bestf;
         tovisit{end+1} = v.l; 
         tovisit{end+1} =v.r;
     end
     tovisit(1) = [];
end

for i = 1:n
    xi = Xdata(i,:);
    % result of tests
    b(i,(feat~=0)) = xi(feat(feat~=0)) >= theta(feat~=0);
    % path
    v = t;
    while (1)
        beta(i,v.idn) = 1;
        
        if (isempty(v.l)) % leaf node
            break
        else
            if (xi(v.bestf)<v.bestt)
                v = v.l;
            else
                v = v.r;
            end
        end
        
    end
    leafid(i) = find(beta(i,:), 1, 'last' );
    depObj(i) = lev(leafid(i)); 
    depObjCn(i) = depObj(i) + IsoC(neltr(leafid(i)));
end
% leaf id: max(find(beta(1,:))
info.b = b;
info.beta = beta;
info.theta = theta;
info.feat = feat;
info.lev = lev;
info.leafid = leafid;
info.depObj = depObj;
info.depObjCn = depObjCn;
