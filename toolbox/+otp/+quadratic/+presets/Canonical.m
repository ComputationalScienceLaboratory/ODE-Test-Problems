classdef Canonical < otp.quadratic.QuadraticProblem
    methods
        function obj = Canonical(varargin)
            tspan = [0, 10];
            params = otp.quadratic.QuadraticParameters('A', 0, 'B', 1, 'C', -1, varargin{:});
            y0 = 2*ones(length(params.A), 1);
            obj = obj@otp.quadratic.QuadraticProblem(tspan, y0, params);
        end
    end
end
