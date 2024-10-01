function qalpha=criticalValuesNemenyi(k,alpha)
if nargin<2
    alpha=0.05;
end
if k<2
    error("K must be at least 2!")
end
if alpha==0.05
    qs=[1.960 2.343 2.569 2.728 2.850 2.949 3.031 3.102 3.164 3.219 3.268 3.313 3.354 3.391 3.426 3.459 3.489 3.517 3.544];
    %not sure this is correct after k>10
elseif alpha==0.1
    qs=[1.645 2.052 2.291 2.459 2.589 2.693 2.780 2.855 2.920];
elseif alpha==0.01
    qs=[2.57599000386259,2.91327993848858,3.13976624050263,3.25481251380168,3.36370695810441,3.45209530575272,3.52634151777731,3.59068823486529,3.64654967057903,3.69604714526208,3.74059487247684,3.78160706578566,3.81837661840736,3.85231774390431,3.88413754905771,3.91383603386754,3.94141319833382,3.96757614923772,3.99161777979806];
end
    qalpha=qs(k-1); %k-1 because vector starts from k=2;


%If k greater would have to call the private function that computes the
%studentized range statistic
end