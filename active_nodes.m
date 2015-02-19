function k_active = active_nodes(c,d)
    
    %find which nodes are active
    
    k_active = [];
    for n = 1:size(c,1)
        k_active = [k_active c(n,1:d(n))];
    end
    k_active = unique(k_active);