classdef ForcedvanderPol < otp.lienard.LienardProblem
    %FORCEDVANDERPOL The forced vanderpol oscillator
    %
    methods
        function obj = ForcedvanderPol(mu, gamma, omega)
            if nargin < 1 || isempty(mu)
                mu = 8.53;
            end
            if nargin < 2 || isempty(gamma)
                gamma = 1.2;
            end
            if nargin < 3 || isempty(omega)
                omega = 2*pi/10;
            end

            tspan = [0, 100];
            y0 = [1.45;...
                0];
            
            params = otp.lienard.LienardParameters;
            params.F  = @(x) mu*(x.^2 - 1);
            params.DF = @(x) 2*mu*x;
            params.G  = @(x) x;
            params.DG = @(x) 1;
            params.P  = @(t) gamma*sin(omega*t);
            params.DP = @(t) gamma*omega*cos(omega*t);
            obj = obj@otp.lienard.LienardProblem(tspan, y0, params);            
        end
    end
end
