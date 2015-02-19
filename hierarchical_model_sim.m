function results = hierarchical_model_sim(sim,varargin)
    
    % Run simulations of various hierarchical motion displays.
    %
    % USAGE: results = hierarchical_model_sim(sim)
    %
    % INPUTS:
    %   sim - simulation number
    %
    % OUTPUTS:
    %   results - results structure
    
    opts = [];
    
    switch sim
        
        case 1
            % Johansson's (1950) Experiment 19 with 2 dots
            x{1} = [0 1; 1 0];
            x{2} = [0 0; 0 0];
            
        case 2
            % Johansson's (1950) 3 dot experiment
            x{1} = [0 0; 0 0.25; 0 1];
            x{2} = [1 0; 1 0.75; 1 1];
            
        case 3
            % Duncker wheel with center
            n = 20;
            theta = pi/4;
            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            x{1} = [0 1; 0 0];
            for i = 2:n
                x{i}(2,:) = x{i-1}(2,:) + [theta 0];
                x{i}(1,:) = x{i}(2,:) + (x{i-1}(1,:)-x{i-1}(2,:))*R;
            end
            
        case 4
            % Duncker wheel without center
            n = 20;
            theta = pi/4;
            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            x{1} = [0 1];
            x2 = [0 0];
            for i = 2:n
                x{i} = (x{i-1}-x2)*R;
                x2 = x2 + [theta 0];
                x{i} = x{i} + x2;
            end
            
        case 5
            % Duncker wheel with displaced center
            n = 20;
            theta = pi/4;
            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            x{1} = [0 1; 0 0.25];
            x2 = [0 0; 0 0];
            for i = 2:n
                x{i} = (x{i-1}-x2)*R;
                x2 = x2 + [theta 0; theta 0];
                x{i} = x{i} + x2;
            end
            
        case 6
            % Gogel's (1974) adjacency experiment
            x{1} = [0 2; 2 0];
            x{2} = [0 1; 1 0];
            
        case 7
            % Johansson dots, small change
            x{1} = [0 0; 0 0.4; 0 1];
            x{2} = [1 0; 1 0.6; 1 1];
            
        case 8
            % Gogel's (1974) adjacency experiment with 3rd dot
            x{1} = [0 1; 1 0; 1.5 0.5];
            x{2} = [0 0.5; 0.5 0; 1.5 1];
            
        case 9
            % Gogel's (1974) adjacency experiment with 3rd dot
            x{1} = [0 1; 0.8 0; 1 0.2];
            x{2} = [0 0; 0 0; 1 1];
            
        case 10
            % Johansson's (1950) 3 dot experiment, but with bottom dot removed
            x{1} = [0 0; 0 0.25];
            x{2} = [1 0; 1 0.75];
            
        case 11
            % transparent motion
            N = 20;
            opts = set_defaults;
            theta = varargin{1};
            if length(varargin)<2; paired = 0; else paired = varargin{2}; end
            T = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            speed = 0.2;
            z1 = [speed*ones(N/2,1) zeros(N/2,1)];
            z2 = z1*T';
            z = [z1; z2];
            if paired
                x1 = rand(N/2,2);
                x2 = x1 - z2;
                x{1} = [x1; x2];
                x{2} = [x2; x1];
            else
                x{1} = rand(N,2);
                x{2} = x{1} + z;
            end
            v{1} = x{2}-x{1};
            opts.cov{1} = exp(-0.5*sq_dist(x{1}')/opts.lambda);    % GP covariance matrix
            c1 = [ones(N,1) ones(N,1)+1];
            c2 = [ones(N/2,1); ones(N/2,1)+1]; c2 = [ones(N,1) c2+1];
            d = zeros(N,1)+2;
            score(1) = gp_lik(v,c1,d,opts) + log(opts.g) + gammaln(N);
            score(2) = gp_lik(v,c2,d,opts) + 2*log(opts.g) + 2*gammaln(N/2);
            results.m{1} = gp_mean(v,1,c2,2,d,opts);
            results.m{2} = gp_mean(v,1,c2,3,d,opts);
            results.score = diff(score);
            f = @(a,b) acos((a*b')./(norm(a')*norm(b')));
            results.repulsion = f(z1(1,:),results.m{1}(1,:));
            return
            
        case 12
            % Loomis & Nakayama (1973)
            N = 20;
            c = linspace(0,5,N);
            v = linspace(1,3,N);
            for n = 1:N
                x{1}(n,:) = [c(n) unifrnd(0,2)];
                x{2}(n,:) = x{1}(n,:) + [v(n) 0];
            end
            d = 0.5*v(N/4) + 0.5*v(3*N/4);
            x{1}(N+1,:) = [c(N/4)+randn*0.1 1];
            x{2}(N+1,:) = x{1}(N+1,:) + [d 0];
            x{1}(N+2,:) = [c(3*N/4)+randn*0.1 1];
            x{2}(N+2,:) = x{1}(N+2,:) + [d 0];
    end
    
    for i = 1:1
        disp(['... starting point ',num2str(i)]);
        R = hierarchical_motion_mcmc(x,opts);
        if i == 1 || R.score > results.score
            results = R;
        end
    end
    results.sim = sim;
    results.x = x;