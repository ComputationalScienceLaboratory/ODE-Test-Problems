classdef Canonical < otp.newtest.SimpleProblem
    methods
        function obj = Canonical
            params = otp.newtest.SimpleParameters;
            params.param1 = 10;

            y0 = [1];
            tspan = [0, 5];

            obj = obj@otp.newtest.SimpleProblem(tspan, y0, params);
        end
    end
end

