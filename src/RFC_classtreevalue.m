function I = RFC_classtreevalue(lab,crit)
% I = RFC_classtreevalue(lab,crit)
% 
% compute splitting criterion
%
% Random Forest Clustering library
% (c) Manuele Bicego 2021
%

switch crit(1)
    case 'g' 
        % gini criterion
        for k = 1:2 % two classes
            p(k) = sum(lab==k);
        end
        p = p./sum(p);
        I = 1-sum(p.*p);
end
