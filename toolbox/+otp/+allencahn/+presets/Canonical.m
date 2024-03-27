classdef Canonical < otp.allencahn.AllenCahnProblem
    %CANONICAL
    
    methods
        function obj = Canonical(varargin)
            params = otp.allencahn.AllenCahnParameters('Size', 64, 'Alpha', 0.1, 'Beta', 1, 'Forcing', 0, varargin{:});
            
            x = linspace(0, 1, params.Size);
            [xs, ys] = meshgrid(x, x);

            u0 = reshape(0.4 + 0.1*(xs + ys) + 0.1*sin(10*xs)*sin(20*ys), [], 1);
            tspan = [0, 0.2];
            obj = obj@otp.allencahn.AllenCahnProblem(tspan, u0, params);
        end
    end
end
