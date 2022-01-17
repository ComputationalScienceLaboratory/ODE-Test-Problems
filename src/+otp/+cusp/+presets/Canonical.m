classdef Canonical < otp.cusp.CUSPProblem
    %CANONICAL The classic problem with the classic coefficients
    %
    % See Hairer and Wanner, Solving ODEs II, p. 147
    
    methods
        function obj = Canonical(varargin)
            p = inputParser;
            p.addParameter('Size', 32, @isscalar);
            p.addParameter('epsilon', 1e-4);
            p.addParameter('sigma', 1/144);
            
            p.parse(varargin{:});
            
            s = p.Results;
            
            n = s.Size;
            
            params = otp.cusp.CUSPParameters;
            params.Size = n;
            params.Epsilon = s.epsilon;
            params.Sigma   = s.sigma;
            
            xs = linspace(0, 1, n + 1)';
            
            % The last point is the same as the first, so we will ignore it.
            xs = xs(1:(end-1));
            
            y0 = zeros(n, 1);
            a0 = -2*cos(2*pi*xs);
            b0 = -2*cos(2*pi*xs);

            u0 = [y0; a0; b0];
            tspan = [0 1.1];
            
            obj = obj@otp.cusp.CUSPProblem(tspan, u0, params);
        end
    end
end
