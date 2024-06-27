function purity = purity(A1,R1,A2,R2)
    cols = length(intersect(A1,A2));
    rows = length(intersect(R1, R2));
    
    purity = (rows*cols)/(length(A1)*length(R1));
end

