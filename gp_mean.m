function m = gp_mean(v,j,c,k,d,opts)
    
    % Posterior predictive mean for one component motion.
    %
    % USAGE: m = gp_mean(v,c,k,d,opts)
    
    v = v{j};
    n = size(v,1);
    
    % construct covariance matrix (excluding target function)
    K = gp_cov(opts.cov{j},c,d);
    L = chol(K/opts.s2+eye(n));               % Cholesky factor of covariance with noise
    
    % construct target covariance matrix
    n = size(K,1);
    K0 = zeros(n);
    for i = 1:n
        if any(c(i,1:d(i))==k)
            for m = i:n
                if any(c(m,1:d(m))==k)
                    K0(i,m) = opts.cov{j}(i,m);
                    K0(m,i) = opts.cov{j}(i,m);
                end
            end
        end
    end
    
    % compute predictive mean
    alpha = solve_chol(L,v)/opts.s2;
    m = K0*alpha;