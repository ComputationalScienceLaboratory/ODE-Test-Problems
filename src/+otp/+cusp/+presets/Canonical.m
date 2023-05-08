classdef Canonical < otp.cusp.CUSPProblem
    %CANONICAL The classic problem with the classic coefficients
    %
    % See Hairer and Wanner, Solving ODEs II, p. 147
    
    methods
        function obj = Canonical(varargin)
            p = inputParser;
            p.addParameter('Size', 32);
            p.addParameter('epsilon', 1e-4);
            p.addParameter('sigma', 1/144);
            p.parse(varargin{:});
            opts = p.Results;
            
            params = otp.cusp.CUSPParameters;
            params.Size = opts.Size;
            params.Epsilon = opts.epsilon;
            params.Sigma = opts.sigma;
            
            ang = 2 * pi / opts.Size * (1:opts.Size).';
            y0 = zeros(opts.Size, 1);
            a0 = -2*cos(ang);
            b0 = 2*sin(ang);

            u0 = [y0; a0; b0];
            tspan = [0; 1.1];
            
            obj = obj@otp.cusp.CUSPProblem(tspan, u0, params);
        end
    end
end
