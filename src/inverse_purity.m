function inverse_purity = inverse_purity(A1,R1,A2,R2)
    rows = length(intersect(R1,R2));
    cols = length(intersect(A1,A2));

    inverse_purity = (rows*cols)/(length(R2)*length(A2));
end

