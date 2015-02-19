function opts = set_defaults(opts)
    
    %Set defaults to a parameter structure.
    %
    %USAGE: opts = set_defaults([opts])
    
    def_opts.d_max = 3;
    def_opts.s2 = 0.01;
    def_opts.g = 1;
    def_opts.nIter = 500;
    def_opts.d0 = 2;
    def_opts.lambda = 100;
    def_opts.update_depth = 1;
    def_opts.alpha = 1;
    def_opts.rho = 0.1;
    def_opts.tau = 1;
    def_opts.savefile = [];
    
    F = fieldnames(def_opts);
    
    if nargin < 1 || isempty(opts)
        opts = def_opts;
    else
        for f = 1:length(F)
            if ~isfield(opts,F{f}) || isempty(opts.(F{f}))
                opts.(F{f}) = def_opts.(F{f});
            end
        end
    end