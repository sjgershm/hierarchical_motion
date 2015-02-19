function lik = gp_lik(v,c,d,opts)
    
    % Log-likelihood function for Gaussian process layered motion model
    %
    % USAGE: lik = gp_lik(v,c,d,opts)
    
    n = size(v{1},1);
    lik = 0;
    
    %compute likelihood
    for s = 1:size(v,1)
        for i = 1:size(v,2)
            if ~isempty(v{s,i})
                K = gp_cov(opts.cov{s,i},c,d);
                L = chol(K+opts.s2*eye(n));               % Cholesky factor of covariance with noise
                alpha = solve_chol(L,v{s,i});
                lik = lik - v{s,i}(:)'*alpha(:)/2 - sum(log(diag(L))) - 0.5*n*log(2*pi*opts.s2);  % log marginal likelihood
            end
        end
    end