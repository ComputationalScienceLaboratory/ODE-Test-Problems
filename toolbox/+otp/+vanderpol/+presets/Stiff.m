classdef Stiff < otp.vanderpol.VanDerPolProblem
    methods
        function obj = Stiff(epsilon)
            if nargin < 1
                epsilon = 1e-6;
            end
            tspan = [0, 0.5];
            y0 = [2; polyval([-1814 / 19683, -292 / 2187, 10 / 81, -2 / 3], epsilon)];

            params = otp.vanderpol.VanDerPolParameters;
            params.Epsilon = epsilon;
            obj = obj@otp.vanderpol.VanDerPolProblem(tspan, y0, params);            
        end
    end
end

