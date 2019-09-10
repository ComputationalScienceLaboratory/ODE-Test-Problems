classdef ForcedvanderPol < otp.lienard.LienardProblem
    methods
        function obj = ForcedvanderPol(varargin)
            tspan = [0, 100];
            y0 = [1.45;...
                0];
            
            mu = 8.53;
            gamma = 1.2;
            omega = 2*pi/10;
            
            params.f  = @(x) mu*(x^2 - 1);
            params.df = @(x) 2*mu*x;
            params.g  = @(x) x;
            params.dg = @(x) 1;
            params.p  = @(t) gamma*sin(omega*t);
            params.dp = @(t) gamma*omega*cos(omega*t);
            obj = obj@otp.lienard.LienardProblem(tspan, y0, params);            
        end
    end
end

