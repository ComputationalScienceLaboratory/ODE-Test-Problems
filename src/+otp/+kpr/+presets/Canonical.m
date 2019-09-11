classdef Canonical < otp.kpr.KPRProblem
    methods
        function obj = Canonical(lambdaf,lambdas,xi,alpha)
            if nargin < 4
                lambdaf = -10;
                lambdas = -1;
                xi =  0.1;
                alpha = 1;
            end
            
            y0 = [2; sqrt(3)];
            tspan = [0, 2.5 * pi];
            params.omega = 20;
            params.omegaMatrix = [lambdaf, (1-xi) / alpha * (lambdaf - lambdas); ...
                -alpha * xi * (lambdaf - lambdas), lambdas];
            obj = obj@otp.kpr.KPRProblem(tspan, y0, params);
        end
    end
end