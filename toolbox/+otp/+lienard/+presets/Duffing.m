classdef Duffing < otp.lienard.LienardProblem
    %DUFFING The duffing oscillator in a chaotic regime
    %
    methods
        function obj = Duffing(alpha, beta, delta, gamma, omega)
            if nargin < 1 || isempty(alpha)
                alpha = 1;
            end
            if nargin < 2 || isempty(beta)
                beta = 5;
            end
            if nargin < 3 || isempty(delta)
                delta = 0.02;
            end
            if nargin < 4 || isempty(gamma)
                gamma = 8;
            end
            if nargin < 5 || isempty(omega)
                omega = 0.5;
            end
            
            
            tspan = [0, 100];
            y0 = [1.45;...
                0];
            
            params = otp.lienard.LienardParameters;
            params.F  = @(x) delta;
            params.DF = @(x) 0;
            params.G  = @(x) alpha*x + beta*(x.^3);
            params.DG = @(x) alpha + 3*beta*(x.^2);
            params.P  = @(t) gamma*cos(omega*t);
            params.DP = @(t) -gamma*omega*sin(omega*t);
            obj = obj@otp.lienard.LienardProblem(tspan, y0, params);            
        end
    end
end
