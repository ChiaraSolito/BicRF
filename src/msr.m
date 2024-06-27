function msr = msr(bicluster)
%MSR Summary of this function goes here
%   Detailed explanation goes here
residuals = 0;
I = size(bicluster,1);
J = size(bicluster,2);
for i=1:I
    for j=1:J
            residual = (bicluster(i,j) - mean(bicluster(:,j)) - mean(bicluster(i,:)) + mean(mean(bicluster))).^2;
    end
    residuals = residuals + residual;
end
msr = residuals/(I*J);

end

