classdef Alpha < otp.linear.LinearProblem
    %ALPHA
    %
    methods
        function obj = Alpha(alpha, numvars, magnituderange)
            if nargin < 1 || isempty(alpha)
                alpha = 0;
            end
            if nargin < 2 || isempty(numvars)
                numvars = 1;
            end
            if nargin < 3 || isempty(magnituderange)
                magnituderange = [1e-4, 1e4];
            end
            
            a = deg2rad(alpha);
            z = logspace(log10(magnituderange(1)), log10(magnituderange(end)), numvars) ...
                * (1i * sin(a) - cos(a));

            if numvars == 1
                A = {z};
            else
                A = {spdiags(z.', 0, numvars, numvars)};
            end

            params = otp.linear.LinearParameters;
            params.A = A;
            
            obj = obj@otp.linear.LinearProblem([0, 1], ones(numvars, 1), params);
        end
    end
end
