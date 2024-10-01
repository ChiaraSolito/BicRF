function [h,CD]=nemenyi(stats,alpha)%stats is the output of friedman
if nargin<2
    alpha=0.05;
end
N=stats.n;
ranks=stats.meanranks;
ranksDiff=abs(ranks-ranks');
k=length(ranks);
qalpha=criticalValuesNemenyi(k,alpha);
CD=qalpha*(sqrt(k*(k+1)/(6*N)));
h=ranksDiff>=CD;
end