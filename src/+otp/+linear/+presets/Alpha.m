classdef Alpha < otp.linear.LinearProblem
    %ALPHA
    %
    methods
        function obj = Alpha(alpha, numVars, magnitudeRange)
            if nargin < 1 || isempty(alpha)
                alpha = 0;
            end
            if nargin < 2 || isempty(numVars)
                numVars = 1;
            end
            if nargin < 3 || isempty(magnitudeRange)
                magnitudeRange = [1e-4, 1e4];
            end
            
            z = logspace(log10(magnitudeRange(1)), log10(magnitudeRange(end)), numVars) ...
                * (1i * sind(alpha) - cosd(alpha));

            params = otp.linear.LinearParameters;
            if numVars == 1
                params.Lambda = {z};
            else
                params.Lambda = {spdiags(z.', 0, numVars, numVars)};
            end
            
            obj = obj@otp.linear.LinearProblem([0, 1], ones(numVars, 1), params);
        end
    end
end
