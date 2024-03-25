classdef Canonical < otp.vanderpol.VanDerPolProblem
    methods
        function obj = Canonical(varargin)
            tspan = [0, 100];
            y0 = [2; 0];
            params = otp.vanderpol.VanDerPolParameters('Epsilon', 1, varargin{:});
            obj = obj@otp.vanderpol.VanDerPolProblem(tspan, y0, params);            
        end
    end
end
