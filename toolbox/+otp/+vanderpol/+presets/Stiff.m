classdef Stiff < otp.vanderpol.VanDerPolProblem
    methods
        function obj = Stiff(varargin)
            params = otp.vanderpol.VanDerPolParameters('Epsilon', 1e-6, varargin{:});
            tspan = [0, 0.5];
            y0 = [2; polyval([-1814 / 19683, -292 / 2187, 10 / 81, -2 / 3], params.Epsilon)];
            obj = obj@otp.vanderpol.VanDerPolProblem(tspan, y0, params);            
        end
    end
end

