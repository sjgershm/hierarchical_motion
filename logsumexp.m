function s = logsumexp(b, dim)
    % s = logsumexp(b) by Tom Minka, modified slightly by Sam Gershman
    % Returns s(i) = log(sum(exp(b(:,i)))) while avoiding numerical underflow.
    % s = logsumexp(b, dim) sums over dimension ’dim’ instead of summing over rows
    
    if nargin < 2 % if 2nd argument is missing
        dim = 1;
    end
    B = max(b,[],dim);
    b = bsxfun(@plus,b,-B);
    s = B + log(sum(exp(b),dim));
    i = find(~isfinite(B));
    if ~isempty(i)
        s(i) = B(i);
    end