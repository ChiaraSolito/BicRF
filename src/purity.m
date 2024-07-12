function purity = purity(A1,R1,A2,R2)
%1 = Original Bicluster
%2 = Found Bicluster
    cols = length(intersect(A1,A2));
    rows = length(intersect(R1, R2));
    
    purity = (rows*cols)/(length(A2)*length(R2));
end

