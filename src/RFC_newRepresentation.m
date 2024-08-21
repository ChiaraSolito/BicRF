function [representation,features, thetas] = RFC_newRepresentation(CI, data);

numfeat = size(data,2);
xfeat  = [CI(:).feat];
xtheta  = [CI(:).theta];
xans = [CI(:).b]; 
representation = zeros(1);
features = [0];
thetas = [0];

for i = 1:numfeat
    ndx = find(xfeat==i); %find the index of every test done on feature i
    [theta,order] = sort(xtheta(ndx)); %sort the thetas for each test, and keep order
    answer = xans(ndx(order)); %did they respond true or false
    
    %for every theta 
    for j=1:length(theta)
        indexes = find(data(:,i) > theta(j));
        representation(indexes,end+1) = 1;
        features(end+1) = i;
        thetas(end+1) = theta(j);
    end
    
end

representation(:,1) = [];
thetas(1) = [];
features(1) = [];

%convert randomly 50% of features
% sampler = randsample(numfeat,ceil(numfeat/2));
% for index=sampler
%    representation(:,index) = ~representation(:,index);
% end