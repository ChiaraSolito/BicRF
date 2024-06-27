function [ids, p, tests] = tree_struct(ids, p, parent, tests, tree)
    %get the tree parent
    
    p = [p parent];
    ids = [ids, tree.idn];
    
    %save what test we're doing
    try
        isempty(tree.bestf);
        exist_var=1;
    catch
        exist_var=0;
    end

    if exist_var
        test = [tree.bestf, tree.bestt];
        tests = [tests; test];
    end

    if ~isempty(tree.l)
        current_node = tree.idn;
        [ids, p, tests] = tree_struct(ids, p, current_node, tests, tree.l);
    end

    if ~isempty(tree.r) 
        current_node = tree.idn;
        [ids, p, tests] = tree_struct(ids, p, current_node,  tests, tree.r);
    end 

end 