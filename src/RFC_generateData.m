% generate toy dataset
function data = RFC_generateData(objnum,featnum,sigma, bic1, bic2)
    data = normrnd(0,100,objnum,featnum);
    data(data<-100) = -100;
    data(data>100) = 100;
    % background = data;
    
    value =  0;
    %data = background;
    for i=bic1:bic2
        for j=bic1:bic2
            data(i,j) = value; %+ normrnd(0,sigma);
        end
    end
end

