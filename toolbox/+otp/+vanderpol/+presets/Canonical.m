classdef Canonical < otp.vanderpol.VanDerPolProblem
    methods
        function obj = Canonical(epsilon)
            if nargin < 1
                epsilon = 1;
            end
            tspan = [0, 100];
            y0 = [2; 0];

            params = otp.vanderpol.VanDerPolParameters;
            params.Epsilon = epsilon;
            obj = obj@otp.vanderpol.VanDerPolProblem(tspan, y0, params);            
        end
    end
end
