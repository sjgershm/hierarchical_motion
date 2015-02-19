function K = gp_cov(K0,c,d)
    
    % Evaluate covariance matrix for Gaussian process layered motion model.
    %
    % USAGE: K = gp_cov(K,c,d)
    
    n = size(K0,1);
    K = zeros(n);
    for i = 1:max(d)
        q=c(:,i);
        q(d<i)=0;
        c(d<i,i)=nan;
        K = K + bsxfun(@eq,c(:,i),q');
    end
    K = K.*K0;