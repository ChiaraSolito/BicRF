function RFC_plotClassicBiclus(data,bicluster,plottitle)
%Plot bicluster obteined by library of classic algorithms
%   ...
    figure, imagesc(data)
    for clus=bicluster.Clust
        rows = clus.rows;
        cols = clus.cols;
        for i=1:length(rows)
            y = rows(i) - 0.5;
            h = 1;
            for j=1:length(cols)
                x = cols(j) - 0.5;
                w = 1;
                rectangle('Position',[x y w h],'EdgeColor','r')
            end
        end
        break
    end
    colorbar
    title(plottitle)
    ylabel('Objects') 
    xlabel('Features')  

end

