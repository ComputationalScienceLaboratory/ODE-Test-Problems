classdef Canonical < otp.allencahn.AllenCahnProblem
    
    methods
        function obj = Canonical(varargin)
            
            p = inputParser;
            p.addParameter('Size', 150, @isscalar);
            p.addParameter('alpha', 0.1);
            p.addParameter('beta', 1);                        

            p.parse(varargin{:});
            
            s = p.Results;
            
            n = s.Size;
            
            params.n = n;
            params.alpha = s.alpha;
            params.beta = s.beta;
            params.forcing = [];
            
            x = linspace(0, 1, n);
            [xs, ys] = meshgrid(x, x);

            u0 = reshape(0.4 + 0.1*(xs + ys) + 0.1*sin(10*xs)*sin(20*ys), n^2, 1);

            tspan = [0, 0.2];
            
            obj = obj@otp.allencahn.AllenCahnProblem(tspan, u0, params);
        end
    end
end
