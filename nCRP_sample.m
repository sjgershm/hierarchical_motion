function [c parents] = nCRP_sample(N,opts)
    
    % Draw random samples from the nested CRP.
    %
    % USAGE: [c parents] = nCRP_sample(N,opts)
    %
    % INPUTS:
    %   N - number of samples
    %   opts - options structure
    %
    % OUTPUTS:
    %   c - [N x opts.d_max] matrix of paths
    %   parents - [1 x max(c(:))] vector of parents for nodes in the tree
    
    c = zeros(N,opts.d_max);
    c(:,1) = 1;
    parents = 0;
    
    for n = 1:N
        for j = 2:opts.d_max
            p = c(n,j-1);
            u = find(parents==p);  %find all nodes that share common p
            if isempty(u)
                c(n,j) = max(c(:))+1;               %make a new node if none exist at this level
            else
                m = [zeros(size(u)) opts.g];
                for k = 1:length(u)
                    m(k) = sum(c(:,j)==u(k));       %collect occupancy counts
                end
                ix = fastrandsample(m./sum(m));
                if ix > length(u)
                    c(n,j) = max(c(:))+1;           %make a new node
                else
                    c(n,j) = u(ix);                 %reuse old node
                end
            end
            if c(n,j) > length(parents)
                parents = [parents p];
            end
        end
    end