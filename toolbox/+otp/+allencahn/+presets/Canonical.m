classdef Canonical < otp.allencahn.AllenCahnProblem
    %CANONICAL
    
    methods
        function obj = Canonical(varargin)
            
            p = inputParser;
            p.addParameter('Size', 64);
            p.addParameter('alpha', 0.1);
            p.addParameter('beta', 1);                        

            p.parse(varargin{:});
            
            s = p.Results;
            
            n = s.Size;
            

            params = otp.allencahn.AllenCahnParameters;
            params.Size = n;
            params.Alpha = s.alpha;
            params.Beta = s.beta;
            params.Forcing = 0;
            
            x = linspace(0, 1, n);
            [xs, ys] = meshgrid(x, x);

            u0 = reshape(0.4 + 0.1*(xs + ys) + 0.1*sin(10*xs)*sin(20*ys), n^2, 1);

            tspan = [0, 0.2];
            
            obj = obj@otp.allencahn.AllenCahnProblem(tspan, u0, params);
        end
    end
end
