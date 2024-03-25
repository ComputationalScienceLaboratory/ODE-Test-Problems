classdef Canonical < otp.kvaernoprotherorobinson.KvaernoProtheroRobinsonProblem
    methods
        function obj = Canonical(lambdaF, lambdaS, xi, alpha)
            if nargin < 1 || isempty(lambdaF)
                lambdaF = -10;
            end
            if nargin < 2 || isempty(lambdaS)
                lambdaS = -10;
            end
            if nargin < 3 || isempty(xi)
                xi = 0.1;
            end
            if nargin < 4 || isempty(alpha)
                alpha = 1;
            end
            
            y0 = [2; sqrt(3)];
            tspan = [0, 2.5 * pi];
            
            params = otp.kvaernoprotherorobinson.KvaernoProtheroRobinsonParameters;
            params.Omega = 20;
            params.Lambda = [lambdaF, (1-xi) / alpha * (lambdaF - lambdaS); ...
                -alpha * xi * (lambdaF - lambdaS), lambdaS];
            obj = obj@otp.kvaernoprotherorobinson.KvaernoProtheroRobinsonProblem(tspan, y0, params);
        end
    end
end