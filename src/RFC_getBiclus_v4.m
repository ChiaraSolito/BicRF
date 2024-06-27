function [final_objects,final_features,similarities] = RFC_getBiclus_v4(representation, objnum, feats,thr)
    
    %count tests for each feature
    [test_counter,feat_idx] = groupcounts(feats');

    for f = feats
        if feat_idx(f) ~= f
          new_feat_idx = [feat_idx(1:f-2); f-1; feat_idx(f-1:end)];
          test_counter = [feat_idx(1:f-2); 0; feat_idx(f-1:end)];
          skip = f - 1;
          feat_idx = new_feat_idx;
          break
        end
        skip = 0;
    end

    % find the most similar couple of objects
    hamming = squareform(pdist(representation,'hamming'));
    value = min(min(hamming(hamming>0)));
    [row, ~] = find(hamming == value);
    min_bic_size = 5;

    % initialize objects and region to start adding other objects
    objects = 1:objnum;
    region = row';
    rep1 = representation(row,:);
    objects(row) = [];

    %calculate the first similarity (last_similarity - )
    int1_region = prod(rep1);
    int0_region = prod(~rep1);

    % calculate percentage of agreeing test in the couple of elements
    m_feat = zeros(length(feat_idx),1);
    for i = 1:length(feats)
        f = feats(i);
        if int1_region(i) == 1
            m_feat(f) = m_feat(f) + 1;
        end 
        if int0_region(i) == 1
            m_feat(f) = m_feat(f) + 1;
        end
    end
    if skip
        m_feat(skip) = [];
        test_counter(skip) = [];
    end
    mean_tests = mean(m_feat./test_counter);

    while ~isempty(objects)
        similarities = zeros(1,objnum);
        mean_test_obj = zeros(1,objnum);

        for obj = objects
            mean_feat = zeros(length(feat_idx),1);
            new_region = [region, obj];
            reg1 = representation(new_region,:);
        
            %calculate intersection
            int1_region1 = prod(reg1);
            int0_region1 = prod(~reg1);
           
            %calculate percentage of agreeing features' tests
            for i = 1:length(feats)
                f = feats(i);
                if int1_region1(i) == 1
                    mean_feat(f) = mean_feat(f) + 1;
                end 
                if int0_region1(i) == 1
                    mean_feat(f) = mean_feat(f) + 1;
                end
            end
            if skip
                mean_feat(skip) = [];
            end
            mean_test_obj(obj) = mean(mean_feat./test_counter);
            
        end

        [max_mean_test,obj_toadd]  = max(mean_test_obj);

        %break if the last mean test was above the threshold
        if max_mean_test == 0 || (length(mean_tests) > min_bic_size && (max_mean_test< thr))
            break
        else
            region = [region, obj_toadd];
            objects(objects == obj_toadd) = [];
            mean_tests = [mean_tests max_mean_test];
        end

    end
    
    %plot the curve of mean tests
    plot(mean_tests)
    title('Variation of common tests')
    ylabel('Mean Test Percentage')
    xlabel('Number of Features')
    %select only the features that are above the threshold
    final_repr = representation(region,:);
    final_objects = sort(region);
    
    int1_region1 = prod(final_repr);
    int0_region1 = prod(~final_repr);
    inter_clus = int1_region1 + int0_region1;
    
    mean_feat = zeros(length(feat_idx),1);
    for i = 1:length(feats)
        f = feats(i);
        if int1_region1(i) == 1
            mean_feat(f) = mean_feat(f) + 1;
        end 
        if int0_region1(i) == 1
            mean_feat(f) = mean_feat(f) + 1;
        end
    end
    if skip
        mean_feat(skip) = [];
    end
    mean_common_test = mean_feat./test_counter;

    features = find(mean_common_test>thr);
    final_features = features';