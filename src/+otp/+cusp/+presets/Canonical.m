classdef Canonical < otp.cusp.CUSPProblem
    % The classic problem with the classic coefficients
    
    methods
        function obj = Canonical(varargin)
            
            p = inputParser;
            addParameter(p, 'Size', 64, @isscalar);
            addParameter(p, 'epsilon', 1e-4, @isnumeric);
            addParameter(p, 'sigma', 1/144, @isnumeric);
                        

            parse(p, varargin{:});
            
            s = p.Results;
            
            n = s.Size;
            
            params.N = n;
            params.epsilon = s.epsilon;
            params.sigma   = s.sigma;
            
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
