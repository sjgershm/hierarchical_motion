function results = hierarchical_motion_mcmc(x,opts,results)
    
    % Run MCMC for the hierarchical motion model.
    %
    % USAGE: results = hierarchical_motion_mcmc(x,opts)
    %
    % INPUTS:
    %   x - dot locations, each cell contains N x 2 matrices
    %   opts - options structure
    %
    % OUTPUTS:
    %   results - structure containing fitted model
    %
    % Sam Gershman, March 2013
    
    %------------ initialization ------------%
    if nargin < 2; opts = []; end
    opts = set_defaults(opts);
    N = size(x{1},1);
    if ~isfield(opts,'sets'); opts.sets = ones(1,length(x)); end
    S = unique(opts.sets);
    for s = 1:length(S)
        ix = find(opts.sets==S(s));
        for j = 1:length(ix)-1
            v{s,j} = x{ix(j+1)}-x{ix(j)};
            opts.cov{s,j} = opts.tau*exp(-0.5*sq_dist(x{ix(j)}')/opts.lambda);    % GP covariance matrix
        end
    end
    
    % initialize cluster assignments
    if nargin < 3 || isempty(results)
        d = zeros(N,1)+opts.d0;
        [c parents] = nCRP_sample(N,opts);
        results.parents = parents;
    else
        c = results.c;
        d = results.d;
        parents = results.parents;
    end
    
    %---------- run MCMC --------------------%
    for i = 1:opts.nIter
        
        if ~mod(i,50); disp(['iteration ',num2str(i)]); end
        
        % annealing temperature
        bt = 2/log(1+i);
        
        % update cluster assignments (gibbs sampling)
        for n = randperm(N)
            C = enumerate_paths(c,parents,d,n,opts);
            logp = zeros(1,length(C));
            for t = 1:length(C)
                c1 = c;
                c1(n,1:d(n)) = C{t};
                logp(t) = gp_lik(v,c1,d,opts) + nCRP(c1,parents,n,C{t},opts.g);
            end
            logp = logp/bt;
            p = exp(logp-logsumexp(logp,2));
            c(n,1:d(n)) = C{fastrandsample(p)};
            
            % add new parents if necessary
            for j = 2:d(n)
                if c(n,j)>length(parents)
                    parents(c(n,j)) = c(n,j-1);
                end
            end
        end
        
        % update depth allocations (gibbs sampling)
        if opts.update_depth==1
            for n = randperm(N)
                logp = zeros(1,opts.d_max);
                dn = d;
                ix = 1:N~=n;
                for j = 1:opts.d_max
                    dn(n) = j;
                    logp(j) = gp_lik(v,c,dn,opts) + opts.alpha*sum(d(ix)==j) - opts.rho*j;
                end
                logp = logp/bt;
                p = exp(logp-logsumexp(logp,2));
                d(n) = fastrandsample(p);
            end
        end
        
        if ~mod(i,10) && ~isempty(opts.savefile)
            results.c = c;
            results.d = d;
            results.opts = opts;
            save(opts.savefile,'results');
            
            if isfield(opts,'connect')
                mocap_play(x,results,opts.connect,opts.sets);
                drawnow
            end
        end
        
    end
    
    % compute predictive means
    k_active = active_nodes(c,d);
    for ki = 1:length(k_active)
        for j = 1:length(v)
            m{ki,j} = gp_mean(v,j,c,k_active(ki),d,opts);
        end
    end
    
    % store results
    results.score = hierarchical_motion_score(x,c,parents,d,opts);
    results.k_active = k_active;
    results.m = m;
    results.c = c;
    results.d = d;
    results.parents = parents;
    results.opts = opts;
    
    if ~isempty(opts.savefile)
        save(opts.savefile,'results');
    end