classdef Duffing < otp.lienard.LienardProblem
    %DUFFING The duffing oscillator in a chaotic regime
    %
    methods
        function obj = Duffing(varargin)
            p = inputParser();
            p.addParameter('Alpha', 1);
            p.addParameter('Beta', 5);
            p.addParameter('Delta', 0.02);
            p.addParameter('Gamma', 8);
            p.addParameter('Omega', 0.5);
            p.parse(varargin{:});

            results = p.Results;
            alpha = results.Alpha;
            beta = results.Beta;
            delta = results.Delta;
            gamma = results.Gamma;
            omega = results.Omega;
            
            tspan = [0, 100];
            y0 = [1.45; 0];
            params = otp.lienard.LienardParameters( ...
                'F', @(x) delta, ...
                'DF', @(x) 0, ...
                'G', @(x) alpha*x + beta*(x.^3), ...
                'DG', @(x) alpha + 3*beta*(x.^2), ...
                'P', @(t) gamma*cos(omega*t), ...
                'DP', @(t) -gamma*omega*sin(omega*t));
            obj = obj@otp.lienard.LienardProblem(tspan, y0, params);            
        end
    end
end
