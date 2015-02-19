function C = enumerate_paths(c,parents,d,n,opts)
    
    %Enumerate all possible paths for a single datapoint.
    
    k_active = active_nodes(c,d);
    opts.K_max = 10*opts.d_max*size(c,1);
    k_inactive = setdiff(1:opts.K_max,k_active); %indices for inactive nodes
    
    C = cell(length(k_active),1); count = zeros(length(k_active),1);
    for i = 1:length(k_active)
        f = k_active(i);
        C{i} = f;
        f = parents(f);
        while f~=0
            C{i} = [f C{i}];
            f = parents(f);
        end
        C{i} = [C{i} k_inactive(1:(d(n)-length(C{i})))];    %add new nodes for paths terminating on internal nodes
        count(i) = length(C{i});
    end
    
    C(count>d(n)) = []; %remove paths that are too deep