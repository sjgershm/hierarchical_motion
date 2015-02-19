function score = hierarchical_motion_score(x,c,parents,d,opts)
    
    if nargin < 5; opts = []; end
    opts = set_defaults(opts);
    if ~isfield(opts,'sets'); opts.sets = ones(1,length(x)); end
    S = unique(opts.sets);
    for s = 1:length(S)
        ix = find(opts.sets==S(s));
        for j = 1:length(ix)-1
            v{s,j} = x{ix(j+1)}-x{ix(j)};
            opts.cov{s,j} = opts.tau*exp(-0.5*sq_dist(x{ix(j)}')/opts.lambda);    % GP covariance matrix
        end
    end
    
    dd = bsxfun(@eq,d,d'); dd = sum(dd(:));
    score = gp_lik(v,c,d,opts) + opts.alpha*0.5*dd - opts.rho*sum(d) + nCRP_treeprob(c,parents,opts.g);