classdef Canonical < otp.cusp.CUSPProblem
    % The classic problem with the classic coefficients
    
    methods
        function obj = Canonical(n, epsilon, sigma)
            if nargin < 1
                n = 64;
            end
            
            if nargin < 2
                epsilon = 1e-4;
            end
            
            if nargin < 3
                sigma = 1/144;
            end
            
            params.N = n;
            
            params.epsilon = epsilon;
            params.sigma   = sigma;
            
            xs = linspace(0, 1, n + 1)';
            
            % The last point is the same as the first, so we will ignore it.
            xs = xs(1:(end-1));
            
            y0 = zeros(n, 1);
            a0 = -2*cos(2*pi*xs);
            b0 = -2*cos(2*pi*xs);

            u0 = [y0; a0; b0];
            tspan = [0 1.1];
            
            obj = obj@otp.cusp.CUSPProblem(tspan, ...
                u0, params);
        end
    end
end
