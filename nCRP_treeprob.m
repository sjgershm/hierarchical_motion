function logp = nCRP_treeprob(c,parents,g,D)
    
    % Evaluate probability of a tree under the nCRP.
    
    logp = 0;
    if nargin < 4; D = size(c,2); end
    for d = 1:D     % loop over levels
        u = parents(unique(c(:,d))');   % set of parents for all customers at level d
        for j = u 
            ix = parents(c(:,d)) == j;  % set of children of parent j
            logp = logp + crp(c(ix,d)',g);
        end
    end
    
end

function logp = crp(c,g)
    N = length(c);
    u = unique(c);
    K = length(u);
    logp = gammaln(g) + K*log(g) - gammaln(N+g);
    for k = u
        logp = logp + gammaln(sum(c==k));
    end
end