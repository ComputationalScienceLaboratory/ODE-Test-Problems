classdef Canonical < otp.allencahn.AllenCahnProblem
    % The classic problem with the classic coefficients
    
    methods
        function obj = Canonical(varargin)
            
            p = inputParser;
            addParameter(p, 'Size', 150, @isscalar);
            addParameter(p, 'alpha', 0.1, @isnumeric);
                        

            parse(p, varargin{:});
            
            s = p.Results;
            
            n = s.Size;
            
            params.n = n;
            params.alpha = s.alpha;
            
            xs = repmat(linspace(0, 1, n)  , n, 1);
            ys = repmat(linspace(0, 1, n).', 1, n);

            u0 = reshape(0.4 + 0.1*(xs + ys) + 0.1*sin(10*xs)*sin(20*ys), n^2, 1);

            tspan = [0, 0.2];
            
            obj = obj@otp.allencahn.AllenCahnProblem(tspan, u0, params);
        end
    end
end
