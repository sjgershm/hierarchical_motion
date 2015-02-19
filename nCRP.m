function logp = nCRP(c,parents,n,cn,g)
    
    %Log pdf for nested Chinese restaurant process.
    %
    %USAGE: logp = nCRP(c,parents,n,cn,g)
    
    c(n,:) = [];
    logp = 0;
    
    %loop over levels in the tree
    for j = 2:length(cn)
        if cn(j)>length(parents)
            break
        end
        u = find(parents==parents(cn(j)));  %find all nodes that share common parent with proposed node
        m = zeros(size(u));
        for k = 1:length(u)
            m(k) = sum(c(:,j)==u(k));       %collect occupancy counts
        end
        a = m(u==cn(j));                    %occupancy corresponding to proposed node
        if a == 0                           %if the proposed node is unused
            a = g;
            m(u==cn(j)) = g;
        elseif ~any(m==0)
            m = [m g];
        else
            m(find(m==0,1)) = g;
        end
        m(m==0) = [];  %make sure we don't take log(0)
        logp = logp + log(a) - log(sum(m));
    end