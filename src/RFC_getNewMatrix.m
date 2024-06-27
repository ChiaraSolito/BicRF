function new_mat = RFC_getNewMatrix(representation, feats,num_feats)

    new_mat = zeros(size(representation,1),num_feats);
    
    for obj = 1:size(representation,1)
        for test = 1:size(representation,2)
            new_mat(obj,feats(test)) = new_mat(obj,feats(test)) + representation(obj,test);
    
        end
    end
    
    for i = 1:size(representation,1)
        for j = 1:num_feats
            if new_mat(i,j) > 1
                new_mat(i,j) = 1;
            end
        end
    end
