classdef Alpha < otp.linear.LinearProblem
    methods
        function obj = Alpha(alpha, numVars, magnitudeRange)
            if nargin < 2
                numVars = 1;
            end
            if nargin < 3
                magnitudeRange = [1e-4, 1e4];
            end
            
            a = deg2rad(alpha);
            z = logspace(log10(magnitudeRange(1)), log10(magnitudeRange(end)), numVars) ...
                * (1i * sin(a) - cos(a));
            
            if numVars == 1
                params.A = {z};
            else
                params.A = {spdiags(z.', 0, numVars, numVars)};
            end
            
            obj = obj@otp.linear.LinearProblem([0, 1], ones(numVars, 1), params);
        end
    end
end
