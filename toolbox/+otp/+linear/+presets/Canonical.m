classdef Canonical < otp.linear.LinearProblem
    methods
        function obj = Canonical(varargin)
            params = otp.linear.LinearParameters('Lambda', {-1}, varargin{:});
            tspan = [0, 1];
            y0 = ones(size(params.Lambda{1}, 1), 1);
            obj = obj@otp.linear.LinearProblem(tspan, y0, params);
        end
    end
end
