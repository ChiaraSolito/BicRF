function c = IsoC(n)
% c = IsoC(n)
% 
% Compute the normalization constant C(n)
% as in Isolation Forest, Liu et al ICDM 2008 
% C(n) = 2H(n-1)-(2(n-1)/n)
% H(i) is the Harmonic number, can be approximated as
% ln(i) + Euler-Mascheroni Constant (0.5772156649)
% http://mathworld.wolfram.com/HarmonicNumber.html

if n >1
    H = log(n-1) + 0.5772156649;
    c = 2*H - (2*(n-1)/n);
else
    c = 0;
end